function t2_1_5(steps::Int, structs::Bool = false)
    
    acids = unfolded_chain2D(15)
    T::Float64 = 10
    xs = [i for i in 0:steps]
    energy = 0.0

    energies = []
    end_to_end = []
    radii_gyr = []

    push!(energies, energy)
    temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
    push!(end_to_end, sqrt(sum(temp.^2)))
    push!(radii_gyr, RoG(acids))

    ps = []

    for i in 1:steps
        energy = MC_sweep!(acids, T, energy)
        push!(energies, energy)
        temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
        push!(end_to_end, sqrt(sum(temp.^2)))
        push!(radii_gyr, RoG(acids))

        # Plotting the stuff. Might want to not do this every time
        if structs 
            if i == 300
                p = plot2D(acids, energy)
                r_energy = round(energy,digits=2)
                Plots.title!("E = $r_energy kb, Sweeps = $i")
                push!(ps,p)
            elseif i == 400
                p = plot2D(acids, energy)
                r_energy = round(energy,digits=2)
                Plots.title!("E = $r_energy kb, Sweeps = $i")
                push!(ps,p)
            elseif i == 500
                p = plot2D(acids, energy)
                r_energy = round(energy,digits=2)
                Plots.title!("E = $r_energy kb, Sweeps = $i")
                push!(ps,p)
            end
        end


    end

    p = Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", title="N = 15, T = $T")
    # Plots.savefig("exam/plots/energies_unfolded_15monomers_100sweeps_1T.png")
    Plots.plot!(xs, end_to_end, color=:red, label="End-end distances", ylabel="Distance")
    # Plots.savefig("exam/plots/endtoend_unfolded_15monomers_100sweeps_1T.png")
    Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
    Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
    
    if structs
        s = Plots.plot(ps..., layout=(1,3), size=(1500, 500))
        Plots.plot(s, p, layout=(2,1), size = (1200, 1000))
        Plots.savefig("exam/plots/2_1_5/subplots10T.png")
    end
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
    energy = 0.0
    ps = []

    push!(energies, energy)
    temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
    push!(end_to_end, sqrt(sum(temp.^2)))
    push!(radii_gyr, RoG(acids))

    for i in 1:steps
        energy = MC_sweep!(acids, T, energy)
        push!(energies, energy)
        temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
        push!(end_to_end, sqrt(sum(temp.^2)))
        push!(radii_gyr, RoG(acids))

        
        # Plotting of the structures. 
        if structs 
            if i == 300
                p = plot2D(acids, energy)
                r_energy = round(energy,digits=2)
                Plots.title!("E = $r_energy kb, Sweeps = $i")
                push!(ps,p)
            elseif i == 400
                p = plot2D(acids, energy)
                r_energy = round(energy,digits=2)
                Plots.title!("E = $r_energy kb, Sweeps = $i")
                push!(ps,p)
            elseif i == 500
                p = plot2D(acids, energy)
                r_energy = round(energy,digits=2)
                Plots.title!("E = $r_energy kb, Sweeps = $i")
                push!(ps,p)
            end
        end

    end
    
    

    p = Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", title="N = 15, T = $T")
    # Plots.savefig("exam/plots/energies_unfolded_15monomers_100sweeps_1T.png")
    Plots.plot!(xs, end_to_end, color=:red, label="End-end distances", ylabel="Distance")
    # Plots.savefig("exam/plots/endtoend_unfolded_15monomers_100sweeps_1T.png")
    Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
    Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy [kb]")
    savename = "exam/plots/2_1_6/15N_" * string(steps) * "sweeps_1T.png"
    if structs
        s = Plots.plot(ps..., layout=(1,3), size=(1500, 500))
        return s, p
    end
    return p
end

function t2_1_7a(len::Int, steps::Int, save_n_plot::Bool = true)


    Ts::Vector{Float64} = [i for i in 4.57:0.01:10]
    base_acids = unfolded_chain2D(len) # Use the same primary structure for each T


    for T in Ts
        
        # Initalize a system each time
        xs = [i for i in 0:steps]
        acids = deepcopy(base_acids)
        energies = []
        radii_gyr = []
        energy::Float64 = 0.0
        push!(energies, energy)
        push!(radii_gyr, RoG(acids))

        # Simulate 
        for j in 1:steps
            energy = MC_sweep!(acids, T, energy)
            push!(energies, energy)
            push!(radii_gyr, RoG(acids))
        end

        if save_n_plot
            # Plot for every integer T
            if isinteger(T)
                Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", ylabel="Distance", title = "N = $len, T = $T")
                Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
                Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
                savename = "exam/plots/2_1_7/a/1000Ts/" * string(len) * "N_" * string(steps) * "sweeps_" * string(T) * "T.png"
                Plots.savefig(savename)
            end

            # if T == 10.0
            #     Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", ylabel="Distance", title = "N = $len, T = $T")
            #     Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
            #     Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
            #     savename = "exam/plots/2_1_7/a/1000Ts/" * string(len) * "N_" * string(steps) * "sweeps_10T.png"
            #     Plots.savefig(savename)
            # end

            # Save data for every run
            # if T != 10.0; jldname = "exam/cache/2_1_7/1000Ts/" * string(len) *"N_" * string(steps) * "sweeps_" * string(T) * "T.jld"
            jldname = "exam/cache/2_1_7/1000Ts/" * string(len) * "N_" * string(steps) * "sweeps_" * string(T) * "T.jld"
            save(jldname, "T", T, "energies", energies, "radii_gyr", radii_gyr, "xs", xs)
        end
    end
end

function t2_1_7b(len::Int, steps::Int)
    Ts = []
    avg_energies = []
    avg_RoGs = []
    for i in 0.1:0.1:9.9
        jldname = "exam/cache/2_1_7/100Ts/" * string(len) * "N_" * string(steps) * "sweeps_" * string(i)[1] * string(i)[3] * "T.jld"
        push!(Ts, load(jldname, "T"))
        push!(avg_energies, mean(load(jldname, "energies")[1000:end]))
        push!(avg_RoGs, mean(load(jldname, "radii_gyr")[1000:end]))
    end

    # There seems to be a bug in Plots.jl, for when I try to use twinx() to have two different y-axis
    # and plot energies and RoGs in the same plot, the x-axis reverts to increasing values instead of 
    # decreasing as wanted. In addition, one of the plots is multiplied by a factor of 10 for its x-values
    # This code works, but produces a far less appealing plot. 

    reverse!(Ts)
    reverse!(avg_energies)
    reverse!(avg_RoGs)
    p = Plots.plot(Ts, avg_energies, color=:blue, label="Average energies", dpi=300, xlabel="Temperature", ylabel="Energy [kb]", title = "N = $len")
    Plots.plot!(p, Ts, NaN.*avg_RoGs, color=:red, label="Average RoG")
    Plots.plot!(Ts, avg_RoGs, color=:red, legend=false, label="Average RoG")
    savename = "exam/plots/2_1_7/b/100Ts/" * string(len) * "N_" * string(steps) * "sweeps.png"
    Plots.savefig(savename)

end

function t2_1_8a(number::Int, steps::Int, structs::Bool = false)
    
    acids, pos_idx = unfolded_chain2D(30)
    T::Float64 = 1.0

    xs = [i for i in 0:steps]
    energies = []
    end_to_end = []
    radii_gyr = []
    energy = 0.0

    push!(energies, energy)
    temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
    push!(end_to_end, sqrt(sum(temp.^2)))
    push!(radii_gyr, RoG(acids))

    for i in 1:steps
        energy, pos_idx = MC_sweep!(acids, pos_idx, T, energy)
        push!(energies, energy)
        temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
        push!(end_to_end, sqrt(sum(temp.^2)))
        push!(radii_gyr, RoG(acids))

        if structs
            if i > 2000 && i % 100 == 0
                plot2D(acids)
                filename = "exam/plots/2_1_8/"* string(number) * "/struct_" * string(i) * "sweeps.png"
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
    
    Plots.plot(xs, energies, color=:blue, legend=false, ylabel="Energy", dpi=300, xlabel="Sweeps", title="N = 30, T = $T")
    savename = "exam/plots/2_1_8/" * string(number) * "/e_" * string(steps) * "sweeps_1T.png"
    Plots.savefig(savename)
end

function t2_1_8(acids::Vector{Acid}, number::Int, steps::Int, annealing::Bool = false, structs::Bool = false)
    
    stepsize = 4.0 / steps
        
    T::Float64 = 1.0
    annealing_naming::String = ""

    if annealing
        T = 4.0
        annealing_naming = "SA"
    end

    xs = [i for i in 0:steps]
    energies = []
    end_to_end = []
    radii_gyr = []
    energy = 0.0

    push!(energies, energy)
    temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
    push!(end_to_end, sqrt(sum(temp.^2)))
    push!(radii_gyr, RoG(acids))

    for i in 1:steps
        energy = MC_sweep!(acids, T, energy)
        push!(energies, energy)
        temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
        push!(end_to_end, sqrt(sum(temp.^2)))
        push!(radii_gyr, RoG(acids))

        if structs
            if i > 9000 && i % 100 == 0 # I found out 10k steps was good, so i just set this manually.
                plot2D(acids)
                filename = "exam/plots/2_1_8/"*  string(number) * "/" * annealing_naming * "struct_" * string(i) * "sweeps.png"
                savefig(filename)
            end
        end

        if annealing
            T -= stepsize
        end

    end
    
    fin_energy = mean(energies[9500:end])
    dev_energy = std(energies[9500:end])


    Plots.plot(xs, energies, color=:blue, legend=false, ylabel="Energy", dpi=300, xlabel="Sweeps", title=("N = 30, T = " * string(round(T, digits=1))))
    annotation = "Energy at end: " * string(round(fin_energy, digits=3)) * "\n Deviation: " * string(round(dev_energy, digits=3))
    Plots.annotate!((.75, .85), annotation)
    savename = "exam/plots/2_1_8/" * string(number) * "/" * annealing_naming * "e_" * string(steps) * "sweeps_1T.png"
    Plots.savefig(savename)
end

function actually_t2_1_8()
    acids = unfolded_chain2D(30)
    for i in 1:5
        temp_acids = deepcopy(acids)
        SA::Bool = false
        if i > 3
            SA = true
        end
        t2_1_8(temp_acids, i, 10000, SA, true)
    end
end


function t2_1_9(acids::Vector{Acid}, number::Int, steps::Int, annealing::Bool = false, structs::Bool = false)
    
    stepsize = 4.0 / steps
        
    T::Float64 = 1.0
    annealing_naming::String = ""

    if annealing
        T = 4.0
        annealing_naming = "SA"
    end

    xs = [i for i in 0:steps]
    energies = []
    end_to_end = []
    radii_gyr = []
    energy = 0.0

    push!(energies, energy)
    temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
    push!(end_to_end, sqrt(sum(temp.^2)))
    push!(radii_gyr, RoG(acids))

    for i in 1:steps
        energy = MC_sweep!(acids, T, energy)
        push!(energies, energy)
        temp = [acids[1].pos[i]-acids[end].pos[i] for i in eachindex(acids[1].pos)]
        push!(end_to_end, sqrt(sum(temp.^2)))
        push!(radii_gyr, RoG(acids))

        if structs
            if i > 9000 && i % 100 == 0 # I found out 10k steps was good, so i just set this manually.
                plot2D_2_1_9(acids)
                filename = "exam/plots/2_1_9/"*  string(number) * "/" * annealing_naming * "struct_" * string(i) * "sweeps.png"
                savefig(filename)
            end
        end

        if annealing
            T -= stepsize
        end

    end
    
    fin_energy = mean(energies[9500:end])
    dev_energy = std(energies[9500:end])


    Plots.plot(xs, energies, color=:blue, legend=false, ylabel="Energy", dpi=300, xlabel="Sweeps", title=("N = 30, T = " * string(round(T, digits=1))))
    annotation = "Energy at end: " * string(round(fin_energy, digits=3)) * "\n Deviation: " * string(round(dev_energy, digits=3))
    Plots.annotate!((.75, .85), annotation)
    savename = "exam/plots/2_1_9/" * string(number) * "/" * annealing_naming * "e_" * string(steps) * "sweeps_1T.png"
    Plots.savefig(savename)
end

function actually_t2_1_9(interact_e)
    acids = unfolded_chain2D(50)

    for i in 1:5 # I think changing 5 of them should be good, considering they are all in the polymer
        first, second = rand(1:20), rand(1:20)
        if interact_e[first, second] < 0
            interact_e[first, second] *= -1
            interact_e[second, first] *= -1
        end
    end
    
    plot_interact_e(interact_e, "exam/plots/2_1_9/interact_e.png")

    save("exam/cache/2_1_9/interact_e.jld", "interact_e", interact_e)

    for i in 1:1
        temp_acids = deepcopy(acids)
        t2_1_9(temp_acids, i, 10000, true, true)
    end
end

function t2_2_2()

    acids = unfolded_chain3D(15)
    T::Float64 = 10.0
    energy = 0.0
    ps = []

    for i in 1:100
        energy = MC_sweep!(acids, T, energy)
        if i == 1
            push!(ps, plot3D(acids))
        end
        if i == 10
            push!(ps, plot3D(acids))
        end
        if i == 100
            push!(ps, plot3D(acids))
        end

    end

    Plots.plot(ps..., layout = (1,3), dpi=300, size = (1500, 600))
    Plots.savefig("exam/plots/2_2_2/subplots.png")

end

function t2_2_3a(len::Int, steps::Int, save_n_plot::Bool = true)


    Ts::Vector{Float64} = [i for i in 0.1:0.1:10]
    base_acids = unfolded_chain3D(len) # Use the same primary structure for each T
    dims::Int = 3

    for T in Ts
        
        # Initalize a system each time
        xs = [i for i in 0:steps]
        acids = deepcopy(base_acids)
        energies = []
        radii_gyr = []

        curr_e = 0.0
        push!(energies, curr_e)
        push!(radii_gyr, RoG3D(acids))

        # Simulate 
        for j in 1:steps
            curr_e = MC_sweep!(acids, T, curr_e)
            push!(energies, calculate_energy(acids, interact_e, dims))
            push!(radii_gyr, RoG3D(acids))
        end

        if save_n_plot
            # Plot for every integer T
            if isinteger(T) && T != 10.0
                Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", ylabel="Distance", title = "N = $len, T = $T")
                Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
                Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
                savename = "exam/plots/2_2_3/a/" * string(len) * "N_" * string(steps) * "sweeps_" * string(T)[1] * "T.png"
                Plots.savefig(savename)
            end

            if T == 10.0
                Plots.plot(xs, radii_gyr, color=:green, label="RoGs", dpi=300, xlabel="Sweeps", ylabel="Distance", title = "N = $len, T = $T")
                Plots.plot!(xs, NaN.*energies, color=:blue, label="Energies")
                Plots.plot!(twinx(), energies, color=:blue, legend=false, ylabel="Energy")
                savename = "exam/plots/2_2_3/a/" * string(len) * "N_" * string(steps) * "sweeps_10T.png"
                Plots.savefig(savename)
            end

            # Save data for every run
            if T != 10.0; jldname = "exam/cache/2_2_3/" * string(len) *"N_" * string(steps) * "sweeps_" * string(T)[1] * string(T)[3] * "T.jld"
            else; jldname = "exam/cache/2_2_3/" * string(len) * "N_" * string(steps) * "sweeps_100T.jld"; end
            save(jldname, "T", T, "energies", energies, "radii_gyr", radii_gyr, "xs", xs)

        end
    end
end

function t2_2_3b(len::Int, steps::Int)
    Ts = []
    avg_energies = []
    avg_RoGs = []
    for i in 0.1:0.1:9.9
        jldname = "exam/cache/2_2_3/" * string(len) * "N_" * string(steps) * "sweeps_" * string(i)[1] * string(i)[end] * "T.jld"
        push!(Ts, load(jldname, "T"))
        push!(avg_energies, mean(load(jldname, "energies")[1200:end]))
        push!(avg_RoGs, mean(load(jldname, "radii_gyr")[1200:end]))
    end
    # reverse!(Ts)
    # reverse!(avg_energies)
    # reverse!(avg_RoGs)
    # Plots.plot(Ts, avg_energies, dpi=300, xlabel="Temperature", ylabel="Energy", title = "Average energy, N = $len", legend=false)
    # savename = "exam/plots/2_2_3/b/avgE_" * string(len) * "N_" * string(steps) * "sweeps.png"
    # Plots.savefig(savename)
    # Plots.plot(Ts, avg_RoGs, dpi=300, xlabel="Temperature", ylabel="Distance", title = "Average RoG, N = $len", legend=false)
    # savename = "exam/plots/2_2_3/b/avgRoG_" * string(len) * "N_" * string(steps) * "sweeps.png"
    # Plots.savefig(savename)
    reverse!(Ts)
    reverse!(avg_energies)
    reverse!(avg_RoGs)
    p = Plots.plot(Ts, avg_energies, color=:blue, label="Average energies", dpi=300, xlabel="Temperature", ylabel="Energy [kb]", title = "N = $len")
    Plots.plot!(p, Ts, NaN.*avg_RoGs, color=:red, label="Average RoG")
    Plots.plot!(Ts, avg_RoGs, color=:red, legend=false, label="Average RoG")
    savename = "exam/plots/2_2_3/b/" * string(len) * "N_" * string(steps) * "sweeps.png"
    Plots.savefig(savename)
end
