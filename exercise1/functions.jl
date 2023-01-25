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



# Initialize function that sets up the system described in problem 1. Returns an array of all discs.
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


# A function that initializes the collisions. Run this after creating all discs.
# This finds the first collision for each disc and initializes the priority queue. The keys in the queue
# are tuples with either two discs or one disc and a wall. Walls are always the second element. 
function initialize_collisions(discs)
    len = length(discs)
    queue = PriorityQueue{Tuple, Float32}
    for i in 1:len
        time = 10^5
        for j in 1:len
            i != j || continue
            temp = delta_t(discs[i].pos, discs[j].pos, discs[i].vel, discs[j].vel)
            if temp < time
                time = temp
                crash = discs[j]
            end
        end
        temp = hori_delta_t(discs[i].radius, discs[i].pos[2], discs[i].vel[2])
        if temp < time
            time = temp
            crash = HoriWall
        end
        temp = vert_delta_t(discs[i].radius, discs[i].pos[1], discs[i].vel[1])
        if temp < time
            time = temp
            crash = VertWall
        end
        if !(crash, discs[i] in queue.keys) # To avoid two instances of the same collision
            enqueue!(queue, (discs[i], crash) => time)
        end
    end
    return queue
end             

# This is the function inside the loop. This finds the next collision and updates every particle to the time
# when this happens, and updates the velocities of involved discs.
function update(queue)
    next = dequeue!(queue)
    for disc in 
    if (typeof(next[2]) == VertWall || typeof(next[2]) == HoriWall)
        

