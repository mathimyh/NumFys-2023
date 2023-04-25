function chain_1D(length::Int, random::Bool = true)
    magnets = []
    for i in 1:length
        vec = [rand(Uniform(-1,1)), rand(Uniform(-1,1)), rand(Uniform(-1,1))]
        push!(magnets, Magnet((i,0,0), vec ./ norm(vec)))
    end

    return magnets
end

function chain_middlediff(length::Int)
    magnets = []
    for i ∈ 1:length
        push!(magnets, Magnet((i,0,0), [0,0,1]))
    end
    halfway = trunc(length/2)
    magnets[50].spin = [0.2, 0.2, √23 / 5]
    
    return magnets
end

