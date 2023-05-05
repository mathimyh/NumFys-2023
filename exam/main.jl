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

# Define colors for the plotting. As we get new interaction energies it doesnt matter that 
# the colors are randomly chosen each time. 
color_dict = Dict(i => rand(RGB) for i in 1:20)

# plots = []
# for i in 1:3
#     acids, pos_idx = folded_chain2D(15)
#     energy = calculate_energy(acids, pos_idx, interact_e, 2)
#     push!(plots, plot2D(acids, energy))
# end
# Plots.plot(plots..., layout=(1,3), size = (1500,500), legend=false)
# Plots.savefig("exam/plots/2_1_3/subplots.png")
# actually_t2_1_9(interact_e)


# ProfileView.@profview(t2_1_7a(5, 10, false))
# ProfileView.@profview(t2_1_7a(15, 1000, false))

# @time t2_1_7a(5,10, false)
# @time t2_1_7a(15,1000, false)

# ProfileView.@profview t2_2_3a(1,10, false)
# ProfileView.@profview t2_2_3a(15, 100, false)

# ProfileView.@profview(t2_2_3a(5, 10, false))
# ProfileView.@profview(t2_2_3a(15, 500, false))

t2_1_7b(15, 2000)

# p1, p2 = t2_1_6(500, true)
# p3 = t2_1_6(10000)

# Plots.plot(p1,p2,p3, layout=(3,1), size=(1200,1400))
# Plots.savefig("exam/plots/2_1_6/subplots1T.png")

# t2_1_5(500, true)

