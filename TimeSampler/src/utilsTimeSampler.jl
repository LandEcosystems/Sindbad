"""
    getdim(a::TimeAggregatorViewInstance{<:Any, <:Any, D})

get the dimension to aggregate for TimeAggregatorViewInstance type
"""
getdim(a::TimeAggregatorViewInstance{<:Any,<:Any,D}) where {D} = D


"""
    Base.size(a::TimeAggregatorViewInstance, i)

extend the size function for TimeAggregatorViewInstance type
"""
function Base.size(a::TimeAggregatorViewInstance, i)
    if i === getdim(a)
        size(a.agg.indices, 1)
    else
        size(a.parent, i)
    end
end

Base.size(a::TimeAggregatorViewInstance) = ntuple(i -> size(a, i), ndims(a))

"""
    Base.getindex(a::TimeAggregatorViewInstance, I::Vararg{Int, N})

extend the getindex function for TimeAggregatorViewInstance type
"""
function Base.getindex(a::TimeAggregatorViewInstance, I::Vararg{Int,N}) where {N}
    idim = getdim(a)
    indices = I
    indices = Base.setindex(indices, a.agg.indices[I[idim]], idim)
    a.agg.aggr_func(view(a.parent, indices...))
end

"""
    Base.view(x::AbstractArray, v::TimeAggregator; dim = 1)

extend the view function for TimeAggregatorViewInstance type

# Arguments:
- `x`: input array to be viewed
- `v`: time aggregator struct with indices and function
- `dim`: the dimension along which the aggregation should be done
"""
function Base.view(x::AbstractArray, v::TimeAggregator; dim=1)
    subarray_t = Base.promote_op(getindex, typeof(x), eltype(v.indices))
    t = Base.promote_op(v.aggr_func, subarray_t)
    TimeAggregatorViewInstance{t,ndims(x),dim,typeof(x),typeof(v)}(x, v, Val{dim}())
end