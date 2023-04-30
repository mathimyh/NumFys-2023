function magnetization(S::Array{Magnet})
    #=

    The formula for finding the magnetization, averaged over N magnets but not time.

    =#
    
    M::Float64 = 0
    for i in CartesianIndices(S)
        M += S[i].spin[3]
    end
    return M / length(S)
end


function simulate_mag(filename::String, steps::Int, N_x::Int = 20, N_y::Int = 20, N_z::Int = 20)
    #= 
    
    Initalizes a 3d boox with random directions, then simulates over given number of steps.
    Also saves this in a file named by filename

    Returns: 
        Ms::Vector{Float64} : The magnetization at each time steps
        ts::Vector{Float64} : The time steps for plotting

    =#

    S = box_random(N_x,N_y,N_z)
    Ms = Vector{Float64}(undef, steps+1)
    ts = Vector{Float64}(undef, steps+1)
    t = 0
    push!(Ms, magnetization(S))
    push!(ts, t)
    
    for i in eachindex(Ms)
        Heun!(S, J)
        t += step_size
        Ms[i] = magnetization(S)
        ts[i] = t
    end
    
    save(filename, "Ms", Ms, "ts", ts)
    
    return Ms, ts
end