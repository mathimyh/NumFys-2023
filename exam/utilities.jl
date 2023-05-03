
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
    interaction_matrix = Symmetric(rand(Uniform(-4,-2), 20,20))
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

function RoG(acids::Vector{Acid})
    
    poses = [acid.pos for acid in acids]

    centre_of_mass = (mean(pos[1] for pos in poses), mean(pos[2] for pos in poses))
    distances = sqrt.(sum.([(pos .- centre_of_mass).^2 for pos in poses]))
    
    mean_sqr_distance = mean(distances.^2)
    radius_of_gyration = √mean_sqr_distance
    
    return radius_of_gyration
end
