# TimeSampler.jl

[![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] [![][ci-img]][ci-url] [![][codecov-img]][codecov-url] [![Julia][julia-img]][julia-url] [![License: EUPL-1.2](https://img.shields.io/badge/License-EUPL--1.2-blue)](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12)

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://earthyscience.github.io/SINDBAD/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://earthyscience.github.io/SINDBAD/stable/

[ci-img]: https://github.com/EarthyScience/SINDBAD/workflows/CI/badge.svg
[ci-url]: https://github.com/EarthyScience/SINDBAD/actions?query=workflow%3ACI

[codecov-img]: https://codecov.io/gh/EarthyScience/SINDBAD/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/EarthyScience/SINDBAD

[julia-img]: https://img.shields.io/badge/julia-v1.6+-blue.svg
[julia-url]: https://julialang.org/

A Julia package for temporal sampling, aggregation, and resampling of time series data, designed for use in the SINDBAD framework.

## Features

- **Flexible Time Aggregation**: Aggregate data to hourly, daily, monthly, or yearly time steps
- **Anomaly Calculations**: Compute anomalies at various time scales
- **Climatological Statistics**: Calculate multi-year seasonal cycles (MSC) and inter-annual variability (IAV)
- **Efficient Views**: Uses array views to avoid unnecessary data copying
- **Multiple Sampling Methods**: Support for various temporal operations including year shuffling and random selection

## Installation

```julia
using Pkg
Pkg.add("TimeSampler")
```

## Quick Start

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

## Available Time Sampling Methods

### Basic Aggregation
- `TimeHour`: Aggregate to hourly time steps
- `TimeDay`: Aggregate to daily time steps
- `TimeMonth`: Aggregate to monthly time steps
- `TimeYear`: Aggregate to yearly time steps
- `TimeMean`: Aggregate to mean over all time steps

### Anomalies
- `TimeHourAnomaly`: Hourly anomalies
- `TimeDayAnomaly`: Daily anomalies
- `TimeMonthAnomaly`: Monthly anomalies
- `TimeYearAnomaly`: Yearly anomalies
- `TimeDayMSCAnomaly`: Daily MSC anomalies
- `TimeMonthMSCAnomaly`: Monthly MSC anomalies

### Climatological Statistics
- `TimeDayMSC`: Multi-year seasonal cycle for daily data
- `TimeMonthMSC`: Multi-year seasonal cycle for monthly data
- `TimeDayIAV`: Inter-annual variability for daily data
- `TimeMonthIAV`: Inter-annual variability for monthly data
- `TimeHourDayMean`: Mean of hourly data over days

### Time Selection
- `TimeAllYears`: Include all years
- `TimeFirstYear`: Select first year only
- `TimeRandomYear`: Select a random year
- `TimeShuffleYears`: Shuffle years

## Documentation

For detailed documentation, see the [SINDBAD documentation](https://earthyscience.github.io/SINDBAD/stable/).

## License

This package is licensed under the EUPL-1.2 (European Union Public Licence v. 1.2). See the [LICENSE](LICENSE) file for details.

## Contributing

This package is part of the SINDBAD project. For contribution guidelines, please refer to the main [SINDBAD repository](https://github.com/EarthyScience/SINDBAD).

## Authors

SINDBAD Contributors
