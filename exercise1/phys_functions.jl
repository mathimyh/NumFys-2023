### HERE ALL PHYSICAL FUNCTIONS ARE DEFINED ###

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
