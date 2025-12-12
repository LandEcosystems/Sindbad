export metric

@doc """

    metric(m::ErrorMetric, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    metric(m::ErrorMetric, ŷ::AbstractArray, y::AbstractArray)
    metric(m::ErrorMetric, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    metric(m::ErrorMetric, ŷ::AbstractArray, y::AbstractArray)

calculate the performance/loss metric for given observation and model simulation data stream

# Arguments:
  - `y`: observation data
  - `yσ`: observational uncertainty data (optional; when omitted it behaves like `ones(size(y))` without allocating)
  - `ŷ`: model simulation data
    
# Returns:
- `metric`: The calculated metric value

"""
function metric end

"""
Non-allocating "ones array" with the same axes/shape as a reference array.
"""
struct _OnesLike{T,A,N} <: AbstractArray{T,N}
    a::A
end

Base.size(o::_OnesLike) = size(o.a)
Base.axes(o::_OnesLike) = axes(o.a)
Base.IndexStyle(::Type{<:_OnesLike{T,A,N}}) where {T,A,N} = Base.IndexStyle(A)
@inline Base.getindex(o::_OnesLike{T}, I...) where {T} = one(T)

@inline function _oneslike(a::AbstractArray, ::Type{T}) where {T}
    return _OnesLike{T,typeof(a),ndims(a)}(a)
end

# --- API bridges + optional yσ (4th argument) ---
# Canonical dispatch in this file is `metric(m, ŷ, y, yσ)`.
@inline metric(y::AbstractArray, yσ::AbstractArray, ŷ::AbstractArray, m::ErrorMetric) = metric(m, ŷ, y, yσ)

# If yσ is omitted, treat it as ones-like (no allocation).
@inline function metric(m::ErrorMetric, ŷ::AbstractArray, y::AbstractArray)
    T = promote_type(eltype(y), eltype(ŷ))
    return metric(m, ŷ, y, _oneslike(y, T))
end

function metric(::MSE, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    return mean(abs2.(y .- ŷ))
end

function metric(::NAME1R, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    μ_y = mean(y)
    μ_ŷ = mean(ŷ)
    NMAE1R = abs(μ_ŷ - μ_y) / (one(eltype(ŷ)) + μ_y)
    return NMAE1R
end

function metric(::NMAE1R, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    μ_y = mean(y)
    NMAE1R = mean(abs.(ŷ - y)) / (one(eltype(ŷ)) + μ_y)
    return NMAE1R
end

function metric(::NNSE, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    NSE_v = metric(y, yσ, ŷ, NSE())
    NNSE = one(eltype(ŷ)) / (one(eltype(ŷ)) + one(eltype(ŷ)) - NSE_v)
    return NNSE
end

function metric(::NNSEInv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    NNSEInv = one(eltype(ŷ)) - metric(y, yσ, ŷ, NNSE())
    return NNSEInv
end

function metric(::NNSEσ, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    NSE_v = metric(y, yσ, ŷ, NSEσ())
    NNSE = one(eltype(ŷ)) / (one(eltype(ŷ)) + one(eltype(ŷ)) - NSE_v)
    return NNSE
end

function metric(::NNSEσInv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    NNSEInv = one(eltype(ŷ)) - metric(y, yσ, ŷ, NNSEσ())
    return NNSEInv
end

function metric(::NPcor, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    r = cor(y, ŷ)
    one_r = one(r)
    n_r = one_r / (one_r + one_r -r)
    return n_r
end

function metric(::NPcorInv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    n_r = metric(y, yσ, ŷ, NPcor())
    return one(n_r) - n_r
end

function metric(::NScor, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    ρ = corspearman(y, ŷ)
    one_ρ = one(ρ)
    n_ρ = one_ρ / (one_ρ + one_ρ -ρ)
    return n_ρ
end

function metric(::NScorInv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    n_ρ = metric(y, yσ, ŷ, NScor())
    return one(n_ρ) - n_ρ
end

function metric(::NSE, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    NSE = one(eltype(ŷ)) .- sum(abs2.((y .- ŷ))) / sum(abs2.((y .- mean(y))))
    return NSE
end

function metric(::NSEInv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    NSEInv = one(eltype(ŷ)) - metric(y, yσ, ŷ, NSE())
    return NSEInv
end

function metric(::NSEσ, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    NSE =
        one(eltype(ŷ)) .-
        sum(abs2.((y .- ŷ) ./ yσ)) /
        sum(abs2.((y .- mean(y)) ./ yσ))
    return NSE
end

function metric(::NSEσInv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    NSEInv = one(eltype(ŷ)) - metric(y, yσ, ŷ, NSEσ())
    return NSEInv
end

function metric(::Pcor, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    return cor(y[:], ŷ[:])
end

function metric(::PcorInv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    rInv = one(eltype(ŷ)) - metric(y, yσ, ŷ, Pcor())
    return rInv
end

function metric(::Pcor2, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    r = metric(y, yσ, ŷ, Pcor())
    return r * r
end

function metric(::Pcor2Inv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    r2Inv = one(eltype(ŷ)) - metric(y, yσ, ŷ, Pcor2())
    return r2Inv
end

function metric(::Scor, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    return corspearman(y[:], ŷ[:])
end

function metric(::ScorInv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    ρInv = one(eltype(ŷ)) - metric(y, yσ, ŷ, Scor())
    return ρInv
end
function metric(::Scor2, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    ρ = metric(y, yσ, ŷ, Scor())
    return ρ * ρ
end
function metric(::Scor2Inv, ŷ::AbstractArray, y::AbstractArray, yσ::AbstractArray)
    ρ2Inv = one(eltype(ŷ)) - metric(y, yσ, ŷ, Scor2())
    return ρ2Inv
end
