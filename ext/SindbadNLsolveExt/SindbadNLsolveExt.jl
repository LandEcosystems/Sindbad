"""
    SindbadNLsolveExt

Julia extension module that enables NLsolve-based spinup solvers for `Sindbad.Simulation`.

# Notes
- This module is loaded automatically by Julia's package extension mechanism when `NLsolve` is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadNLsolveExt` directly; instead `using Sindbad` / `using Sindbad.Simulation` is sufficient once the weak dependency is installed.
"""
module SindbadNLsolveExt

using NLsolve

include("SimulationSpinup.jl")

end

