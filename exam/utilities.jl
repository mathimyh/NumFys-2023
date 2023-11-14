
function interaction_energies()
    #=

    Make a symmetric matrix using Symmetric from the LinearAlgebra package
    It is not possible to change the elements in this, however, so a regular matrix
    is initalized and set to be completely identical. 
    This regular matrix is returned. 

    =#
    
    interaction_matrix = Symmetric(rand(Uniform(-4,-2), 20,20))
    interact_e = Matrix{Float64}(undef, size(interaction_matrix)...)
    for idx in CartesianIndices(interaction_matrix)
        interact_e[idx] = interaction_matrix[idx]
    end
    
    return interact_e
end

function calculate_energy(acids::Vector{Acid}, interaction_e, dims::Int)::Float64
    
    #=

    The idea is that I go through every monomer, finds it nearest neighbours, and add to energy
    Returns the total energy of the system. 
    Important: Divide by half at end to account for double counting

    =#

    # Starts the energy with 0
    energy::Float64 = 0
   
    # Nearest neighbours given the dimensions
    bords = []
    if dims == 2
        bords = [(0,1),(1,0),(0,-1),(-1,0)] 
    elseif dims == 3
        bords = [(1,0,0),(0,1,0),(0,0,1),(-1,0,0),(0,-1,0),(0,0,-1)]
    else
        throw(error("$dims dimensions not supported!"))
    end

    # Goes through every monomer in the vector
    for i in eachindex(acids)
        
        # For easier referencing later (prob faster too)
        this = acids[i]
        
        # Makes a list of the covalent bonds. 
        cov = []
        if i > 1
            push!(cov,acids[i-1])
        end
        if i < length(acids)
            push!(cov, acids[i+1])
        end
        
        for bord in bords    
            # Checks a position, is there a monomer there?
            temp = ()
            if dims == 2
                temp = (this.pos[1] + bord[1], this.pos[2] + bord[2])
            else
                temp = (this.pos[1] + bord[1], this.pos[2] + bord[2],this.pos[3]+bord[3])
            end
            temp_idx = findindex(temp, acids)
            
            # If temp_idx is zero no monomer was found at the position
            if temp_idx != 0
                that = acids[temp_idx]
                if that ∉ cov
                    energy += interaction_e[this.type, that.type]
                end
            end
        end
    end

    return energy * 0.5 # Account for double counting

end
     
function findindex(this::Tuple, acids::Vector{Acid})::Int
    #= 

    This is quite slow, and was part of the code I wanted to replace
    Returns the index of the acid that is in a given position.

    =# 

    idx = 0
    for i in eachindex(acids)
        if acids[i].pos == this
            idx = i
            return idx
        end
    end
    return idx
end

function RoG(acids::Vector{Acid})
    
    #=

    Returns the radius of gyration for a 2 dimensional polymer

    =#


    poses = [acid.pos for acid in acids]

    centre_of_mass = (mean(pos[1] for pos in poses), mean(pos[2] for pos in poses))
    distances = sqrt.(sum.([(pos .- centre_of_mass).^2 for pos in poses]))
    
    mean_sqr_distance = mean(distances.^2)
    radius_of_gyration = √mean_sqr_distance
    
    return radius_of_gyration
end



function RoG3D(acids::Vector{Acid}) # This should easily be generalized if I have time
    
    #= 

    Returns the radius of gyration of a 3 dimensional polymer

    =#

    poses = [acid.pos for acid in acids]

    centre_of_mass = (mean(pos[1] for pos in poses), mean(pos[2] for pos in poses), mean(pos[3] for pos in poses))
    distances = sqrt.(sum.([(pos .- centre_of_mass).^2 for pos in poses]))
    
    mean_sqr_distance = mean(distances.^2)
    radius_of_gyration = √mean_sqr_distance
    
    return radius_of_gyration
end