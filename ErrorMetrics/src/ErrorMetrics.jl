"""
    ErrorMetrics

The `ErrorMetrics` module provides tools for evaluating the performance of SINDBAD models. It includes a variety of metrics for comparing model outputs with observations, calculating statistical measures, and updating model parameters based on evaluation results.

# Purpose
This module is designed to define and compute metrics that assess the accuracy and reliability of SINDBAD models. It supports a wide range of statistical and performance metrics, enabling robust model evaluation and calibration.

# Included Files
- `ErrorMetricsTypes.jl`: Core ErrorMetrics types.
- `metric.jl`: Metric definitions (e.g., RMSE, correlation) and custom metrics for SINDBAD experiments.


# Notes
- The module is designed to be extensible, allowing users to define custom metrics for specific use cases.
- Metrics are computed in a modular fashion, ensuring compatibility with SINDBAD's optimization and evaluation workflows.
- Supports both standard statistical metrics and domain-specific metrics tailored to SINDBAD experiments.

# Examples
1. **Calculating RMSE**:
```julia
using ErrorMetrics
rmse = metric(MSE(), model_output, observations)
```

2. **Computing correlation**:
```julia
using ErrorMetrics
correlation = metric(Pcor(), model_output, observations)
```

"""
module ErrorMetrics

   using StatsBase

   include("ErrorMetricsTypes.jl")
   include("metric.jl")

end # module ErrorMetrics
