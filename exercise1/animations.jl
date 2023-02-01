function plotting_easy(circles)
    plot(circles, legend=false, xlim=(0,1), ylim=(0,1))
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