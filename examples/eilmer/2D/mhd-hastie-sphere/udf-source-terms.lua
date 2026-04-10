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

-- some convenient variables needed for the calculations
local molar_mass_Ar = 39.948e-3 -- kg/mol
local W_e = 5.485799e-7 --kg/mol -- electron molar mass, actually W_e = mass_e x NA 
local mass_e = 9.10938356e-31 -- mass of one elecron in kg
local NA = 6.02e23 -- Avogadro's constant 1/mol

--- Simulation parameters ---
-- Streamwise location of the center of the magnet. This strength corresponds to the strongest magnetic field (?)
magnet_location = 130*0.0254/2 -- streamwise location of the magnet center
magnetisation = -1185.0 --(?)
magnet_radius = 130*0.0254/2 --(?)
mu0 = 1.0 --(?)
n_e_min = 1.0e19  -- where did you find this threshold?

function magnetic_field(x,y)
    B_vector = {}
    x = x - magnet_location --need to adjust so that x is the relative distance between the magnet centre and the cell
    r = math.sqrt(x^2+y^2)
    if r < magnet_radius then
        Bx = 2./3.*mu0*magnetisation
        By = 0.0
    else
        mx = 4./3.*math.pi*magnet_radius^3*magnetisation
        Bx = mu0/4./math.pi * (-mx/r^3 + 3*mx*x^2/r^5)
        By = mu0/4./math.pi * (3*mx*x*y/r^5)
    end
    -- equations above are for mT, so changing those to Tesla
    Bx = Bx/1000.0
    By = By/1000.0
    B_vector.x = Bx
    B_vector.y = By
    return B_vector
end -- end function magnetic_field 

--magnet delay and ramp-up time (?????????)
local t_magnet_delay = 10.0E-6 --(?)
local t_magnet_ramp = 20.0E-6 --(?)

local magnet_schedule_t = {0, 10.0E-6, 20.0E-6, 30.0E-6, 40.0E-6, 50.0E-6, 60.0E-6, 70.0E-6, 80.0E-6, 90.0E-6,
100.0E-6, 110.0E-6, 120.0E-6, 130.0E-6, 140.0E-6, 150.0E-6, 160.0E-6, 170.0E-6, 180.0E-6, 190.0E-6, 200.0E-6,
210.0E-6, 220.0E-6, 230.0E-6, 240.0E-6, 250.0E-6} ----------------should these not be in terms of t_magnetdelay??

--local magnet_schedule_t = {0, 10.0E-6, 20.0E-6, 30.0E-6, 40.0E-6, 50.0E-6, 60.0E-6, 70.0E-6, 80.0E-6, 90.0E-6,
--100.0E-6, 110.0E-6, 120.0E-6, 130.0E-6, 140.0E-6, 150.0E-6, 160.0E-6, 170.0E-6, 180.0E-6, 190.0E-6, 200.0E-6,
--210.0E-6, 220.0E-6, 230.0E-6, 240.0E-6, 250.0E-6} ----------------should these not be in terms of t_magnetdelay??
-- Also changed above to be more appropriate scaling (??????????)

local magnet_schedule_Bscale = {0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
local size_magnet_schedule = 26 --table.getn(magnet_schedule_t) -------------------------------------But there is only 6 elements
local t_current = 0.0
local t_counter = 0

function sourceTerms(t, cell)
    -- computes the Lorentz force source term which appears in the resistive MHD equations
    src = {}
    local ux = cell.velx
    local uy = cell.vely
    local massf_e_minus = cell.massf["e-"]
    local massf_Ar = cell.massf["Ar"]
    local rho = cell.rho
    local Tve = cell.T_modes[1]

    --electron mass fraction
    local n_e = 0.0
    if cell.massf["e-"] == nil then
        n_e = 0.0
    else
        n_e = NA*cell.massf["e-"]*cell.rho/W_e --electron number density -----------------cant find eq but units make sense
    end

     function conductivity(n_e)
        sigma = 0.0
        --electrical conductivity from Raiser for a strongly ionized plasma
        if n_e < n_e_min then
           sigma = 0.0
        else
           local Te = 0.0; local lnA = 0.0
            K_to_eV = 11604.525 --conversion between Kelvin and eV --K eV-1
            Te = Tve / K_to_eV
            lnA = 13.57 + 1.5 * math.log10(Te) - 0.5 * math.log10((n_e+1.0)*1.0e-6) ---------------------The +1?
            sigma = (1.9e2 * (Te^(1.5)) / lnA) * 100.0 --Ohm-1 m-1
         end

        if sigma == nil or sigma > 1.0e5 then -- This is just to handle some extreme cases that can occur in low density/freestream flow
            sigma = 0.0
        end
        return sigma -- conductivity
    end
    --------------------------------------------------------didnt use weakly ionised equation (?)
    function Lorentz_src(Bx,By,ux,uy,sigma)
        F = {}
        F.x = -sigma*By*(ux*By-uy*Bx)
        F.y = sigma*Bx*(ux*By-uy*Bx)
        return F
    end --Lorentz_src

    -- Some flow/geometry parameters
    local Ro = 0.01905 --[m] -----------------changed this
    local V_inf = 6306.0 -- m/s ----------changed this
    local flowTime = 2.0*Ro/V_inf

    --Only calculate Lorentz force if sufficient ionization is reached, otherwise might get unstable/strange results
    if n_e < n_e_min or t < 0.0*flowTime then --------------------------------------------Is this meant to be 0*Flow time?
        src.momentum_x = 0.0 -- -sigma*By*(ux*By-uy*Bx)
        src.momentum_y = 0.0 -- sigma*Bx*(ux*By-uy*Bx)
        src.momentum_z = 0.0
        src.total_energy = 0.0
    else
        x = cell.x
        y = cell.y
        B_vector = magnetic_field(x,y)

        for i = 2,size_magnet_schedule,1
        do
            if t < magnet_schedule_t[i] then
                t_lwr = magnet_schedule_t[i-1]
                Bscale_lwr = magnet_schedule_Bscale[i-1]
                t_upr = magnet_schedule_t[i]
                Bscale_upr = magnet_schedule_Bscale[i]
            break
            end
        end

        BScale = Bscale_lwr + (Bscale_upr - Bscale_lwr)/(t_upr - t_lwr)*(t - t_lwr)
        Bx = B_vector.x*BScale
        By = B_vector.y*BScale
        --if t~=t_current then
        --t_counter = t_counter + 1
        --if t_counter==10 then
        --t_current=t
        --print("Bscale = ",BScale)
        --print("t = ",t)
        --print("x = ",x)
        --print("y = ",y)
        --print("Bx = ",Bx)
        --print("By = ",By)
        --t_counter = 0
        --end
        --end

        sigma = conductivity(n_e)
        MHD_force = Lorentz_src(Bx,By,ux,uy,sigma)
        src.momentum_x = MHD_force.x
        src.momentum_y = MHD_force.y
        src.momentum_z = 0.0
        src.total_energy = 0.0
        
    end
    return src
end
