# I made a new type which is a gridpoint. This is either a monomer (Acid) or an empty spot (EmptySpot)
# This made it easier to access the different monomers in the grid.

abstract type GridPoint end

mutable struct Acid <: GridPoint
    pos::Tuple{Int, Int}
    type::Int
    cov_bond::Vector{Acid}
    nearest::Vector{Acid}
end

mutable struct EmptySpot <: GridPoint
end

# A logger is a struct containing information about the system at each MC sweep
mutable struct Logger
    energies::Vector{Float64}
end

function nearest_neighbours(this::Acid, acids::Vector{Acid})
    occupied = [acid.pos for acid in acids]
    this.nearest = Vector{Acid}()
    bords = [(0,1),(1,0),(0,-1),(-1,0)] # Generalize!
    for bord in bords
        temp = pos .+ bord
        idx = findindex(temp, acids)
        if temp ∈ occupied && temp ∉ this.cov_bond
            push!(this.nearest, acids[idx])
        end
    end
end


function folded_chain2D(len::Int, grid_size::Int)

    grid = Array{GridPoint, 2}(undef, grid_size, grid_size)
    for idx in CartesianIndices(grid); grid[idx] = EmptySpot(); end
    acids = Vector{Acid}()
    start::Acid = Acid((rand(1:grid_size), rand(1:grid_size)), rand(1:20), Vector{Acid}(), Vector{Acid}())
    grid[start.pos...] = start
    push!(acids, start)

    for i in 2:len 
        
        occupied = [acid.pos for acid in acids]

        # There is a possibility that all ways to go are occupied, can only happen after the 7th acid
        # This tracks back and finds a new route
        
        #   A -> A -> A             A -> A -> A             A -> A -> A
        #   ^         |             ^         |             ^         |
        #   S    E    A     ---->   S         A     OR      S         A 
        #        ^    |                       |                       |
        #        A <- A                  A <- A             E <- A <- A
        #                                |
        #                                E 

        # if i > 2; if all([acids[i-1].pos .+ bord for bord in bords] ∈ occupied)
        #     last_step = acids[i-2].pos .- acids[i-1].pos
        #     lastlast_step = acids[i-2].pos .- acids[i-2].pos 
        #     temp = bords
        #     delete!(temp, last_step)
        #     delete!(temp, lastlast_step)
            
        #     # If it is totally stuck its just easier to start over
        #     if (acids[i-2].pos .+ temp[1] ∈ occupied) && (acids[i-2].pos .+ temp[2] ∈ occupied)
        #         return chain_2d(len, grid_size, folded)
        #     end

        #     acids[i-1].pos = acids[i-2].pos .+ rand(temp)
        # end; end


        # Find a position thats not occupied
        pos = acids[i-1].pos .+ rand(bords)
        tries = 0
        while pos ∈ occupied || !all(1 < x < grid_size for x in pos)
            pos = acids[i-1].pos .+ rand(bords)
            tries += 1
            if tries > 4
                return chain_2d(len, grid_size, folded)
            end
        end

        # Add to the grid and vector
        grid[pos...] = Acid(pos, rand(1:20), Vector{Acid}(), Vector{Acid}())
        push!(acids, grid[pos...])

        # Find the covalent bonds
        push!(grid[pos...].cov_bond, acids[i-1])
        push!(acids[i-1].cov_bond, grid[pos...])
        
        # Find the nearest neighbours
        nearest_neighbours(grid[pos...], acids)
    end

    return grid, acids
end

function unfolded_chain2D(len::Int, gridsize::Int)
    
    grid = Array{GridPoint, 2}(undef, gridsize, gridsize)
    for idx in CartesianIndices(grid); grid[idx] = EmptySpot(); end
    acids = Vector{Acid}()

    for i in 1:len
        new = Acid((trunc(Int,gridsize/3+i), trunc(Int, gridsize/2)), rand(1:20), Vector{Acid}(), Vector{Acid}())
        push!(acids, new)
        grid[new.pos...] = new
        if i > 1
            push!(acids[i].cov_bond, acids[i-1])
            push!(acids[i-1].cov_bond, acids[i])
        end
    end

    return grid, acids
end


function interaction_energies()
    interaction_matrix = Symmetric(rand(Uniform(-4*kb,-2*kb), 20,20))
    return interaction_matrix
end

function calculate_energy(acids::Vector{Acid}, interaction_e)::Float64
    energy::Float64 = 0
    for acid in acids
        for near in acid.nearest
            energy += interaction_e[acid.type, near.type]
        end
    end
    return energy * 0.5 # Account for double counting
end
     
function findindex(this::Acid, acids::Vector{Acid})::Int
    idx = 0
    for i in eachindex(acids)
        if acids[i].pos == this.pos
            idx = i
        end
    end
    return idx
end
        
        