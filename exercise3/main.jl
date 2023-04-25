include("fractals.jl")
include("lattice.jl")
include("solvers.jl")
include("plotting.jl")
include("saving.jl")
include("curve_fitting.jl")

using LinearAlgebra, ForwardDiff
using DataStructures
using Random, Distributions
using CalculusWithJulia
using Plots, Unitful  
using ProfileView
using SparseArrays, Arpack
using CSV, DataFrames
using CurveFit
using PlotlyJS; #plotlyjs()

l = 3
solutions = 10
excited = 5

eigvals, eigvecs, x_size = fivepoint_solver(l, solutions)
contourplot_3D(l, excited, eigvecs, x_size)
#ninepoint_solver(3, 1)

# ProfileView.@profview(fivepoint_solver(2))
# ProfileView.@profview(fivepoint_solver(l))

# for l in 2:4
#     eigvals, eigvecs, x_size = fivepoint_solver(l, solutions)
#     println("Level $l: ", round.(eigvals, digits=3))
# end


# delta_N = find_delta_N(l,eigvals)
# a,b = curve_fitting(eigvals, delta_N)
# println("a: $a")
# println("b: $b")
# plot_curvefit(eigvals, delta_N, a, b)


