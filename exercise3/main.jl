include("functions.jl")
include("datatypes.jl")
include("problems.jl")

using LinearAlgebra, ForwardDiff
using DataStructures
using Random, Distributions
using CalculusWithJulia
using Plots, Unitful
using ProfileView
using SparseArrays, Arpack
using PlotlyJS

plotlyjs()


# ProfileView.@profview(problem4(1,1))
# ProfileView.@profview(problem4(2,5))

#problem4(4,5)
problem7(3,6)
#draw_fractal(1)
