using Random

mass_i = 0.01
mass_j = 0.01
ksi = 1

# First define functions for wall collisions
vert_wall((v_x, v_y)) = (-ksi*v_x, ksi*v_y)
hori_wall((v_x, v_y)) = (ksi*v_x, -ksi*v_y)
function vert_delta_t(radius, x_i, v_xi)
    if v_xi == 0
        return nothing
    elseif v_xi > 0
        return (1-radius-x_i) / v_xi
    else
        return (radius-x_i) / v_xi
    end
end
function hori_delta_t(radius, y_i, v_yi)
    if v_yi == 0
        return nothing
    elseif v_yi > 0
        return (1-radius-y_i) / v_yi
    else
        return (radius-y_i) / v_yi
    end
end

# Then functions for two particle collisions
delta_x((x_i, y_i),(x_j, y_j)) = (x_j-x_i, y_j-y_i)
delta_v((v_xi, v_yi), (v_xj, v_yj)) = (v_xj-v_xi, v_yj-v_yi)
R_squared((x_i,y_i), (x_j, y_j)) = (x_i-x_j)^2 + (y_i-y_j)^2
d(i,j,v_i,v_j) = (delta_v(v_i,v_j)*delta_x(i,j))^2 - (delta_v(v_i,v_j))^2 * ((delta_x(i,j))^2-R_squared(i,j))
function delta_t(i,j,v_i,v_j)
    if delta_x(i,j) * delta_v(v_i, v_j) >= 0
        return nothing
    elseif d(i,j,v_i,v_j) <= 0
        return nothing
    else
        return - (delta_v(v_i, v_j) * delta_x(i,j) + sqrt(d(i,j,v_i,v_j))) / (delta_v(v_i, v_j)^2) 
    end
end
function two_particles((x, y), (v_x, v_y))
    return ()
end


# The struct describing the discs. They have position, velocity, mass and radius. They also
# have a nearest collision, which can either be wall or disc
mutable struct Disc
    pos::Tuple{Float32, Float32}
    vel::Tuple{Float32, Float32}
    mass::Float32
    radius::Float32
    min_t::Float32
    nearest_coll
end

# Also make structs for the walls so that it's easy to make ifs and elseifs
struct VertWall
end
struct HoriWall
end

# Initialize function that sets up the system described in problem 1
function initialize1(n, random_mass = false)
    radius = 1 / (100*n) # So it doesn't get too crowded
    discs = Array{Disc}
    for i in 1:n
        if random_mass
            mass = rand(Float32, (1,100))
        else
            mass = 1
        end
        pos = (rand(Float32, (radius/2, 1 - radius/2)), rand(Float32, (radius/2, 1 - radius/2))) 
        
        
    end
end

# The next collision function. This finds the first collision and updates every disc to their new 
# positions, in addition to calculating the colliding particles new velocity. 
function next_collision(disc_priorities)





## First initalize all particles with a position and velocity. I will make each disc a type with 
# a position, velocity, mass and radius. They will also have a collision variable, which shows the time until 
# their first collision and what object they collide with. This can be another disc or the wall

## Now i will calculate each discs first collision and add them together with their time into a queue. Then 
# the loop starts. 

## The loop will find the first collision that happens and then move every particle to their new position at the 
# moment of the first collision, after the smallest time. The time until every particles first collision will be 
# reduced by the time spent moving. Then the new collisions for the particles involved in the last collision are 
# calculated. The loop begins anew by moving every particle until the next collision happens. It is also important
# here to check wether the collision is valid, there might be some complications if the particles involved in the 
# last collision are for example hitting another disc before its presumed first collision. 