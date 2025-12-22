"""
`SindbadTEM.TEMTypes`

Submodule that groups all core TEM type definitions and shared abstract types
used across the terrestrial ecosystem model (TEM) implementation, including
`SindbadTypes`, and `LandEcosystem`.

This module is the primary entry point for **type-level** building blocks of
SINDBAD TEM processes and models.
"""
module TEMTypes
    using ..SindbadTEM
    import ..SindbadTEM: purpose

    export SindbadTypes
    abstract type SindbadTypes end
    purpose(::Type{SindbadTypes}) = "Abstract type for all Julia types in SINDBAD models, frameworks and modules that are re-exported by Sindbad"

    # ------------------------- land ecosystem type ------------------------------------------------------------
    export LandEcosystem
    abstract type LandEcosystem <: SindbadTypes end

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


    """
        DoCatchModelErrors

    Dispatch type to **enable error catching** during model execution.
    """
    struct DoCatchModelErrors <: SindbadTypes end
    purpose(::Type{DoCatchModelErrors}) = "Enable error catching during model execution"

    """
        DoNotCatchModelErrors

    Dispatch type to **disable error catching** during model execution.
    """
    struct DoNotCatchModelErrors <: SindbadTypes end
    purpose(::Type{DoNotCatchModelErrors}) = "Disable error catching during model execution"

    """
        DoDebugModel

    Dispatch type to **enable debug mode** for model execution.

    Used by higher-level orchestration code (e.g. `computeTEM`) to select
    debug-oriented execution paths (extra printing, timing, etc.).
    """
    struct DoDebugModel <: SindbadTypes end
    purpose(::Type{DoDebugModel}) = "Enable model debugging mode"

    """
        DoNotDebugModel

    Dispatch type to **disable debug mode** for model execution.
    """
    struct DoNotDebugModel <: SindbadTypes end
    purpose(::Type{DoNotDebugModel}) = "Disable model debugging mode"

    """
        DoInlineUpdate

    Dispatch type to **enable inline updates** of model state (within a single time step).
    """
    struct DoInlineUpdate <: SindbadTypes end
    purpose(::Type{DoInlineUpdate}) = "Enable inline updates of model state"

    """
        DoNotInlineUpdate

    Dispatch type to **disable inline updates** of model state.
    """
    struct DoNotInlineUpdate <: SindbadTypes end
    purpose(::Type{DoNotInlineUpdate}) = "Disable inline updates of model state"

end  # module TEMTypes
