"""
    UtilKit

The `UtilKit` module provides a collection of utility functions and tools for handling data, managing NamedTuples, and performing spatial and temporal operations in the SINDBAD framework. It serves as a foundational package for simplifying common tasks and ensuring consistency across SINDBAD experiments.

# Purpose:
This module is designed to provide reusable utilities for data manipulation, statistical operations, and spatial/temporal processing.

# Dependencies:
- `Crayons`: Enables colored terminal output, improving the readability of logs and messages.
- `StyledStrings`: Provides styled text for enhanced terminal output.
- `DataStructures`: Provides data structure utilities for collections and ordered containers.
- `Logging`: Provides logging utilities for debugging and monitoring SINDBAD workflows.
- `FIGlet`: Generates ASCII art text, useful for creating visually appealing headers in logs or outputs.
- `Accessors`: Provides utilities for accessing and modifying nested data structures.

# Included Files:
1. **`utilsArray.jl`**:
   - Implements functions for working with arrays, including views and array operations.

2. **`utilsCollections.jl`**:
   - Contains utilities for working with collections and data structures.

3. **`utilsDisp.jl`**:
   - Provides display and formatting utilities for output.

4. **`utilsDocstrings.jl`**:
   - Contains utilities for generating and managing docstrings.

5. **`utilsLongTuple.jl`**:
   - Provides utilities for working with long tuples and tuple operations.

6. **`utilsMethods.jl`**:
   - Contains utilities for method manipulation and introspection.

# Notes:
- The module provides foundational utilities used across all SINDBAD packages.
- Functions are designed to be type-stable and performant for use in performance-critical workflows.
- NamedTuple utilities enable efficient manipulation of SINDBAD's structured data types.

# Examples:
1. **Working with utilities**:
```julia
using UtilKit
# Various utility functions are available for collections, arrays, tuples, and more
```

2. **Display and formatting**:
```julia
using UtilKit
# Display utilities and formatting functions are available
```

"""
module UtilKit
   using Crayons
   using StyledStrings
   using DataStructures
   using Logging
   using FIGlet
   using Accessors
   using TypedTables: Table
   using InteractiveUtils
   using Base.Docs: doc as base_doc

   include("utilsNumber.jl")
   include("utilsString.jl")
   include("utilsCollections.jl")
   include("utilsLongTuple.jl")
   include("utilsArray.jl")
   include("utilsDisp.jl")
   include("utilsDocstrings.jl")
   include("utilsMethods.jl")
   
end # module UtilKit
