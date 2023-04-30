function chain_random(length::Int)
    magnets = Array{Magnet,1}(undef, length)
    for i in 1:length
        vec = [rand(Uniform(-1,1)), rand(Uniform(-1,1)), rand(Uniform(-1,1))]
        magnets[i] = Magnet((i,0,0), vec ./ norm(vec))
    end
    magnets = collect(magnets)
    return magnets
end

function chain_groundstate(length::Int, middle_tilted::Bool = false)
    magnets = Vector{Magnet}()
    for i ∈ 1:length
        push!(magnets, Magnet((i,0,0), [0,0,1]))
    end
    
    if middle_tilted
        halfway = floor(length/2)
        magnets[halfway].spin = [0.2, 0.2, √23 / 5]
    end
    
    return magnets
end

function box_random(N_x::Int, N_y::Int, N_z::Int)::Array{Magnet,3}
    dims = (N_x, N_y, N_z)
    magnets = Array{Magnet,3}(undef, N_x, N_y, N_z)
    for idx in CartesianIndices(magnets)
        vec = [rand(Uniform(-1,1)), rand(Uniform(-1,1)), rand(Uniform(-1,1))]
        magnets[idx] = Magnet((idx.I), vec ./ norm(vec))
    end
    return magnets
end
            


