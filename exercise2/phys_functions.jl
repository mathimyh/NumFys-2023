# First defining the physical functions
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
    
    # neighbours_spin = zeros(3)
    # for neighbour in neighbours
    #     neighbours_spin .+= S[neighbour...].spin
    # end

    derivative = Vector{Float64}(undef,3)
    @. derivative = -(J*0.5) * neighbours_spin - 2 *d_z *[0,0,S[index...].spin[3]] - mu_b * [0,0,1] 
    return -(1/mu) .* derivative .+ ksi()
end

function dS(H_eff::Vector{Float64}, S::AbstractArray{Magnet}, index::Tuple)
    return - gamma / (1+ alfa^2) .* (cross(S[index...].spin, H_eff) + cross(alfa.*S[index...].spin, cross(S[index...].spin, H_eff)))
end

# function dS(H_eff::Vector{Float64}, S::Vector{Float64}, index::Int64)
#     return - gamma / (1+ alfa^2) .* (cross(S[index], H_eff) + cross(alfa.*S[index], cross(S[index], H_eff)))
# end

function Heun!(S::AbstractArray{Magnet}, J::Float64)
    #S1 = deepcopy(S)
    
    f = similar(S, Vector{Float64})
    for idx in CartesianIndices(S)
        f[idx] = dS(H_eff(J, S, idx.I), S, idx.I)
    end
    
    # f1 = [dS(H_eff(J,S1,(i,)), S,(i,)) for i in 1:10]

    # println("f = ", f[1])
    # println("f1 = ", f[1])

    temp = similar(S)
    for idx in CartesianIndices(S)
        temp[idx] = Magnet(S[idx].pos, S[idx].spin + step_size * f[idx])  
    end 
    
    # temp1 = [Magnet(S1[i].pos, S1[i].spin + step_size * f[i]) for i in 1:10]

    # println("temp = ", temp[1])
    # println("temp1 = ", temp1[1])

    for idx in CartesianIndices(S)
        S[idx].spin += step_size * 0.5 * (f[idx] + dS(H_eff(J, temp, idx.I), temp, idx.I))
        S[idx].spin /= norm(S[idx].spin)
    end
    
    # for i in 1:10
    #     S1[i].spin += step_size * 0.5 * (f[i] + dS(H_eff(J, temp, (i,)), temp, (i,)))
    #     S1[i].spin /= norm(S1[i].spin)
    # end

    # println("After Heun: ", S[1].spin)
    # println("After old Heun: ", S1[1].spin)


    return nothing
end





