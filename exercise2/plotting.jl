
function omega(j, dz, ka)
    return 2*dz + 2*j*(1-cos(ka))
end

function plot_omega()
    j = 10
    dz = 3
    xs = LinRange(0,π,100)
    ys1 = omega.(j, dz, xs)
    Plots.plot(xs,ys1)
    j = 20
    dz = 3
    ys2 = omega.(j,dz,xs)
    Plots.plot!(xs,ys2)
    j = 10
    dz = 6
    ys3 = omega.(j,dz,xs)
    Plots.plot!(xs,ys3)
    Plots.savefig("exercise2/plots/w(ka).png")
end
    
   







