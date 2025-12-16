"""
    SindbadEnzymeExt

Julia extension module that enables Enzyme backends for `Sindbad.MachineLearning`.

# Notes:
- This module is loaded automatically by Julia's package extension mechanism when Enzyme is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadEnzymeExt` directly; instead `using Sindbad` is sufficient once the weak dependency is installed.
- The extension code is included in the `ext/` directory and is automatically loaded when the extension package is installed.

Modify the code in the "MachineLearningGradientSite.jl" file to extend the package.
"""
module SindbadEnzymeExt

    using Enzyme
    
    include("MachineLearningGradientSite.jl")

end

