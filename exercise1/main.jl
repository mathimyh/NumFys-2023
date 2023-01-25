include("structs.jl")
include("functions.jl")

using Random

mass_i = 0.01
mass_j = 0.01
ksi = 1




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