function check_transitions()
    grid, acids = chain_2d(20, 40)
    energy = calculate_energy(acids, interact_e)
    plot2D(grid, acids, energy)
    Plots.savefig("exam/plots/beforechange.png")
    check = transition!(acids, grid)
    tries = 0
    while !check
        global check = transition!(acids, grid)
        global tries += 1
        if tries > 500
            break
        end
    end
    plot2D(grid, acids, energy)
    Plots.savefig("exam/plots/afterchange.png")
end

function plot_some_energies()
    for i in 1:10
        grid, acids = chain_2d(20, 40)
        energy = calculate_energy(acids, interaction_energies())
        plot2D(grid, acids, energy)
        filename = "exam/plots/20length_energy_nr" * string(i) * ".png"
        Plots.savefig(filename)
    end
end