include("systems.jl")
include("utilities.jl")
include("monte_carlo.jl")
include("plotting.jl")
include("tasks.jl")

using Random
using Distributions
using LinearAlgebra
using Statistics
using JLD
using ProfileView
using Plots; gr()

# Declare the variable at start of each run. Should change this so I can run several systems at once.
const kb = 1.380649e-23 # m^2 kg s^-2 K^-1
global interact_e = interaction_energies()

# ProfileView.@profview(t2_1_7a(5, 10, false))
# ProfileView.@profview(t2_1_7a(15, 1000, false))

# @time t2_1_7a(5,10)
# @time t2_1_7a(15,1000)

# t2_1_7a(15, 2000)
t2_1_7b(15, 2000)


