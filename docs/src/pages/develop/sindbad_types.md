# SINDBAD Types: what comes from where

This page serves as an overview of the type definitions used across the SINDBAD ecosystem.

- **Sindbad (this repository)**: types defined under `src/Types/`
- **Related packages**: types that are not defined in `Sindbad/src/Types`, but are used/re-exported by SINDBAD (e.g. `SindbadTEM`, `TimeSamplers`, `ErrorMetrics`, `OmniTools`)

## Types defined in `Sindbad` (this repository)

## Types.jl
**Main module file that defines the core type system and includes type definitions for SINDBAD.**

This file establishes the `purpose` function, which provides descriptive information about types in the SINDBAD framework. It defines the base `SindbadTypes` abstract type from which all other SINDBAD types inherit. The file includes all other type definition files and provides documentation for the type system.

## SpinupTypes.jl
**Defines types for model spinup procedures and sequences.**

This file defines the `SpinupTypes` abstract type and its subtypes, which contains types for different spinup modes and methods:
- `SpinupMode`: Abstract type with numerous concrete implementations
- Scaling methods: `EtaScaleA0H`, `EtaScaleAH`, etc.
- Solver methods: `NlsolveFixedpointTrustregion`, `ODETsit5`, etc.
- Spinup sequence types: `SpinupSequence`, `SpinupSequenceWithAggregator`

These types control how models reach equilibrium states before simulation.

## LandTypes.jl
**Defines types for land model data structures and helpers.**

This file defines the `LandTypes` abstract type and its subtypes, which provides types for handling SINDBAD `land` and how the model output in every time step is organized:
- `PreAlloc`: Types for preallocating memory for model outputs
- `LandWrapper`: A wrapper for nested data structures with dot notation access
- `GroupView`: For accessing groups of data within a `LandWrapper`
- `ArrayView`: For accessing specific arrays within groups

Includes methods for pretty-printing and accessing data in these structures.

## ArrayTypes.jl
**Defines array types used throughout the SINDBAD framework.**

This file defines `ArrayTypes` and contains two main categories of array types:
- `ModelArrayType`: For internal model variables (standard arrays, static arrays, views)
- `OutputArrayType`: For model outputs (standard arrays, MArrays, SizedArrays, YAXArrays)

These types control how data is stored and manipulated within the model and output processes.

## InputTypes.jl
**Defines types for handling input data and processing.**

This file defines the `InputTypes` abstract type and its subtypes, which includes types for:
- Data backends: `BackendNetcdf`, `BackendZarr`
- Input array types: `InputArray`, `InputKeyedArray`, `InputNamedDimsArray`, `InputYaxArray`
- Forcing variable types: `ForcingWithTime`, `ForcingWithoutTime`
- Spatial subsetting methods: `Spaceid`, `Spacelatitude`, `Spacelon`, etc.

These types control how input data is loaded and processed.

## SimulationTypes.jl
**Defines types for experiment configuration and execution.**

This file defines the `SimulationTypes` abstract type and its subtypes, which contains types for controlling model runs:
- `RunFlag`: Boolean flags for various model behaviors (e.g., `DoSpinupTEM`, `DoSaveInfo`)
- `ParallelizationPackage`: Options for parallelization (`ThreadsParallelization`, `QbmapParallelization`)
- `OutputStrategy`: Controls for model output behavior (`DoOutputAll`, `DoSaveSingleFile`)

These types configure how model experiments are executed.

## ParameterOptimizationTypes.jl
**Defines types for model optimization and parameter estimation.**

This file defines the `ParameterOptimizationTypes` abstract type and its subtypes, which includes:
- `ParameterOptimizationMethod`: Various optimization algorithms (BFGS, CMA-ES, Nelder-Mead, etc.)
- `GSAMethod`: Global sensitivity analysis methods (Morris, Sobol)
- `CostMethod`: Methods for calculating cost between model and observations
- `ParameterScaling`: Methods for scaling parameters during optimization

These types control how model parameters are optimized.

## MetricsTypes.jl
**Defines types for model performance metrics and evaluation.**

This file defines `MetricTypes` abstract type and its subtypes, which contains:
- `PerfMetric`: Performance metrics (NSE, correlation, MSE, etc.)
- `DataAggrOrder`: Controls order of data aggregation (space-then-time or time-then-space)
- `SpatialDataAggr`: Methods for spatial data aggregation
- `SpatialMetricAggr`: Methods for aggregating metrics spatially

These types control how model performance is evaluated.

## MachineLearningTypes.jl
**Defines types for machine learning and gradient calculations.**

This file defines `MachineLearningTypes` abstract type and its subtypes, which focuses on gradient calculation methods:
- `MachineLearningGradType`: Abstract type for gradient calculation methods
- Various automatic differentiation methods: `ForwardDiffGrad`, `ZygoteGrad`, `EnzymeGrad`
- Finite difference methods: `FiniteDiffGrad`, `FiniteDifferencesGrad`

These types control how gradients are calculated for optimization.

## LongTuple.jl
**Defines a specialized tuple type for handling large collections of data.**

This file implements the `LongTuple` type, which splits large tuples into smaller chunks for better memory management and performance. It includes methods for indexing, mapping, and displaying these `LongTuple`s.

## TypesFunctions.jl
**Provides utility functions for working with SINDBAD types.**

This file contains functions for:
- `get_definitions`: Retrieving defined objects in SINDBAD
- `get_type_docstring`: Generating formatted documentation for types
- `methods_of`: Displaying subtypes and their purposes
- `write_type_docstring`: Writing type documentation to files

These functions support documentation and introspection of the type system.

## docStringForTypes.jl
**Contains generated documentation for SINDBAD types.**

This file contains pre-generated documentation strings for all SINDBAD types, including their purpose, type hierarchy, and available subtypes.

::: warning

This file should not be edited manually.

:::

## Types from related packages (used/re-exported by SINDBAD)

### SindbadTEM (package)
Defines the core TEM model type hierarchy for SINDBAD (e.g. `LandEcosystem`) and associated TEM-level tooling.

### TimeSamplers.jl (package)
Defines time-related types for temporal subsetting and aggregation:
- `TimeSampler` and a comprehensive set of time scales/aggregations (e.g. `TimeDay`, `TimeMonth`, `TimeYear`, MSC/anomaly aggregations, etc.)