export SindbadTypes
abstract type SindbadTypes end
purpose(::Type{SindbadTypes}) = "Abstract type for all Julia types in SINDBAD models, frameworks and modules that are re-exported by Sindbad"

export TEMTypes
abstract type TEMTypes <: SindbadTypes end
purpose(::Type{TEMTypes}) = "Abstract type for all Julia types in SindbadTEM"

# ------------------------- land ecosystem type ------------------------------------------------------------
export LandEcosystem
abstract type LandEcosystem <: TEMTypes end

purpose(T::Type{LandEcosystem}) = nameof(T) == :LandEcosystem ? "Abstract type for all SINDBAD land ecosystem models/approaches" : "Purpose of a SINDBAD land ecosystem model/approach. Add `purpose(::Type{$(nameof(T))}) = \"the_purpose\"` in `$(nameof(T)).jl` file to define the specific purpose of the model/approach"

function purpose(T::Type{<:LandEcosystem}) 
    foreach(subtypes(T)) do subtype
        subsubtype = subtypes(subtype)
        if isempty(subsubtype)
            purpose(subtype)    
        else
            purpose.(subsubtype)
        end
    end
end

purpose(T::LandEcosystem) = purpose(typeof(T))

# ------------------------- model error handling type ------------------------------------------------------------
export DoCatchModelErrors
export DoNotCatchModelErrors
export DoDebugModel
export DoNotDebugModel
export DoInlineUpdate
export DoNotInlineUpdate


struct DoCatchModelErrors <: TEMTypes end
purpose(::Type{DoCatchModelErrors}) = "Enable error catching during model execution"

struct DoNotCatchModelErrors <: TEMTypes end
purpose(::Type{DoNotCatchModelErrors}) = "Disable error catching during model execution"

struct DoDebugModel <: TEMTypes end
purpose(::Type{DoDebugModel}) = "Enable model debugging mode"

struct DoNotDebugModel <: TEMTypes end
purpose(::Type{DoNotDebugModel}) = "Disable model debugging mode"

struct DoInlineUpdate <: TEMTypes end
purpose(::Type{DoInlineUpdate}) = "Enable inline updates of model state"

struct DoNotInlineUpdate <: TEMTypes end
purpose(::Type{DoNotInlineUpdate}) = "Disable inline updates of model state"
