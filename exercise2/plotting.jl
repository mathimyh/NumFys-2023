
function omega(j, dz, ka)
    return 2*dz + 2*j*(1-cos(ka))
end

function plot_omega()
    j = 10
    dz = 3
    xs = LinRange(0,π,100)
    ys1 = omega.(j, dz, xs)
    Plots.plot(xs,ys1)
    j = 20
    dz = 3
    ys2 = omega.(j,dz,xs)
    Plots.plot!(xs,ys2)
    j = 10
    dz = 6
    ys3 = omega.(j,dz,xs)
    Plots.plot!(xs,ys3)
    Plots.savefig("exercise2/plots/w(ka).png")
end

function fourier_heatmap(filename::String)
    
    fft_result = load(filename, "fft_result")
    freq_time = load(filename, "freq_time")
    freq_space = load(filename, "freq_space")

    # x_indices = sortperm(freq_space)
    # y_indices = sortperm(freq_time)

    # fft_sorted = fft_result[x_indices, y_indices]
    # fft_sorted = fft_sorted[:,1:2000]

    Nx, Ny = size(fft_result)
    println(Nx, Ny)
    dx, dt = 1.0, 5e-16
    dk = 2π / (Nx * dx)
    dw = 2π / (Ny * dt)
    k = -dk*(Nx÷2):dk:(dk*(Nx÷2-1))
    w = -dw*(Ny÷2):dw:(dw*(Ny÷2-1))
    println(size(k), size(w))

    #PlotlyJS.plot(PlotlyJS.heatmap(z=abs.(fft_result)))
    # Plots.heatmap(abs.(fft_sorted), color=:viridis)
    heatmap(k, w, abs.(fftshift(fft_result)))
end
    
   







