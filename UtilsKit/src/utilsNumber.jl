export clampZeroOne
export cumSum!
export getFrac
export isInvalid
export maxZero, maxOne, minZero, minOne
export replaceInvalid

"""
    clampZeroOne(num)

returns max(min(num, 1), 0)
"""
function clampZeroOne(num)
    return clamp(num, zero(num), one(num))
end

"""
    cumSum!(i_n::AbstractVector, o_ut::AbstractVector)

fill out the output vector with the cumulative sum of elements from input vector
"""
function cumSum!(i_n::AbstractVector, o_ut::AbstractVector)
    for i ∈ eachindex(i_n)
        o_ut[i] = sum(i_n[1:i])
    end
    return o_ut
end



"""
    getFrac(num, den)

return either a ratio or numerator depending on whether denomitor is a zero
"""
function getFrac(num, den)
    if !iszero(den)
        rat = num / den
    else
        rat = num
    end
    return rat
end


"""
    isInvalid(_data::Number)

Checks if a number is invalid (e.g., `nothing`, `missing`, `NaN`, or `Inf`).

# Arguments:
- `_data`: The input number.

# Returns:
`true` if the number is invalid, otherwise `false`.
"""
function isInvalid(_data)
    return isnothing(_data) || ismissing(_data) || isnan(_data) || isinf(_data)
end



"""
    maxZero(num)

returns max(num, 0)
"""
function maxZero(num)
    return max(num, zero(num))
end


"""
    maxOne(num)

returns max(num, 1)
"""
function maxOne(num)
    return max(num, one(num))
end


"""
    minZero(num)

returns min(num, 0)
"""
function minZero(num)
    return min(num, zero(num))
end


"""
    minOne(num)

returns min(num, 1)
"""
function minOne(num)
    return min(num, one(num))
end


"""
    replaceInvalid(_data, _data_fill)

Replaces invalid numbers in the input with a specified fill value.

# Arguments:
- `_data`: The input number.
- `_data_fill`: The value to replace invalid numbers with.

# Returns:
The input number if valid, otherwise the fill value.
"""
function replaceInvalid(_data, _data_fill)
    _data = isInvalid(_data) ? _data_fill : _data
    return _data
end
