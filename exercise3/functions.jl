function generator(point0, point1)
    if point0[2] == point1[2]
        d = (point1[1] - point0[1]) / 4
        return [point0, (point0[1] + d, point0[2]), (point0[1]+d, point0[2]+d), (point0[1]+2*d, point0[2]+d), (point0[1]+2*d, point0[2]), (point0[1]+2*d, point0[2]-d), (point0[1]+3*d, point0[2]-d), (point0[1]+3*d, point0[2]), (point0[1]+4*d, point0[2])]
    else
        d = (point1[2] - point0[2]) / 4
        return [point0, (point0[1], point0[2]+d), (point0[1]-d, point0[2]+d), (point0[1]-d, point0[2]+2*d), (point0[1], point0[2]+2*d), (point0[1]+d, point0[2]+2*d), (point0[1]+d, point0[2]+3*d), (point0[1], point0[2]+3*d), (point0[1], point0[2]+4*d)]
    end
end
     
function Koch(l::Int64)
    points = [(0,1), (1,1), (1,0), (0,0)]
    for i in 1:l
        temp = []
        for j in 1:length(points)
            if (j == length(points))
                next = points[1]
            else 
                next = points[j+1]
            end
            new = generator(points[j], next)
            temp = vcat(temp, new)
        end
        points = temp
    end
    return points
end

# Finds and set all points inside to inside
function search(point, lattice)
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
    



# Returns a lattice where each point is either border, inside or outside
function make_lattice(l::Int64, fractal)
    
    delta = 1 / 4^l

    x = trunc.(Int64, 4^l .* [tuple[1] for tuple in fractal])
    y = trunc.(Int64, 4^l .* [tuple[2] for tuple in fractal])
    borders = (tuple.(x,y))


    # Finding the borders for the loops
    min_x = minimum(x)
    max_x = maximum(x)
    min_y = minimum(y)
    max_y = maximum(y)

    x_size = trunc(Int64, max_x - min_x) + 1
    y_size = trunc(Int64, max_y - min_y) + 1


    # Initializing an undefined lattice with correct size
    lattice = Matrix{GridPoint}(undef, x_size, y_size)
    # Iterating through each point, set it to correct type
    for i in 1:x_size
        for j in 1:y_size
            # println((i+min_x, j+min_y))
            b_eff = (i + min_x - 1, j + min_y - 1)
            if b_eff ∈ borders
                lattice[i,j] = border::GridPoint
            else 
                lattice[i,j] = none::GridPoint
            end 
        end
    end

    point0 = (ceil(Int64, x_size/2), ceil(Int64, y_size/2))
    search(point0, lattice)

    for i in 1:x_size
        for j in 1:y_size
            if lattice[i,j] == none::GridPoint
                lattice[i,j] = outside::GridPoint
            end
        end
    end

    return lattice, x_size
end

function draw_fractal(l::Int64)
    points = Koch(l)
    x = [tuple[1] for tuple in points]
    y = [tuple[2] for tuple in points]
    Plots.plot(x,y)
end

# delta_N(w, A) = 






