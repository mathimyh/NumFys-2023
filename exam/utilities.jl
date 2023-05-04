
function interaction_energies()
    interaction_matrix = Symmetric(rand(Uniform(-4,-2), 20,20))
    return interaction_matrix
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
            temp = this.pos .+ bord
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
    
    poses = [acid.pos for acid in acids]

    centre_of_mass = (mean(pos[1] for pos in poses), mean(pos[2] for pos in poses))
    distances = sqrt.(sum.([(pos .- centre_of_mass).^2 for pos in poses]))
    
    mean_sqr_distance = mean(distances.^2)
    radius_of_gyration = √mean_sqr_distance
    
    return radius_of_gyration
end


# From here and down the functions are made for 3 dimensions
# If I have more time I would want to generalize the functions to work for both but for now it is what it is

# function nearest_neighbours3D(this::Acid, acids::Vector{Acid})
#     occupied = [acid.pos for acid in acids]
#     this.nearest = Vector{Acid}()
#     bords = [(0,1,0),(0,1,0),(0,0,1),(-1,0,0),(0,-1,0),(0,0,-1)] # Generalize!
#     for bord in bords
#         temp = this.pos .+ bord
#         idx = findindex(temp, acids)
#         if temp ∈ occupied && acids[idx] ∉ this.cov_bond
#             push!(this.nearest, acids[idx])
#         end
#     end
# end

# function nearest_neighbours3D(tup::Tuple{Int, Int}, acids::Vector{Acid})
#     this = acids[findindex(tup, acids)]
#     occupied = [acid.pos for acid in acids]
#     this.nearest = Vector{Acid}()
#     bords = [(0,1,0),(0,1,0),(0,0,1),(-1,0,0),(0,-1,0),(0,0,-1)] # Generalize!
#     for bord in bords
#         temp = this.pos .+ bord
#         idx = findindex(temp, acids)
#         if temp ∈ occupied && acids[idx] ∉ this.cov_bond
#             push!(this.nearest, acids[idx])
#         end
#     end
# end

function RoG3D(acids::Vector{Acid}) # This should easily be generalized if I have time
    
    poses = [acid.pos for acid in acids]

    centre_of_mass = (mean(pos[1] for pos in poses), mean(pos[2] for pos in poses), mean(pos[3] for pos in poses))
    distances = sqrt.(sum.([(pos .- centre_of_mass).^2 for pos in poses]))
    
    mean_sqr_distance = mean(distances.^2)
    radius_of_gyration = √mean_sqr_distance
    
    return radius_of_gyration
end