"""
    SindbadOptimizationExt

Julia extension module that enables Optimization.jl-based optimizer backends for `Sindbad.ParameterOptimization`.

# Notes
- This module is loaded automatically by Julia's package extension mechanism when `Optimization` is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using SindbadOptimizationExt` directly; instead `using Sindbad` / `using Sindbad.ParameterOptimization` is sufficient once the weak dependency is installed.
"""
module SindbadOptimizationExt

import Sindbad: OptimizationBFGS, OptimizationBBOxnes, OptimizationBBOadaptive, OptimizationFminboxGradientDescentFD, OptimizationFminboxGradientDescent, OptimizationGCMAESDef, OptimizationGCMAESFD, OptimizationMultistartOptimization, OptimizationNelderMead, OptimizationQuadDirect

import Sindbad

using Optimization

include("ParameterOptimizationOptimizer.jl")

end
