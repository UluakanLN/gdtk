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

-- Define flow conditions
-- These flow conditions are from Expansion Tube Test Flow.. 
-- ..Design for Magnetohydrodynamic Aerobraking (Gilfind et al, 2021) 
p_inf = 427.0  -- Pa
T_inf = 1112.0 -- K
v_inf = 6306.0 -- flow speed, m/s
mf_inf = {['Ar']=1.0,['Ar+']=0.0,['e-']=0.0}

inflow = FlowState:new{p=p_inf,T=T_inf,T_modes={T_inf},velx=v_inf,massf=mf_inf}
initial = FlowState:new{p=0.1*p_inf,T=T_inf,T_modes={T_inf},velx=0.0,massf=mf_inf}

-- Define the geometry
