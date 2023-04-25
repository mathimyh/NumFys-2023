# Problem 1 takes in n number of discs and m number of collisions until end of simulation
function problem1(n::Int64, m::Int64)
    p = make_subplots(rows = 1, cols = 2)
    
    radius = 1 / (2*n)

    discs::Vector{Disc} = uniform_distribution(n, radius)
    queue::PriorityQueue, clock::Clock = initialize_collisions(discs)

    add_trace!(p, PlotlyJS.histogram(x=[sqrt(disc.vel[1]^2+disc.vel[2]^2) for disc in discs], nbinsx=n/2), row=1, col=1)

    vels = []
    for i in 1:m
        update(queue, discs, clock)
        if (i == m - 1000) || (i == m - 750) || (i == m - 500 ) || (i == m - 250) || (i == m)
            for disc in discs
                push!(vels, sqrt(disc.vel[1]^2+disc.vel[2]^2))
            end
        end
    end

    add_trace!(p, PlotlyJS.histogram(x=vels), row=1, col=2)
    PlotlyJS.savefig(p, "problem1.png")
end

# Problem 2 also takes in n number of discs, and m number of collisions
function problem2(n::Int64, m::Int64)
    p = make_subplots(rows = 2, cols = 2)
    
    radius = 1 / (2*n)

    discs::Vector{Disc} = uniform_distribution(n, radius, true)
    queue::PriorityQueue, clock::Clock = initialize_collisions(discs)
    halfway::Int64 = n/2
    add_trace!(p, PlotlyJS.histogram(x=[sqrt(disc.vel[1]^2+disc.vel[2]^2) for disc in discs[1:halfway]], nbinsx=n/2), row=1, col=1)
    add_trace!(p, PlotlyJS.histogram(x=[sqrt(disc.vel[1]^2+disc.vel[2]^2) for disc in discs[halfway+1:end]], nbinsx=n/2), row=2, col=1)


    vels1 = []
    vels2 = []
    for i in 1:m
        update(queue, discs, clock)
        if (i == m - 1000) || (i == m - 750) || (i == m - 500 ) || (i == m - 250) || (i == m)
            for disc in discs[1:halfway]
                push!(vels1, sqrt(disc.vel[1]^2+disc.vel[2]^2))
            end
            for disc in discs[halfway+1:end]
                push!(vels2, sqrt(disc.vel[1]^2+disc.vel[2]^2))
            end
        end
    end

    add_trace!(p, PlotlyJS.histogram(x=vels1), row=1, col=2)
    add_trace!(p, PlotlyJS.histogram(x=vels2), row=2, col=2)

    PlotlyJS.savefig(p, "problem2.png")

end


function problem3(n::Int64, m::Int64)
    p = make_subplots(rows = 2, cols = 2)
    
    radius = 1 / (2*n)

    discs::Vector{Disc} = uniform_distribution(n, radius, true)
    queue::PriorityQueue, clock::Clock = initialize_collisions(discs)
    halfway::Int64 = n/2

    for i in 1:m
        update(queue, discs, clock)
        if i % 100 == 0
            