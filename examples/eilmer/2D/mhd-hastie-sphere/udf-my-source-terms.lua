-- udf-source-terms.lua
--
-- Source term for including Lorentz force as a body force in the flow
--
-- changed magnetic field formulation to be correct for spherical magnet, rather than using theoretical dipole,
-- equation from http://farside.ph.utexas.edu/teaching/jk1/lectures/node61.html
--
-- Note this script does not account for Hall effects, nor does it account for the MHD source term in the energy
-- conservation equation.
--
-- Electrical conductivity is a scalar value

-- some convenient functions for later use
local exp = math.exp
local sqrt = math.sqrt
local pi = math.pi
local log = math.log

-- some convenient functions needed for the calculations
local molar_mass_Ar = 39.948e-3 -- kg/mol
local W_e = 5.485799e-7 kg/mol -- electron molar mass, actually W_e = mass_e x NA 
local mass_e = 9.10938356e-31 -- mass of one elecron in kg
local NA = 6.02e23 -- Avogadro's constant 1/mol

function sourceTerms(t, cell)
    -- computes the Lorentz force source term which appears in the resistive MHD equations
    src = {}
    --local ux = cell.velx
    --local uy = cell.vely
    --local massf_e_minus = cell.massf["e-"]
    --local massf_Ar = cell.massf["Ar"]
    --local rho = cell.rho
    --local Tve = cell.T_modes[1]

    ------------------------------------------Is this meant to be 0*Flow time?
        src.momentum_x = 0.0 -- -sigma*By*(ux*By-uy*Bx)
        src.momentum_y = 0.0 -- sigma*Bx*(ux*By-uy*Bx)
        src.momentum_z = 0.0
        src.total_energy = 0.0
    return src
end
