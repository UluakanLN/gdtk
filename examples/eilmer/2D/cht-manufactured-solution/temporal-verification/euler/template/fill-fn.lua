local sin = math.sin
local cos = math.cos
local exp = math.exp
local pi = math.pi
t = 0.0
function gasFillFn(x, y, z)
   

p = 50000.0*sin(6283.1853071795865*t) + 100000.0



T_ = (300.2 - 0.2*y)*(0.5*sin(6283.1853071795865*t) + 1.0)



velx = (1.0 - y)*(0.05*sin(6283.1853071795865*t) + 0.1)



vely = (1.0 - y)*(0.05*sin(6283.1853071795865*t) + 0.1)



   return FlowState:new{p=p, T=T, velx=velx, vely=vely}
end
