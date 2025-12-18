"""
    SindbadTEM

A Julia package for the terrestrial ecosystem model (TEM) implementation within the **S**trategies to **IN**tegrate **D**ata and **B**iogeochemic**A**l mo**D**els (SINDBAD) framework.

The `SindbadTEM` package serves as the core of the SINDBAD framework, providing foundational types, utilities, and tools for building and managing SINDBAD models.

# Purpose
This module defines the `LandEcosystem` supertype, which serves as the base for all SINDBAD models. It also provides utilities for managing model variables, tools for model operations, and a catalog of variables used in SINDBAD workflows.

# Dependencies
Key dependencies used/re-exported by the module include:
- `Reexport`: Re-export helpers (`@reexport`).
- `UtilsKit`: Shared utilities and `purpose` integration.
- `CodeTracking`: Development/debug helpers.
- `DataStructures`: Collection types used across TEM utilities.
- `StaticArraysCore`: Fixed-size and sized array types for performance.
- `Accessors`: Nested update helpers (`@set`).
- `StatsBase`: Statistical helpers used across processes/utilities.
- `InteractiveUtils`, `Crayons`: Interactive/dev UX helpers.

# Included Files
- **`TEMTypes.jl`**: Core TEM types (including `LandEcosystem`) and shared type utilities.
- **`TEMUtils.jl`**: Helper macros/functions for pools, NamedTuples, logging, and TEM utilities.
- **`TEMVariableCatalog.jl`**: Canonical catalog of SINDBAD variables for consistent IO metadata.
- **`Processes/Processes.jl`**: Process hierarchy, metadata macros, and process/approach definitions (re-exported as `SindbadTEM.Processes`).
- *(Internal)* `tmp_precompile_placeholder.jl`: Auto-managed placeholder to force precompilation when new processes/approaches are added.

# Notes
- The `LandEcosystem` supertype serves as the foundation for all SINDBAD models, enabling extensibility and modularity.
- The module re-exports key functionality from several dependencies (e.g., `StaticArraysCore`, `DataStructures`) to simplify downstream usage.
- Designed to be lightweight and modular, allowing seamless integration with other SINDBAD modules in the top src directory of the repository.

# Examples
1. **Defining a new SINDBAD model**:
```julia
struct MyProcess <: LandEcosystem
    # Define model-specific fields
end
```

2. **Using utilities from the package**:
```julia
using Sindbad.Simulation
# Access utilities or models
flattened_data = flatten(nested_data)
```

3. **Querying the variable catalog**:
```julia
using Sindbad.Simulation
catalog = getVariableCatalog()
```
"""
module SindbadTEM
   using Reexport: @reexport
   @reexport using UtilsKit
   import UtilsKit: purpose
   @reexport using Reexport
   @reexport using Pkg
   @reexport using CodeTracking
   @reexport using DataStructures: DataStructures
   @reexport using StaticArraysCore: StaticArray, SVector, MArray, SizedArray
   @reexport using Accessors: @set
   @reexport using StatsBase
   @reexport using InteractiveUtils
   @reexport using Crayons
   @reexport using Base.Docs: doc as base_doc

   # create a tmp_ file for tracking the creation of new approaches. This is needed because precompiler is not consistently loading the newly created approaches. This file is appended every time a new model/approach is created which forces precompile in the next use of SindbadTEM.
   file_path = file_path = joinpath(@__DIR__, "tmp_precompile_placeholder.jl")
   # Check if the file exists
   if isfile(file_path)
      # Include the file if it exists
      include(file_path)
   else
      # Create a blank file if it does not exist
      open(file_path, "w") do file
         # Optionally, you can write some initial content
         write(file, "# This is a blank file created by SindbadTEM module to keep track of newly added sindbad approaches/processes which automatically updates this file and then forces precompilation to include the new processes.\n")
      end
      println("Created a blank file: $file_path to track precompilation of new processes and approaches")
   end
   
   include("TEMTypes.jl")
   include("TEMUtils.jl")
   include("TEMVariableCatalog.jl")
   include("Processes/Processes.jl")
   @reexport using .Processes

   # append the docstring of the LandEcosystem type to the docstring of the SindbadTEM module so that all the methods of the LandEcosystem type are included after the models have been described
   @doc """
   LandEcosystem

   $(purpose(LandEcosystem))

   # Methods
   All subtypes of `LandEcosystem` must implement at least one of the following methods:
   - `define`: Initialize arrays and variables
   - `precompute`: Update variables with new realizations
   - `compute`: Update model state in time
   - `update`: Update pools within a single time step


   # Example
   ```julia
   # Define a new model type
   struct MyProcess <: LandEcosystem end

   # Implement required methods
   function define(params::MyProcess, forcing, land, helpers)
   # Initialize arrays and variables
   return land
   end

   function precompute(params::MyProcess, forcing, land, helpers)
   # Update variables with new realizations
   return land
   end

   function compute(params::MyProcess, forcing, land, helpers)
   # Update model state in time
   return land
   end

   function update(params::MyProcess, forcing, land, helpers)
   # Update pools within a single time step
   return land
   end
   ```

   ---

   # Extended help
   $(methods_of(LandEcosystem, purpose_function=purpose))
   """
   LandEcosystem
   
end
