local sin = math.sin
local cos = math.cos
local exp = math.exp
local pi = math.pi

function refSoln(t, x, y, z)
   tab = {}
   

tab.rho = 0.00348432055749129*(50000.0*sin(6283.1853071795865*t) +100000.0)/((300.2 - 0.2*y)*(0.5*sin(6283.1853071795865*t) + 1.0))



tab.p = 50000.0*sin(6283.1853071795865*t) + 100000.0



tab.T = (300.2 - 0.2*y)*(0.5*sin(6283.1853071795865*t) + 1.0)



tab.T = (300.02 - 0.02*y)*(0.5*sin(6283.1853071795865*t) + 1.0)



tab['vel.x'] = (1.0 - y)*(0.05*sin(6283.1853071795865*t) + 0.1)



tab['vel.y'] = (1.0 - y)*(0.05*sin(6283.1853071795865*t) + 0.1)



   return tab
end

refSolidSoln = refSoln

