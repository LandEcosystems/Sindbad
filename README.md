# SINDBAD

[![][docs-stable-img]][docs-stable-url][![][docs-dev-img]][docs-dev-url][![][ci-img]][ci-url] [![][codecov-img]][codecov-url][![Julia][julia-img]][julia-url][![License: EUPLv1.2](https://img.shields.io/badge/License-EUPLv1.2-seagreen)](https://github.com/EarthyScience/SINDBAD/blob/main/LICENSE)

<img src="docs/src/assets/logo.png" align="right" style="padding-left:10px;" width="150"/>

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://earthyscience.github.io/SINDBAD/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://earthyscience.github.io/SINDBAD/stable/

[codecov-img]: https://codecov.io/gh/EarthyScience/SINDBAD/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/EarthyScience/SINDBAD

[ci-img]: https://github.com/EarthyScience/SINDBAD/workflows/CI/badge.svg
[ci-url]: https://github.com/EarthyScience/SINDBAD/actions?query=workflow%3ACI

[julia-img]: https://img.shields.io/badge/julia-v1.10+-blue.svg
[julia-url]: https://julialang.org/

Welcome to the repository for **S**trategies to **IN**tegrate **D**ata and **B**iogeochemic**A**l mo**D**els (SINDBAD).

Researchers and developers actively developing the model and doing research using [this public SINDBAD repo](https://github.com/EarthyScience/SINDBAD) are encouraged to contact and join [the RnD-Team](./SindbadTEM/governance4RnD.md), which provides "beta" updates under active development.

## Overview

SINDBAD is a model data integration framework that encompasses the biogeochemical cycles of water and carbon, allowing for extensive and flexible integration of parsimonious models with a diverse set of observational data streams.

The framework provides a unified system for:
- **Model Structure**: Adaptable ecosystem process representations
- **Input Data**: Flexible data ingestion and processing
- **Observation Data**: Versatile observational constraint integration
- **Integration Methods**: Customizable optimization and assimilation approaches

## Repository Structure

SINDBAD is organized as a monorepo containing:

- **`SindbadTEM/`**: Core terrestrial ecosystem models, types, and utilities
- **`src/`**: Main SINDBAD framework modules:
  - `DataLoaders/`: Data loading and preprocessing
  - `Setup/`: Experiment configuration and setup
  - `Simulation/`: Terrestrial ecosystem model execution
  - `ParameterOptimization/`: Parameter calibration and optimization
  - `MachineLearning/`: ML-assisted surrogates and emulators
  - `Metrics/`: Performance metrics and cost functions
  - `Visualization/`: Plotting and visualization tools
  - `Experiment/`: High-level experiment orchestration
  - `Types/`: Type definitions for SINDBAD structures
- **`ext/`**: Extension packages for optional dependencies
- **`examples/`**: Example experiments and configurations
- **`docs/`**: Documentation source files

## Installation

### With Git Repository Access

```julia
using Pkg
Pkg.add(url="https://github.com/EarthyScience/SINDBAD.git")
```

### Without Git Repository Access

Download the latest SINDBAD package and navigate to the directory.

For development setup and usage instructions, see [CONTRIBUTING.md](./CONTRIBUTING.md).

## Quick Start

```julia
using Sindbad

# Build experiment info from configuration
info = Sindbad.Setup.build_info("experiment_config.json")

# Load forcing data
forcing = Sindbad.DataLoaders.load_forcing(info)

# Run simulation
results = Sindbad.Simulation.run(info, forcing)

# Visualize results
Sindbad.Visualization.plot_output(results)
```

## Documentation

Comprehensive documentation is available at:
- **Stable**: https://earthyscience.github.io/SINDBAD/stable/
- **Development**: https://earthyscience.github.io/SINDBAD/dev/

## SINDBAD Contributors

SINDBAD is developed at the Department of Biogeochemical Integration of the Max Planck Institute for Biogeochemistry in Jena, Germany with active contributions from [Sujan Koirala](https://www.bgc-jena.mpg.de/person/skoirala/2206), [Xu Shan](https://www.bgc-jena.mpg.de/person/138641/2206), [Jialiang Zhou](https://www.bgc-jena.mpg.de/person/137086/2206), [Lazaro Alonso](https://www.bgc-jena.mpg.de/person/lalonso/2206), [Fabian Gans](https://www.bgc-jena.mpg.de/person/fgans/4777761), [Felix Cremer](https://www.bgc-jena.mpg.de/person/fcremer/2206), [Nuno Carvalhais](https://www.bgc-jena.mpg.de/person/ncarval/2206).

For a full list of current and previous contributors, see http://sindbad-mdi.org/pages/about/team.html

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on:
- Development setup
- Code style and conventions
- Submitting pull requests
- Reporting issues

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
