include("fractals.jl")
include("lattice.jl")
include("solvers.jl")
include("plotting.jl")
include("saving.jl")

using LinearAlgebra, ForwardDiff
using DataStructures
using Random, Distributions
using CalculusWithJulia
using Plots, Unitful  
using ProfileView
using SparseArrays, Arpack
using CSV, DataFrames
using PlotlyJS; plotlyjs()

l = 4
excited = 3

#eigvals, eigvecs, x_size = fivepoint_solver(l)
# save_eigs(eigvals, eigvecs, "test.CSV")
#contourplot_3D(l, excited, eigvecs, x_size)
#ninepoint_solver(3, 1)

ProfileView.@profview(fivepoint_solver(2))
ProfileView.@profview(fivepoint_solver(l))
