"""
    SindbadForwardDiffExt

Julia extension module that enables ForwardDiff backends for `Sindbad.MachineLearning`.

# Notes:
- This module is loaded automatically by Julia's package extension mechanism when ForwardDiff is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadForwardDiffExt` directly; instead `using Sindbad` is sufficient once the weak dependency is installed.
- The extension code is included in the `ext/` directory and is automatically loaded when the extension package is installed.

Modify the code in the "MachineLearningGradientSite.jl" file to extend the package.
"""
module SindbadForwardDiffExt

    using ForwardDiff
    
    include("MachineLearningGradientSite.jl")
    include("MachineLearningGetCacheFromOutput.jl")
    include("MachineLearningGetOutputFromCache.jl")

end

