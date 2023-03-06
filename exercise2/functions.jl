# First defining the physical functions

function ksi() 
    return [Normal(0,1), Normal(0,1), Normal(0,1)] .* sqrt(2*alfa*kbt / (gamma*mu*delta_t)) 
end

function H_eff(J::Float64, S, index::Int64, B::Vector{Float64})
    before = index - 1
    after = index + 1
    if index == 0
        before = -1
    elseif index == length(S)
        after = 0
    end
    derivative = - J .* [S[before].spin, S[after].spin] - [0,0,2*d_z*S[index].spin] - mu_b * B[index]
    return derivative + ksi()
end

function dS(H_eff::Vector{Float64}, S, index::Int64)
    return - gamma / (1+ alfa^2) .* (cross(S[index].spin, H_eff) + cross(alfa.*S[index].spin, cross(S[index].spin, H_eff)))
end

function dS(H_eff::Vector{Float64}, S::Vector{Float64}, index::Int64)
    return - gamma / (1+ alfa^2) .* (cross(S[index], H_eff) + cross(alfa.*S[index], cross(S[index], H_eff)))
end

function Heun(S, J::Float64, B::Vector{Float64})
    f = [dS(H_eff(J, S, i, B), S, i) for i in 1:length(S)]
    temp = [Magnet(S[i].pos, S[i].spin + step_size * f[i]) for i in 1:length(S)]
    for i in 1:length(S)
        S[i].spin += step_size * 0.5 * (f[i] + dS(H_eff(J, temp, i, B), temp, i))
        S[i].spin /= norm(S[i])
    end
    return nothing
end





