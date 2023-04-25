function find_delta_N(l::Int, N::Array{Float64})
    delta_N = Array{Float64}(undef, size(N))
    for i in eachindex(N)
        delta_N[i] = N[i] / (4*π) - i
    end
    return delta_N
end

function curve_fitting(N::Array{Float64}, delta_N::Array{Float64})
    a,b = power_fit(sqrt.(N), delta_N)
    return a,b 
end
