export createTimeSampler
export getTimeSamplerInstance


"""
    createTimeSampler(date_vector, t_step, sampler_func = mean, skip_sampling = false)

a function to create a temporal sampling/aggregation struct for a given time step 

# Arguments:
- `date_vector`: a vector of datetime objects that determine the index of the array to be aggregated
- `t_step`: a string/Symbol/Type defining the sampling/aggregation time target with different types as follows:
  - `::Union{String, Symbol}`: a string/Symbol defining the sampling/aggregation time target from the settings
- `sampler_func`: a function to use for sampling/aggregation, defaults to mean
- `skip_sampling`: a flag indicating if the sampling/aggregation target is the same as the input data and the sampling/aggregation can be skipped, defaults to false

# Returns:
- `::Vector{TimeSample}`: a vector of time-sampling/aggregation objects (`TimeSample`), or `nothing` entries when `skip_sampling=true`

"""
function createTimeSampler end


function createTimeSampler(date_vector, t_step::Union{String, Symbol}, sampler_func=mean, skip_sampling=false)
    return createTimeSampler(date_vector, getTimeSamplerInstance(t_step), sampler_func, skip_sampling)
end

function createTimeSampler(date_vector, ::TimeMean, sampler_func=mean, skip_sampling=false)
    stepvectime = getTimeArray([1:length(date_vector)], getTypeOfTimeIndexArray())
    mean_agg = TimeSample(stepvectime, sampler_func)
    return [mean_agg,]
end

function createTimeSampler(date_vector, ::TimeDay, sampler_func=mean, skip_sampling=false)
    stepvectime = getIndicesForTimeGroups(day.(date_vector))
    day_agg = TimeSample(stepvectime, sampler_func)
    if skip_sampling
        day_agg = nothing
    end
    return [day_agg,]
end

function createTimeSampler(date_vector, ::TimeDayAnomaly, sampler_func=mean, skip_sampling=false)
    day_agg = createTimeSampler(date_vector, TimeDay(), sampler_func, skip_sampling)
    mean_agg = createTimeSampler(date_vector, TimeMean(), sampler_func)
    return [day_agg[1], mean_agg[1]]
end

function createTimeSampler(date_vector, ::TimeDayIAV, sampler_func=mean, skip_sampling=false)
    days = dayofyear.(date_vector)
    day_aggr = createTimeSampler(date_vector, TimeDay(), sampler_func, skip_sampling)
    daysMsc = unique(days)
    daysMsc_inds = [findall(==(dd), days) for dd in daysMsc]
    daysIav_inds = [getTimeArray(daysMsc_inds[d], getTypeOfTimeIndexArray()) for d in days]
    dayIav_agg = TimeSample(daysIav_inds, sampler_func)
    return [day_aggr[1], dayIav_agg]
end

function createTimeSampler(date_vector, ::TimeDayMSC, sampler_func=mean, skip_sampling=false)
    days = dayofyear.(date_vector)
    daysMsc = unique(days)
    days_ind = [getTimeArray(findall(==(dd), days), getTypeOfTimeIndexArray()) for dd in daysMsc]
    dat_msc_agg = TimeSample(days_ind, sampler_func)
    return [dat_msc_agg,]
end

function createTimeSampler(date_vector, ::TimeDayMSCAnomaly, sampler_func=mean, skip_sampling=false)
    dat_msc_agg = createTimeSampler(date_vector, TimeDayMSC(), sampler_func, skip_sampling)
    mean_agg = createTimeSampler(date_vector, TimeMean(), sampler_func)
    return [dat_msc_agg[1], mean_agg[1]]
end


function createTimeSampler(date_vector, ::TimeHour, sampler_func=mean, skip_sampling=false)
    stepvectime = getIndicesForTimeGroups(hour.(date_vector))
    hour_agg = TimeSample(stepvectime, sampler_func)
    if skip_sampling
        hour_agg = nothing
    end
    return [hour_agg,]
end

function createTimeSampler(date_vector, ::TimeHourAnomaly, sampler_func=mean, skip_sampling=false)
    hour_agg = createTimeSampler(date_vector, TimeHour(), sampler_func, skip_sampling)
    mean_agg = createTimeSampler(date_vector, TimeMean(), sampler_func)
    return [hour_agg[1], mean_agg[1]]
end

function createTimeSampler(date_vector, ::TimeHourDayMean, sampler_func=mean, skip_sampling=false)
    hours = hour.(date_vector)
    hours_day = unique(hours)
    t_hour_msc_agg = TimeSample([getTimeArray(findall(==(hh), hours), getTypeOfTimeIndexArray()) for hh in hours_day], sampler_func)
    return [t_hour_msc_agg,]
end

function createTimeSampler(date_vector, ::TimeMonth, sampler_func=mean, skip_sampling=false)
    stepvectime = getIndicesForTimeGroups(month.(date_vector))
    month_agg = TimeSample(stepvectime, sampler_func)
    return [month_agg,]
end

function createTimeSampler(date_vector, ::TimeMonthAnomaly, sampler_func=mean, skip_sampling=false)
    month_agg = createTimeSampler(date_vector, TimeMonth(), sampler_func, skip_sampling)
    mean_agg = createTimeSampler(date_vector, TimeMean(), sampler_func)
    return [month_agg[1], mean_agg[1]]
end

function createTimeSampler(date_vector, ::TimeMonthIAV, sampler_func=mean, skip_sampling=false)
    months = month.(date_vector) # month for each time step, size = number of time steps
    month_aggr = createTimeSampler(date_vector, TimeMonth(), sampler_func, skip_sampling) #to get the month per month, size = number of months
    months_series = Int.(view(months, month_aggr[1])) # aggregate the months per time step
    monthsMsc = unique(months) # get unique months
    monthsMsc_inds = [findall(==(mm), months) for mm in monthsMsc] # all timesteps per unique month
    monthsIav_inds = [getTimeArray(monthsMsc_inds[mm], getTypeOfTimeIndexArray()) for mm in months_series] # repeat monthlymsc indices for each month in time range
    monthIav_agg = TimeSample(monthsIav_inds, sampler_func) # generate aggregator
    return [month_aggr[1], monthIav_agg]
end

function createTimeSampler(date_vector, ::TimeMonthMSC, sampler_func=mean, skip_sampling=false)
    months = month.(date_vector)
    monthsMsc = unique(months)
    t_month_msc_agg = TimeSample([getTimeArray(findall(==(mm), months), getTypeOfTimeIndexArray()) for mm in monthsMsc], sampler_func)
    return [t_month_msc_agg,]
end

function createTimeSampler(date_vector, ::TimeMonthMSCAnomaly, sampler_func=mean, skip_sampling=false)
    t_month_msc_agg = createTimeSampler(date_vector, TimeMonthMSC(), sampler_func, skip_sampling)
    mean_agg = createTimeSampler(date_vector, TimeMean(), sampler_func)
    return [t_month_msc_agg[1], mean_agg[1]]
end

function createTimeSampler(date_vector, ::TimeYear, sampler_func=mean, skip_sampling=false)
    stepvectime = getTimeArray(getIndicesForTimeGroups(year.(date_vector)), getTypeOfTimeIndexArray())
    year_agg = TimeSample(stepvectime, sampler_func)
    return [year_agg,]
end

function createTimeSampler(date_vector, ::TimeYearAnomaly, sampler_func=mean, skip_sampling=false)
    year_agg = createTimeSampler(date_vector, TimeYear(), sampler_func, skip_sampling)
    mean_agg = createTimeSampler(date_vector, TimeMean(), sampler_func)
    return [year_agg[1], mean_agg[1]]
end

function createTimeSampler(date_vector, ::TimeAllYears, sampler_func=mean, skip_sampling=false)
    stepvectime = getTimeArray([1:length(date_vector)], getTypeOfTimeIndexArray())
    all_agg = TimeSample(stepvectime, sampler_func)
    return [all_agg,]
end

function createTimeSampler(date_vector, ::TimeFirstYear, sampler_func=mean, skip_sampling=false)
    years = year.(date_vector)
    first_year = minimum(years)
    year_inds = getIndexForSelectedYear(years, first_year)
    year_agg = TimeSample(year_inds, sampler_func)
    return [year_agg,]
end

function createTimeSampler(date_vector, ::TimeRandomYear, sampler_func=mean, skip_sampling=false)
    years = year.(date_vector)
    random_year = rand(unique(years))
    year_inds = getIndexForSelectedYear(years, random_year)
    year_agg = TimeSample(year_inds, sampler_func)
    return [year_agg,]
end

function createTimeSampler(date_vector, ::TimeShuffleYears, sampler_func=mean, skip_sampling=false)
    years = year.(date_vector)
    unique_years = unique(years)
    shuffled_unique_years = sample(unique_years, length(unique_years), replace=false)
    year_inds = getIndexForSelectedYear.(Ref(years), shuffled_unique_years)
    year_agg = TimeSample(year_inds, sampler_func)
    return [year_agg,]
end


"""
    getTimeSamplerInstance(aggr)

Creates and returns a time aggregator instance based on the provided sampling/aggregation.

# Arguments
- `aggr::Symbol`: Symbol specifying the type of time sampling/aggregation to be performed
- `aggr::String`: String specifying the type of time sampling/aggregation to be performed

# Returns
An instance of the corresponding time aggregator type.

# Notes:
- A similar approach `getTypeInstanceForNamedOptions` is used in `Setup` for creating types of other named option
"""
function getTimeSamplerInstance end

function getTimeSamplerInstance(aggr::Symbol)
    return getTimeSamplerInstance(string(aggr))
end

function getTimeSamplerInstance(aggr::String)
    # uc_first = String(aggr)
    # uc_first = toUpperCaseFirst(aggr, "Time")
    return getfield(TimeSampler, Symbol(aggr))()
end


"""
    getTypeOfTimeIndexArray(_type=:array)

a helper functio to easily switch the array type for indices of the TimeSampler object
"""
function getTypeOfTimeIndexArray(_type=:array)
    time_type = TimeArray()
    if _type == :sized_array
        time_type = TimeSizedArray()
    end
    return time_type
end



"""
    getIndexForSelectedYear(years, sel_year)

a helper function to get the indices of the first year from the date vector
"""
function getIndexForSelectedYear(years, sel_year)
    return getTimeArray(findall(==(sel_year), years), getTypeOfTimeIndexArray())
end


"""
    getIndicesForTimeGroups(groups)

a helper function to get the indices of the date group of the time series
"""
function getIndicesForTimeGroups(groups)
    _, rl = rle(groups)
    cums = [0; cumsum(rl)]
    stepvectime = [cums[i]+1:cums[i+1] for i in 1:length(rl)]
    return stepvectime
end


"""
    getTimeArray(ar, ::TimeSizedArray || ::TimeArray)

a helper function to get the array of indices

# Arguments:
- `ar`: an array of time
- array type: a type defining the type of array to be returned
    - `::TimeSizedArray`: indices as static array
    - `::TimeArray`: indices as normal array
"""
function getTimeArray(ar, ::TimeSizedArray)
    return SizedArray{Tuple{size(ar)...},eltype(ar)}(ar)
end

function getTimeArray(ar, ::TimeArray)
    return ar
end
