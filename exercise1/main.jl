include("structs.jl")
include("functions.jl")

using Random
using DataStructures
using LinearAlgebra
using Plots

function circle(disc; n=30)
    θ = 0:360÷n:360
    Plots.Shape(disc.radius*sind.(θ) .+ disc.pos[1], disc.radius*cosd.(θ) .+ disc.pos[2])
end

function circle(x, y , radius; n=30)
    θ = 0:360÷n:360
    Plots.Shape(radius*sind.(θ) .+ x, radius*cosd.(θ) .+ y)
end

mass_i = 1
mass_j = 0.01
ksi = 1
clock = 0 # A timer of sorts. This is so the pq can keep track of which collision is next

disc1 = Disc((0.1, 0.5), (0.2,0), mass_i, 0.05, 0)
disc2 = Disc((0.9, 0.5), (-0.2,0), mass_i, 0.05, 0)
disc3 = Disc((0.7, 0.2), (-0.3, 0.5), mass_i, 0.05, 0)
discs = [disc1, disc2]#, disc3]
queue = initialize_collisions(discs, clock)


# for i in 1:4
#     update(queue, discs, clock)
#     println("\n", queue)
# end

# circles = circle.(discs)
# plot(circles, xlim=(0,1), ylim=(0,1))

function plotting_easy(circles)
    plot(circles, legend=false, xlim=(0,1), ylim=(0,1))
    Plots.frame(anim)
end

function move_til_next(queue, discs, clock, anim)
    startpoints = [disc.pos for disc in discs]
    vels = [disc.vel for disc in discs]
    println(([sqrt((vel[1])^2+(vel[2])^2) for vel in vels]))
    moving_time = peek(queue)[1].time_until
    update(queue, discs, clock)
    x = []
    y = []
    radii = []
    for i in 0:0.05:moving_time
        circles = []
        for j in 1:length(startpoints)
            dx = (startpoints[j][1] - discs[j].pos[1]) / (moving_time)
            dy = (startpoints[j][2] - discs[j].pos[2]) / (moving_time)
            push!(x, startpoints[j][1] - dx*i)
            push!(y, startpoints[j][2] - dy*i)
            push!(radii, discs[j].radius)
        end
        circles = circle.(x, y, radii)
        plotting_easy(circles)
    end
end


anim = Plots.Animation()
for k in 1:10
    move_til_next(queue, discs, clock, anim)
end

gif(anim, "anim2.gif")

# anim = @animate for _ in 1:steps
#     move_til_next(queue, discs, clock)
# end

# gif(anim, "anim.gif")





## First initalize all particles with a position and velocity. I will make each disc a type with 
# a position, velocity, mass and radius. They will also have a collision variable, which shows the time until 
# their first collision and what object they collide with. This can be another disc or the wall.

## Now i will calculate each discs first collision and add them together with their time into a queue.
# It seems like the best way is to use tuples. Then the loop starts. 

## The loop will find the first collision that happens and then move every particle to their new position at the 
# moment of the first collision, after the smallest time. Every particles time until next collision is reduced
# by the time spent getting to the last collison. Then the new collisions for the particles involved in the last collision are 
# calculated. The loop begins anew by moving every particle until the next collision happens. It is also important
# here to check wether the collision is valid, there might be some complications if the particles involved in the 
# last collision are for example hitting another disc before its presumed first collision. 