include("structs.jl")
include("functions.jl")
include("animations.jl")

using Random
using DataStructures
using LinearAlgebra
using Plots
using ProfileView

ksi = 1


@time problem1(500)
# ProfileView.@profview problem1(10)
# ProfileView.@profview problem1(500)