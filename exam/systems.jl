mutable struct Acid
    pos::Tuple{Int, Int}
    type::Int
    cov_bond::Vector{Acid}
    nearest::Vector{Acid}
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
        temp = this.pos .+ bord
        idx = findindex(temp, acids)
        if temp ∈ occupied && acids[idx] ∉ this.cov_bond
            push!(this.nearest, acids[idx])
        end
    end
end

function nearest_neighbours(tup::Tuple{Int, Int}, acids::Vector{Acid})
    this = acids[findindex(tup, acids)]
    occupied = [acid.pos for acid in acids]
    this.nearest = Vector{Acid}()
    bords = [(0,1),(1,0),(0,-1),(-1,0)] # Generalize!
    for bord in bords
        temp = this.pos .+ bord
        idx = findindex(temp, acids)
        if temp ∈ occupied && acids[idx] ∉ this.cov_bond
            push!(this.nearest, acids[idx])
        end
    end
end


function folded_chain2D(len::Int)

    #=

    Initalizes a chain of monomers in a 2D grid. 
    Returns the vector of these monomers where all elements are of type Acid
    
    =# 

    acids = Vector{Acid}()
    start::Acid = Acid((len, len), rand(1:20), Vector{Acid}(), Vector{Acid}())
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

        # Find a position thats not occupied'
        bords = [(1,0),(0,1),(-1,0),(0,-1)]
        pos = acids[i-1].pos .+ rand(bords)
        tries = 0
        while pos ∈ occupied
            pos = acids[i-1].pos .+ rand(bords)
            tries += 1
            if tries > 4 # Should maybe make a more sophisticated solution here. I just try again if its stuck
                return chain_2d(len)
            end
        end

        # Add to the grid and vector
        this = Acid(pos, rand(1:20), Vector{Acid}(), Vector{Acid}())
        push!(acids, this)

        # Find the covalent bonds
        push!(this.cov_bond, acids[i-1])
        push!(acids[i-1].cov_bond, this)
        
        # Find the nearest neighbours
        nearest_neighbours(this, acids)
    end

    return acids
end

function unfolded_chain2D(len::Int)
    
    #=

    Initalizes a straight chain of monomers on a 2D grid. Returns the vector of these. 
    
    =#

    acids = Vector{Acid}()

    for i in 1:len
        this = Acid((len+i, len), rand(1:20), Vector{Acid}(), Vector{Acid}())
        push!(acids, this)
        if i > 1
            push!(acids[i].cov_bond, acids[i-1])
            push!(acids[i-1].cov_bond, acids[i])
        end
    end

    return acids
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
     
function findindex(this::Tuple{Int,Int}, acids::Vector{Acid})::Int
    idx = 0
    for i in eachindex(acids)
        if acids[i].pos == this
            idx = i
        end
    end
    return idx
end
        
        