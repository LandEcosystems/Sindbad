"""
    ParameterOptimization

The `ParameterOptimization` module provides tools for optimizing SINDBAD models, including parameter estimation, model calibration, and cost function evaluation. It integrates various optimization algorithms and utilities to streamline the optimization workflow for SINDBAD experiments.

# Purpose:
This module is designed to support optimization tasks in SINDBAD, such as calibrating model parameters to match observations or minimizing cost functions. It leverages multiple optimization libraries and provides a unified interface for running optimization routines.

# Dependencies:
## Related (SINDBAD ecosystem)
- `ErrorMetrics`: Metric implementations for cost evaluation.
- `TimeSampler`: Temporal helpers used by some workflows.
- `UtilKit`: Shared helpers and table utilities.

## External (third-party)
- `StableRNGs`: Reproducible random number generation for stochastic workflows.

## Internal (within `Sindbad`)
- `Sindbad.Setup`
- `Sindbad.Simulation`
- `Sindbad.Types`
- `SindbadTEM`

## Optional dependencies (extensions / weakdeps)
Some optimizer backends are enabled via Julia extensions (see root `Project.toml` and `ext/`):
- `CMAEvolutionStrategy` → `SindbadCMAEvolutionStrategyExt`
- `Optimization` → `SindbadOptimizationExt`

Other packages listed under `[weakdeps]` may be used by experimental workflows but are not required for the base module to load.

# Included Files:
1. **`optimizer.jl`**:
   - Implements the core optimization logic, including merging algorithm options and selecting optimization methods.

2. **`cost.jl`**:
   - Defines cost functions for evaluating the loss of SINDBAD models against observations.

3. **`optimizeTEM.jl`**:
   - Provides functions for optimizing SINDBAD TEM parameters for single locations or small spatial grids.
   - Functionality to handle optimization using large-scale 3D data YAXArrays cubes, enabling parameter calibration across spatial dimensions.

4. **`sensitivityAnalysis.jl`**:
   - Provides functions for performing sensitivity analysis on SINDBAD models, including global sensitivity analysis and local sensitivity analysis.

!!! note
    - The package integrates multiple optimization libraries, allowing users to choose the most suitable algorithm for their problem.
    - Designed to be modular and extensible, enabling users to customize optimization workflows for specific use cases.
    - Supports both gradient-based and derivative-free optimization methods, ensuring flexibility for different types of cost functions.

# Examples:
1. **Running an experiment**:
```julia
using Sindbad.Simulation
# Set up experiment parameters
experiment_config = ...

# Run the experiment
runExperimentOpti(experiment_config)
```
2. **Running a CMA-ES optimization**:
```julia
using Sindbad.ParameterOptimization
optimized_params = optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, CMAEvolutionStrategyCMAES())
```
"""
module ParameterOptimization

   # using CMAEvolutionStrategy: minimize, xbest
   # using BayesOpt: ConfigParameters, set_kernel!, bayes_optimization, SC_MAP
   # using Evolutionary: Evolutionary
   # using ForwardDiff
   # using GlobalSensitivity
   # using MultistartOptimization: MultistartOptimization
   # using NLopt: NLopt
   # using Optim
   # using Optimization
   # using OptimizationOptimJL
   # # using OptimizationBBO
   # using OptimizationGCMAES
   # using OptimizationCMAEvolutionStrategy
   # # using OptimizationQuadDIRECT
   # using QuasiMonteCarlo
   using StableRNGs
   using UtilKit
   using ErrorMetrics
   using TimeSampler
   using SindbadTEM
   using ..Types
   # using ..Metrics
   using ..Setup
   using ..Simulation

   include("handleDataForCost.jl")
   include("getCost.jl")
   include("optimizer.jl")
   include("cost.jl")
   include("prepOpti.jl")
   include("optimizeTEM.jl")
   include("sensitivityAnalysis.jl")

end # module ParameterOptimization
