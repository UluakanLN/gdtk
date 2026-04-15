-- sphere.lua
--
-- X3 Argon Experimental test flow over spherical model
--
-- Adjusting to geometry and flow conditions used in Gilfind et al. (2022)
-- This is an inviscid simulation, so viscosity is not turned on

config.title = "X2_Finite_Rate_Argon"
config.axisymmetric = true

nsp,nmodes,gm=setGasModel("argon-gas-2T.lua")
config.reacting = true
config.reactions_file = "argon-gas-2T.lua"

--- Define flow conditions ---
-- These flow conditions are from Expansion Tube Test Flow.. 
-- ..Design for Magnetohydrodynamic Aerobraking (Gilfind et al, 2021) 
p_inf = 427.0  -- Pa
T_inf = 1112.0 -- K
v_inf = 6306.0 -- flow speed, m/s
mf_inf = {['Ar']=1.0,['Ar+']=0.0,['e-']=0.0}

inflow = FlowState:new{p=p_inf,T=T_inf,T_modes={T_inf},velx=v_inf,massf=mf_inf}
initial = FlowState:new{p=0.1*p_inf,T=T_inf,T_modes={T_inf},velx=0.0,massf=mf_inf}

--- Define the geometry ---
R = 0.01905 -- Radius of the spherical test body
alpha = 50.8*math.pi/180 --Angular positions to be used for defining geometry nodes

pnts = {} --Initialise list for storing all points

pnts.centr = Vector3:new{x=0.0, y=0.0};
pnts.a = Vector3:new{x=-1.0*R, y=0.0}; pnts.b = Vector3:new{x=R*math.cos(alpha), y=R*math.sin(alpha)}
pnts.c = Vector3:new{x=0.9*R, y=2.65*R}; pnts.d = Vector3:new{x=-1.4*R, y=0.0}
-- Bezier points for inflow boundary
pnts.s1 = Vector3:new{x=-1.4*R, y=1.1*R}; pnts.s2 = Vector3:new{x=-0.5*R, y=1.8*R}
-- Bezier points for outflow boundary
pnts.m1 = Vector3:new{x=0.9*R, y=1.5*R}; pnts.m2 = Vector3:new{x=1.0*R, y=2.1*R}

--- Define paths for the four boundary edges ---
-- Sphere surface
Arc_s = Arc:new{p0=pnts.a, p1=pnts.b, centre=pnts.centr} 
-- Outflow boundary, noting we have to reverse direction to match convention of North boundary progressing west to east
Bez_out =ReversedPath:new{underlying_path=Bezier:new{points={pnts.b,pnts.m1,pnts.m2,pnts.c}}}
-- Inflow boundary
Bez_in = Bezier:new{points={pnts.d,pnts.s1,pnts.s2,pnts.c}}
-- Shock standoff boundary
Line1 = Line:new{p0=pnts.d, p1=pnts.a}

-- Create points on inflow boundary and sphere surface boundary to allow us to split up into multiple blocks
-- Use eval tool with input of 0<=t<=1 to define points on these boundaries
tv1=0.175; tv2=0.4; tv3=0.6; tv4=0.8
-- Points on inflow boundary
pnts.e1 = Bez_in:eval(tv1); pnts.e2 = Bez_in:eval(tv2); pnts.e3 = Bez_in:eval(tv3); pnts.e4 = Bez_in:eval(tv4)
-- Points on shpere boundary
pnts.r1 = Arc_s:eval(tv1); pnts.r2 = Arc_s:eval(tv2); pnts.r3 = Arc_s:eval(tv3); pnts.r4 = Arc_s:eval(tv4)

-- Define points to define shape of the Bezier curves that split domain into 5 sub-blocks
pnts.p1 = Vector3:new{x=pnts.e1.x+0.65*(pnts.r1.x-pnts.e1.x),y=pnts.e1.y+0.0*R}
pnts.p2 = Vector3:new{x=pnts.e2.x+0.67*(pnts.r2.x-pnts.e2.x),y=pnts.r2.y+0.7*(pnts.e2.y-pnts.r2.y)}
pnts.p3 = Vector3:new{x=pnts.r3.x+0.0*R,y=pnts.r3.y+0.65*(pnts.e3.y-pnts.r3.y)}
pnts.p4 = Vector3:new{x=pnts.r4.x+0.15*R, y=(pnts.e4.y+pnts.r4.y)/2}

-- Define the Bezier curves used to split domain into 5 subgrids
Bez_a = Bezier:new{points={pnts.e1, pnts.p1, pnts.r1}}
Bez_b = Bezier:new{points={pnts.e2, pnts.p2, pnts.r2}}
Bez_c = Bezier:new{points={pnts.e3, pnts.p3, pnts.r3}}
Bez_d = Bezier:new{points={pnts.e4, pnts.p4, pnts.r4}}

--- Make patches ---

-- Initialise list for storing all patches
patch = {}

patch[0] = CoonsPatch:new{north=Bez_a, east=SubRangedPath:new{underlying_path=Arc_s, t0=0, t1=tv1},
south=Line1, west=SubRangedPath:new{underlying_path=Bez_in, t0=0, t1=tv1}}
patch[1] = CoonsPatch:new{north=Bez_b, east=SubRangedPath:new{underlying_path=Arc_s, t0=tv1, t1=tv2},
south=Bez_a, west=SubRangedPath:new{underlying_path=Bez_in, t0=tv1, t1=tv2}}
patch[2] = CoonsPatch:new{north=Bez_c, east=SubRangedPath:new{underlying_path=Arc_s, t0=tv2, t1=tv3},
south=Bez_b, west=SubRangedPath:new{underlying_path=Bez_in, t0=tv2, t1=tv3}}
patch[3] = CoonsPatch:new{north=Bez_d, east=SubRangedPath:new{underlying_path=Arc_s, t0=tv3, t1=tv4},
south=Bez_c, west=SubRangedPath:new{underlying_path=Bez_in, t0=tv3, t1=tv4}}
patch[4] = CoonsPatch:new{north=Bez_out, east=SubRangedPath:new{underlying_path=Arc_s, t0=tv4, t1=1.0},
south=Bez_d, west=SubRangedPath:new{underlying_path=Bez_in, t0=tv4, t1=1.0}}

--- Make the grid ---
-- No clustering for the inviscid flow simulations
-- Use parameter 'factor' to scale the grid (larger value means finer grid)
-- Note that 'factor' has to be a multiple of 4 be construction
factor = 72 -- note this is not 5grid-5 (?)
n0 = 3*factor; n1=0.5*factor
-- Initialise list for storing all grids
grid ={} 

grid[0] = StructuredGrid:new{psurface=patch[0], niv=n0+1, njv=n1+1}
grid[1] = StructuredGrid:new{psurface=patch[1], niv=n0+1, njv=n1+1}
grid[2] = StructuredGrid:new{psurface=patch[2], niv=n0+1, njv=n1+1}
grid[3] = StructuredGrid:new{psurface=patch[3], niv=n0+1, njv=n1+1}
grid[4] = StructuredGrid:new{psurface=patch[4], niv=n0+1, njv=n1+1, cfList={north=RobertsFunction:new{end0=false, end1=true, beta=1.25}}}
-- Inviscid simulation o yüzden clusterig yok dedin, bu ne peki??

-- Write vtk file so we can see mesh before running the simulation
for ib = 0,4 do

    fileName = string.format("sim-domain-blk-%d.vtk",ib)
    grid[ib]:write_to_vtk_file(fileName)
end

-- Call the lua file which does sketch of domain to visually inspect it
dofile("sketch-domain.lua")

-- Define fluid blocks as having initial state defined by 'initial'
blk0 = FluidBlock:new{grid=grid[0], initialState=initial}
blk1 = FluidBlock:new{grid=grid[1], initialState=initial}
blk2 = FluidBlock:new{grid=grid[2], initialState=initial}
blk3 = FluidBlock:new{grid=grid[3], initialState=initial}
blk4 = FluidBlock:new{grid=grid[4], initialState=initial}

identifyBlockConnections()

--- Define boundary conditions ---

-- Inflow is through west bundary of all grids
blk0.bcList['west'] = InFlowBC_Supersonic:new{flowState=inflow}
blk1.bcList['west'] = InFlowBC_Supersonic:new{flowState=inflow}
blk2.bcList['west'] = InFlowBC_Supersonic:new{flowState=inflow}
blk3.bcList['west'] = InFlowBC_Supersonic:new{flowState=inflow}
blk4.bcList['west'] = InFlowBC_Supersonic:new{flowState=inflow}

-- Outflow is north boundary of grid4
blk4.bcList['north'] = OutFlowBC_Simple:new{}

-- The east boundary of each grid block is the surface sphere
-- Given this is an inviscid simulation, can only use wall with slip boundary conditions 
blk0.bcList['east'] = WallBC_WithSlip:new{}
blk1.bcList['east'] = WallBC_WithSlip:new{}
blk2.bcList['east'] = WallBC_WithSlip:new{}
blk3.bcList['east'] = WallBC_WithSlip:new{}
blk4.bcList['east'] = WallBC_WithSlip:new{}

--- Define history points
-- Add history points in front of stagnation point
setHistoryPoint{x=-1.01*R,y=0.0}
setHistoryPoint{x=-1.05*R,y=0.0}
setHistoryPoint{x=-1.10*R,y=0.0}

--- Config options ---
-- Source terms for Lorentz force
--config.udf_source_terms = true
--config.udf_source_terms_file = 'udf-source-terms.lua'

config.flux_calculator = "hanel" -- try using different flux calculator to remove carbuncle effect (?)

config.sticky_electrons = true --(?)
config.cfl_value = 0.12 -- to get better chemistry-gas-dynamics coupling

config.max_time = 250.0e-6
config.max_step = 2000000
--config.dt_plot = 2.5e-6
config.dt_plot = 2.5e-7
config.dt_history = config.dt_plot/100.0 -- added this line to hopefully have history plot more frequently (?)
config.dt_init = 1.0e-9

-- AT the beginning, the temperature in some of the cells of the grid exceeds 50,000 K. 
-- This is not desirable since the finite rate chemistry is valid for temperatures up to 50,000 K.
-- Report invalid cells, adjust them, but continue to run the simulation. 
config.max_invalid_cells = n0*n1/4 --means simulation will only terminate if over a quarter of cells in each subgrid are invalid (?)
config.adjust_invalid_cell_data = true -- (?)
config.report_invalid_cells = false -- This will speed up sim

-- Take snapshots every 1000 step and store the last two of them
-- So no need to start the simulation from the very beginning all the time
 config.snapshot_count = 1000
 config.number_total_snapshots = 2