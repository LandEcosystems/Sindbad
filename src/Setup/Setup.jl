
"""
   Setup

The `Setup` module provides tools for setting up and configuring SINDBAD experiments and runs. It handles the creation of experiment configurations, model structures, parameters, and output setups, ensuring a streamlined workflow for SINDBAD simulations.

# Purpose:
This module is designed to produce the SINDBAD `info` object, which contains all the necessary configurations and metadata for running SINDBAD experiments. It facilitates reading configurations, building model structures, and preparing outputs.

# Dependencies:
## Related (SINDBAD ecosystem)
- `ErrorMetrics`: Metric type construction for cost options.
- `TimeSampler`: Temporal setup helpers.
- `UtilKit`: Shared utilities (e.g. `Table`).

## External (third-party)
- `CSV`, `JLD2`, `JSON`: Configuration and persistence tooling.
- `ConstructionBase`, `Dates`, `NaNStatistics`: Core utilities used during setup.
- `Infiltrator`: Optional interactive debugging (reexported for convenience).

## Internal (within `Sindbad`)
- `Sindbad.Types`
- `SindbadTEM`

# Included Files:
1. **`defaultOptions.jl`**:
   - Defines default configuration knobs for optimization, sensitivity, and machine-learning routines referenced during setup.

2. **`getConfiguration.jl`**:
   - Reads JSON/CSV configuration files and normalizes them into the internal settings representation.

3. **`setupSimulationInfo.jl`**:
   - Builds the simulation `info` NamedTuple that downstream modules consume.

4. **`setupTypes.jl`**:
   - Instantiates SINDBAD types after parsing settings (time, land, metrics, optimization, etc.).

5. **`setupPools.jl`**:
   - Initializes land pools and state variables based on model structure, helpers, and constants.

6. **`updateParameters.jl`**:
   - Applies metric feedback to parameter values (e.g., during optimization iterations).

7. **`setupParameters.jl`**:
   - Loads parameter metadata (bounds, timescales, priors) and prepares arrays used by optimization/ML.

8. **`setupModels.jl`**:
   - Validates and orders the selected processes, wiring approaches to the overall run sequence.

9. **`setupOutput.jl`**:
   - Configures diagnostic/output arrays, filenames, and write schedules.

10. **`setupParameterOptimization.jl`**:
    - Collects optimizer-specific settings (algorithm, stopping criteria, restarts, etc.).

11. **`setupHybridMachineLearning.jl`**:
    - Handles hybrid Machine Learning-specific configuration (fold definitions, feature sets, surrogate wiring).

12. **`setupInfo.jl`**:
    - Final assembly step that integrates all previous pieces into the `info` object exported to simulations.

# Notes:
- The package re-exports several key packages (`Infiltrator`, `CSV`, `JLD2`) for convenience, allowing users to access their functionality directly through `Setup`.
- Designed to be modular and extensible, enabling users to customize and expand the setup process for specific use cases.

"""
module Setup

   using SindbadTEM
   @reexport using UtilKit: Table
   using TimeSampler
   using ErrorMetrics
   using ..Types
   using ConstructionBase
   using Dates
   using NaNStatistics
   @reexport using CSV: CSV
   @reexport using Infiltrator
   using JSON: parsefile, json, print as json_print
   @reexport using JLD2: @save, load

   include("defaultOptions.jl")
   include("SetupUtils.jl")
   include("generateCode.jl")
   include("getConfiguration.jl")
   include("setupSimulationInfo.jl")
   include("setupTypes.jl")
   include("setupPools.jl")
   include("updateParameters.jl")
   include("setupParameters.jl")
   include("setupModels.jl")
   include("setupOutput.jl")
   include("setupParameterOptimization.jl")
   include("setupHybridMachineLearning.jl")
   include("setupInfo.jl")

end # module Setup
