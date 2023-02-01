## First define functions for wall collisions
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

## Then functions for two particle collisions
delta_x((x_i, y_i),(x_j, y_j)) = (x_j-x_i, y_j-y_i)
delta_v((v_xi, v_yi), (v_xj, v_yj)) = (v_xj-v_xi, v_yj-v_yi)
R_squared((x_i,y_i), (x_j, y_j)) = (x_j-x_i)^2 + (y_j-y_i)^2
d(i,j,v_i,v_j, rad_i, rad_j) = (dot(delta_v(v_i, v_j), delta_x(i,j)))^2 - (dot(delta_v(v_i, v_j), delta_v(v_i, v_j))) * (dot(delta_x(i,j), delta_x(i,j))-(rad_i+rad_j)^2)
function delta_t(i,j,v_i,v_j, rad_i, rad_j)
    if dot(delta_v(v_i, v_j), delta_x(i,j)) >= 0
        return nothing
    elseif d(i,j,v_i,v_j, rad_i, rad_j) <= 0
        return nothing
    else
        dv_dx =  dot(delta_v(v_i, v_j), delta_x(i,j))
        dd = d(i,j, v_i, v_j, rad_i, rad_j)
        dv_dv =  dot(delta_v(v_i, v_j), delta_v(v_i, v_j))
        # println("dv_dx = $dv_dv")
        # println("dd = $dd")
        # println("dv_dv = $dv_dv")
        # println(- (dv_dx + sqrt(dd)) / dv_dv)
        return - (dv_dx + sqrt(dd)) / dv_dv
    end
end

function big_factor_i(disc_i, disc_j)
    return (1+ksi) * (disc_j.mass/(disc_i.mass+disc_j.mass)) * (dot(delta_v(disc_i.vel, disc_j.vel), delta_x(disc_i.pos, disc_j.pos))/(disc_i.radius+disc_j.radius)^2)
end

function big_factor_j(disc_i, disc_j)
    return (1+ksi) * (disc_i.mass/(disc_i.mass+disc_j.mass)) * (dot(delta_v(disc_i.vel, disc_j.vel), delta_x(disc_i.pos, disc_j.pos))/((disc_i.radius+disc_j.radius)^2))
end

function vel_two_discs_i(disc_i, disc_j)
    vel = (disc_i.vel[1] + big_factor_i(disc_i, disc_j) * delta_x(disc_i.pos, disc_j.pos)[1], disc_i.vel[2] + big_factor_i(disc_i, disc_j) * delta_x(disc_i.pos, disc_j.pos)[2])
    return vel
end

function vel_two_discs_j(disc_i, disc_j)
    vel = (disc_j.vel[1] - big_factor_j(disc_i, disc_j) * delta_x(disc_i.pos, disc_j.pos)[1], disc_j.vel[2] - big_factor_j(disc_i, disc_j) * delta_x(disc_i.pos, disc_j.pos)[2])
    return vel 
end

# The function that finds the collisions for discs, then updates the queue.
function update_collision(disc, discs, queue, clock)
    # I check if discs collide with other discs. All possible collision are put into the queue!!!
    for other in discs if other != disc
        time = delta_t(disc.pos, other.pos, disc.vel, other.vel, disc.radius, other.radius)
        if !isnothing(time) 
            crash = other
            enqueue!(queue, Collision(disc, crash, disc.c_count, crash.c_count, time) => time + clock.time)
        end
    end;end
    
    # Now check for both walls. 
    time = hori_delta_t(disc.radius, disc.pos[2], disc.vel[2])
    if !isnothing(time) 
        crash = HoriWall()
        enqueue!(queue, Collision(disc, crash, disc.c_count, 0, time) => time + clock.time)
    end
    time = vert_delta_t(disc.radius, disc.pos[1], disc.vel[1])
    if !isnothing(time)
        crash = VertWall()
        enqueue!(queue, Collision(disc, crash, disc.c_count, 0, time) => time + clock.time)
    end
    return nothing   
end

# Initializes all collision at the start of the simulation given the disc array.
function initialize_collisions(discs)
    clock = Clock(0)
    queue = PriorityQueue()
    for disc in discs
        update_collision(disc, discs, queue, clock)
    end
    return queue, clock
end             


## The function that moves the system to the next collision. 
function update(queue, discs, clock)
    next = dequeue!(queue) 
    # Check if collision is valid first. If not try again
    if (next.object1.c_count != next.count1) 
        #update_collision(next.object1, discs, queue, clock)
        return false
    end
    if typeof(next.object2) != HoriWall && typeof(next.object2) != VertWall
        if (next.object2.c_count != next.count2)
            #update_collision(next.object2, discs, queue, clock)
            return false
        end
    end

    # Might be some trouble that the time is 0
    # if next.time_until == 0
    #     return false
    # end
    # Updating positions of all discs
    for collision in collect(keys(queue))
        collision.time_until -= next.time_until
    end
    for disc in discs 
        disc.pos = (disc.pos[1] + disc.vel[1]*next.time_until, disc.pos[2] + disc.vel[2]*next.time_until) 
    end
    clock.time += next.time_until
    # Updating velocities of involved discs
    if typeof(next.object2) == VertWall
        next.object1.vel = vert_wall(next.object1.vel)
        next.object1.c_count += 1
        update_collision(next.object1, discs, queue, clock)
    elseif typeof(next.object2) == HoriWall
        next.object1.vel = hori_wall(next.object1.vel)
        next.object1.c_count += 1
        update_collision(next.object1, discs, queue, clock)
    else
        # println("Time until: ", next.time_until)
        temp1_vel = vel_two_discs_i(next.object1,next.object2)
        temp2_vel = vel_two_discs_j(next.object1,next.object2)
        # println("new vels: $temp1_vel and $temp2_vel")
        next.object1.vel = temp1_vel
        next.object2.vel = temp2_vel
        next.object1.c_count += 1
        next.object2.c_count += 1
        update_collision(next.object1, discs, queue, clock)
        update_collision(next.object2, discs, queue, clock)
    end
    return true
end

# Initalizes a system with n uniform sized discs with a given radius. 
function uniform_distribution(n, radius, random_mass=false) 
    masses = []
    if random_mass
        for i in 1:n
            push!(masses, rand([0.1,1]))
        end
    else
        for i in 1:n
           push!(masses, 1)
        end
    end 
    gridsize = Int(1 / (2*radius))
    print(gridsize)
    discs = []
    for i in 1:n
        pos = 0
        while true
            pos = (rand(1:(gridsize-1)) * 2*radius, rand(1:(gridsize-1)) *2* radius)
            pos in [disc.pos for disc in discs] || break
        end
        disc = Disc(pos, (rand(-10:0.01:10), rand(-10:0.01:10)), masses[i], radius, 0)
        push!(discs, disc)
    end
    return discs
end


