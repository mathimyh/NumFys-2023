# Make a struct for each disc. They have position, velocity, mass, radius and collision count
mutable struct Disc
    pos::Vector{Float64}
    vel::Vector{Float64}
    mass::Float64
    radius::Float64
    c_count::Int64
end

# Also make structs for the walls so that it's easy to make ifs and elseifs
struct VertWall
end
struct HoriWall
end

# Make the structs for each collision. A collision has two objects, their collision counts at the moment the collision
# is calculated, and the time when the collision is supposed to happen. 
mutable struct Collision
    object1
    object2
    count1::Int64
    count2::Int64
    crash_time::Float64
end

# The timer 
mutable struct Clock
    time::Float64
end