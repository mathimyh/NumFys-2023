function fourier_2D(length::Int)
    S = chain_groundstate(length)
    time = 0
    xs = []
    while time < 30e-14
        u = vec([s.spin[1] for s in S])
        push!(xs, u) 
        Heun!(S, J)
        time += step_size
    end

    M = hcat(xs...)
    
    # Apply 2D Fourier transform on the matrix
    fft_result = fft(M)

    # Get the frequencies in the time and space domain
    freq_time = fftfreq(size(M, 2))
    freq_space = fftfreq(size(M, 1))

    # # Shift the result to center the low frequencies
    # fft_result = fftshift(fft_result)

    # Plot the Fourier transform
    Plots.heatmap(freq_space, freq_time, abs.(fft_result), xlabel="Space", ylabel="Time", color=:viridis)
end
