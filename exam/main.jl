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

grid, acids = unfolded_chain2D(15, 10000)

for i in 1:100
    MC_sweep!(acids, grid)
    if i == 1
        local energy = calculate_energy(acids, interact_e)
        println(energy)
        plot2D(grid, acids, energy)
        savefig("exam/plots/unfolded_20monomers_10T_1sweep.png")
    elseif i == 10
        local energy = calculate_energy(acids, interact_e)
        println(energy)
        plot2D(grid, acids, energy)
        savefig("exam/plots/unfolded_20monomers_10T_10sweeps.png")
    elseif i == 100
        local energy = calculate_energy(acids, interact_e)
        println(energy)
        plot2D(grid, acids, energy)
        savefig("exam/plots/unfolded_20monomers_10T_100sweeps.png")
    end
end

# anim = @animate for i in 1:1000
#     MC_sweep!(acids, grid)
#     local energy = calculate_energy(acids, interact_e)
#     plot2D(grid, acids, energy)
# end

# gif(anim, "exam/gifs/testyboy.gif")

