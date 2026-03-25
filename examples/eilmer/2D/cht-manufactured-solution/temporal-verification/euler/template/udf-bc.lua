local sin = math.sin
local cos = math.cos
local exp = math.exp
local pi = math.pi

function fillTable(tab, x, y, t)
   

tab.p = 50000.0*sin(6283.1853071795865*t) + 100000.0



tab.T = (300.2 - 0.2*y)*(0.5*sin(6283.1853071795865*t) + 1.0)



tab.velx = (1.0 - y)*(0.05*sin(6283.1853071795865*t) + 0.1)



tab.vely = (1.0 - y)*(0.05*sin(6283.1853071795865*t) + 0.1)



   tab.velz = 0.0
   return tab
end

function ghostCells(args)
   x = args.x; y = args.y; t = args.t
   i = args.i; j = args.j; k = args.k
   ghost0 = {}
   fillTable(ghost0, args.gc0x, args.gc0y,t)
   ghost1 = {}
   fillTable(ghost1, args.gc1x, args.gc1y,t)
   return ghost0, ghost1
end

function interface(args)
   x = args.x; y = args.y; t = args.t
   iface = {}
   fillTable(iface, x, y, t);
   return iface
end


