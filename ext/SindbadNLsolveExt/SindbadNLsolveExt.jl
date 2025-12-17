"""
    SindbadNLsolveExt

Julia extension module that enables NLsolve backends for `Sindbad.Simulation`.

# Notes:
- This module is loaded automatically by Julia's package extension mechanism when NLsolve is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadNLsolveExt` directly; instead `using Sindbad` is sufficient once the weak dependency is installed.
- The extension code is included in the `ext/` directory and is automatically loaded when the extension package is installed.

Modify the code in the "SimulationSpinup.jl" file to extend the package.
"""
module SindbadNLsolveExt

    using NLsolve
    
    include("SimulationSpinup.jl")

end

