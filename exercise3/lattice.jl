@enum GridPoint border inside outside none

function search(point, lattice)
#= 

Finds every inside point by starting at the middle and searching in every direction by recursion.

=#

    lattice[point[1], point[2]] = inside::GridPoint
    right = (point[1]+1, point[2])
    if lattice[right[1],right[2]] != border::GridPoint && lattice[right[1],right[2]] != inside::GridPoint && right[1] <= size(lattice,1)
        search(right, lattice)
    end
    left = (point[1]-1, point[2])
    if lattice[left[1],left[2]] != border::GridPoint && lattice[left[1],left[2]] != inside::GridPoint && left[1] > 0
        search(left, lattice)
    end
    up = (point[1], point[2]+1)
    if lattice[up[1],up[2]] != border::GridPoint && lattice[up[1],up[2]] != inside::GridPoint && up[2] <= size(lattice, 2)
        search(up, lattice)
    end
    down = (point[1], point[2]-1)
    if lattice[down[1],down[2]] != border::GridPoint && lattice[down[1],down[2]] != inside::GridPoint && up[2] > 0
        search(down, lattice)
    end
    return nothing
end
    

function make_lattice(l::Int64)
#= 

Constructs a lattice where every corner in the fractal for level l falls upon a point in the lattice.

=# 
    fractal = Koch(l)

    # Convert every point to ints for easier calculations later
    x = trunc.(Int64, 4^l .* [tuple[1] for tuple in fractal])
    y = trunc.(Int64, 4^l .* [tuple[2] for tuple in fractal])
    borders = (tuple.(x,y))

    min_x = minimum(x)
    max_x = maximum(x)
    min_y = minimum(y)
    max_y = maximum(y)

    x_size = trunc(Int64, max_x - min_x) + 1
    y_size = trunc(Int64, max_y - min_y) + 1

    # Initializing an empty lattice
    lattice = Matrix{GridPoint}(undef, x_size, y_size)

    # Set the border points
    for i in 1:x_size
        for j in 1:y_size
            b_eff = (i + min_x - 1, j + min_y - 1)
            if b_eff ∈ borders
                lattice[i,j] = border::GridPoint
            else 
                lattice[i,j] = none::GridPoint
            end 
        end
    end

    # Set the inside points
    point0 = (ceil(Int64, x_size/2), ceil(Int64, y_size/2))
    search(point0, lattice)

    # Set the outside points
    for i in 1:x_size
        for j in 1:y_size
            if lattice[i,j] == none::GridPoint
                lattice[i,j] = outside::GridPoint
            end
        end
    end

    return lattice, x_size, fractal
end