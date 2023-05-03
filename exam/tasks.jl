function t2_1_5(steps::Int, structs::Bool = false)
    
    acids = unfolded_chain2D(15)
    T::Float64 = 10
    xs = [i for i in 0:steps]
    energies = []
    end_to_end = []
    radii_gyr = []

    push!(energies, calculate_energy(acids, interact_e))
    temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
    push!(end_to_end, sqrt(sum(temp.^2)))
    push!(radii_gyr, RoG(acids))

    for i in 1:steps
        MC_sweep!(acids, T)
        push!(energies, calculate_energy(acids, interact_e))
        temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
        push!(end_to_end, sqrt(sum(temp.^2)))
        push!(radii_gyr, RoG(acids))

        if structs 
            if i % 100 == 0
                plot2D(acids)
                filename = "exam/plots/2_1_5/structures/15N_" * string(i) * "steps.png"
                savefig(filename)
            end
        end

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

    Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", title="N = 15, T = $T")
    # Plots.savefig("exam/plots/energies_unfolded_15monomers_100sweeps_1T.png")
    Plots.plot!(xs, end_to_end, color=:red, label="End-end distances", ylabel="Distance")
    # Plots.savefig("exam/plots/endtoend_unfolded_15monomers_100sweeps_1T.png")
    Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
    Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
    savename = "exam/plots/2_1_5/15N_" * string(steps) * "sweeps_10T.png"
    Plots.savefig(savename)
end

function t2_1_6(steps::Int, structs::Bool = false)
    
    acids = unfolded_chain2D(15)
    T::Float64 = 1


    xs = [i for i in 0:steps]
    energies = []
    end_to_end = []
    radii_gyr = []

    push!(energies, calculate_energy(acids, interact_e))
    temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
    push!(end_to_end, sqrt(sum(temp.^2)))
    push!(radii_gyr, RoG(acids))

    for i in 1:steps
        MC_sweep!(acids, T)
        push!(energies, calculate_energy(acids, interact_e))
        temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
        push!(end_to_end, sqrt(sum(temp.^2)))
        push!(radii_gyr, RoG(acids))

        if structs
            if i % 100 == 0
                plot2D(acids)
                filename = "exam/plots/2_1_6/structures/15N_" * string(i) * "sweeps.png"
                savefig(filename)
            end
        end
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
    
    Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", title="N = 15, T = $T")
    # Plots.savefig("exam/plots/energies_unfolded_15monomers_100sweeps_1T.png")
    Plots.plot!(xs, end_to_end, color=:red, label="End-end distances", ylabel="Distance")
    # Plots.savefig("exam/plots/endtoend_unfolded_15monomers_100sweeps_1T.png")
    Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
    Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
    savename = "exam/plots/2_1_6/15N_" * string(steps) * "sweeps_1T.png"
    Plots.savefig(savename)
end

function t2_1_7a(len::Int, steps::Int, save_n_plot::Bool = true)


    Ts::Vector{Float64} = [i for i in 0.1:0.1:10]
    base_acids = unfolded_chain2D(len) # Use the same primary structure for each T


    for T in Ts
        
        # Initalize a system each time
        xs = [i for i in 0:steps]
        acids = deepcopy(base_acids)
        energies = []
        radii_gyr = []

        push!(energies, calculate_energy(acids, interact_e))
        push!(radii_gyr, RoG(acids))

        # Simulate 
        for j in 1:steps
            MC_sweep!(acids, T)
            push!(energies, calculate_energy(acids, interact_e))
            push!(radii_gyr, RoG(acids))
        end

        if save_n_plot
            # Plot for every integer T
            if isinteger(T) && T != 10.0
                Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", ylabel="Distance", title = "N = $len, T = $T")
                Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
                Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
                savename = "exam/plots/2_1_7/a/" * string(len) * "N_" * string(steps) * "sweeps_" * string(T)[1] * "T.png"
                Plots.savefig(savename)
            end

            if T == 10.0
                Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", ylabel="Distance", title = "N = $len, T = $T")
                Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
                Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
                savename = "exam/plots/2_1_7/a/" * string(len) * "N_" * string(steps) * "sweeps_10T.png"
                Plots.savefig(savename)
            end

            # Save data for every run
            if T != 10.0; jldname = "exam/cache/2_1_7/" * string(len) *"N_" * string(steps) * "sweeps_" * string(T)[1] * string(T)[3] * "T.jld"
            else; jldname = "exam/cache/2_1_7/" * string(len) * "N_" * string(steps) * "sweeps_100T.jld"; end
            save(jldname, "T", T, "energies", energies, "radii_gyr", radii_gyr, "xs", xs)

        end
    end
end

function t2_1_7b(len::Int, steps::Int)
    Ts = []
    avg_energies = []
    avg_RoGs = []
    for i in 0.1:0.1:9.9
        jldname = "exam/cache/2_1_7/" * string(len) * "N_" * string(steps) * "sweeps_" * string(i)[1] * string(i)[end] * "T.jld"
        push!(Ts, load(jldname, "T"))
        push!(avg_energies, mean(load(jldname, "energies")[1200:end]))
        push!(avg_RoGs, mean(load(jldname, "radii_gyr")[1200:end]))
    end
    reverse!(Ts)
    reverse!(avg_energies)
    reverse!(avg_RoGs)
    Plots.plot(Ts, avg_energies, dpi=300, xlabel="Temperature", ylabel="Energy", title = "Average energy, N = $len", legend=false)
    savename = "exam/plots/2_1_7/b/avgE_" * string(len) * "N_" * string(steps) * "sweeps.png"
    Plots.savefig(savename)
    Plots.plot(Ts, avg_RoGs, dpi=300, xlabel="Temperature", ylabel="Distance", title = "Average RoG, N = $len", legend=false)
    savename = "exam/plots/2_1_7/b/avgRoG_" * string(len) * "N_" * string(steps) * "sweeps.png"
    Plots.savefig(savename)

end



