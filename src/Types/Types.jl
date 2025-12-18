"""
    Types

The `Types` module consolidates and organizes all the types used in the SINDBAD framework into a central location. This ensures a single source for type definitions, promoting consistency and reusability across all SINDBAD packages. It also provides helper functions and utilities for working with these types.

# Purpose
This module serves as the backbone for type definitions in SINDBAD, ensuring modularity and extensibility. It provides a unified hierarchy for SINDBAD-specific types and includes utilities for introspection, type manipulation, and documentation.

# Dependencies
## External (third-party)
- `InteractiveUtils`: Interactive exploration and debugging helpers.
- `Base.Docs`: Documentation utilities for type introspection.

# Included Files
- **`LandTypes.jl`**: Types for land variables and land/array structures used during model execution.
- **`ArrayTypes.jl`**: Specialized array types for efficient data handling.
- **`InputTypes.jl`**: Types for input data/configuration (forcing/observation metadata and wiring).
- **`SimulationTypes.jl`**: Types representing simulation setup/configuration and results.
- **`ParameterOptimizationTypes.jl`**: Types for optimization workflows (algorithms, options, cost hooks).
- **`MachineLearningTypes.jl`**: Types supporting machine-learning workflows and data structures.

# Notes
- The `Types` module serves as the backbone for type definitions in SINDBAD, ensuring modularity and extensibility.
- Each type is documented with its purpose via the `purpose` function, making it easier for developers to understand and extend the framework.
- The `SindbadTypes` abstract type serves as the base for all Julia types in the SINDBAD framework.

# Examples
1. **Querying type purpose**:
```julia
using Sindbad.Types
purpose(BayesOptKMaternARD5)  # Returns the purpose string for the type
```

2. **Working with SINDBAD types**:
```julia
using Sindbad.Types
# All SINDBAD types are available through this module
```

"""
module Types
    import Sindbad: purpose
    using Sindbad: get_type_docstring, SindbadTypes
    using TimeSamplers

    # ------------------------- SindbadTypes ------------------------------------------------------------
    include("LandTypes.jl")
    include("ArrayTypes.jl")
    include("InputTypes.jl")
    include("SimulationTypes.jl")
    include("ParameterOptimizationTypes.jl")
    include("MachineLearningTypes.jl")


    # append the docstring of the SindbadTypes type to the docstring of the Sindbad module so that all the methods of the SindbadTypes type are included after the models have been described
    @doc """
    $(get_type_docstring(SindbadTypes, purpose_function=purpose))
    """
    SindbadTypes
end