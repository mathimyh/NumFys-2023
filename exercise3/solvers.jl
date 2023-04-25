function remove_zeros(matty)
    #= 

    Removes every column and row that is zero in the matrix

    =#
    indices1 = count(!=(0), matty, dims=1).>0
    indices2 = count(!=(0), matty, dims=2).>0

    matty = matty[indices1[1,:], indices2[:,1]]

    return matty, indices1
end

function add_back_zeros(eigvec, indices, size)
    #=

    Adds back the zeros necessary to have complete eigenfunctions, at the correct indices.

    =# 

    res = zeros(size^2)
    res[indices[1,:]] = eigvec

    return res
end

function fivepoint_solver(l::Int64)
    #=

    A solver which uses the normal five-point stencil approximation. The sparse matrix is here 
    created by the use of 5 sparse arrars, each corresponding to one stencil. 

    Returns:
        eigvals : The 10 smallest eigenvalues
        eigvecs : The eigenvectors corresponding to the eigenvalues

    =#
    lattice, x_size = make_lattice(l)
    delta = 1 / 4^l

    # Define the 5 vectors that makes up the matrix
    a = zeros(x_size^2) # Middle diagonal  
    b = zeros(x_size^2-1) # Upper diagonal
    c = zeros(x_size^2-1)  # Lower diagonal
    d = zeros(x_size^2-x_size)  # Upmost diagonal
    e = zeros(x_size^2-x_size)  # Downmost diagonal

    a_indexer = 1
    b_indexer = 1
    c_indexer = 1
    d_indexer = 1
    e_indexer = 1

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
            b_indexer += 1  # This too; it is outside of range at j=i=x_size but wont be called
            d_indexer += 1  # Similar as for b, outside of range for i=x_size but never called 
            if a_indexer > 2 
                c_indexer += 1  # Always updates except the first time
            end; if a_indexer > x_size + 2
                e_indexer += 1  # Always updates except for i < x_size
            end
        end
    end

    equation = spdiagm(-x_size => sparse(e), -1 => sparse(c), 0 => sparse(a), 1 => sparse(b), x_size => sparse(e))

    equation, indices = remove_zeros(equation)
    eigvals, temps = eigs(equation, nev=10, which=:SM, tol=1e-1, maxiter=10000)
    
    eigvecs = []

    for i in 1:10
        push!(eigvecs, add_back_zeros(temps[:,i], indices, x_size))
    end

    return eigvals, eigvecs, x_size
end


function ninepoint_solver(l::Int64)
    lattice, x_size = make_lattice(l)
    delta = 1 / 4^l

    x = Int64[]
    y = Int64[]
    val = Float64[]

    bords = [(1,0),(0,1),(-1,0),(0,-1)]
    weights = [16, -1]

    indexer = 1

    for i in 1:x_size
        for j in 1:x_size
            if lattice[i,j] == inside::GridPoint # Only add when you are at an inside point
                for k in 1:2
                        for bord in bords # Now all 8 points around it
                            if lattice[i+k*bord[1],i+k*bord[2]] == inside::GridPoint
                                push!(x, indexer + bord[1] + x_size*bord[2])
                                push!(y, indexer)
                                push!(val, weights[k] / (12*delta^2))
                            end
                        end 
                    end
                push!(x, indexer)
                push!(y, indexer)
                push!(val, -30 / (12*delta^2)) 
            end; indexer += 1
        end
    end

    equation = sparse(x,y,val, x_size^2,x_size^2)

    equation, indices = remove_zeros(equation)
    eigvals, temps = eigs(equation, nev=10, which=:SM, tol=1e-2, maxiter=10000)
    
    eigvecs = []

    for i in 1:10
        push!(eigvecs, add_back_zeros(temps[:,i], indices, x_size))
    end

    return eigvals, eigvecs, x_size
end
