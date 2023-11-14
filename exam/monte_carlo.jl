function MMC_check(test::Acid, transition::Tuple, acids::Vector{Acid}, T::Float64, curr_e::Float64)::Float64
    
    #=

    The Metropolis Monte Carlo method for checking if a transition is energetically possible
    
    =#

    # Keep the old position incase the transition doesnt happen
    old_pos = test.pos
    
    # Change the monomers position to the new one
    test.pos = transition

    # Find the new energy of the system and the difference between the new and old
    dims = length(test.pos)
    new_e = calculate_energy(acids, interact_e, dims)
    delta_e = new_e - curr_e

    # Check according to the MMC principle
    if delta_e < 0
        return new_e
    else
        numba = rand()
        boltzmann_factor = exp(-delta_e/(T))
        if numba < boltzmann_factor
            return new_e
        else
            # It does not happen, return the monomers position to the old one
            test.pos = old_pos
            return curr_e
        end
    end
end

function transition!(acids::Vector{Acid}, T::Float64, curr_e::Float64)
    
    #=
    
    Picks one random monomer and checks if it has physically possible transitions 
    
    =#

    energy::Float64 = curr_e
    test = rand(acids)
    idx = findfirst(x -> x == test, acids)
    
    cov_pos = []
    if idx > 1
        push!(cov_pos, acids[idx-1].pos)
    end
    if idx < length(acids)
        push!(cov_pos, acids[idx+1].pos)
    end

    dims = length(acids[1].pos)
    bords = []
    if dims == 2
        bords = [(i,j) for i in -1:1 for j in -1:1] # Should generalize this
    elseif dims == 3
        bords = [(i,j,k) for i in -1:1 for j in -1:1 for k in -1:1]
    else
        throw(error("$dims dimensions is not supported!"))
    end
    shuffle!(bords)

    for bord in bords 
        temp = test.pos .+ bord
        distances = ([abs.(temp .- cov) for cov in cov_pos])
        temp_idx = findindex(temp, acids)
        if temp_idx == 0 && all(sum(tup) <= 1 for tup in distances)  # Check if it is physically possible
            energy = MMC_check(test, temp, acids, T, curr_e)  # Check if it is energetically favored 
        end
    end

    return energy
end

function MC_sweep!(acids::Vector{Acid}, T::Float64, curr_e::Float64)
    #=

    Performs a transition N times. If transition didnt happen, it does not count as one of the N'S

    =#
    
    energy::Float64 = 0
    N = length(acids)

    for i in 1:N
        curr_e = transition!(acids, T, curr_e)
    end

    energy = curr_e

    return energy
end


# # Just the 3D versions of the monte carlo method
# # Again, if I have time, I should generalize but this is an easy fix for now
# function MMC_check3D(test::Acid, transition::Tuple{Int,Int,Int}, acids::Vector{Acid}, T::Float64)
    
#     #=

#     The Metropolis Monte Carlo method for checking if a transition will happen.
#     Returns true if it will, false if not
    
#     =#

#     curr_e = calculate_energy(acids, interact_e) # Make a copy, make the transition, and check energy for that one, compare the two
#     old_pos = test.pos
#     test.pos = transition
#     for acid in acids
#         nearest_neighbours3D(acid, acids)
#     end
#     new_e = calculate_energy(acids, interact_e)
#     delta_e = new_e - curr_e
#     if delta_e < 0
#         return nothing
#     else
#         numba = rand()
#         boltzmann_factor = exp(-delta_e/(T))
#         if numba < boltzmann_factor
#             return nothing
#         else
#             test.pos = old_pos
#             for acid in acids
#                 nearest_neighbours3D(acid, acids)
#             end
#             return nothing
#         end
#     end
# end

# function transition3D!(acids::Vector{Acid}, T::Float64)
    
#     #=
    
#     Picks one random monomer and checks if it has possible transitions. 
#     If yes, it moves the monomer to the new position.
#     Returns true if it moved a monomer, false if not. 
    
#     =#

#     test = rand(acids)
#     occupied = [x.pos for x in acids]
#     cov_pos = [cov.pos for cov in test.cov_bond]

#     bords = [(i,j,k) for i in -1:1 for j in -1:1 for k in -1:1] # Should generalize this
#     shuffle!(bords)

#     for bord in bords 
#         temp = test.pos .+ bord
#         distances = ([abs.(temp .- cov) for cov in cov_pos])
#         if temp ∉ occupied && all(sum(tup) <= 1 for tup in distances)  # Check if it is physically possible
#             MMC_check3D(test, temp, acids, T)  # Check if it is energetically favored 
#         end
#     end
# end

# function MC_sweep3D!(acids::Vector{Acid}, T::Float64)::Nothing
#     #=

#     Performs a transition N times. If transition didnt happen, it does not count as one of the N'S

#     =#
    
#     N = length(acids)
#     for i in 1:N
#         transition3D!(acids, T::Float64)
#     end
#     return nothing
# end

function MMC_check3D(test::Acid, transition::Tuple{Int,Int}, acids::Vector{Acid}, T::Float64, curr_e::Float64)::Float64
    
    #=

    The Metropolis Monte Carlo method for checking if a transition will happen.
    Returns true if it will, false if not
    
    =#

    # Keep the old position incase the transition doesnt happen
    old_pos = test.pos
    
    # Change the monomers position to the new one
    test.pos = transition

    # Find the new energy of the system and the difference between the new and old
    new_e = calculate_energy(acids, interact_e)
    delta_e = new_e - curr_e

    # Check according to the MMC principle
    if delta_e < 0
        return new_e
    else
        numba = rand()
        boltzmann_factor = exp(-delta_e/(T))
        if numba < boltzmann_factor
            return new_e
        else
            # It does not happen, return the monomers position to the old one
            test.pos = old_pos
            return curr_e
        end
    end
end

function transition3D!(acids::Vector{Acid}, T::Float64, curr_e::Float64)
    
    #=
    
    Picks one random monomer and checks if it has possible transitions. 
    If yes, it moves the monomer to the new position.
    
    =#
    energy::Float64 = curr_e
    test = rand(acids)
    idx = findfirst(x -> x == test, acids)
    
    cov_pos = []
    if idx > 1
        push!(cov_pos, acids[idx-1].pos)
    end
    if idx < length(acids)
        push!(cov_pos, acids[idx+1].pos)
    end

    bords = [(i,j) for i in -1:1 for j in -1:1] # Should generalize this
    shuffle!(bords)

    for bord in bords 
        temp = test.pos .+ bord
        distances = ([abs.(temp .- cov) for cov in cov_pos])
        temp_idx = findindex(temp, acids)
        if temp_idx == 0 && all(sum(tup) <= 1 for tup in distances)  # Check if it is physically possible
            energy = MMC_check(test, temp, acids, T, curr_e)  # Check if it is energetically favored 
        end
    end

    return energy
end
