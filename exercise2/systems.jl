function chain_random(length::Int)::Vector{Magnet}
    #=

    Returns a 1D vector of magnets along the x-axis. Spins are random

    =# 
    magnets = Array{Magnet,1}(undef, length)
    for i in 1:length
        vec = [rand(Uniform(-1,1)), rand(Uniform(-1,1)), rand(Uniform(-1,1))]
        magnets[i] = Magnet((i,0,0), vec ./ norm(vec))
    end
    magnets = collect(magnets)
    return magnets
end

function chain_groundstate_FM(length::Int, middle_tilted::Bool = false)::Vector{Magnet}
    #= 

    Returns a 1D vector of magnets along the x-axis. Spins are in ground state [0,0,1].
    If middle_tilted == true, the middle magnet is given a slightly tilted spin. 

    =#
    
    magnets = Vector{Magnet}()
    for i ∈ 1:length
        push!(magnets, Magnet((i,0,0), [0,0,1]))
    end
    
    if middle_tilted
        halfway = trunc(Int,length/2)
        magnets[halfway].spin = [0.2, 0.2, √23 / 5]
    end
    
    return magnets
end

function box_random(N_x::Int, N_y::Int, N_z::Int)::Array{Magnet,3}
    #=

    Returns a 3D array of magnets with given dimensions. Spins are random

    =#

    magnets = Array{Magnet,3}(undef, N_x, N_y, N_z)
    for idx in CartesianIndices(magnets)
        vec = [rand(Uniform(-1,1)), rand(Uniform(-1,1)), rand(Uniform(-1,1))]
        magnets[idx] = Magnet((idx.I), vec ./ norm(vec))
    end
    return magnets
end
            
function box_groundstate(N_x::Int, N_y::Int, N_z::Int)::Array{Magnet,3}
    #=

    Returns a 3D array of magnets with given dimensions. Spins are in ground state [0,0,1]

    =#
    
    magnets = Array{Magnet,3}(undef, N_x, N_y, N_z)
    for idx in CartesianIndices(magnets)
        magnets[idx] = Magnet((idx.I), [0,0,1])
    end
    return magnets
end

function chain_groundstate_AFM(length::Int, middle_tilted::Bool = false)::Vector{Magnet}
    #= 

    Returns a 1D vector of magnets along the x-axis. Spins are in ground state [0,0,1].
    If middle_tilted == true, the middle magnet is given a slightly tilted spin. 

    =#
    
    magnets = Vector{Magnet}()
    for i ∈ 1:length
        if i % 2 == 0
            push!(magnets, Magnet((i,0,0), [0,0,1]))
        else
            push!(magnets, Magnet((i,0,0), [0,0,-1]))
        end
    end
    
    if middle_tilted
        halfway = trunc(Int,length/2)
        magnets[halfway].spin = [0.2, 0.2, √23 / 5]
    end
    
    return magnets
end