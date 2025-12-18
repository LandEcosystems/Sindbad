# Metrics

SINDBAD uses [ErrorMetrics.jl](https://landecosystems.github.io/ErrorMetrics.jl) for performance metrics and error calculations.

## ErrorMetrics.jl

ErrorMetrics.jl is a dedicated Julia package providing error and performance metrics for comparing model outputs with observations. It includes:

- **Error-based metrics**: MSE, NAME1R, NMAE1R
- **Nash-Sutcliffe Efficiency metrics**: NSE, NSEInv, NSEσ, NNSE, and variants
- **Correlation-based metrics**: Pearson and Spearman correlations with various normalizations
- **Support for observational uncertainty**: Metrics that incorporate uncertainty information

## Usage in SINDBAD

In SINDBAD, metrics from ErrorMetrics.jl are used in parameter optimization and model evaluation:

```julia
using ErrorMetrics
using Sindbad

# Metrics are used in cost_options for optimization
cost_options = (
    variable = :gpp,
    cost_metric = MSE(),  # From ErrorMetrics.jl
    # ... other options
)
```

For detailed documentation on all available metrics, implementation details, and usage examples, see the [ErrorMetrics.jl documentation](https://landecosystems.github.io/ErrorMetrics.jl).
