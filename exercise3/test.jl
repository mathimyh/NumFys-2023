using SparseArrays

arr = sparse([1,1,2,3,4], [1,3,2,3,4], [0,1,2,0,0])

bools = count(!=(0), arr, dims=1).>0
println(size(bools))


arr = arr[bools[1,:], bools[1,:]]
println(bools[1,:])
println(arr)