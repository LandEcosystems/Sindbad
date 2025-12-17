# Contributing to SINDBAD

Thank you for your interest in contributing to SINDBAD! This guide will help you get started with development.

## Development Setup

### Prerequisites

- Julia 1.10 or later
- Git (for cloning the repository)

### Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/EarthyScience/SINDBAD.git
   cd SINDBAD
   ```

2. Start Julia in the repository root:
   ```bash
   julia
   ```

3. Navigate to the sandbox directory:
   ```julia
   cd("sandbox")
   ```

4. Create a new sandbox environment:
   ```julia
   run(`mkdir -p my_env`)
   cd("my_env")
   ```

5. Activate the environment and set up development dependencies:
   ```julia
   using Pkg
   Pkg.activate(".")
   ```

### Setting Up Development Dependencies

For **SINDBAD Experiments**:
```julia
Pkg.develop(path="../../")
Pkg.develop(path="../../SindbadTEM")
# Add any other local dependencies as needed
Pkg.resolve()
Pkg.instantiate()
```

For **SINDBAD Machine Learning** workflows:
```julia
Pkg.develop(path="../../")
Pkg.develop(path="../../SindbadTEM")
# Add ML-specific dependencies
Pkg.resolve()
Pkg.instantiate()
```