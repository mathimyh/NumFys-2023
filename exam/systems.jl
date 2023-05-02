mutable struct Acid
    pos::Tuple{Int, Int}
    type::Int
    cov_bond::Set{Acid}
    nearest::Set{Acid}
end

function chain_2d(len::Int, grid_size::Int, folded::Bool = true)
    
    grid = Array{Acid, 2}(undef, grid_size, grid_size)
    acids = Set()
    prev::Acid = Acid((rand(1:grid_size), rand(1:grid_size)), rand(1:20), Set(), Set())
    bords = [(0,1),(1,0),(0,-1),(-1,0)]
    println(prev.pos)

    for i in 1:len-1
        
        # Find a position thats not occupied
        pos = prev.pos .+ rand(bords)
        while pos ∈ acids || pos .> (grid_size,grid_siz || pos .< (1,1)
            pos = prev.pos .+ rand(bords)
        end
        
        println(pos)

        # Add to the array and set
        grid[pos...] = Acid(pos, rand(1:20), Set(), Set())
        push!(acids, pos)

        # Find the covalent bonds
        if i > 1
            push!(grid[pos...].cov_bond, prev)
            push!(grid[prev.pos...].cov_bond, grid[pos...])
        end
        

        # Find the nearest neighbours
        for bord in bords
            temp = pos .+ bord
            if temp ∈ acids && temp ∉ grid[pos...].cov_bond
                push!(grid[pos...].nearest, grid[temp...])
            end
        end

        # Define this for next iteration 
        prev = grid[pos...]
    end

    return grid, acids
end
        
        
        