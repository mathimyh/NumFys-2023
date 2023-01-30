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
R_squared((x_i,y_i), (x_j, y_j)) = (x_j-x_i)^2 + (y_j-y_i)^2
d(i,j,v_i,v_j, rad_i, rad_j) = (dot(delta_v(v_i, v_j), delta_x(i,j)))^2 - (dot(delta_v(v_i, v_j), delta_v(v_i, v_j))) * (dot(delta_x(i,j), delta_x(i,j))-(rad_i+rad_j)^2)
function delta_t(i,j,v_i,v_j, rad_i, rad_j)
    if dot(delta_v(v_i, v_j), delta_x(i,j)) >= 0
        return 10^8
    elseif d(i,j,v_i,v_j, rad_i, rad_j) <= 0
        return 10^8
    else
        dv_dx =  dot(delta_v(v_i, v_j), delta_x(i,j))
        dd = d(i,j, v_i, v_j, rad_i, rad_j)
        dv_dv =  dot(delta_v(v_i, v_j), delta_v(v_i, v_j))
        return - (dv_dx + sqrt(dd)) / dv_dv
    end
end

function big_factor_i(disc1, disc2)
    return (1+ksi) * (disc2.mass/(disc1.mass+disc2.mass)) * (dot(delta_v(disc1.vel, disc2.vel), delta_x(disc1.pos, disc2.pos))/(disc1.radius^2+disc2.radius^2))
end

function big_factor_j(disc1, disc2)
    return (1+ksi) * (disc1.mass/(disc1.mass+disc2.mass)) * (dot(delta_v(disc1.vel, disc2.vel), delta_x(disc1.pos, disc2.pos))/((disc1.radius+disc2.radius)^2))
end

function vel_two_discs_i(disc1, disc2)
    return (disc1.vel[1] + big_factor_i(disc1, disc2) * delta_x(disc1.pos, disc2.pos)[1], disc1.vel[2] + big_factor(disc1, disc2) * delta_x(disc1.pos, disc2.pos)[2])
end

function vel_two_discs_j(disc1, disc2)
    return (disc1.vel[2] - big_factor_j(disc1, disc2) * delta_x(disc1.pos, disc2.pos)[1], disc1.vel[2] + big_factor(disc1, disc2) * delta_x(disc1.pos, disc2.pos)[2])
end

# The function that finds the earliest collision for a disc. Updates the queue as well
function update_collision(disc, discs, queue, clock)
    time = 10^8
    for other in discs if other != disc
        temp = delta_t(disc.pos, other.pos, disc.vel, other.vel, disc.radius, other.radius)
        if temp < time
            time = temp
            crash = other
        end
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
    if (typeof(crash) != Disc)
        enqueue!(queue, Collision(disc, crash, disc.c_count, 0, time) => time + clock)
    else
        colls = [(coll.object1.pos, coll.object2.pos) for coll in collect(keys(queue)) if typeof(coll.object2) == Disc]
        if !((crash.pos, disc.pos) in colls) # Dont add the same collision twice
            enqueue!(queue, Collision(disc, crash, disc.c_count, crash.c_count, time) => time + clock)
        end
    end    
end

# Initializes all collision at the start of the simulation given the disc array.
function initialize_collisions(discs, clock)
    queue = PriorityQueue()
    for disc in discs
        update_collision(disc, discs, queue, clock)
    end
    return queue
end             


## The function that moves the system to the next collision. 
function update(queue, discs, clock)
    next = dequeue!(queue) 
    # Check if collision is valid first. If not try again
    # if (next.object1.c_count != next.count1) 
    #     return nothing
    # end
    # if typeof(next.object2) != HoriWall && typeof(next.object2) != VertWall
    #     if (next.object2.c_count != next.count2)
    #         return nothing
    #     end
    # end
    # Updating positions of all discs
    for disc in discs 
        disc.pos = (disc.pos[1] + disc.vel[1]*next.time_until, disc.pos[2] + disc.vel[2]*next.time_until) 
    end
    clock += next.time_until
    # Updating velocities of involved discs
    if typeof(next.object2) == VertWall
        next.object1.vel = vert_wall(next.object1.vel)
        update_collision(next.object1, discs, queue, clock)
        #next.object1.c_count += 1
    elseif typeof(next.object2) == HoriWall
        next.object1.vel = hori_wall(next.object1.vel)
        update_collision(next.object1, discs, queue, clock)
        #next.object1.c_count += 1
    else
        temp1_vel = vel_two_discs_i(next.object1,next.object2)
        temp2_vel = vel_two_discs_j(next.object1,next.object2)
        next.object1.vel = temp1_vel
        next.object2.vel = temp2_vel
        update_collision(next.object1, discs, queue, clock)
        update_collision(next.object2, discs, queue, clock)
        #next.object1.c_count += 1
        #next.object2.c_count += 1
    end
    return nothing
end
        
        

