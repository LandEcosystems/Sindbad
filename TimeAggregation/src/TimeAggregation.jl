module TimeAggregation
using UtilKit
using Dates
using StatsBase

include("TimeAggregationTypes.jl")
include("utilsTimeAggregation.jl")
include("createTimeAggregator.jl")
include("doTemporalAggregation.jl")
end # module TimeAggregation
