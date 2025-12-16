"""
    SindbadFiniteDiffExt

Julia extension module that enables FiniteDiff backends for `Sindbad.ParameterOptimization`.

# Notes:
- This module is loaded automatically by Julia's package extension mechanism when FiniteDiff is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadFiniteDiffExt` directly; instead `using Sindbad` is sufficient once the weak dependency is installed.
- The extension code is included in the `ext/` directory and is automatically loaded when the extension package is installed.

Modify the code in the "ParameterOptimizationCost.jl" file to extend the package.
"""
module SindbadFiniteDiffExt

    using FiniteDiff
    
    include("ParameterOptimizationCost.jl")

end

