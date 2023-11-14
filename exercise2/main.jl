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
#using PlotlyJS;

# Never change these
const gamma::Float64 = 1.6e11
const mu::Float64 = 5.8e-2

# Defining the constants, all in meV
J::Float64 = -10
kbt::Float64 = 0
mu_b::Float64 = 0
step_size::Float64 = 1e-15
alfa::Float64 = 0.2
d_z::Float64 = 0.3
b::Float64 = mu_b / mu


# for i in 0.1:0.2:1.9
#     global kbt = i*J
#     filename = "exercise2/cache/magnetization_20x20x20_" * string(i)[1] * string(i)[3] * "T_10000steps.jld"
#     simulate_groundstate(filename, 10000)
# end


# S = [Magnet((0.5, 0.5, 0.5), [0.5, 0.5, 1/sqrt(2)])]#, Magnet((0.5, 0.7, 0.5), [0.5, -0.5, 1/sqrt(2)])]

S = chain_random(10)
# S = chain_groundstate(100, true)
# S = box_random(5,5,5)

# saving_S = [S]

# plot_Ms()

# plot_tavg_M()

# for i in 1:5000
#     Heun!(S, J)
#     push!(saving_S, S)
# end

# save("exercise2/cache/10x10x10_5000steps_0T.jld", "S", saving_S)

#Ss = load("exercise2/cache/10x10x10_5000steps_0T.jld", "S")

# simulate_random("exercise2/cache/zeroT.jld", 50000, 10,10,10)
# anim = @animate for i in 1:500
#     Heun!(S,J)
#     x = vec([s.pos[1] for s in S])
#     y = vec([s.pos[2] for s in S])
#     z = vec([s.pos[3] for s in S])
#     u = vec([s.spin[1] for s in S]) 
#     v = vec([s.spin[2] for s in S])
#     w = vec([s.spin[3] for s in S])
#     Plots.quiver(x, y, z, quiver= (u,v,w), xlims = (-1,6), ylims = (-1, 6), zlims = (-1, 6), camera=(30,30))
#     xlabel!("x")
#     ylabel!("y")
# end

for i in 1:2000
    Heun!(S,J)
end
x = vec([s.pos[1] for s in S])
y = vec([s.pos[2] for s in S])
z = vec([s.pos[3] for s in S])
u = vec([s.spin[1] for s in S]) 
v = vec([s.spin[2] for s in S])
w = vec([s.spin[3] for s in S])
Plots.quiver(x, y, z, quiver= (u,v,w), xlims = (-1,11), ylims = (-1, 1), zlims = (-1, 1), camera=(30,30), dpi=300)
xlabel!("x")
ylabel!("y")
savefig("exercise2/plots/chaintesty1000neg.png")


# gif(anim, "yeayeyeayy.gif", fps=30)
# @time fourier_2D(100, "exercise2/cache/fouriermatrix_100mags_2kbt_AFM_mub.jld", false)
# fourier_heatmap("exercise2/cache/fouriermatrix_100mags_2kbt_AFM_mub.jld", "exercise2/plots/fourier_heatmap_100mags_2kbt_AFM_mub.png")

# Ms, ts = simulate_mag("exercise2/cache/magnetization_20x20x20_01T_10000steps.jld", 10000)
# Ms = load("exercise2/cache/magnetization_20x20x20_05T_10000steps.jld", "Ms")
# ts = load("exercise2/cache/magnetization_20x20x20_05T_10000steps.jld", "ts")
# p1 = Plots.plot(ts ./ 1e-12, Ms, legend=false, ylabel="M", xlabel="Time [ps]", dpi=300, title = "T = 0.5J")
# Plots.vline!(p1,[1])
# println(time_avg_magnetization(ts,Ms,1e-12))
# Plots.hline!(p1,[time_avg_magnetization(ts, Ms, 0.1*1e-12)])
# Plots.ylims!(0,1)

# Ms = load("exercise2/cache/magnetization_20x20x20_14T_10000steps.jld", "Ms")
# ts = load("exercise2/cache/magnetization_20x20x20_14T_10000steps.jld", "ts")
# p2 = Plots.plot(ts ./ 1e-12, Ms, legend=false, ylabel="M", xlabel="Time [ps]", dpi=300, title = "T = 1.4J")
# Plots.vline!(p2,[3])
# Plots.hline!(p2,[time_avg_magnetization(ts, Ms, 3e-12)])
# Plots.ylims!(0,1)

# Plots.plot(p1,p2, layout = (2,1), dpi=300, size = (1000,1000))
# savefig("exercise2/plots/magnetization/subplots_mags.png")

# ProfileView.@profview(simulate_mag("exercise2/cache/proftest.jld", 10))
# ProfileView.@profview(simulate_mag("exercise2/cache/proftest.jld", 500))

# @time(simulate_groundstate("exercise2/cache/proftest.jld", 10))
# @time(simulate_groundstate("exercise2/cache/magnetization_20x20x20_01T_10000steps.jld", 10000))


# Just define this here since I use a global variable and dont wanna bother wiht modules


# plot_Ms()

plot_tavg_M()



