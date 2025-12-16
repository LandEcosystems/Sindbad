"""
    SindbadFiniteDifferencesExt

Julia extension module that enables FiniteDifferences backends for `Sindbad.MachineLearning`.

# Notes:
- This module is loaded automatically by Julia's package extension mechanism when FiniteDifferences is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadFiniteDifferencesExt` directly; instead `using Sindbad` is sufficient once the weak dependency is installed.
- The extension code is included in the `ext/` directory and is automatically loaded when the extension package is installed.

Modify the code in the "MachineLearningGradientSite.jl" file to extend the package.
"""
module SindbadFiniteDifferencesExt

    using FiniteDifferences
    
    include("MachineLearningGradientSite.jl")

end

