function sourceTerms(t, cell)
    local src = {}

    src.mass = 0.0
    src.momentum_x = 0.0
    src.momentum_y = 0.0
    src.momentum_z = 0.0
    src.total_energy = 1e8

   -- if t >= 2.0e-5 then
    --    src.momentum_y = 500.0
    --end

    return src
end