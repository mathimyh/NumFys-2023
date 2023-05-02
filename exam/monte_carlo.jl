function MMC_check(test::Acid, transition::Tuple{Int,Int}, acids::Vector{Acid})::Bool
    
    #=

    The Metropolis Monte Carlo method for checking if a transition will happen.
    Returns true if it will, false if not
    
    =#

    curr_e = calculate_energy(acids, interact_e)
    new_acids = deepcopy(acids) # Make a copy, make the transition, and check energy for that one, compare the two
    idx = 0
    for i in eachindex(acids)
        if acids[i] == test
            idx = i
        end
    end
    new_acids[idx].pos = transition
    new_e = calculate_energy(new_acids, interact_e)
    delta_e = new_e - curr_e
    if delta_e < 0
        return true
    else
        numba = rand()
        boltzmann_factor = exp(-delta_e/(kb*T))
        if numba < boltzmann_factor
            return true
        else
            return false
        end
    end
end

function transition!(acids::Vector{Acid}, grid::Array{GridPoint})::Bool
    
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
            if MMC_check(test, temp, acids)  # Check if it is energetically favored 
                grid[test.pos...] = EmptySpot()
                test.pos = temp
                grid[test.pos...] = test
                nearest_neighbours(test.pos, [acid.pos for acid in acids], grid) # Update this!!!
                return true
            end
        end
    end
    return false
end

function MC_sweep!(acids::Vector{Acid}, grid::Array{GridPoint})::Nothing
    N = length(acids)
    for i in 1:N
        if !transition!(acids, grid)
            i -= 1
        end
    end
    push!(logger.energies, calculate_energy(acids, interact_e))
    return nothing
end
    

    