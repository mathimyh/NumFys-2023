## First define functions for wall collisions
vert_wall((v_x, v_y)) = (-ksi*v_x, ksi*v_y)
hori_wall((v_x, v_y)) = (ksi*v_x, -ksi*v_y)
function vert_delta_t(radius, x_i, v_xi)
    if v_xi == 0
        return 10^8
    elseif v_xi > 0
        return (1-radius-x_i) / v_xi
    else
        return (radius-x_i) / v_xi
    end
end
function hori_delta_t(radius, y_i, v_yi)
    if v_yi == 0
        return 10^8
    elseif v_yi > 0
        return (1-radius-y_i) / v_yi
    else
        return (radius-y_i) / v_yi
    end
end

## Then functions for two particle collisions
delta_x((x_i, y_i),(x_j, y_j)) = (x_j-x_i, y_j-y_i)
delta_v((v_xi, v_yi), (v_xj, v_yj)) = (v_xj-v_xi, v_yj-v_yi)
R_squared((x_i,y_i), (x_j, y_j)) = (x_i-x_j)^2 + (y_i-y_j)^2
d(i,j,v_i,v_j) = (dot(delta_v(v_i, v_j), delta_x(i,j)))^2 - (dot(delta_v(v_i, v_j), delta_v(v_i, v_j))) * (dot(delta_x(i,j), delta_x(i,j))-R_squared(i,j))
function delta_t(i,j,v_i,v_j)
    if delta_x(i,j)[1] * delta_v(v_i, v_j)[1] + delta_x(i,j)[2] * delta_v(v_i, v_j)[2] >= 0
        return 10^8
    elseif d(i,j,v_i,v_j) <= 0
        return 10^8
    else
        return - (dot(delta_v(v_i, v_j), delta_x(i,j)) + sqrt(d(i,j,v_i,v_j))) / (dot(delta_v(v_i, v_j), delta_v(v_i, v_j))) 
    end
end

function vel_two_discs(disc1, disc2)
    return (disc1.vel[1] + ((1+ksi) * disc2.mass / (disc1.mass+disc2.mass) * delta_v(disc1.vel, disc2.vel)[1] * delta_x(disc1.pos, disc2.pos)[1] / (disc1.radius+disc2.radius)^2), disc1.vel[2] + ((1+ksi) * disc2.mass / (disc1.mass+disc2.mass) * delta_v(disc1.vel, disc2.vel)[2] * delta_x(disc1.pos, disc2.pos)[2] / (disc1.radius+disc2.radius)^2))
end

## Initialize function that sets up the system described in problem 1. Returns an array of all discs.
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

# The function that finds the earliest collision for a disc given an array of discs. Updates the queue
function update_collision(disc, discs, queue)
    time = 10^8
    for other in discs
        disc != other || continue
        temp = delta_t(disc.pos, other.pos, disc.vel, other.vel)
        if temp < time
            time = temp
            crash = other
        end
    end
    temp = hori_delta_t(disc.radius, disc.pos[2], disc.vel[2])
    if temp < time
        time = temp
        crash = HoriWall()
    end
    temp = vert_delta_t(disc.radius, disc.pos[1], disc.vel[1])
    if temp < time
        time = temp
        crash = VertWall()
    end
    println(typeof(crash))
    # if !((crash, disc) in queue.keys) # To avoid two instances of the same collision
    if (typeof(crash) != Disc)
        enqueue!(queue, Collision(disc, crash, disc.c_count, 0) => time)
    else
        enqueue!(queue, Collision(disc, crash, disc.c_count, crash.c_count) => time)
    end    
end

# Initializes all collision at the start of the simulation
function initialize_collisions(discs)
    len = length(discs)
    queue = PriorityQueue{Collision, Float64}
    for disc in discs
        update_collision(disc, discs, queue)
    end
    return queue
end             


## The function that moves the system to the next collision. 
function update(queue, discs)
    next = dequeue!(queue) 
    # Check if collision is valid first! 
    if (next.object1.c_count != next.count[1]) 
        return nothing
    end
    if typeof(next.object2 != HoriWall) && typeof(next.object2 != VertWall)
        if (next.object2.c_count != next.count[2])
            return nothing
        end
    end
    # Updating positions of all discs
    for disc in discs 
        disc.pos[1] += disc.vel[1]*time
        disc.pos[2] += disc.vel[2]*time 
    end
    # Updating velocities of involved discs
    if typeof(next.object2) == VertWall
        next.object1.vel = vert_wall(next.object1.vel)
        update_collision(next.object1, discs, queue)
    elseif typeof(next.object2) == HoriWall
        next.object1.vel = hori_wall(next.object1.vel)
        update_collision(next.object1, discs, queue)
    else
        temp1_vel = vel_two_discs(next.object1,next.object2)
        temp2_vel = vel_two_discs(next.object2,next.object1)
        next.object1.vel = temp1_vel
        next.object2.vel = temp2_vel
        update_collision(next.object1, discs, queue)
        update_collision(next.object2, discs, queue)
    end
    return nothing
end
        
        

