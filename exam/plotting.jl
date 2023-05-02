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
    annotation = "Energy = " * string(round.(energy/(kb*T), digits=3)) * " kb"
    Plots.annotate!(minimum(acid.pos[1] for acid in acids)+2, maximum(acid.pos[2] for acid in acids)-1, annotation)
end
