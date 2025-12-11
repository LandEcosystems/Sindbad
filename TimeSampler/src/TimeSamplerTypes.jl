
export TimeSamplers
abstract type TimeSamplers end
purpose(::Type{TimeSamplers}) = "Abstract type for implementing time subset, sampling, resampling, and aggregation types in SINDBAD"

# ------------------------- time aggregator ------------------------------------------------------------
export TimeSamplerMethod
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
export TimeSampler
export TimeSamplerViewInstance


# ------------------------- time aggregator --------------------------------
"""
    TimeSampler{I, sampler_func}

define a type for temporal sampling/aggregation of an array

# Fields:
- `indices::I`: indices to be collected for sampling/aggregation
- `sampler_func::sampler_func`: a function to use for sampling/aggregation, defaults to mean
"""
struct TimeSampler{I,sampler_func} <: TimeSamplers
    indices::I
    sampler_func::sampler_func
end
purpose(::Type{TimeSampler}) = "define a type for temporal sampling/aggregation of an array"

"""
    TimeSamplerViewInstance{T, N, D, P, AV <: TimeSampler}



# Fields:
- `parent::P`: the parent data
- `agg::AV`: a view of the parent data
- `dim::Val{D}`: a val instance of the type that stores the dimension to be aggregated on
"""
struct TimeSamplerViewInstance{T,N,D,P,AV<:TimeSampler} <: AbstractArray{T,N}
    parent::P
    agg::AV
    dim::Val{D}
end
purpose(::Type{TimeSamplerViewInstance}) = "view of a TimeSampler"


abstract type TimeSamplerMethod <: TimeSamplers end
purpose(::Type{TimeSamplerMethod}) = "Abstract type for time sampling/aggregation methods in SINDBAD"

struct TimeAllYears <: TimeSamplerMethod end
purpose(::Type{TimeAllYears}) = "aggregation/slicing to include all years"

struct TimeArray <: TimeSamplerMethod end
purpose(::Type{TimeArray}) = "use array-based time sampling/aggregation"

struct TimeHour <: TimeSamplerMethod end
purpose(::Type{TimeHour}) = "aggregation to hourly time steps"

struct TimeHourAnomaly <: TimeSamplerMethod end
purpose(::Type{TimeHourAnomaly}) = "aggregation to hourly anomalies"

struct TimeHourDayMean <: TimeSamplerMethod end
purpose(::Type{TimeHourDayMean}) = "aggregation to mean of hourly data over days"

struct TimeDay <: TimeSamplerMethod end
purpose(::Type{TimeDay}) = "aggregation to daily time steps"

struct TimeDayAnomaly <: TimeSamplerMethod end
purpose(::Type{TimeDayAnomaly}) = "aggregation to daily anomalies"

struct TimeDayIAV <: TimeSamplerMethod end
purpose(::Type{TimeDayIAV}) = "aggregation to daily IAV"

struct TimeDayMSC <: TimeSamplerMethod end
purpose(::Type{TimeDayMSC}) = "aggregation to daily MSC"

struct TimeDayMSCAnomaly <: TimeSamplerMethod end
purpose(::Type{TimeDayMSCAnomaly}) = "aggregation to daily MSC anomalies"

struct TimeDiff <: TimeSamplerMethod end
purpose(::Type{TimeDiff}) = "aggregation to time differences, e.g. monthly anomalies"

struct TimeFirstYear <: TimeSamplerMethod end
purpose(::Type{TimeFirstYear}) = "aggregation/slicing of the first year"

struct TimeIndexed <: TimeSamplerMethod end
purpose(::Type{TimeIndexed}) = "aggregation using time indices, e.g., TimeFirstYear"

struct TimeMean <: TimeSamplerMethod end
purpose(::Type{TimeMean}) = "aggregation to mean over all time steps"

struct TimeMonth <: TimeSamplerMethod end
purpose(::Type{TimeMonth}) = "aggregation to monthly time steps"

struct TimeMonthAnomaly <: TimeSamplerMethod end
purpose(::Type{TimeMonthAnomaly}) = "aggregation to monthly anomalies"

struct TimeMonthIAV <: TimeSamplerMethod end
purpose(::Type{TimeMonthIAV}) = "aggregation to monthly IAV"

struct TimeMonthMSC <: TimeSamplerMethod end
purpose(::Type{TimeMonthMSC}) = "aggregation to monthly MSC"

struct TimeMonthMSCAnomaly <: TimeSamplerMethod end
purpose(::Type{TimeMonthMSCAnomaly}) = "aggregation to monthly MSC anomalies"

struct TimeNoDiff <: TimeSamplerMethod end
purpose(::Type{TimeNoDiff}) = "aggregation without time differences"

struct TimeRandomYear <: TimeSamplerMethod end
purpose(::Type{TimeRandomYear}) = "aggregation/slicing of a random year"

struct TimeShuffleYears <: TimeSamplerMethod end
purpose(::Type{TimeShuffleYears}) = "aggregation/slicing/selection of shuffled years"

struct TimeSizedArray <: TimeSamplerMethod end
purpose(::Type{TimeSizedArray}) = "aggregation to a sized array"

struct TimeYear <: TimeSamplerMethod end
purpose(::Type{TimeYear}) = "aggregation to yearly time steps"

struct TimeYearAnomaly <: TimeSamplerMethod end
purpose(::Type{TimeYearAnomaly}) = "aggregation to yearly anomalies"

