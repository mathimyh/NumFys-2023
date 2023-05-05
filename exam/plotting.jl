function plot2D(acids::Vector{Acid}, energy::Float64)
    colors = [color_dict[acid.type] for acid in acids]
    x = []
    y = []
    for acid in acids
        push!(x, acid.pos[1])
        push!(y, acid.pos[2])
    end
    tittel = "E = " * string(round.(energy, digits=3)) * " kb"
    p = Plots.plot(x,y, aspect_ratio=1, title = tittel, c=:black, legend = false)
    Plots.scatter!(p,x,y, color=colors, markersize=10)
    return p
end

function plot2D(acids::Vector{Acid})
    colors = [color_dict[acid.type] for acid in acids]
    x = []
    y = []
    for acid in acids
        push!(x, acid.pos[1])
        push!(y, acid.pos[2])
    end
    p = Plots.plot(x,y, aspect_ratio=1, legend = false, c=:black)
    Plots.scatter!(p, x,y, color=colors)
    return p
end


function plot3D(acids::Vector{Acid})
    colors = [color_dict[acid.type] for acid in acids]
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
    Plots.plot!(xs,ys,zs, legend=false)
    Plots.scatter!(xs,ys,zs, legend=false, color=colors)
    return p
end

function plot_interact_e(interact_e)
    Plots.heatmap(interact_e, aspect_ratio=:equal, showaxis= false, legend= :none, color= :viridis, grid = false)
    Plots.savefig("exam/plots/rithard/interaction_matrix.png")
end
