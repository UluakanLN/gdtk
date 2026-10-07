-- sphere.lua
--
-- X2 Air Experimental test flow over spherical model
--
-- Adjusting to geometry and flow conditions used in Lefevre, Alexis PhD thesis (2022)
-- This is an inviscid simulation, so viscosity is not turned on

config.title = "X2-Experiment-Condition-C5"
config.axisymmetric = true

nsp,nmodes,gmodel=setGasModel("air-11sp-gas-model.lua")
config.viscous = true
config.reacting = true
config.reactions_file = "air-11sp-reactions.lua"
config.energy_exchange_file = 'air-11sp-energy-exchange.lua'

--- Define flow conditions ---
-- Freestream properties are taken from PhD Thesis of Alexis Lefevre 
T_inf = 2000.0 -- K
T_wall = 300.0 -- K
rho_inf = 1.0e-3 -- kg/m^3
mass_fraction = {N2=0.767, O2=0.233}
u_inf = 13.7e3 -- m/s

-- Compute full inflow state from T,rho, and u
Q = GasState:new{gmodel}
Q.T = T_inf;
Q.rho = rho_inf;
Q.massf = mass_fraction
Q.T_modes = {T_inf}
gmodel:updateThermoFromRHOT(Q);
gmodel:updateSoundSpeed(Q)
p_inf = Q.p
M_inf = u_inf/Q.a
gmodel:updateTransCoeffs(Q);

initial = FlowState:new{p=p_inf, T=T_inf, velx=u_inf, vely=0.0, massf=mass_fraction, T_modes={T_inf}}
inflow = FlowState:new{p=p_inf, T=T_inf, velx=u_inf, vely=0.0, massf=mass_fraction, T_modes={T_inf}}

--- Define the geometry ---
R = 0.01905  -- radius of sphere, in metres
ni = 64; nj = 128
print("M_inf=", M_inf)
local billig = require 'billig'
local billig_patch = {}

function billig_patch.make_patch(t)
   -- Construct a surface patch for use in a bluff-body simulation
   -- using arguments found in the supplied table.
   -- For the quadrant==2 case the patch is above the x-axis.
   --
   --                      ++d[#d]
   --                    +   |
   --                  +     | North
   --        West    +       |
   --               +        |
   --              +      ---b
   --             +      /
   --            +      /
   --            +     |
   --          d[1]----a     c  ----> x
   --            South
   --
   -- For the quandrant==3 case the patch is below the x-axis.
   --
   --            North
   --          d[1]----a     c  ----> x
   --            +     |
   --            +      \
   --             +      \
   --              +      ---b
   --        West   +        |
   --                +       | South
   --                  +     |
   --                    +   |
   --                      ++d[#d]
   --
   if not type(t) == "table" then
      error("Expected a single table containing named arguments.", 2)
   end
   -- Arguments without default values.
   -- Free-stream Mach number.
   local Minf = t.Minf
   -- Radius of cylinder or sphere.
   local R = t.R
   -- Arguments with default values.
   local quadrant = t.quadrant or 2
   -- Position of centre of body.
   local xc = t.xc or 0.0
   local yc = t.yc or 0.0
   -- Scale for accommodating thermochemical variation
   -- away from ideal low-Temperature air.
   -- Set the scales using the most specific information available,
   -- eventually defaulting to a scale of 1.0 if nothing is specified.
   local x_scale = nil
   local y_scale = nil
   if t.x_scale then x_scale = t.x_scale end
   if t.y_scale then y_scale = t.y_scale end
   if t.scale then
      x_scale = x_scale or t.scale
      y_scale = y_scale or t.scale
   end
   x_scale = x_scale or 1.0
   y_scale = y_scale or 1.0
   -- Assume 2D cylinder (axisymmetric=true for a sphere).
   local axisymmetric = t.axisymmetric or false
   -- Angle of aft-body with respect to freestream direction.
   local theta = t.theta or 0.0
   --
   local a = Vector3:new{x=xc-R, y=yc}
   local b = Vector3:new{x=xc, y=yc+R}
   if quadrant == 3 then b = Vector3:new{x=xc, y=yc-R} end
   local c = Vector3:new{x=xc, y=yc}
   local body
   if quadrant == 2 then
      body = Arc:new{p0=a, p1=b, centre=c}
   else
      body = Arc:new{p0=b, p1=a, centre=c}
   end
   --
   -- In order to have a grid that fits reasonably close the the shock,
   -- use Billig's shock shape correlation to generate
   -- a few sample points along the expected shock position.
   print("Points on Billig's correlation.")
   local xys = {}
   --local y_samples = {0.0, 0.2, 0.4, 0.6, 1.0, 1.4, 1.6, 2.0, 2.37}
   --local y_samples = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0}
   local y_samples = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.3, 1.4, 1.5,1.6,1.7}
   if t.y_samples then y_samples = t.y_samples end
   for i,y in ipairs(y_samples) do
      -- y is normalized for R=1
      local x = billig.x_from_y(y*R, Minf, theta, axisymmetric, R)
      xys[#xys+1] = {x=x, y=y*R}  -- a new coordinate pair
      -- print("x=", x, "y=", y*R)
   end
   -- Scale the Billig distances, depending on the expected behaviour
   -- relative to the gamma=1.4 ideal gas.
   local d = {} -- will use a list to keep the nodes for the shock boundary
   local shock
   local xaxis
   local outlet
   local patch
   if quadrant == 2 then
      for i, xy in ipairs(xys) do
         -- the outer boundary should be a little further than the shock itself
         d[#d+1] = Vector3:new{x=-x_scale*xy.x+xc, y=y_scale*xy.y+yc}
      end
      shock = ArcLengthParameterizedPath:new{underlying_path=Spline:new{points=d}}
      --shock = Bezier:new{points=d}
      --
      xaxis = Line:new{p0=d[1], p1=a} -- shock to nose of body
      outlet = Line:new{p0=d[#d], p1=b} -- shock to last-point of body
      --
     -- patch = CoonsPatch:new{south=xaxis, north=outlet, west=shock, east=body}  -- I guess CoonsPatch cause the first cells on boundary not being in normal direction to surface
      patch = ControlPointPatch:new{south=xaxis, north=outlet, west=shock, east=body, ncpi=5, ncpj=7, guide_patch="channel-e2w"}
   else
      -- For quadrant 3, the shock path progresses fro the outer point to the axis.
      for i=1,#xys do
         -- the outer boundary should be a little further than the shock itself
         local xy = xys[#xys-i+1]
         d[#d+1] = Vector3:new{x=-x_scale*xy.x+xc, y=-y_scale*xy.y+yc}
      end
      shock = ArcLengthParameterizedPath:new{underlying_path=Spline:new{points=d}}
      --
      xaxis = Line:new{p0=d[#d], p1=a} -- shock to nose of body
      outlet = Line:new{p0=d[1], p1=b} -- shock to last-point of body
      --
      patch = CoonsPatch:new{south=outlet, north=xaxis, west=shock, east=body}
   end
    local file = assert(io.open("west-boundary.csv", "w"))
   file:write("x,y\n")

   for _, p in ipairs(d) do
     file:write(string.format("%.16e,%.16e\n", p.x, p.y))
   end

   file:close()

   return {patch=patch, points={a=a, b=b, c=c, d=d}}
end
bp = billig_patch.make_patch{Minf=M_inf, R=R, scale=1.5, axisymmetric=true}
cf_circum = RobertsFunction:new{end0=false, end1=true, beta=1.01}
-- grid = StructuredGrid:new{psurface=bp.patch, niv=121, njv=121}
grid = StructuredGrid:new{psurface=bp.patch, niv=128+1, njv=256+1,
                       cfList={south=cf_circum, north=cf_circum}}

blk0 = FBArray:new{grid=grid, initialState=initial, label="blk",
                       bcList={west=InFlowBC_Supersonic:new{flowState=inflow},
                               north=OutFlowBC_Simple:new{}},
                       nib=1, njb=8}
-- We have left east and south as (default) slip-walls

grid:write_to_vtk_file("grid.vtk")

config.flux_calculator = "adaptive_hanel_ausmdv" -- try using different flux calculator to remove carbuncle effect (?)
config.spatial_deriv_calc = "divergence"
config.spatial_deriv_locn = "vertices"
body_flow_time = R/u_inf
t_final = 20 * body_flow_time -- allow time to establish
config.sticky_electrons = false  -- when it is disabled, the electrons are assumed to be in thermal equilibrium with the heavy species. When it is enabled, the electrons are allowed to have a different temperature from the heavy species.
-- config.cfl_value = 0.12 -- to get better chemistry-gas-dynamics coupling
config.cfl_value = 0.3
config.max_time = t_final
config.max_step = 2000000
config.dt_init = 1.0e-10
config.cfl_value = 0.2
config.dt_plot = t_final/50.0
config.dt_init = 1.0e-10

-- AT the beginning, the temperature in some of the cells of the grid exceeds 50,000 K. 
-- This is not desirable since the finite rate chemistry is valid for temperatures up to 50,000 K.
-- Report invalid cells, adjust them, but continue to run the simulation without interruption. 
config.max_invalid_cells = ni*nj/4 --means simulation will only terminate if over a quarter of cells in each subgrid are invalid (?)
config.adjust_invalid_cell_data = true -- (?)
config.report_invalid_cells = false -- This will speed up sim

-- Take snapshots every 1000 step and store the last two of them
-- So no need to start the simulation from the very beginning all the time
 config.snapshot_count = 1000
 config.number_total_snapshots = 2


                                               
