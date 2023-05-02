function plot2D(grid::Array{Acid, 2})
    plot_grid = similar(grid, Int)
    for idx in CartesianIndices(grid)
        if isassigned(grid, idx.I[1], idx.I[2])
            plot_grid[idx] = 1
        else
            plot_grid[idx] = 0
        end
    end
    Plots.scatter(plot_grid)
end
