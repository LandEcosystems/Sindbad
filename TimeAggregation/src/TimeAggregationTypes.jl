
export TimeAggregators
abstract type TimeAggregators end
purpose(::Type{TimeAggregators}) = "Abstract type for implementing time subset and aggregation types in SINDBAD"

# ------------------------- time aggregator ------------------------------------------------------------
export TimeAggregatorMethod
export TimeAllYears
export TimeArray
export TimeHour
export TimeHourAnomaly
export TimeHourDayMean
export TimeDay
export TimeDayAnomaly
export TimeDayIAV
export TimeDayMSC
export TimeDayMSCAnomaly
export TimeDiff
export TimeFirstYear
export TimeIndexed
export TimeMean
export TimeMonth
export TimeMonthAnomaly
export TimeMonthIAV
export TimeMonthMSC
export TimeMonthMSCAnomaly
export TimeNoDiff
export TimeRandomYear
export TimeShuffleYears
export TimeSizedArray
export TimeYear
export TimeYearAnomaly
export TimeAggregator
export TimeAggregatorViewInstance


# ------------------------- time aggregator --------------------------------
"""
    TimeAggregator{I, aggr_func}

define a type for temporal aggregation of an array

# Fields:
- `indices::I`: indices to be collected for aggregation
- `aggr_func::aggr_func`: a function to use for aggregation, defaults to mean
"""
struct TimeAggregator{I,aggr_func} <: TimeAggregators
    indices::I
    aggr_func::aggr_func
end
purpose(::Type{TimeAggregator}) = "define a type for temporal aggregation of an array"

"""
    TimeAggregatorViewInstance{T, N, D, P, AV <: TimeAggregator}



# Fields:
- `parent::P`: the parent data
- `agg::AV`: a view of the parent data
- `dim::Val{D}`: a val instance of the type that stores the dimension to be aggregated on
"""
struct TimeAggregatorViewInstance{T,N,D,P,AV<:TimeAggregator} <: AbstractArray{T,N}
    parent::P
    agg::AV
    dim::Val{D}
end
purpose(::Type{TimeAggregatorViewInstance}) = "view of a TimeAggregator"


abstract type TimeAggregatorMethod <: TimeAggregators end
purpose(::Type{TimeAggregatorMethod}) = "Abstract type for time aggregation methods in SINDBAD"

struct TimeAllYears <: TimeAggregatorMethod end
purpose(::Type{TimeAllYears}) = "aggregation/slicing to include all years"

struct TimeArray <: TimeAggregatorMethod end
purpose(::Type{TimeArray}) = "use array-based time aggregation"

struct TimeHour <: TimeAggregatorMethod end
purpose(::Type{TimeHour}) = "aggregation to hourly time steps"

struct TimeHourAnomaly <: TimeAggregatorMethod end
purpose(::Type{TimeHourAnomaly}) = "aggregation to hourly anomalies"

struct TimeHourDayMean <: TimeAggregatorMethod end
purpose(::Type{TimeHourDayMean}) = "aggregation to mean of hourly data over days"

struct TimeDay <: TimeAggregatorMethod end
purpose(::Type{TimeDay}) = "aggregation to daily time steps"

struct TimeDayAnomaly <: TimeAggregatorMethod end
purpose(::Type{TimeDayAnomaly}) = "aggregation to daily anomalies"

struct TimeDayIAV <: TimeAggregatorMethod end
purpose(::Type{TimeDayIAV}) = "aggregation to daily IAV"

struct TimeDayMSC <: TimeAggregatorMethod end
purpose(::Type{TimeDayMSC}) = "aggregation to daily MSC"

struct TimeDayMSCAnomaly <: TimeAggregatorMethod end
purpose(::Type{TimeDayMSCAnomaly}) = "aggregation to daily MSC anomalies"

struct TimeDiff <: TimeAggregatorMethod end
purpose(::Type{TimeDiff}) = "aggregation to time differences, e.g. monthly anomalies"

struct TimeFirstYear <: TimeAggregatorMethod end
purpose(::Type{TimeFirstYear}) = "aggregation/slicing of the first year"

struct TimeIndexed <: TimeAggregatorMethod end
purpose(::Type{TimeIndexed}) = "aggregation using time indices, e.g., TimeFirstYear"

struct TimeMean <: TimeAggregatorMethod end
purpose(::Type{TimeMean}) = "aggregation to mean over all time steps"

struct TimeMonth <: TimeAggregatorMethod end
purpose(::Type{TimeMonth}) = "aggregation to monthly time steps"

struct TimeMonthAnomaly <: TimeAggregatorMethod end
purpose(::Type{TimeMonthAnomaly}) = "aggregation to monthly anomalies"

struct TimeMonthIAV <: TimeAggregatorMethod end
purpose(::Type{TimeMonthIAV}) = "aggregation to monthly IAV"

struct TimeMonthMSC <: TimeAggregatorMethod end
purpose(::Type{TimeMonthMSC}) = "aggregation to monthly MSC"

struct TimeMonthMSCAnomaly <: TimeAggregatorMethod end
purpose(::Type{TimeMonthMSCAnomaly}) = "aggregation to monthly MSC anomalies"

struct TimeNoDiff <: TimeAggregatorMethod end
purpose(::Type{TimeNoDiff}) = "aggregation without time differences"

struct TimeRandomYear <: TimeAggregatorMethod end
purpose(::Type{TimeRandomYear}) = "aggregation/slicing of a random year"

struct TimeShuffleYears <: TimeAggregatorMethod end
purpose(::Type{TimeShuffleYears}) = "aggregation/slicing/selection of shuffled years"

struct TimeSizedArray <: TimeAggregatorMethod end
purpose(::Type{TimeSizedArray}) = "aggregation to a sized array"

struct TimeYear <: TimeAggregatorMethod end
purpose(::Type{TimeYear}) = "aggregation to yearly time steps"

struct TimeYearAnomaly <: TimeAggregatorMethod end
purpose(::Type{TimeYearAnomaly}) = "aggregation to yearly anomalies"

