function sourceTerms(t, cell)
    local src = {}

    src.mass = 0.0
    src.momentum_x = 0.0
    src.momentum_y = 0.0
    src.momentum_z = 0.0
    src.total_energy = 0.0

    if t >= 5.0e-4 then
        src.momentum_y = 50000.0
    end

    return src
end