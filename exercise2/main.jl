include("functions.jl")
include("plotting.jl")
include("structs.jl")
include("systems.jl")

using LinearAlgebra, ForwardDiff
using DataStructures
using Random, Distributions
using CalculusWithJulia
using Plots, Unitful

# Defining the constants, all in meV
const J::Float64 = 0
const unaxial_const::Float64 = 3
const kbt::Float64 = 0
const mu_b::Float64 = 3
const gamma::Float64 = 1.6e11
const mu::Float64 = 5.8e-2
const step_size::Float64 = 1e-14
const alfa::Float64 = 0.5
const d_z::Float64 = 1
const b::Float64 = mu_b / mu


S = [Magnet((0.5, 0.5, 0.5), [0.5, 0.5, 1/sqrt(2)])]#, Magnet((0.5, 0.7, 0.5), [0.5, -0.5, 1/sqrt(2)])]

# @gif for i in 1:500
#     Heun(S, J)
#     x = vec([s.pos[1] for s in S])
#     y = vec([s.pos[2] for s in S])
#     z = vec([s.pos[3] for s in S])
#     u = vec([s.spin[1] for s in S]) 
#     v = vec([s.spin[2] for s in S])
#     w = vec([s.spin[3] for s in S])
#     # spin1 = S[1].spin
#     # println("$spin1", ", ", norm(spin1))
#     Plots.quiver(x, y, z, quiver= (u,v,w), camera=(45, round(atand(1 / √2))), xlims = (0, 1.5), ylims = (0, 1.5), zlims = (0, 1.5))
# end

S = chain_1D(10)

@gif for i in 1:500
    Heun(S, J)
    x = vec([s.pos[1] for s in S])
    y = vec([s.pos[2] for s in S])
    z = vec([s.pos[3] for s in S])
    u = vec([s.spin[1] for s in S]) 
    v = vec([s.spin[2] for s in S])
    w = vec([s.spin[3] for s in S])
    Plots.quiver(x, y, z, quiver= (u,v,w), xlims = (0, 11), ylims = (0, 1.5), zlims = (-1.5, 1.5))
    xlabel!("x")
    ylabel!("y")
end
