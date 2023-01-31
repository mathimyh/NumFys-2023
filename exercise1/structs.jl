# The struct describing the discs. They have position, velocity, mass, radius and collision count.
mutable struct Disc
    pos::Tuple{Float64, Float64}
    vel::Tuple{Float64, Float64}
    mass::Float64
    radius::Float64
    c_count::Int64
end

# Also make structs for the walls so that it's easy to make ifs and elseifs
struct VertWall
end
struct HoriWall
end

# Make the structs for each collision. 
mutable struct Collision
    object1
    object2
    count1::Int64
    count2::Int64
    time_until::Float64
end

# The timer 
mutable struct Clock
    time::Float64
end