# The physical functions here are N-dimensional. They can be given an array of any dimension of magnets
# and they will calculate for the correct neighbours. 
mutable struct Magnet
    pos
    spin::Vector{Float64}
end

function ksi()
    return sqrt(2*alfa*kbt / (gamma*mu*step_size)) .* [randn(), randn(), randn()]   
end

function H_eff(J::Float64, S::AbstractArray{Magnet}, index::Tuple)
    dims = size(S)
    neighbours_spin = zeros(3)

    for i in eachindex(index)
        idx = [index[j] for j in eachindex(index)]
        for delta in (-1, 1)
            idx[i] += delta

            idx[i] = mod(idx[i]-1, dims[i]) + 1 # First "remove 1 indexing" with -1 in the mod(), then return with +1

            if all(1 .<= idx .<= dims)
                neighbours_spin .+= S[idx...].spin
            end
            idx[i] -= delta
        end
    end
    

    derivative = Vector{Float64}(undef,3)
    @. derivative = -(J*0.5) * neighbours_spin - 2 *d_z *[0,0,S[index...].spin[3]] - mu_b * [0,0,1] 
    return -(1/mu) .* derivative .+ ksi()
end

function dS(H_eff::Vector{Float64}, S::AbstractArray{Magnet}, index::Tuple)
    return - gamma / (1+ alfa^2) .* (cross(S[index...].spin, H_eff) + cross(alfa.*S[index...].spin, cross(S[index...].spin, H_eff)))
end


function Heun!(S::AbstractArray{Magnet}, J::Float64)
    
    #= 

    Takes one timestep and updates the position of every spin in the array S.

    =#


    # Save f first
    f = similar(S, Vector{Float64})
    for idx in CartesianIndices(S)
        f[idx] = dS(H_eff(J, S, idx.I), S, idx.I)
    end
    
    # Then the first of the y's, equation (5)
    temp = similar(S)
    for idx in CartesianIndices(S)
        temp[idx] = Magnet(S[idx].pos, S[idx].spin + step_size * f[idx])  
    end 

    # Then the second y, equation (6)
    for idx in CartesianIndices(S)
        S[idx].spin += step_size * 0.5 * (f[idx] + dS(H_eff(J, temp, idx.I), temp, idx.I))
        S[idx].spin /= norm(S[idx].spin)
    end

    return nothing
end





