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
#=

Function that returns every corner point of a fractal given the level. 

=# 
    points = [(0,1), (1,1), (1,0), (0,0)]
    for i in 1:l
        temp = []
        for j in eachindex(points)
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

