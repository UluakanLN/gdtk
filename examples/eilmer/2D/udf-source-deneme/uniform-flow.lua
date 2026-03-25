-- simple.lua

config.title = "2D UDF test - y momentum forcing"
config.axisymmetric = false

-- gaz modeli
setGasModel("ideal-air-gas-model.lua")

-- giriş akışı (soldan sağa)
inflow = FlowState:new{
    p = 1.0e5,
    T = 300.0,
    velx = 200.0,
    vely = 0.0
}

-- domain (kare)
a = Vector3:new{x=0.0, y=0.0}
b = Vector3:new{x=1.0, y=0.0}
c = Vector3:new{x=0.0, y=1.0}
d = Vector3:new{x=1.0, y=1.0}

patch = makePatch{
    north=Line:new{p0=c, p1=d},
    east=Line:new{p0=b, p1=d},
    south=Line:new{p0=a, p1=b},
    west=Line:new{p0=a, p1=c}
}

grid = StructuredGrid:new{
    psurface=patch,
    niv=41,
    njv=41
}

blk = FluidBlock:new{
    grid=grid,
    initialState=inflow
}

-- boundary conditions
blk.bcList['west']  = InFlowBC_Supersonic:new{flowState=inflow}
blk.bcList['east']  = OutFlowBC_Simple:new{}
blk.bcList['north'] = WallBC_WithSlip:new{}
blk.bcList['south'] = WallBC_WithSlip:new{}

-- UDF AKTİF Mİ?
config.udf_source_terms = true
config.udf_source_terms_file = "udf-source-terms.lua"

-- solver ayarları
config.max_time = 1.0e-2
config.dt_init = 1.0e-7
config.max_step = 5e3
config.dt_plot = 0.5e-4
config.flux_calculator = "ausmdv"

