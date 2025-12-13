"""
	TimeSampler

A package for temporal sampling, aggregation, and resampling of time series data in SINDBAD.

# Overview

`TimeSampler` provides a flexible framework for performing temporal operations on arrays, including:
- Aggregation to different time scales (hourly, daily, monthly, yearly)
- Computation of anomalies and climatological means
- Inter-annual variability (IAV) and multi-year seasonal cycle (MSC) calculations
- Time-based indexing and subsetting
- Year shuffling and random year selection

# Main Types

- `TimeSample`: Core struct containing indices and a sampling function for temporal aggregation
- `TimeSampleViewInstance`: A view of an array with temporal sampling applied
- `TimeSampleMethod`: Abstract type for different time sampling methods

# Available Time Sampling Methods

The package supports various time sampling methods:

## Basic Aggregation
- `TimeHour`: Aggregate to hourly time steps
- `TimeDay`: Aggregate to daily time steps
- `TimeMonth`: Aggregate to monthly time steps
- `TimeYear`: Aggregate to yearly time steps
- `TimeMean`: Aggregate to mean over all time steps

## Anomalies
- `TimeHourAnomaly`: Hourly anomalies (hourly values minus overall mean)
- `TimeDayAnomaly`: Daily anomalies (daily values minus overall mean)
- `TimeMonthAnomaly`: Monthly anomalies (monthly values minus overall mean)
- `TimeYearAnomaly`: Yearly anomalies (yearly values minus overall mean)
- `TimeDayMSCAnomaly`: Daily MSC anomalies (daily values minus multi-year seasonal cycle)
- `TimeMonthMSCAnomaly`: Monthly MSC anomalies (monthly values minus multi-year seasonal cycle)

## Climatological Statistics
- `TimeDayMSC`: Multi-year seasonal cycle for daily data
- `TimeMonthMSC`: Multi-year seasonal cycle for monthly data
- `TimeDayIAV`: Inter-annual variability for daily data
- `TimeMonthIAV`: Inter-annual variability for monthly data
- `TimeHourDayMean`: Mean of hourly data over days

## Time Selection
- `TimeAllYears`: Include all years
- `TimeFirstYear`: Select first year only
- `TimeRandomYear`: Select a random year
- `TimeShuffleYears`: Shuffle years

## Special Methods
- `TimeArray`: Use array-based time sampling
- `TimeSizedArray`: Use sized array for indices
- `TimeIndexed`: Use time indices for selection
- `TimeDiff`: Compute time differences (e.g., anomalies)
- `TimeNoDiff`: No time differences required

# Main Functions

- `createTimeSampler`: Create one or more `TimeSample` aggregators from a date vector and time step specification
- `doTimeSampling`: Apply temporal sampling/aggregation to data using a vector of time samplers
- `timeSampling`: Apply a single time sampler to an array
- `getTimeSamplerInstance`: Get a time sampler method instance from a string or symbol

# Usage Example

```julia
using TimeSampler
using Dates

# Create a date vector
dates = collect(Date(2000, 1, 1):Day(1):Date(2000, 12, 31))

# Create a time sampler for daily aggregation
daily_sampler = createTimeSampler(dates, TimeDay())

# Apply to data (assuming data is a 2D array with time as first dimension)
# sampled_data = doTimeSampling(data, daily_sampler, TimeNoDiff())
```

# Notes

- The package is designed to work efficiently with views, avoiding unnecessary data copying
- Multiple samplers can be chained together for complex temporal operations
- The default aggregation function is `mean`, but custom functions can be provided
- Time dimension is configurable (defaults to dimension 1)

# See Also

- `TimeSample` for the core type
- `createTimeSampler` for creating samplers
- `doTimeSampling` for applying samplers to data
"""
module TimeSampler
using Dates
using StatsBase

include("TimeSamplerTypes.jl")
include("utilsTimeSampler.jl")
include("createTimeSampler.jl")
include("doTimeSampling.jl")
end # module TimeSampler
