function chain_random(length::Int)
    magnets = []
    for i in 1:length
        vec = [rand(Uniform(-1,1)), rand(Uniform(-1,1)), rand(Uniform(-1,1))]
        push!(magnets, Magnet((i,0,0), vec ./ norm(vec)))
    end

    return magnets
end

function chain_groundstate(length::Int, middle_tilted::Bool = false)
    magnets = []
    for i ∈ 1:length
        push!(magnets, Magnet((i,0,0), [0,0,1]))
    end
    
    if middle_tilted
        halfway = floor(length/2)
        magnets[halfway].spin = [0.2, 0.2, √23 / 5]
    end
    
    return magnets
end

    

