"""
    Experiment

The `Experiment` package provides tools for designing, running, and analyzing experiments in the SINDBAD MDI framework. It integrates SINDBAD packages and utilities to streamline the experimental workflow, from data preparation to model execution and output analysis.

# Purpose:
This package acts as a high-level interface for conducting experiments using the SINDBAD framework. It leverages the functionality of core SINDBAD packages and provides additional utilities for running experiments and managing outputs.

# Dependencies:
- `SindbadTEM`: Provides the core SINDBAD models and types.
- `Setup`: Manages setup configurations, parameter handling, and shared types for SINDBAD experiments.
- `DataLoaders`: Provides the SINDBAD data handling functions.
- `SindbadTEM.Utils`: Provides utility functions for handling NamedTuple, spatial operations, and other helper tasks for spatial and temporal operations.
- `Setup`: Provides the SINDBAD setup functions.
- `ParameterOptimization`: Provides optimization algorithms for parameter estimation and model calibration.

# Included Files:
1. **`runExperiment.jl`**:
   - Contains functions for executing experiments, including setting up models, running simulations, and managing workflows.

2. **`saveOutput.jl`**:
   - Provides utilities for saving experiment outputs in various formats, ensuring compatibility with downstream analysis tools.

# Notes:
- Designed to be extensible, enabling users to customize and expand the experimental workflow that combines different SINDBAD modules as needed.

# Examples:
1. **Running an experiment**:
```julia
using Experiment
# Set up experiment parameters
experiment_config = ...

# Run the experiment
runExperimentForward(experiment_config)
```
"""
module Experiment
    using UtilKit
    using ErrorMetrics
    using ...SindbadTEM
    using ..Types
    using ..Setup
    using ..DataLoaders
    using ..Simulation
    using ..ParameterOptimization
    using ..Visualization

    include("runExperiment.jl")
    include("saveOutput.jl")

end # module Experiment