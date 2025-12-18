# Utilities

SINDBAD uses [OmniTools.jl](https://landecosystems.github.io/OmniTools.jl) for foundational utility functions.

## OmniTools.jl

OmniTools.jl is a comprehensive utility package providing foundational functions for:

- **Array operations**: Booleanization, masking, matrix operations, view operations
- **Collections and data structures**: Dictionary to NamedTuple conversion, NamedTuple manipulation, table operations
- **String utilities**: Case conversion, prefix/suffix manipulation
- **Number utilities**: Clamping, validation, invalid number handling
- **Display and formatting**: Colored terminal output, ASCII art banners, logging
- **Type and method utilities**: Type introspection, docstring generation, method manipulation
- **Package management**: Extension scaffolding and package utilities

## Usage in SINDBAD

OmniTools.jl is used throughout SINDBAD for common utility operations:

```julia
using OmniTools

# Convert dictionary to NamedTuple
dict = Dict(:a => 1, :b => 2)
nt = dict_to_namedtuple(dict)

# Display formatted output
print_figlet_banner("SINDBAD")

# Type introspection
purpose(SomeType)
```

For detailed documentation on all available utilities, see the [OmniTools.jl documentation](https://landecosystems.github.io/OmniTools.jl).
