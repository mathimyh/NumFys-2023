### HERE ALL FUNCTIONS FOR THE SYSTEM ITSELF ARE DEFINED

# Changing the position of each disc after a collision
function change_pos(disc, time_spent)
    disc.pos = disc.pos .+ (disc.vel .* time_spent)
end 


# The function that finds every possible collision for a disc, then updates the queue.
# ALL possible collisions are put into the queue. 
function update_collision(discs, queue, clock::Clock, j::Int64)
    
    # First checking disc-disc collisions
    disc_len = length(discs)
    for i in 1:disc_len if i != j
        time = delta_t(discs[i], discs[j])
        if !isnothing(time) 
            enqueue!(queue, Collision(discs[j], discs[i], discs[j].c_count, discs[i].c_count, time + clock.time) => time + clock.time)
        end
    end;end
    
    # Now check disc-wall collisions
    time = hori_delta_t(discs[j])
    if !isnothing(time) 
        crash = HoriWall()
        enqueue!(queue, Collision(discs[j], crash, discs[j].c_count, 0, time + clock.time) => time + clock.time)
    end
    time = vert_delta_t(discs[j])
    if !isnothing(time)
        crash = VertWall()
        enqueue!(queue, Collision(discs[j], crash, discs[j].c_count, 0, time + clock.time) => time + clock.time)
    end


    return nothing   
end

# This is the same function that finds every collision for a disc, however it takes in the disc ITSELF
# as a parameter and not the index of the disc. Due to Julia not having pointers the two functions were necessary 
# to use the disc array as pass by reference, improving performance
function update_collision2(disc::Disc, discs, queue, clock::Clock)
    disc_len = length(discs)
    for i in 1:disc_len if discs[i] != disc
        time = delta_t(discs[i], disc)
        if !isnothing(time) 
            enqueue!(queue, Collision(disc, discs[i], disc.c_count, discs[i].c_count, time + clock.time) => time + clock.time)
        end
    end;end
     
    time = hori_delta_t(disc)
    if !isnothing(time) 
        crash = HoriWall()
        enqueue!(queue, Collision(disc, crash, disc.c_count, 0, time + clock.time) => time + clock.time)
    end
    time = vert_delta_t(disc)
    if !isnothing(time)
        crash = VertWall()
        enqueue!(queue, Collision(disc, crash, disc.c_count, 0, time + clock.time) => time + clock.time)
    end
    return nothing   
end


# Initializes all collisions at the start of a simulation given an array of discs.
function initialize_collisions(discs)
    clock = Clock(0)
    queue = PriorityQueue()
    len = length(discs)
    for j in 1:len
        update_collision(discs, queue, clock, j)
    end
    return queue, clock
end  


## The function that moves the system to the next collision. 
function update(queue, discs, clock)
    next = dequeue!(queue) 
    
    # Check if collision counts are the same. If not the collision is invalid, and you need to try again.
    if (next.object1.c_count != next.count1)
        return false
    end
    if typeof(next.object2) != HoriWall && typeof(next.object2) != VertWall
        if (next.object2.c_count != next.count2)
            return false
        end
    end

    # Find the time spent between the collisions, and update to the new time
    last_time = clock.time
    clock.time = next.crash_time
    time_spent = clock.time - last_time
    
    change_pos.(discs, time_spent)
    
    # Updating velocities and collision counts of involved objects
    if typeof(next.object2) == VertWall
        next.object1.vel = vert_wall(next.object1)
        next.object1.c_count += 1
        update_collision2(next.object1, discs, queue, clock)
    elseif typeof(next.object2) == HoriWall
        next.object1.vel = hori_wall(next.object1)
        next.object1.c_count += 1
        update_collision2(next.object1, discs, queue, clock)
    else
        temp1_vel = vel_two_discs_i(next.object1,next.object2)
        temp2_vel = vel_two_discs_j(next.object1,next.object2)
        next.object1.vel = temp1_vel
        next.object2.vel = temp2_vel
        next.object1.c_count += 1
        next.object2.c_count += 1
        update_collision2(next.object1, discs, queue, clock)
        update_collision2(next.object2, discs, queue, clock)
    end
    return true
end

# Initalizes a system with n uniform sized discs with a given radius. The velocities are random
# Can either make all discs have same mass, or half have 4 times the mass of the other half
function uniform_distribution(n, radius, diff_mass=false, vel = 1) 
    masses = []
    if diff_mass
        for i in 1:(n/2)
            push!(masses, 1)
        end
        for i in ((n/2)+1):n
            push!(masses, 4)
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
            pos = [rand(1:(gridsize-1)) * 2*radius, rand(1:(gridsize-1)) *2* radius]
            pos in [disc.pos for disc in discs] || break
        end
        angle = rand(0:0.001:2*pi)
        disc = Disc(pos, [vel*cos(angle), vel*sin(angle)], masses[i], radius, 0)
        push!(discs, disc)
    end
    return discs
end






