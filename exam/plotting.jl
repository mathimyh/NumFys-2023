function plot2D(acids::Vector{Acid}, energy::Float64)
    x = []
    y = []
    for acid in acids
        push!(x, acid.pos[1])
        push!(y, acid.pos[2])
    end
    Plots.scatter(x,y)
    Plots.plot!(x,y, aspect_ratio=1)
    # Plots.xlims!(0, gridsize[1])
    # Plots.ylims!(0, gridsize[2])
    annotation = "Energy = " * string(round.(energy/(T), digits=3)) * " kb"
    # Plots.annotate!(minimum(acid.pos[1] for acid in acids)+2, maximum(acid.pos[2] for acid in acids)-1, annotation)
end

function plot2D(acids::Vector{Acid})
    x = []
    y = []
    for acid in acids
        push!(x, acid.pos[1])
        push!(y, acid.pos[2])
    end
    Plots.scatter(x,y)
    Plots.plot!(x,y, aspect_ratio=1)
end

function plot3D(acids::Vector{Acid})
    xs = []
    ys = []
    zs = []
    for acid in acids
        push!(xs, acid.pos[1])
        push!(ys, acid.pos[2])
        push!(zs, acid.pos[3])
    end
    
    # I found this code online for getting the aspect ratios to be equal:
    # https://discourse.julialang.org/t/plots-jl-aspect-ratio-1-0-for-3d-plot/58607/2
    # Seems that you have to do it the complicated way...
    
    x12, y12, z12 = extrema(xs), extrema(ys), extrema(zs)
    d = maximum([diff([x12...]),diff([y12...]),diff([z12...])])[1] / 2
    xm, ym, zm = mean(x12),  mean(y12),  mean(z12)
    
    p = Plots.plot(; xlabel="x",ylabel="y",zlabel="z", aspect_ratio=:equal, grid=:true)
    Plots.plot!(xlims=(xm-d,xm+d), ylims=(ym-d,ym+d), zlims=(zm-d,zm+d))
    Plots.plot!(;camera=(45,30))    #(azimuth,elevation) ???
    Plots.scatter!(xs,ys,zs, legend=false)
    Plots.plot!(xs,ys,zs, legend=false)
end


