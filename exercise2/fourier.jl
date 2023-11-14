function fourier_2D(length::Int, filename::String, FM::Bool = true)
    
    #=

    Simulates either a ferromagnetic or antiferromagnetic groundstate for length timesteps, saves 
    the x-values of the spin.
    Then takes the Fourier transform of the x-values, and saves the Fourier matrix in a file filename

    =#


    if FM
        S = chain_groundstate_FM(length)
    else
        S = chain_groundstate_AFM(length)
    end

    time = 0
    xs = []
    while time < 30e-12
        u = vec([s.spin[1] for s in S])
        push!(xs, u) 
        Heun!(S, J)
        time += step_size
    end

    M = hcat(xs...)
    

    # Apply 2D Fourier transform on the matrix
    fft_result = FFTW.fft(M, (1,2))

    # Get the frequencies in the time and space domain
    freq_time = fftfreq(size(M, 2))
    freq_space = fftfreq(size(M, 1))

    save(filename, "fft_result", fft_result, "freq_time", freq_time, "freq_space", freq_space)
    return nothing
end
