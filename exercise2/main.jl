include("phys_functions.jl")
include("plotting.jl")
include("structs.jl")
include("systems.jl")
include("fourier.jl")

using LinearAlgebra, ForwardDiff
using DataStructures
using Random, Distributions
using CalculusWithJulia
using FFTW
using Plots, Unitful; gr()

# Defining the constants, all in meV
const J::Float64 = 10
const unaxial_const::Float64 = 3
const kbt::Float64 = 2
const mu_b::Float64 = 3
const gamma::Float64 = 1.6e11
const mu::Float64 = 5.8e-2
const step_size::Float64 = 5e-16
const alfa::Float64 = 0.25
const d_z::Float64 = 3
const b::Float64 = mu_b / mu


#S = [Magnet((0.5, 0.5, 0.5), [0.5, 0.5, 1/sqrt(2)])]#, Magnet((0.5, 0.7, 0.5), [0.5, -0.5, 1/sqrt(2)])]

# S = chain_random(10)
# #S = chain_groundstate(100)

# anim = @animate for i in 1:1500
#     Heun!(S, J)
#     x = vec([s.pos[1] for s in S])
#     y = vec([s.pos[2] for s in S])
#     z = vec([s.pos[3] for s in S])
#     u = vec([s.spin[1] for s in S]) 
#     v = vec([s.spin[2] for s in S])
#     w = vec([s.spin[3] for s in S])
#     Plots.quiver(x, y, z, quiver= (u,v,w), xlims = (-1,11), ylims = (-1.2, 1.2), zlims = (-1.2, 1.2), camera=(30,30))
#     xlabel!("x")
#     ylabel!("y")
# end

# gif(anim, "exercise2/gifs/10chain_posJ.gif", fps=30)

guess = fourier_2D(50)