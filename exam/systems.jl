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

        # Make a new monomer and add to the vector
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



        
        