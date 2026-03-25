local sin = math.sin
local cos = math.cos
local exp = math.exp
local pi = math.pi
t = 0.0
function solidFillFn(x, y, z)
   

T_s = (300.02 - 0.02*y)*(0.5*sin(6283.1853071795865*t) + 1.0)



   return T_s
end
