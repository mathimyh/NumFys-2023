# First defining the physical functions

function ksi() 
    return sqrt(2*alfa*kbt / (gamma*mu*step_size)) .* [randn(), randn(), randn()]   
end

function H_eff(J::Float64, S, index::Int64)
    before = index - 1
    after = index + 1
    if index == 1
        before = length(S)
    end
    if index == length(S)
        after = 1
    end
    derivative = Vector{Float64}(undef,3)
    @. derivative = -(J*0.5) * S[before].spin - (J*0.5) * S[after].spin - 2 *d_z *[0,0,S[index].spin[1]] - mu_b * [0,0,1] 
    return -(1/mu) .* derivative .+ ksi()
end

function dS(H_eff::Vector{Float64}, S, index::Int64)
    return - gamma / (1+ alfa^2) .* (cross(S[index].spin, H_eff) + cross(alfa.*S[index].spin, cross(S[index].spin, H_eff)))
end

function dS(H_eff::Vector{Float64}, S::Vector{Float64}, index::Int64)
    return - gamma / (1+ alfa^2) .* (cross(S[index], H_eff) + cross(alfa.*S[index], cross(S[index], H_eff)))
end

function Heun!(S, J::Float64)
    f = [dS(H_eff(J, S, i), S, i) for i in 1:length(S)]
    temp = [Magnet(S[i].pos, S[i].spin + step_size * f[i]) for i in 1:length(S)]
    for i in 1:length(S)
        S[i].spin += step_size * 0.5 * (f[i] + dS(H_eff(J, temp, i), temp, i))
        S[i].spin /= norm(S[i].spin)
    end
    return nothing
end





