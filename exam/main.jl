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


# actually_t2_1_9(interact_e)


# ProfileView.@profview(t2_1_7a(5, 10, false))
# ProfileView.@profview(t2_1_7a(15, 1000, false))

# @time t2_1_7a(5,10, false)
# @time t2_1_7a(15,2000, false)

ProfileView.@profview t2_2_3a(1,10, false)
ProfileView.@profview t2_2_3a(15, 100, false)

# ProfileView.@profview(t2_2_3a(5, 10, false))
# ProfileView.@profview(t2_2_3a(15, 500, false))




