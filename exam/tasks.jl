function t2_1_6()
    acids = unfolded_chain2D(15)

    xs = [i for i in 0:1000]
    energies = []
    end_to_end = []
    RoG = []

    push!(energies, calculate_energy(acids, interact_e))
    temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
    push!(end_to_end, sqrt(sum(temp.^2)))

    for i in 1:1000
        MC_sweep!(acids)
        push!(energies, calculate_energy(acids, interact_e))
        temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
        push!(end_to_end, sqrt(sum(temp.^2)))
        
        # # Plotting the stuff. Might want to not do this every time
        # if i == 1
        #     local energy = calculate_energy(acids, interact_e)
        #     plot2D(acids, energy)
        #     savefig("exam/plots/unfolded_20monomers_10T_1sweep.png")
        # elseif i == 10
        #     local energy = calculate_energy(acids, interact_e)
        #     plot2D(acids, energy)
        #     savefig("exam/plots/unfolded_20monomers_10T_10sweeps.png")
        # elseif i == 100
        #     local energy = calculate_energy(acids, interact_e)
        #     plot2D(acids, energy)
        #     savefig("exam/plots/unfolded_20monomers_10T_100sweeps.png")
        # end
    end

    Plots.plot(xs, energies)
    Plots.savefig("exam/plots/energies_unfolded_15monomers_1000sweeps_1T.png")
    Plots.plot(xs, end_to_end)
    Plots.savefig("exam/plots/endtoend_unfolded_15monomers_1000sweeps_1T.png")

end
