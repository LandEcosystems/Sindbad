"""
    SindbadPreallocationToolsExt

Julia extension module that enables PreallocationTools backends for `Sindbad.MachineLearning`.

# Notes:
- This module is loaded automatically by Julia's package extension mechanism when PreallocationTools is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadPreallocationToolsExt` directly; instead `using Sindbad` is sufficient once the weak dependency is installed.
- The extension code is included in the `ext/` directory and is automatically loaded when the extension package is installed.

Modify the code in the "MachineLearningGetCacheFromOutput.jl" file to extend the package.
"""
module SindbadPreallocationToolsExt

    using PreallocationTools
    
    include("MachineLearningGetCacheFromOutput.jl")
    include("MachineLearningGetOutputFromCache.jl")

end

