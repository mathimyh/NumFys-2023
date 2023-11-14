
function omega(j, dz, ka)
    return 2*dz + 2*j*(1-cos(ka))
end

function plot_omega(J, dz)
    xs = LinRange(-π,π,1000)
    ys1 = omega.(J, dz, xs)
    Plots.plot!(xs,ys1, legend=false, grid=false, color=:red, linewidth=3)
end

function fourier_heatmap(filename::String, pngname::String)
    
    #= 
    
    Plots a heatmap of the fourer matrix in filename together with w(k).
    Saves the heatmap in a file named pngname

    =#

    fft_result = load(filename, "fft_result")
    freq_time = load(filename, "freq_time")
    freq_space = load(filename, "freq_space")

    println(typeof(fft_result))


    fft_result = fft_result[:,1:700]
    fft_result = transpose((fft_result))


    new_fft = (abs.(fftshift(fft_result, 2)))
    x_values = LinRange(-pi, pi, size(new_fft, 2))
    y_values = LinRange(0, 100, size(new_fft, 1))

    Plots.heatmap(x_values, y_values, new_fft, color=:viridis, clim=(NaN, 5000), xlims=(-pi/2,pi/2),legend = false, ylabel="w", xlabel="k")
    # plot_omega()

    # plot_omega(J,d_z*10)

    Plots.savefig(pngname)
end


function plot_Ms()
    p = Plots.plot()
    for i in 0.1:0.2:2.0
        filename = "exercise2/cache/magnetization_20x20x20_" * string(i)[1] * string(i)[3] * "T_10000steps.jld"
        pngname = "exercise2/plots/magnetization_20x20x20_" * string(i)[1] * string(i)[3] * "T_10000steps.png"
        Ms = load(filename, "Ms")
        ts = load(filename, "ts")
        ts ./= 10e-12
        Plots.plot!(ts,Ms, size=(1000, 700), legend=("Magnetization"))
        # Plots.vline!([0.1], legend="Start time")
        Plots.xlabel!("Time [ps]")
        Plots.ylabel!("M")
        Plots.ylims!(0,1)
    end
    Plots.savefig("exercise2/plots/magnetization/collection_mags.png")
end


function plot_tavg_M()
    avg_Ms = Vector{Float64}()

    startpoints = [0.1 for i in 1:15]
    temps = [0.5 for i in 1:5]
    startpoints = vcat(startpoints, temps)
    Ts = [0.1*i for i in 1:20]

    for i in 0.1:0.1:2
        filename = "exercise2/cache/magnetization_20x20x20_" * string(i)[1] * string(i)[3] * "T_10000steps.jld"
        pngname = "exercise2/plots/magnetization_20x20x20_" * string(i)[1] * string(i)[3] * "T_10000steps.png"
        Ms = load(filename, "Ms")
        ts = load(filename, "ts")
        ts ./= 1e-12
        idx = trunc(Int, i*10)
        push!(avg_Ms, time_avg_magnetization(ts, Ms, startpoints[idx]))
    end

    Plots.plot(Ts, avg_Ms, size=(700,500), dpi=300, title="M(T)", ylabel="M", xlabel="T [kb]", legend= false)
    Plots.savefig("exercise2/plots/temp_M(T).png")
end







