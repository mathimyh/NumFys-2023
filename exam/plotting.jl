function plot2D(grid::Array{GridPoint, 2}, acids::Vector{Acid}, energy::Float64)
    x = []
    y = []
    gridsize = size(grid)
    for idx in CartesianIndices(grid)
        if typeof(grid[idx]) != EmptySpot
            push!(x, idx.I[1])
            push!(y, idx.I[2])
        end
    end
    Plots.scatter(x,y)
    temps = [acid.pos for acid in acids]
    xs = [temp[1] for temp in temps]
    ys = [temp[2] for temp in temps]
    Plots.plot!(xs,ys, aspect_ratio=1)
    # Plots.xlims!(0, gridsize[1])
    # Plots.ylims!(0, gridsize[2])
    annotation = "Energy = " * string(round.(energy/kbt, digits=3)) * " kb"
    Plots.annotate!(minimum(acid.pos[1] for acid in acids)+2, maximum(acid.pos[2] for acid in acids)-1, annotation)
end
