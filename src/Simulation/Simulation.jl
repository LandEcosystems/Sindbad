"""
    Simulation

The `Simulation` module provides the core functionality for running the SINDBAD Terrestrial Ecosystem Model (TEM). It includes utilities for preparing model-ready objects, managing spinup processes and running models.

# Purpose:
This module integrates various components and utilities required to execute the SINDBAD TEM, including precomputations, spinup, and time loop simulations. It supports parallel execution and efficient handling of large datasets.

# Dependencies:
## Related (SINDBAD ecosystem)
- `TimeSampler`: Temporal helpers used in time-loop workflows.
- `UtilKit`: Shared utilities used during simulation and output handling.

## External (third-party)
- `ComponentArrays`: Hierarchical state/parameter containers.
- `ProgressMeter`: Progress bars for long-running simulations.
- `ThreadPools`: Threaded parallelism helpers.

## Internal (within `Sindbad`)
- `Sindbad.DataLoaders`
- `Sindbad.Setup`
- `Sindbad.Types`
- `SindbadTEM`

# Included Files:
1. **`utilsSimulation.jl`**:
   - Core helpers for extracting forcing slices, managing outputs, logging progress, and orchestrating helper NamedTuples.

2. **`deriveSpinupForcing.jl`**:
   - Provides functionality for deriving spinup forcing data, which is used to force the model during initialization to a steady state.

3. **`prepTEMOut.jl`**:
   - Handles the preparation of output structures, ensuring that results are stored efficiently during simulations.

4. **`runModels.jl`**:
   - Contains functions for executing individual models within the SINDBAD framework.

5. **`prepTEM.jl`**:
   - Prepares the necessary inputs and configurations for running the TEM, including spatial and temporal data preparation.

6. **`prepOpti.jl`**:
   - Prepares the necessary inputs and configurations for running optimization routines.

7. **`runTEMLoc.jl`**:
   - Implements the logic for running the TEM for a single location, including optional spinup and the main simulation loop.

8. **`runTEMSpace.jl`**:
   - Extends the functionality to handle spatial grids, enabling simulations across multiple locations with parallel execution.

9. **`runTEMCube.jl`**:
   - Adds support for running the TEM on 3D `YAXArrays` cubes, useful for large-scale simulations with spatial dimensions.

10. **`runExperiment.jl`**:
   - High-level orchestration that wires setup, simulation, and optional optimization/ML hooks into a repeatable workflow.

11. **`saveOutput.jl`**:
    - Serialization helpers for storing simulation outputs and diagnostics.

12. **`spinupTEM.jl`**:
   - Manages the spinup process, initializing the model to a steady state using various methods (e.g., ODE solvers, fixed-point solvers).

13. **`spinupSequence.jl`**:
    - Handles sequential spinup loops, allowing for iterative refinement of model states during the spinup process.

# Notes:
- The package is designed to be modular and extensible, allowing users to customize and extend its functionality for specific use cases.
- It integrates tightly with the SINDBAD framework, leveraging shared types and utilities from `Setup`.
- Some spinup solvers are enabled via an optional extension:
  - `NLsolve` → `SindbadNLsolveExt` (see `ext/SindbadNLsolveExt/`).
"""
module Simulation
   using ComponentArrays
   using ProgressMeter
   using SindbadTEM
   using TimeSampler
   using ..Types
   using UtilKit
   using ..Setup
   using ..DataLoaders: YAXArrays
   using ThreadPools

   include("SimulationUtils.jl")
   include("deriveSpinupForcing.jl")
   include("prepTEMOut.jl")
   include("prepTEM.jl")
   include("runTEMForLocation.jl")
   include("runTEMInSpace.jl")
   include("runTEMOnCube.jl")
   include("spinupTEM.jl")
   include("spinupSequence.jl")

end # module Simulation
