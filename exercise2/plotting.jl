
function omega(j, dz, ka)
    return 2*dz + 2*j*(1-cos(ka))
end

function plot_omega()
    j = 10
    dz = 3
    xs = LinRange(0,π,100)
    ys1 = omega.(j, dz, xs)
    Plots.plot!(xs,ys1)
    j = 20
    dz = 3
    ys2 = omega.(j,dz,xs)
    Plots.plot!(xs,ys2)
    j = 10
    dz = 6
    ys3 = omega.(j,dz,xs)
    Plots.plot!(xs,ys3)
end

function fourier_heatmap(filename::String, pngname::String)
    
    fft_result = load(filename, "fft_result")
    freq_time = load(filename, "freq_time")
    freq_space = load(filename, "freq_space")

    println(typeof(fft_result))


    fft_result = fft_result[:,1:700]
    fft_result = transpose((fft_result))

    Plots.heatmap((abs.(fftshift(fft_result, 2))), color=:viridis, clim=(NaN, 20000))
    # plot_omega()

    Plots.savefig(pngname)
end


function plot_Ms()
    for i in 0.1:0.2:1.9
        filename = "exercise2/cache/magnetization_20x20x20_" * string(i)[1] * string(i)[3] * "T_10000steps.jld"
        pngname = "exercise2/plots/magnetization_20x20x20_" * string(i)[1] * string(i)[3] * "T_10000steps.png"
        Ms = load(filename, "Ms")
        ts = load(filename, "ts")
        ts ./= 10e-12
        Plots.plot(ts,Ms, size=(1000, 700))
        Plots.vline!([0.1])
        Plots.xlabel!("Time [ps]")
        Plots.ylabel!("M")
        Plots.ylims!(0,1)
        Plots.savefig(pngname)
    end
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

    Plots.plot(Ts, avg_Ms, size=(700,500), dpi=300)
    Plots.savefig("exercise2/plots/temp_M(T).png")
end







