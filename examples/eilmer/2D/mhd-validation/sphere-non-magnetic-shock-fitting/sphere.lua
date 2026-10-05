-- sphere.lua
--
-- X2 Air Experimental test flow over spherical model
--
-- Adjusting to geometry and flow conditions used in Lefevre, Alexis PhD thesis (2022)
-- This is an inviscid simulation, so viscosity is not turned on

config.title = "X2-Experiment-Condition-C5"
config.axisymmetric = true

nsp,nmodes,gmodel=setGasModel("air-11sp-gas-model.lua")
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
delta = 0.007 (approximate guess from billig patch result with a scale 1.2)

grid:write_to_vtk_file("grid.vtk")

-- Take snapshots every 1000 step and store the last two of them
-- So no need to start the simulation from the very beginning all the time
 config.snapshot_count = 1000
 config.number_total_snapshots = 2

