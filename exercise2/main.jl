include("functions.jl")
include("plotting.jl")
include("structs.jl")

using LinearAlgebra, ForwardDiff
using DataStructures
using Random
using CalculusWithJulia
using Plots, Unitful

# Defining the constants
const heisenberg::Float64 = 0.01
const unaxial_const::Float64 = 0.003
const kbt::Float64 = 0.001
const mu_b::Float64 = 0.003
const gamma::Float64 = 1.6e11
const mu::Float64 = 5.8e-5
const step_size::Float64 = 1e-15
const alfa::Float64 = 0.1
const d_z::Float64 = 0.1

S = [Magnet((0.5, 0.5), [0.8, 0, 0.6])]

@gif for i in 1:step_size:100
    pos = [s.pos for s in S]
    vect = vec([s.spin for s in S])
    Plots.quiver(pos, quiver=(vect))
end






