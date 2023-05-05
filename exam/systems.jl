mutable struct Acid
    pos::Tuple
    type::Int
end

# A logger is a struct containing information about the system at each MC sweep (IS this necessary?)
mutable struct Logger
    energies::Vector{Float64}
end


function folded_chain2D(len::Int)

    #=

    Initalizes a chain of monomers in a 2D grid. 
    Returns the vector of these monomers where all elements are of type Acid
    
    =# 

    acids = Vector{Acid}()
    start::Acid = Acid((len, len), rand(1:20))
    pos_idx = Dict{Tuple, Int}()
    

    push!(acids, start)
    pos_idx[(len,len)] = 1
    
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
                return folded_chain2D(len)
            end
        end

        # Make a new monomer and add to the vector
        this = Acid(pos, rand(1:20))
        push!(acids, this)
        pos_idx[pos] = i
        
    end

    return acids, pos_idx
end

function unfolded_chain2D(len::Int)
    
    #=

    Initalizes a straight chain of monomers on a 2D grid. Returns the vector of these. 
    Further in the code, when we check if a monomer has neighbours, it takes a long time to use 
    the position to check if the position is in the vector, and return the index. So we use a
    dictionary to keep track of which acids are in which positions. Since the number of acids
    doesnt get too high this will not pose a problem.     
    
    =#

    acids = Vector{Acid}()
    pos_idx = Dict{Tuple, Int}()

    for i in 1:len
        this = Acid((len+i, len), rand(1:20))
        push!(acids, this)
        pos_idx[(len+i, len)] = i
    end

    return acids
end


function unfolded_chain3D(len::Int)
#=

    Initalizes a straight chain of monomers on a 3D grid. Returns the vector of these. 
    
    =#

    acids = Vector{Acid}()
    pos_idx = Dict{Tuple, Int}()

    for i in 1:len
        this = Acid((len+i, len, len), rand(1:20))
        push!(acids, this)
        pos_idx[(len+i, len, len)] = i
    end

    return acids, pos_idx
end



        
        