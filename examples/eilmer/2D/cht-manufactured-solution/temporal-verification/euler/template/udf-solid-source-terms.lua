local sin = math.sin
local cos = math.cos
local exp = math.exp
local pi = math.pi

function solidSourceTerms(t, cell)
   src = {}
   x = cell.x
   y = cell.y


fe_s = 1000000000.0*pi*(300.02 - 0.02*y)*cos(6283.1853071795865*t)



   return fe_s
end
