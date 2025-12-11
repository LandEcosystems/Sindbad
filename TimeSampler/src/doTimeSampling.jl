export doTemporalAggregation
export temporalAggregation

"""
    getTimeAggrArray(_dat::AbstractArray{T, 2})

a helper function to instantiate an array from the TimeAggregatorViewInstance for N-dimensional array
"""
function getTimeAggrArray(_dat::AbstractArray{<:Any,N}) where N
    inds = ntuple(_->Colon(),N)
    inds = map(size(_dat)) do _
        Colon()
    end
    _dat[inds...]
end


"""
    temporalAggregation(dat::AbstractArray, temporal_aggregator::TimeAggregator, dim = 1)

a temporal aggregation function to aggregate the data using a given aggregator when the input data is an array

# Arguments:
- `dat`: a data array/vector to aggregate with function for the following types:
  - `::AbstractArray`: an array
  - `::SubArray`: a view of an array
  - `::Nothing`: a dummy type to return the input and do no aggregation data
- `temporal_aggregator`: a time aggregator struct with indices and function to do aggregation
- `dim`: the dimension along which the aggregation should be done
"""
function temporalAggregation end

function temporalAggregation(dat::AbstractArray, temporal_aggregator::TimeAggregator, dim=1)
    dat = view(dat, temporal_aggregator, dim=dim)
    return getTimeAggrArray(dat)
end

function temporalAggregation(dat::SubArray, temporal_aggregator::TimeAggregator, dim=1)
    dat = view(dat, temporal_aggregator, dim=dim)
    return getTimeAggrArray(dat)
end

function temporalAggregation(dat, temporal_aggregator::Nothing, dim=1)
    return dat
end

"""
    doTemporalAggregation(dat, temporal_aggregators, aggregation_type)

a temporal aggregation function to aggregate the data using a vector of aggregators

# Arguments:
- `dat`: a data array/vector to aggregate
- `temporal_aggregators`: a vector of time aggregator structs with indices and function to do aggregation
- aggregation_type: a type defining the type of aggregation to be done as follows:
    - `::TimeNoDiff`: a type defining that the aggregator does not require removing/reducing values from original time series
    - `::TimeDiff`: a type defining that the aggregator requires removing/reducing values from original time series. First aggregator aggregates the main time series, second aggregator aggregates to the time series to be removed.
    - `::TimeIndexed`: a type defining that the aggregator requires indexing the original time series
"""
function doTemporalAggregation end

function doTemporalAggregation(dat, temporal_aggregators, ::TimeIndexed)
    return dat[first(temporal_aggregators).indices...]
end

function doTemporalAggregation(dat, temporal_aggregators, ::TimeNoDiff)
    return temporalAggregation(dat, first(temporal_aggregators))
end

function doTemporalAggregation(dat, temporal_aggregators, ::TimeDiff)
    dat_agg = temporalAggregation(dat, first(temporal_aggregators))
    dat_agg_to_remove = temporalAggregation(dat, last(temporal_aggregators))
    return dat_agg .- dat_agg_to_remove
end
