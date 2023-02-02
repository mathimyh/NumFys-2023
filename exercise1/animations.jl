function circle(disc; n=30)
    θ = 0:360÷n:360
    Plots.Shape(disc.radius*sind.(θ) .+ disc.pos[1], disc.radius*cosd.(θ) .+ disc.pos[2])
end

function circle(x, y , radius; n=30)
    θ = 0:360÷n:360
    Plots.Shape(radius*sind.(θ) .+ x, radius*cosd.(θ) .+ y)
end

function plotting_easy(circles)
    plot(circles, legend=false, xlim=(0,1), ylim=(0,1), aspect=:equal,xticks=[],yticks=[], framestyle=:box)
    Plots.frame(anim)
end

function move_til_next(queue, discs, clock, anim)
    if length(queue) == 0
        return nothing
    end
    startpoints = [disc.pos for disc in discs]
    vels = [disc.vel for disc in discs]
    # println(([sqrt((vel[1])^2+(vel[2])^2) for vel in vels]))
    moving_time = peek(queue)[1].time_until
    #println(queue, "\n")
    moved = update(queue, discs, clock)
    x = []
    y = []
    radii = []
    if moved && (moving_time != 0)
        for i in 0:0.05:moving_time
            circles = []
            for j in 1:length(startpoints)
                push!(x, startpoints[j][1] + vels[j][1]*i)
                push!(y, startpoints[j][2] + vels[j][2]*i)
                push!(radii, discs[j].radius)
            end
            circles = circle.(x, y, radii)
            plotting_easy(circles)
        end
    end   
end

function show_still(n)
    for i in 1:n
        update(queue, discs, clock)
    end
    circles = circle.(discs)
    plot(circles, xlim=(0,1), ylim=(0,1), legend=false)
end

function animate_it(n, name)
    anim = Plots.Animation()
    #println("Energy at start: ", sum([1/2 * disc.mass * (disc.vel[1]^2+disc.vel[2]^2) for disc in discs]))
    for k in 1:n
        move_til_next(queue, discs, clock, anim)
    end
    #println("Energy at end: ", sum([1/2 * disc.mass * (disc.vel[1]^2+disc.vel[2]^2) for disc in discs]))
    gif(anim, name)
end