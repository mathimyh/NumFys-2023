include("systems.jl")
include("plotting.jl")

using Random
using Plots; gr()


grid, acids = chain_2d(10, 20)
plot2D(grid)