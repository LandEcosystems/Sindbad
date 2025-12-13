"""
    Types

The `Types` module consolidates and organizes all the types used in the SINDBAD framework into a central location. This ensures a single source for type definitions, promoting consistency and reusability across all SINDBAD packages. It also provides helper functions and utilities for working with these types.

# Purpose:
This module serves as the backbone for type definitions in SINDBAD, ensuring modularity and extensibility. It provides a unified hierarchy for SINDBAD-specific types and includes utilities for introspection, type manipulation, and documentation.

# Dependencies:
## External (third-party)
- `InteractiveUtils`: Interactive exploration and debugging helpers.
- `Base.Docs`: Documentation utilities for type introspection.

# Included Files:
1. **`TEMTypes.jl`**:
   - Defines types for models in SindbadTEM, representing various model/processes.

2. **`TimeSamplers.jl`**:
   - Defines types for handling time-related operations, managing temporal aggregation of data.

3. **`SpinupTypes.jl`**:
   - Defines types for spinup processes in SindbadTEM, handling methods for initialization and equilibrium states.

4. **`LandTypes.jl`**:
   - Defines types for collecting variables from `land` and saving them, building land and array structures for model execution.

5. **`ArrayTypes.jl`**:
   - Defines types for array structures used in SindbadTEM, providing specialized array types for efficient data handling.

6. **`InputTypes.jl`**:
   - Defines types for input data and configurations, managing input flows and forcing data.

7. **`SimulationTypes.jl`**:
   - Defines types for experiments conducted in SindbadTEM, representing experimental setups, configurations, and results.

8. **`ParameterOptimizationTypes.jl`**:
   - Defines types for optimization-related functions and methods, separating methods for optimization, cost functions, etc.

9. **`MetricsTypes.jl`**:
   - Defines types for metrics used to evaluate model performance, representing performance metrics and cost evaluation.

10. **`MachineLearningTypes.jl`**:
    - Defines types for machine learning components, supporting machine learning workflows and data structures.

11. **`LongTuple.jl`**:
    - Provides definitions and methods for working with `longTuple` type, facilitating operations on tuples with many elements.

12. **`TypesFunctions.jl`**:
    - Provides helper functions related to SINDBAD types, including utilities for introspection, type manipulation, and documentation.

13. **`docStringForTypes.jl`**:
    - Auto-generated documentation that appends type docstrings to the main module for discoverability.

# Notes:
- The `Types` module serves as the backbone for type definitions in SINDBAD, ensuring modularity and extensibility.
- Each type is documented with its purpose via the `purpose` function, making it easier for developers to understand and extend the framework.
- The `SindbadTypes` abstract type serves as the base for all Julia types in the SINDBAD framework.

# Examples:
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
    using Sindbad: getTypeDocString, SindbadTypes, TimeSampler

    # ------------------------- SindbadTypes ------------------------------------------------------------
    include("LandTypes.jl")
    include("ArrayTypes.jl")
    include("InputTypes.jl")
    include("SimulationTypes.jl")
    include("ParameterOptimizationTypes.jl")
    include("MachineLearningTypes.jl")


    # append the docstring of the SindbadTypes type to the docstring of the Sindbad module so that all the methods of the SindbadTypes type are included after the models have been described
    @doc """
    $(getTypeDocString(SindbadTypes, purpose_function=purpose))
    """
    SindbadTypes
end