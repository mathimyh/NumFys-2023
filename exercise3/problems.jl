function problem4(l::Int64, excited::Int64)
    # Setting up the system
    borders = Koch(l)
    lattice, x_size = make_lattice(l, borders)
    delta = 1 / 4^l

    # Define the 5 vectors that makes up the matrix
    a = zeros(x_size^2) # Middle diagonal  
    b = zeros(x_size^2-1) # Upper diagonal
    c = zeros(x_size^2-1)  # Lower diagonal
    d = zeros(x_size^2-x_size)  # Upmost diagonal
    e = zeros(x_size^2-x_size)  # Downmost diagonal

    # Since they have different length the indices need to be separately adjusted
    a_indexer = 1
    b_indexer = 1
    c_indexer = 1
    d_indexer = 1
    e_indexer = 1

    # Going through every point in the lattice and adding to the vectors
    for i in 1:x_size
        for j in 1:x_size
            if lattice[i,j] == inside::GridPoint # Only add when you are at an inside point
                a[a_indexer] =  4 / (delta^2)
                if j > 1 && lattice[i,j-1] == inside::GridPoint
                    c[c_indexer] = - 1 / (delta^2)
                end; if j < x_size && lattice[i,j+1] == inside::GridPoint
                    b[b_indexer] = - 1 / (delta^2)
                end; if i > 1 && lattice[i-1,j] == inside::GridPoint
                    d[d_indexer] = - 1 / (delta^2)
                end; if i < x_size && lattice[i+1,j] == inside::GridPoint
                    e[e_indexer] = - 1 / (delta^2)
                end;
            end;

            # Now we update the indexers
            a_indexer += 1  # This always updates
            b_indexer += 1  # This too; it is outside of range at j,i>=x_size but wont be called
            d_indexer += 1  # Similar as for b, outside of range for i>=x_size but never called 
            if a_indexer > 2 
                c_indexer += 1  # Always updates except the first time
            end; if a_indexer > x_size + 2
                e_indexer += 1  # Always updates except for when i < x_size
            end
        end
    end

    # spdiagm is a function from SparseArrays, returns a sparse matrix
    equation = spdiagm(-x_size => sparse(e), -1 => sparse(c), 0 => sparse(a), 1 => sparse(b), x_size => sparse(e))

    equation, indices = remove_zeros(equation, x_size)

    # solving for eigenvalues and eigenfunctions, reshaping into 2 dimensions
    eigvals, eigvecs = eigs(equation, nev=10, which=:SM, tol=1e-2, maxiter=10000)
    eigvec = add_back_zeros(eigvecs[:,excited+2], indices, x_size)
    eigvec_grid = reshape(eigvec, (x_size, x_size))

    # From here the rest is just plotting the data
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

function problem7(l::Int64, excited::Int64)
    # Setting up the system
    borders = Koch(l)
    lattice, x_size = make_lattice(l, borders)
    delta = 1 / 4^l

    # Using a different method for the sparse matrix here.
    # Every point that is not zero has an x and y coordinate, and a val
    x = Int64[]
    y = Int64[]
    val = Float64[]

    bords = [(1,0),(0,1),(-1,0),(0,-1)]

    # Here only one indexer is needed!
    indexer = 1

    # Similar process as problem4
    for i in 1:x_size
        for j in 1:x_size
            if lattice[i,j] == inside::GridPoint # Only add when you are at an inside point
                for k in 1:3
                        for bord in bords # Now all 8 points around it
                            if lattice[i+k*bord[1],i+k*bord[2]] == inside::GridPoint
                                push!(x, indexer + bord[1] + x_size*bord[2])
                                push!(y, indexer)
                                push!(val, -1 / (3*delta^2))
                            end
                        end
                        push!(x, indexer)
                        push!(y, indexer)
                        push!(val, 8 / (3*delta^2))  
                    end
            end; indexer += 1
        end
    end

    # using the sparse function from SparseArrays here
    equation = sparse(x,y,val, x_size^2,x_size^2)

    # Solving for eigenvalues and eigenfunctions
    eigvals, eigvecs = eigs((equation), nev=30, which=:SM, tol=1e-3, maxiter=10000)
    eigvec_grid = reshape((eigvecs[:,excited]), (x_size, x_size))



    # And now the rest is just plotting
    layout = Layout(
        title = "Fractal drum of l = $l in excited state $excited",
        autosize = false,
        width = 500,
        height = 500,
        margin = attr(l=65,r=50,b=65,t=90)
    )
    println("Im plotting")
    PlotlyJS.plot(PlotlyJS.surface(z=real(eigvec_grid)), layout)
end
