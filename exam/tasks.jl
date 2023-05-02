function t2_1_6()
    acids = unfolded_chain2D(15)

    for i in 1:100
        MC_sweep!(acids)
        if i == 1
            local energy = calculate_energy(acids, interact_e)
            plot2D(acids, energy)
            savefig("exam/plots/unfolded_20monomers_10T_1sweep.png")
        elseif i == 10
            local energy = calculate_energy(acids, interact_e)
            plot2D(acids, energy)
            savefig("exam/plots/unfolded_20monomers_10T_10sweeps.png")
        elseif i == 100
            local energy = calculate_energy(acids, interact_e)
            plot2D(acids, energy)
            savefig("exam/plots/unfolded_20monomers_10T_100sweeps.png")
        end
    end