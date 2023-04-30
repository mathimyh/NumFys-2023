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
using JLD
using PlotlyJS; #plotlyjs()

l = 4
solutions = 10
excited = 7

# eigvals, eigvecs, x_size = ninepoint_solver(l, solutions)
# save_eigs(eigvals, eigvecs, x_size, "exercise3/cache/thirteenpoint_l4_10sols_test.jld")
# eigvecs = load("exercise3/cache/ninepoint_l3_10sols_negativelaplacian.jld", "eigvecs")
# eigvals = load("exercise3/cache/ninepoint_l3_10sols_negativelaplacian.jld", "eigvals")
# eigvals2 = load("exercise3/cache/fivepoint_l5_10sols.jld", "eigvals")
# println(eigvals, eigvals2)
# x_size = load("exercise3/cache/ninepoint_l3_10sols_negativelaplacian.jld", "x_size")
# contourplot_3D("exercise3/cache/thirteenpoint_l4_10sols_test.jld",l, excited)
#ninepoint_solver(3, 1)


# ProfileView.@profview(ninepoint_solver(2, solutions))
# ProfileView.@profview(ninepoint_solver(l, solutions))

# for l in 2:4
#     eigvals, eigvecs, x_size = fivepoint_solver(l, solutions)
#     println("Level $l: ", round.(eigvals, digits=3))
# end


# @time(ninepoint_solver(2, solutions))
# @time(ninepoint_solver(l, solutions))


# @ProfileView.profview(ninepoint_solver(2, solutions))
# @ProfileView.profview(ninepoint_solver(l, solutions))

#save("exercise3/cache/fivepoint_l4_10eigvals.jld", "eigvals", eigvals)
# eigvals = load("exercise3/cache/fivepoint_l4_10eigvals.jld", "eigvals")


# delta_N = find_delta_N(l,eigvals[1])
# a,b = curve_fitting(eigvals[1], delta_N)
# plot_curvefit(eigvals[1], delta_N, a, b, "exercise3/plots/fivepoint_l4_1000eigvals.pdf")