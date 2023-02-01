include("structs.jl")
include("functions.jl")
include("animations.jl")

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
mass_j = 1
ksi = 1
radius_i = 0.05
radius_j = 0.005


# disc1 = Disc((0.5, 0.5), (0.1,-0.3), mass_i, radius_i, 0)
# disc2 = Disc((0.5, 0.1), (0,0.4), mass_j, radius_i, 0)
# disc3 = Disc((0.7, 0.2), (0.38, 0.32), mass_i, 0.05, 0)
# disc4 = Disc((0.3, 0.8), (-0.1, -0.2), mass_i, radius_i, 0)
# discs = [disc1, disc2, disc3, disc4]

discs = uniform_distribution(5, radius_i)

queue, clock = initialize_collisions(discs)


# for i in 1:1
#     update(queue, discs, clock)
# end

# circles = circle.(discs)
# plot(circles, xlim=(0,1), ylim=(0,1), legend=false)



anim = Plots.Animation()
println("Energy at start: ", sum([1/2 * disc.mass * (disc.vel[1]^2+disc.vel[2]^2) for disc in discs]))
for k in 1:500
    move_til_next(queue, discs, clock, anim)
end
println("Energy at end: ", sum([1/2 * disc.mass * (disc.vel[1]^2+disc.vel[2]^2) for disc in discs]))
gif(anim, "anim2.gif")



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