"""
    SindbadDifferentialEquationsExt

Julia extension module that enables DifferentialEquations backends for `Sindbad.Simulation`.

# Notes:
- This module is loaded automatically by Julia's package extension mechanism when DifferentialEquations is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadDifferentialEquationsExt` directly; instead `using Sindbad` is sufficient once the weak dependency is installed.
- The extension code is included in the `ext/` directory and is automatically loaded when the extension package is installed.

Modify the code in the "SimulationSpinup.jl" file to extend the package.
"""
module SindbadDifferentialEquationsExt

    using DifferentialEquations
    
    include("SimulationSpinup.jl")

end

