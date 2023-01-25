# The struct describing the discs. They have position, velocity, mass, radius and collision count.
mutable struct Disc
    pos::Tuple{Float64, Float64}
    vel::Tuple{Float64, Float64}
    mass::Float64
    radius::Float64
    min_t::Float64
    c_count::Int64
end

# Also make structs for the walls so that it's easy to make ifs and elseifs
struct VertWall
end
struct HoriWall
end