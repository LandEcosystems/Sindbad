# SindbadTEM.jl

[![][docs-stable-img]][docs-stable-url][![][docs-dev-img]][docs-dev-url][![][ci-img]][ci-url] [![][codecov-img]][codecov-url][![Julia][julia-img]][julia-url][![License: EUPLv1.2](https://img.shields.io/badge/License-EUPLv1.2-seagreen)](https://github.com/LandEcosystems/Sindbad/blob/main/LICENSE)

<img src="../docs/src/assets/sindbad_logo.png" align="right" style="padding-left:10px;" width="150"/>

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://landecosystems.github.io/Sindbad/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://landecosystems.github.io/Sindbad/stable/

[codecov-img]: https://codecov.io/gh/LandEcosystems/Sindbad/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/LandEcosystems/Sindbad

[ci-img]: https://github.com/LandEcosystems/Sindbad/workflows/CI/badge.svg
[ci-url]: https://github.com/LandEcosystems/Sindbad/actions?query=workflow%3ACI

[julia-img]: https://img.shields.io/badge/julia-v1.10+-blue.svg
[julia-url]: https://julialang.org/

## Overview

`SindbadTEM` is the core package of the **S**trategies to **IN**tegrate **D**ata and **B**iogeochemic**A**l mo**D**els (SINDBAD) framework. It provides foundational types, utilities, and tools for building and managing terrestrial ecosystem models.

This package serves as the foundation for the SINDBAD framework, defining the `LandEcosystem` supertype that serves as the base for all SINDBAD models, along with utilities for managing model variables, tools for model operations, and a catalog of variables used in SINDBAD workflows.

## Features

- **Core Types**: Defines the `LandEcosystem` supertype and all SINDBAD type hierarchies
- **Model Processes**: Implements ecosystem process representations and approaches
- **Variable Catalog**: Maintains canonical catalog of SINDBAD variables for consistent metadata
- **Model Tools**: Provides tooling for inspecting models, parameter conversions, and docstring generation
- **Code Generation**: Utilities for scaffolding new SINDBAD process implementations

## Repository Structure

`SindbadTEM` is part of the SINDBAD monorepo. The package structure includes:

- **`src/Types/`**: All SINDBAD type definitions (model, time, land, array, experiment, etc.)
- **`src/Processes/`**: Process hierarchy, metadata macros, and all process/approach definitions
- **`src/TEMUtils.jl`**: Helper macros and functions for manipulating pools, NamedTuples, and logging
- **`src/TEMTools.jl`**: Tooling for inspecting models (I/O listings, parameter conversions, etc.)
- **`src/sindbadVariableCatalog.jl`**: Canonical catalog of SINDBAD variables
- **`src/generateCode.jl`**: Code-generation utilities for new process implementations

## Installation

`SindbadTEM` is part of the SINDBAD monorepo. For installation and development setup, see the main [SINDBAD README](../README.md) and [CONTRIBUTING.md](../CONTRIBUTING.md).

### As Part of SINDBAD

When developing with SINDBAD, `SindbadTEM` is automatically included:

```julia
using Pkg
Pkg.develop(path="path/to/SINDBAD")
Pkg.develop(path="path/to/Sindbad/SindbadTEM")
```

## Usage

```julia
using SindbadTEM

# Define a new SINDBAD model
struct MyProcess <: LandEcosystem
    # Define model-specific fields
end

# Access utilities
flattened_data = flatten(nested_data)

# Query the variable catalog
catalog = getVariableCatalog()
```

## Main Components

### Types Module

The `Types` module collects all SINDBAD types and exports helper utilities:

- Model types (`LandEcosystem` and subtypes)
- Time and temporal types
- Land and spatial types
- Array types
- Experiment and configuration types

### Processes Module

The `Processes` module declares the process hierarchy and all process/approach definitions:

- Process metadata macros
- Ecosystem process implementations
- Model approach definitions

### TEMUtils

Helper utilities for:
- Pool manipulation
- NamedTuple operations
- Logging utilities
- TER (Terrestrial Ecosystem) utilities

### TEMTools

Tooling for:
- Model inspection
- I/O listings
- Parameter conversions
- Docstring builders

## Dependencies

- `Reexport`: Simplifies re-exporting functionality
- `CodeTracking`: Code definition tracking for debugging
- `DataStructures`: Advanced data structures (OrderedDict, Deque)
- `StaticArraysCore`: Fixed-size arrays for performance-critical operations
- `StatsBase`: Statistical functions
- `OmniTools`: Utility functions (maintained in a separate repository; installed automatically by Julia’s package manager)

## Documentation

Comprehensive documentation is available at:
- **Stable**: https://landecosystems.github.io/Sindbad/dev/
- **Development**: https://landecosystems.github.io/Sindbad/dev/

## SINDBAD Contributors

SINDBAD is developed at the Department of Biogeochemical Integration of the Max Planck Institute for Biogeochemistry in Jena, Germany with active contributions from [Sujan Koirala](https://www.bgc-jena.mpg.de/person/skoirala/2206), [Xu Shan](https://www.bgc-jena.mpg.de/person/138641/2206), [Jialiang Zhou](https://www.bgc-jena.mpg.de/person/137086/2206), [Lazaro Alonso](https://www.bgc-jena.mpg.de/person/lalonso/2206), [Fabian Gans](https://www.bgc-jena.mpg.de/person/fgans/4777761), [Felix Cremer](https://www.bgc-jena.mpg.de/person/fcremer/2206), [Nuno Carvalhais](https://www.bgc-jena.mpg.de/person/ncarval/2206).

For a full list of current and previous contributors, see http://sindbad-mdi.org/pages/about/team.html

## Contributing

For contribution guidelines, please refer to the main [SINDBAD CONTRIBUTING.md](../CONTRIBUTING.md).

## Copyright and License

**SINDBAD: Strategies to Integrate Data and Biogeochemical Models**

**Copyright © 2025**  
Max-Planck-Gesellschaft zur Förderung der Wissenschaften

For copyright details, see the [NOTICE](./NOTICE) file.

---

### License

SINDBAD is free and open-source software, licensed under the [European Union Public License v1.2 (EUPL)](https://eupl.eu/1.2/en).

---

### Your Rights

You are free to:

- Copy, modify, and redistribute the code  
- Use the software as a package in your own projects, regardless of their license or copyright status  
- Apply the software in both commercial and non-commercial contexts  

---

### Your Responsibilities

If you modify the code — excluding changes made solely for interoperability — you **must redistribute the modified version under the EUPL v1.2 or a compatible license**. This ensures the long-term sustainability of the project and supports an open, inclusive, and collaborative community.

---

### Disclaimer

This software is provided in the hope that it will be useful, but **without any warranty** — including, without limitation, the implied warranties of merchantability or fitness for a particular purpose.
