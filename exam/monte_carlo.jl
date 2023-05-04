function MMC_check(test::Acid, transition::Tuple{Int,Int}, acids::Vector{Acid}, T::Float64)
    
    #=

    The Metropolis Monte Carlo method for checking if a transition will happen.
    Returns true if it will, false if not
    
    =#

    curr_e = calculate_energy(acids, interact_e) # Make a copy, make the transition, and check energy for that one, compare the two
    old_pos = test.pos
    test.pos = transition
    for acid in acids
        nearest_neighbours(acid, acids)
    end
    new_e = calculate_energy(acids, interact_e)
    delta_e = new_e - curr_e
    if delta_e < 0
        return nothing
    else
        numba = rand()
        boltzmann_factor = exp(-delta_e/(T))
        if numba < boltzmann_factor
            return nothing
        else
            test.pos = old_pos
            for acid in acids
                nearest_neighbours(acid, acids)
            end
            return nothing
        end
    end
end

function transition!(acids::Vector{Acid}, T::Float64)
    
    #=
    
    Picks one random monomer and checks if it has possible transitions. 
    If yes, it moves the monomer to the new position.
    Returns true if it moved a monomer, false if not. 
    
    =#

    test = rand(acids)
    occupied = [x.pos for x in acids]
    cov_pos = [cov.pos for cov in test.cov_bond]

    bords = [(i,j) for i in -1:1 for j in -1:1] # Should generalize this
    shuffle!(bords)

    for bord in bords 
        temp = test.pos .+ bord
        distances = ([abs.(temp .- cov) for cov in cov_pos])
        if temp ∉ occupied && all(sum(tup) <= 1 for tup in distances)  # Check if it is physically possible
            MMC_check(test, temp, acids, T)  # Check if it is energetically favored 
        end
    end
end

function MC_sweep!(acids::Vector{Acid}, T::Float64)::Nothing
    #=

    Performs a transition N times. If transition didnt happen, it does not count as one of the N'S

    =#
    
    N = length(acids)
    for i in 1:N
        transition!(acids, T::Float64)
    end
    return nothing
end


# Just the 3D versions of the monte carlo method
# Again, if I have time, I should generalize but this is an easy fix for now
function MMC_check3D(test::Acid, transition::Tuple{Int,Int,Int}, acids::Vector{Acid}, T::Float64)
    
    #=

    The Metropolis Monte Carlo method for checking if a transition will happen.
    Returns true if it will, false if not
    
    =#

    curr_e = calculate_energy(acids, interact_e) # Make a copy, make the transition, and check energy for that one, compare the two
    old_pos = test.pos
    test.pos = transition
    for acid in acids
        nearest_neighbours3D(acid, acids)
    end
    new_e = calculate_energy(acids, interact_e)
    delta_e = new_e - curr_e
    if delta_e < 0
        return nothing
    else
        numba = rand()
        boltzmann_factor = exp(-delta_e/(T))
        if numba < boltzmann_factor
            return nothing
        else
            test.pos = old_pos
            for acid in acids
                nearest_neighbours3D(acid, acids)
            end
            return nothing
        end
    end
end

function transition3D!(acids::Vector{Acid}, T::Float64)
    
    #=
    
    Picks one random monomer and checks if it has possible transitions. 
    If yes, it moves the monomer to the new position.
    Returns true if it moved a monomer, false if not. 
    
    =#

    test = rand(acids)
    occupied = [x.pos for x in acids]
    cov_pos = [cov.pos for cov in test.cov_bond]

    bords = [(i,j,k) for i in -1:1 for j in -1:1 for k in -1:1] # Should generalize this
    shuffle!(bords)

    for bord in bords 
        temp = test.pos .+ bord
        distances = ([abs.(temp .- cov) for cov in cov_pos])
        if temp ∉ occupied && all(sum(tup) <= 1 for tup in distances)  # Check if it is physically possible
            MMC_check3D(test, temp, acids, T)  # Check if it is energetically favored 
        end
    end
end

function MC_sweep3D!(acids::Vector{Acid}, T::Float64)::Nothing
    #=

    Performs a transition N times. If transition didnt happen, it does not count as one of the N'S

    =#
    
    N = length(acids)
    for i in 1:N
        transition3D!(acids, T::Float64)
    end
    return nothing
end