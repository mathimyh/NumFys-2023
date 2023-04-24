function chain_1D(length::Int, random::Bool = true)
    magnets = []
    for i in 1:length
        vec = [rand(Uniform(-1,1)), rand(Uniform(-1,1)), rand(Uniform(-1,1))]
        push!(magnets, Magnet((i,0,0), vec ./ norm(vec)))
    end

    return magnets
end