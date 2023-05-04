
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

function interaction_energies()
    #=

    Constructs the matrix with interaction energies
    Since you can not change elements in the Symmetric() matrix from the LinearAlgebra package,
    it is turned into a regular matrix which is returned

    =#
    
    interaction_matrix = Symmetric(rand(Uniform(-4,-2), 20,20))
    interact_e = Matrix{Float64}(undef, size(interaction_matrix)...)
    for idx in CartesianIndices(interaction_matrix)
        interact_e[idx] = interaction_matrix[idx]
    end
    
    return interact_e
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
     
function findindex(this::Tuple, acids::Vector{Acid})::Int
    idx = 0
    for i in eachindex(acids)
        if acids[i].pos == this
            idx = i
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

function nearest_neighbours3D(this::Acid, acids::Vector{Acid})
    occupied = [acid.pos for acid in acids]
    this.nearest = Vector{Acid}()
    bords = [(0,1,0),(0,1,0),(0,0,1),(-1,0,0),(0,-1,0),(0,0,-1)] # Generalize!
    for bord in bords
        temp = this.pos .+ bord
        idx = findindex(temp, acids)
        if temp ∈ occupied && acids[idx] ∉ this.cov_bond
            push!(this.nearest, acids[idx])
        end
    end
end

function nearest_neighbours3D(tup::Tuple{Int, Int}, acids::Vector{Acid})
    this = acids[findindex(tup, acids)]
    occupied = [acid.pos for acid in acids]
    this.nearest = Vector{Acid}()
    bords = [(0,1,0),(0,1,0),(0,0,1),(-1,0,0),(0,-1,0),(0,0,-1)] # Generalize!
    for bord in bords
        temp = this.pos .+ bord
        idx = findindex(temp, acids)
        if temp ∈ occupied && acids[idx] ∉ this.cov_bond
            push!(this.nearest, acids[idx])
        end
    end
end

function RoG3D(acids::Vector{Acid}) # This should easily be generalized if I have time
    
    poses = [acid.pos for acid in acids]

    centre_of_mass = (mean(pos[1] for pos in poses), mean(pos[2] for pos in poses), mean(pos[3] for pos in poses))
    distances = sqrt.(sum.([(pos .- centre_of_mass).^2 for pos in poses]))
    
    mean_sqr_distance = mean(distances.^2)
    radius_of_gyration = √mean_sqr_distance
    
    return radius_of_gyration
end