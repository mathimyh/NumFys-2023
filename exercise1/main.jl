include("structs.jl")
include("functions.jl")
include("animations.jl")

using Random
using DataStructures
using LinearAlgebra
using Plots

ksi = 1

@time problem1(500)