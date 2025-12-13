"""
    SindbadCMAEvolutionStrategyExt

Julia extension module that enables CMA-ES optimizer backends (via `CMAEvolutionStrategy.jl`) for `Sindbad.ParameterOptimization`.

# Notes
- This module is loaded automatically by Julia's package extension mechanism when `CMAEvolutionStrategy` is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadCMAEvolutionStrategyExt` directly; instead `using Sindbad` / `using Sindbad.ParameterOptimization` is sufficient once the weak dependency is installed.
"""
module SindbadCMAEvolutionStrategyExt

import Sindbad: CMAEvolutionStrategyCMAES

import Sindbad

using CMAEvolutionStrategy

include("ParameterOptimizationOptimizer.jl")

end