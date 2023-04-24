function draw_fractal(l::Int64)
    points = Koch(l)
    x = [tuple[1] for tuple in points]
    y = [tuple[2] for tuple in points]
    Plots.plot(x,y)
end

function contourplot_3D(l::Int, excited::Int, eigvecs, x_size)
    eigvec_grid = reshape(eigvecs[excited], (x_size, x_size))

    layout = Layout(
        title = "Fractal drum of l = $l in excited state $excited",
        autosize = false,
        width = 500,
        height = 500,
        margin = attr(l=65,r=50,b=65,t=90)
    )

    println("Im plotting")
    x = []
    for i in 1:10
        push!(x,i)
    end
    #println(eigvals)
    PlotlyJS.plot(PlotlyJS.surface(z=(eigvec_grid)), layout)
    #Plots.plot(x,eigvals)
end
