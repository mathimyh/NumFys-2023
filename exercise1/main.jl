include("structs.jl")
include("phys_functions.jl")
include("sys_functions.jl")
include("animations.jl")
include("problems.jl")

using Random
using DataStructures
using LinearAlgebra
#using Plots
using ProfileView
using PlotlyJS


ksi = 1

# @time problem1(10, 100)
# @time problem1(5000, 500000)
# ProfileView.@profview problem1(10)
# ProfileView.@profview problem1(5000)

# @time problem2(10, 100)
# @time problem2(5000, 10000)
