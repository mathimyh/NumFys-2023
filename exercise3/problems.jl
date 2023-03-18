function problem4(l::Int64, excited::Int64)
    borders = Koch(l)
    lattice, x_size = make_lattice(l, borders)

    equation = zeros(x_size^2,x_size^2)
    indexer = 1
    for i in 1:x_size
        for j in 1:x_size
            if lattice[i,j] == inside::GridPoint
                equation[indexer, (i-1)*x_size+j] = -4
            end; if j > 1 && lattice[i,j-1] == inside::GridPoint
                equation[indexer, (i-1)*x_size+j-1] = 1
            end; if j < x_size && lattice[i,j+1] == inside::GridPoint
                equation[indexer, (i-1)*x_size+j+1] = 1
            end; if i > 1 && lattice[i-1,j] == inside::GridPoint
                equation[indexer, (i-2)*x_size+j] = 1
            end; if i < x_size && lattice[i+1,j] == inside::GridPoint
                equation[indexer, (i)*x_size+j] = 1
            end; indexer += 1
        end
    end

    
    #println(equation)
    eigvals, eigvecs = eigs(equation, nev=10, which=:SR, tol=1e-2)

    eigvec = eigvecs[:,excited]
    eigvec_grid = reshape(real(eigvec), (x_size, x_size))

    layout = Layout(
        title = "Fractal drum of l = $l in excited state $excited",
        autosize = false,
        width = 500,
        height = 500,
        margin = attr(l=65,r=50,b=65,t=90)
    )

    println("Im plotting")

    PlotlyJS.plot(PlotlyJS.surface(z=(eigvec_grid)), layout)

end

    