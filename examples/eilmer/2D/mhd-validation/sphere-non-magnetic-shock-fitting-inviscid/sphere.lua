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
print("M_inf=", M_inf)

-- Set up the geometry for defining the grid.
a = {x=0.0, y=0.0}
b = {x=-R, y=0.0}
c = {x=0.0, y=R}
d = {{x=-1.5*R,y=0.0}, {x=-1.5*R,y=R}, {x=-R,y=2*R}, {x=0.0,y=3*R}}
-- Set up surface and grid.
psurf = CoonsPatch:new{
   north=Line:new{p0=d[#d], p1=c}, east=Arc:new{p0=b, p1=c, centre=a},
   south=Line:new{p0=d[1], p1=b}, west=Bezier:new{points=d}
}
ni = 64; nj = 128
grid = StructuredGrid:new{psurface=psurf, niv=ni+1, njv=nj+1}
-- Shock-fitting is coordinated across four blocks
-- that are part of a single FBArray.
blk = FBArray:new{
   grid=grid, fillCondition=initial, label='blk',
   bcList={west=InFlowBC_ShockFitting:new{flowCondition=inflow},
           north=OutFlowBC_Simple:new{}},
   nib=1, njb=8
}

grid:write_to_vtk_file("grid.vtk")

-- Now, set some configuration options.
body_flow_time = R/u_inf
t_final = 30 * body_flow_time -- allow time to establish
--config.axisymmetric = true
--config.reacting = true
--config.reactions_file = 'Rogers-Schexnayder-reac-file.lua'
config.flux_calculator = "ausmdv"
config.gasdynamic_update_scheme = "moving_grid_2_stage"
config.grid_motion = "shock_fitting"
config.shock_fitting_delay = 3 * body_flow_time
config.interpolation_delay = 10 * body_flow_time
config.max_time = t_final
config.max_step = 800000
config.dt_init = 1.0e-10
config.cfl_value = 0.4
config.dt_plot = config.max_time/10.0

-- AT the beginning, the temperature in some of the cells of the grid exceeds 50,000 K. 
-- This is not desirable since the finite rate chemistry is valid for temperatures up to 50,000 K.
-- Report invalid cells, adjust them, but continue to run the simulation without interruption. 
config.max_invalid_cells = ni*nj/16 --means simulation will only terminate if over a quarter of cells in each subgrid are invalid (?)
config.adjust_invalid_cell_data = true -- (?)
config.report_invalid_cells = false -- This will speed up sim

-- Take snapshots every 1000 step and store the last two of them
-- So no need to start the simulation from the very beginning all the time
 config.snapshot_count = 1000
 config.number_total_snapshots = 2