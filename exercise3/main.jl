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

function main()
    # l = 2
    # points = Koch(l)
    # x = [tuple[1] for tuple in points]
    # y = [tuple[2] for tuple in points]
    # lattice = make_lattice(l, points)
    # x = []
    # y = []
    # i = 0
    # for row in eachcol(lattice)
    #     j = 0
    #     for element in row
    #         if element == border::GridPoint
    #             push!(x,j)
    #             push!(y,i)
    #         end; j+=1
    #     end; i+=1
    # end

    # #println(lattice)
    # Plots.scatter(x,y)

    # x = []
    # y = []
    # i = 0
    # for row in eachcol(lattice)
    #     j = 0
    #     for element in row
    #         if element == outside::GridPoint
    #             push!(x,j)
    #             push!(y,i)
    #         end; j+=1
    #     end; i+=1
    # end
    # Plots.scatter!(x,y)
    #Plots.plot(x,y)
    
    #contour3d(x,y,eigvec_grid, levels=20, color=:viridis, clims=(-1,1))
end

# ProfileView.@profview(problem4(1,1))
# ProfileView.@profview(problem4(2,5))

problem4(4,4)