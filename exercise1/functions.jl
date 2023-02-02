## First define functions for wall collisions
vert_wall(disc) = [-ksi*disc.vel[1], ksi*disc.vel[2]]
hori_wall(disc) = [ksi*disc.vel[1], -ksi*disc.vel[2]]
function vert_delta_t(disc)
    if disc.vel[1] == 0
        return nothing
    elseif disc.vel[1] > 0
        return (1-disc.radius-disc.pos[1]) / disc.vel[1]
    else
        return (disc.radius-disc.pos[1]) / disc.vel[1]
    end
end
function hori_delta_t(disc)
    if disc.vel[2] == 0
        return nothing
    elseif disc.vel[2] > 0
        return (1-disc.radius-disc.pos[2]) / disc.vel[2]
    else
        return (disc.radius-disc.pos[2]) / disc.vel[2]
    end
end

## Then functions for two particle collisions
delta_x(disc_i, disc_j) = [disc_j.pos[1]-disc_i.pos[1], disc_j.pos[2]-disc_i.pos[2]]
delta_v(disc_i, disc_j) = [disc_j.vel[1]-disc_i.vel[1], disc_j.vel[2]-disc_i.vel[2]]
# R_squared((x_i,y_i), (x_j, y_) = (x_j-x_i)^2 + (y_j-y_i)^2
d(disc_i, disc_j) = (dot(delta_v(disc_i, disc_j), delta_x(disc_i,disc_j)))^2 - (dot(delta_v(disc_i, disc_j), delta_v(disc_i, disc_j))) * (dot(delta_x(disc_i,disc_j), delta_x(disc_i,disc_j))-(disc_i.radius+disc_j.radius)^2)
function delta_t(disc_i, disc_j)
    if dot(delta_v(disc_i, disc_j), delta_x(disc_i,disc_j)) >= 0
        return nothing
    elseif d(disc_i, disc_j) <= 0
        return nothing
    else
        dv_dx =  dot(delta_v(disc_i, disc_j), delta_x(disc_i,disc_j))
        dd = d(disc_i, disc_j)
        dv_dv =  dot(delta_v(disc_i, disc_j), delta_v(disc_i, disc_j))
        return - (dv_dx + sqrt(dd)) / dv_dv
    end
end


function big_factor_i(disc_i, disc_j)
    return (1+ksi) * (disc_j.mass/(disc_i.mass+disc_j.mass)) * (dot(delta_v(disc_i, disc_j), delta_x(disc_i, disc_j))/(disc_i.radius+disc_j.radius)^2)
end

function big_factor_j(disc_i, disc_j)
    return (1+ksi) * (disc_i.mass/(disc_i.mass+disc_j.mass)) * (dot(delta_v(disc_i, disc_j), delta_x(disc_i, disc_j))/((disc_i.radius+disc_j.radius)^2))
end

function vel_two_discs_i(disc_i, disc_j)
    vel = [disc_i.vel[1] + big_factor_i(disc_i, disc_j) * delta_x(disc_i, disc_j)[1], disc_i.vel[2] + big_factor_i(disc_i, disc_j) * delta_x(disc_i, disc_j)[2]]
    return vel
end

function vel_two_discs_j(disc_i, disc_j)
    vel = [disc_j.vel[1] - big_factor_j(disc_i, disc_j) * delta_x(disc_i, disc_j)[1], disc_j.vel[2] - big_factor_j(disc_i, disc_j) * delta_x(disc_i, disc_j)[2]]
    return vel 
end

# Changing the position of each disc function
function change_pos(disc, time_spent)
    disc.pos = disc.pos .+ (disc.vel .* time_spent)
end 

# The function that finds the collisions for discs, then updates the queue.
function update_collision(discs, queue, clock::Clock, j::Int64)
    # I check if discs collide with other discs. All possible collision are put into the queue!!!
    disc_len = length(discs)
    for i in 1:disc_len if i != j
        time = delta_t(discs[i], discs[j])
        if !isnothing(time) 
            enqueue!(queue, Collision(discs[j], discs[i], discs[j].c_count, discs[i].c_count, time + clock.time) => time + clock.time)
        end
    end;end
    
    # Now check for both walls. 
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

# Initializes all collision at the start of the simulation given the disc array.
function initialize_collisions(discs)
    clock = Clock(0)
    queue = PriorityQueue()
    len = length(discs)
    for j in 1:len
        update_collision(discs, queue, clock, j)
    end
    return queue, clock
end  

function update_collision2(disc::Disc, discs, queue, clock::Clock)
    # I check if discs collide with other discs. All possible collision are put into the queue!!!
    disc_len = length(discs)
    for i in 1:disc_len if discs[i] != disc
        time = delta_t(discs[i], disc)
        if !isnothing(time) 
            enqueue!(queue, Collision(disc, discs[i], disc.c_count, discs[i].c_count, time + clock.time) => time + clock.time)
        end
    end;end
    
    # Now check for both walls. 
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

# Initializes all collision at the start of the simulation given the disc array.
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

    last_time = clock.time
    clock.time = next.crash_time
    time_spent = clock.time - last_time
    
    change_pos.(discs, time_spent)
    
    # for disc in discs 
    #     disc.pos = (disc.pos[1] + disc.vel[1]*time_spent, disc.pos[2] + disc.vel[2]*time_spent) 
    # end
    # Updating velocities of involved discs
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
function uniform_distribution(n, radius, random_mass=false, vel = 1) 
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
            pos = [rand(1:(gridsize-1)) * 2*radius, rand(1:(gridsize-1)) *2* radius]
            pos in [disc.pos for disc in discs] || break
        end
        disc = Disc(pos, [vel*rand(0:0.001:2*pi), vel*rand(0:0.001:2*pi)], masses[i], radius, 0)
        push!(discs, disc)
    end
    return discs
end


function problem1(n::Int64)
    n = 5000
    radius = 1 / (2*n)

    discs::Vector{Disc} = uniform_distribution(n, radius)
    queue::PriorityQueue, clock::Clock = initialize_collisions(discs)

    vels = []
    for i in 1:(n*10)
        update(queue, discs, clock)
        if (i == 40000) || (i == 42500) || (i == 45000) || (i == 47500) || (i == 50000)
            for disc in discs
                push!(vels, sqrt(disc.vel[1]^2+disc.vel[2]^2))
            end
        end
    end

    # histogram(vels)
    # savefig("problem1.png")
end


