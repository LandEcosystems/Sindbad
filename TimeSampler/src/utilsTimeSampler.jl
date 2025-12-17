"""
    getdim(a::TimeSampleViewInstance{<:Any, <:Any, D})

get the dimension to aggregate for TimeSampleViewInstance type
"""
getdim(a::TimeSampleViewInstance{<:Any,<:Any,D}) where {D} = D


"""
    Base.size(a::TimeSampleViewInstance, i)

extend the size function for TimeSampleViewInstance type
"""
function Base.size(a::TimeSampleViewInstance, i)
    if i === getdim(a)
        size(a.agg.indices, 1)
    else
        size(a.parent, i)
    end
end

Base.size(a::TimeSampleViewInstance) = ntuple(i -> size(a, i), ndims(a))

"""
    Base.getindex(a::TimeSampleViewInstance, I::Vararg{Int, N})

extend the getindex function for TimeSampleViewInstance type
"""
function Base.getindex(a::TimeSampleViewInstance, I::Vararg{Int,N}) where {N}
    idim = getdim(a)
    indices = I
    indices = Base.setindex(indices, a.agg.indices[I[idim]], idim)
    a.agg.sampler_func(view(a.parent, indices...))
end

"""
    Base.view(x::AbstractArray, v::TimeSample; dim = 1)

extend the view function for TimeSampleViewInstance type

# Arguments:
- `x`: input array to be viewed
- `v`: time aggregator struct with indices and function
- `dim`: the dimension along which the sampling/aggregation should be done
"""
function Base.view(x::AbstractArray, v::TimeSample; dim=1)
    subarray_t = Base.promote_op(getindex, typeof(x), eltype(v.indices))
    t = Base.promote_op(v.sampler_func, subarray_t)
    TimeSampleViewInstance{t,ndims(x),dim,typeof(x),typeof(v)}(x, v, Val{dim}())
end