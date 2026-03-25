local sin = math.sin
local cos = math.cos
local exp = math.exp
local pi = math.pi

function solidInterface(args)
   x = args.x; y = args.y; t = args.t
   

T_s = (300.02 - 0.02*y)*(0.5*sin(6283.1853071795865*t) + 1.0)



   return T_s
end

