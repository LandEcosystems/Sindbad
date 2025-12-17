
export TimeSamplers
abstract type TimeSamplers end
purpose(::Type{TimeSamplers}) = "Abstract type for implementing time subset, sampling, resampling, and aggregation types in SINDBAD"

# ------------------------- time aggregator ------------------------------------------------------------
export TimeSampleMethod
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
export TimeSample
export TimeSampleViewInstance


# ------------------------- time aggregator --------------------------------
"""
    TimeSample{I, sampler_func}

define a type for temporal sampling/aggregation of an array

# Fields:
- `indices::I`: indices to be collected for sampling/aggregation
- `sampler_func::sampler_func`: a function to use for sampling/aggregation, defaults to mean
"""
struct TimeSample{I,sampler_func} <: TimeSamplers
    indices::I
    sampler_func::sampler_func
end
purpose(::Type{TimeSample}) = "define a type for temporal sampling/aggregation of an array"

"""
    TimeSampleViewInstance{T, N, D, P, AV <: TimeSample}



# Fields:
- `parent::P`: the parent data
- `agg::AV`: a view of the parent data
- `dim::Val{D}`: a val instance of the type that stores the dimension to be aggregated on
"""
struct TimeSampleViewInstance{T,N,D,P,AV<:TimeSample} <: AbstractArray{T,N}
    parent::P
    agg::AV
    dim::Val{D}
end
purpose(::Type{TimeSampleViewInstance}) = "view of a TimeSample"


abstract type TimeSampleMethod <: TimeSamplers end
purpose(::Type{TimeSampleMethod}) = "Abstract type for time sampling/aggregation methods in SINDBAD"

struct TimeAllYears <: TimeSampleMethod end
purpose(::Type{TimeAllYears}) = "aggregation/slicing to include all years"

struct TimeArray <: TimeSampleMethod end
purpose(::Type{TimeArray}) = "use array-based time sampling/aggregation"

struct TimeHour <: TimeSampleMethod end
purpose(::Type{TimeHour}) = "aggregation to hourly time steps"

struct TimeHourAnomaly <: TimeSampleMethod end
purpose(::Type{TimeHourAnomaly}) = "aggregation to hourly anomalies"

struct TimeHourDayMean <: TimeSampleMethod end
purpose(::Type{TimeHourDayMean}) = "aggregation to mean of hourly data over days"

struct TimeDay <: TimeSampleMethod end
purpose(::Type{TimeDay}) = "aggregation to daily time steps"

struct TimeDayAnomaly <: TimeSampleMethod end
purpose(::Type{TimeDayAnomaly}) = "aggregation to daily anomalies"

struct TimeDayIAV <: TimeSampleMethod end
purpose(::Type{TimeDayIAV}) = "aggregation to daily IAV"

struct TimeDayMSC <: TimeSampleMethod end
purpose(::Type{TimeDayMSC}) = "aggregation to daily MSC"

struct TimeDayMSCAnomaly <: TimeSampleMethod end
purpose(::Type{TimeDayMSCAnomaly}) = "aggregation to daily MSC anomalies"

struct TimeDiff <: TimeSampleMethod end
purpose(::Type{TimeDiff}) = "aggregation to time differences, e.g. monthly anomalies"

struct TimeFirstYear <: TimeSampleMethod end
purpose(::Type{TimeFirstYear}) = "aggregation/slicing of the first year"

struct TimeIndexed <: TimeSampleMethod end
purpose(::Type{TimeIndexed}) = "aggregation using time indices, e.g., TimeFirstYear"

struct TimeMean <: TimeSampleMethod end
purpose(::Type{TimeMean}) = "aggregation to mean over all time steps"

struct TimeMonth <: TimeSampleMethod end
purpose(::Type{TimeMonth}) = "aggregation to monthly time steps"

struct TimeMonthAnomaly <: TimeSampleMethod end
purpose(::Type{TimeMonthAnomaly}) = "aggregation to monthly anomalies"

struct TimeMonthIAV <: TimeSampleMethod end
purpose(::Type{TimeMonthIAV}) = "aggregation to monthly IAV"

struct TimeMonthMSC <: TimeSampleMethod end
purpose(::Type{TimeMonthMSC}) = "aggregation to monthly MSC"

struct TimeMonthMSCAnomaly <: TimeSampleMethod end
purpose(::Type{TimeMonthMSCAnomaly}) = "aggregation to monthly MSC anomalies"

struct TimeNoDiff <: TimeSampleMethod end
purpose(::Type{TimeNoDiff}) = "aggregation without time differences"

struct TimeRandomYear <: TimeSampleMethod end
purpose(::Type{TimeRandomYear}) = "aggregation/slicing of a random year"

struct TimeShuffleYears <: TimeSampleMethod end
purpose(::Type{TimeShuffleYears}) = "aggregation/slicing/selection of shuffled years"

struct TimeSizedArray <: TimeSampleMethod end
purpose(::Type{TimeSizedArray}) = "aggregation to a sized array"

struct TimeYear <: TimeSampleMethod end
purpose(::Type{TimeYear}) = "aggregation to yearly time steps"

struct TimeYearAnomaly <: TimeSampleMethod end
purpose(::Type{TimeYearAnomaly}) = "aggregation to yearly anomalies"

