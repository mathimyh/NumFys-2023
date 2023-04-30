include("phys_functions.jl")
include("plotting.jl")
include("systems.jl")
include("fourier.jl")
include("phase_diagrams.jl")

using LinearAlgebra, ForwardDiff
using DataStructures
using Random, Distributions
using CalculusWithJulia
using FFTW
using JLD
using ProfileView
using Plots, Unitful; gr()
#using PlotlyJS; plotlyjs()

# Never change these
const gamma::Float64 = 1.6e11
const mu::Float64 = 5.8e-2

# Defining the constants, all in meV
J::Float64 = 10
kbt::Float64 = 0
mu_b::Float64 = 0
step_size::Float64 = 1e-15
alfa::Float64 = 0.2
d_z::Float64 = 3
b::Float64 = mu_b / mu


#S = [Magnet((0.5, 0.5, 0.5), [0.5, 0.5, 1/sqrt(2)])]#, Magnet((0.5, 0.7, 0.5), [0.5, -0.5, 1/sqrt(2)])]

# S = chain_random(10)
# #S = chain_groundstate(100)
# S = box_random(10,10,10)

# saving_S = [S]



# for i in 1:5000
#     Heun!(S, J)
#     push!(saving_S, S)
# end

# save("exercise2/cache/10x10x10_5000steps_0T.jld", "S", saving_S)

#Ss = load("exercise2/cache/10x10x10_5000steps_0T.jld", "S")


# anim = @animate for S in Ss
#     x = vec([s.pos[1] for s in S])
#     y = vec([s.pos[2] for s in S])
#     z = vec([s.pos[3] for s in S])
#     u = vec([s.spin[1] for s in S]) 
#     v = vec([s.spin[2] for s in S])
#     w = vec([s.spin[3] for s in S])
#     Plots.quiver(x, y, z, quiver= (u,v,w), xlims = (-1,11), ylims = (-1, 11), zlims = (-1, 11), camera=(30,30))
#     xlabel!("x")
#     ylabel!("y")
# end

# gif(anim, "exercise2/gifs/testy_3d.gif", fps=30)
#fourier_2D(50, "exercise2/cache/fouriermatrix_50mags.jld")
#fourier_heatmap("exercise2/cache/fouriermatrix_50mags.jld")

# Ms, ts = simulate_mag("exercise2/cache/magnetization_20x20x20_01T_10000steps.jld", 10000)
# Ms = load("exercise2/cache/magnetization_20x20x20_0T_10000steps.jld", "Ms")
# ts = load("exercise2/cache/magnetization_20x20x20_0T_10000steps.jld", "ts")
# println(ts[1:40])
# Plots.plot(ts, Ms)

# ProfileView.@profview(simulate_mag("exercise2/cache/proftest.jld", 10))
# ProfileView.@profview(simulate_mag("exercise2/cache/proftest.jld", 500))

@time(simulate_mag("exercise2/cache/proftest.jld", 10))
@time(simulate_mag("exercise2/cache/.jld", 500))