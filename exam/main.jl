include("systems.jl")
include("monte_carlo.jl")
include("plotting.jl")


using Random
using Distributions
using LinearAlgebra
using Plots; gr()

# Declare the variable at start of each run. Should change this so I can run several systems at once.
const kb = 1.380649e-23 # m^2 kg s^-2 K^-1
T::Float64 = 10
interact_e = interaction_energies()
logger = Logger(Vector{Float64}())





