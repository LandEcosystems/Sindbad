"""
    UtilKit

A comprehensive utility package providing foundational functions for data manipulation, collections management, display formatting, and type introspection in the SINDBAD framework.

# Overview

`UtilKit` serves as a core utility library that provides reusable functions for common programming tasks. It is designed to be type-stable, performant, and consistent across SINDBAD packages.

# Main Features

## Array Operations
- Array booleanization and masking
- Matrix diagonal operations (upper, lower, off-diagonal)
- Array stacking and view operations
- Invalid value handling and replacement

## Collections and Data Structures
- Dictionary to NamedTuple conversion
- NamedTuple manipulation (field dropping, combining, setting)
- Table to NamedTuple conversion
- List tabularization
- Unique/non-unique element detection

## String Utilities
- String case conversion and formatting
- Prefix/suffix manipulation

## Number Utilities
- Value clamping and validation
- Invalid number detection and replacement
- Fractional and cumulative sum operations

## Display and Formatting
- Colored terminal output with `Crayons` and `StyledStrings`
- ASCII art banners with `FIGlet`
- Logging level management
- Type information display with color coding
- Banner and separator display functions

## Type and Method Utilities
- Type introspection and hierarchy exploration
- Docstring generation for types
- Method manipulation utilities
- Long tuple handling

## Documentation Utilities
- Automated docstring generation
- Type documentation formatting
- Purpose function integration

# Dependencies

- `Accessors`: Utilities for accessing and modifying nested data structures
- `Crayons`: Colored terminal output
- `DataStructures`: Data structure utilities for collections
- `FIGlet`: ASCII art text generation
- `InteractiveUtils`: Interactive utilities for Julia REPL
- `Logging`: Logging framework
- `StyledStrings`: Styled text for terminal output
- `TypedTables`: Typed table data structures

# Usage Example

```julia
using UtilKit

# Convert dictionary to NamedTuple
dict = Dict(:a => 1, :b => 2)
nt = dictToNamedTuple(dict)

# Display a banner
displayBanner("SINDBAD")

# Work with arrays
arr = [1, 2, 3, 0, -1, 5]
bool_arr = booleanizeArray(arr)

# String utilities
str = toUpperCaseFirst("hello_world", "Time")  # Returns :TimeHelloWorld
```

# Notes

- Functions are designed to be type-stable for performance-critical workflows
- The package provides foundational utilities used across all SINDBAD packages
- Display utilities support both colored and plain text output
- NamedTuple utilities enable efficient manipulation of structured data types

# See Also

- [`dictToNamedTuple`](@ref) for dictionary conversion
- [`displayBanner`](@ref) for ASCII art display
- [`booleanizeArray`](@ref) for array booleanization
- [`getTypeDocString`](@ref) for type documentation generation
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
   using Logging
   using Pkg
   using TOML


   include("utilsNumber.jl")
   include("utilsString.jl")
   include("utilsCollections.jl")
   include("utilsLongTuple.jl")
   include("utilsArray.jl")
   include("utilsDisp.jl")
   include("utilsDocstrings.jl")
   include("utilsMethods.jl")
   include("utilsPkg.jl")
   
end # module UtilKit
