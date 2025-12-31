# SINDBAD Cost Metrics

This document describes how to use metrics in SINDBAD's parameter optimization and model evaluation workflows.

## Overview

SINDBAD uses [ErrorMetrics.jl](https://landecosystems.github.io/ErrorMetrics.jl) for performance metrics and error calculations. The metrics system is designed to be modular and extensible, allowing users to define custom metrics for specific use cases while maintaining compatibility with SINDBAD's optimization and evaluation workflows.

## Available Metrics

For a complete list of available metrics, their descriptions, and implementation details, see the [ErrorMetrics.jl documentation](https://landecosystems.github.io/ErrorMetrics.jl).

To list all available cost metrics and their purposes in your Julia session:

:::tip
```julia
using ErrorMetrics
using OmniTools: show_methods_of

# List all available metrics
show_methods_of(ErrorMetric)
```

This will display a formatted list of all cost metrics and their descriptions, including:
- The metric's purpose
- Required parameters
- Return values
- Any special considerations

:::

## Using Metrics in SINDBAD

### In Cost Options

Metrics from ErrorMetrics.jl are used in `cost_options` for parameter optimization. Temporal aggregation uses [TimeSamplers.jl](https://landecosystems.github.io/TimeSamplers.jl):

```julia
using ErrorMetrics
using Sindbad

# Define cost options for a single variable
cost_options = (
    variable = :gpp,
    cost_metric = MSE(),  # From ErrorMetrics.jl
    cost_weight = 1.0,
    # ... other options
)

# Define cost options for multiple variables
cost_options = [
    (
        variable = :gpp,
        cost_metric = MSE(),
        cost_weight = 1.0
    ),
    (
        variable = :npp,
        cost_metric = NSE(),
        cost_weight = 0.5
    )
]
```

### Metric Combination

SINDBAD provides methods to combine metrics from multiple variables:

```julia
using Sindbad.ParameterOptimization

# Calculate metrics for all cost options
cost_vector = metricVector(model_output, observations, cost_options)

# Combine metrics using different methods
combined_metric = combineMetric(cost_vector, MetricSum())
combined_metric = combineMetric(cost_vector, MetricMinimum())
combined_metric = combineMetric(cost_vector, MetricMaximum())
```

Available combination methods:
- `MetricSum`: Returns the total sum as the metric
- `MetricMinimum`: Returns the minimum value as the metric
- `MetricMaximum`: Returns the maximum value as the metric

### Data Handling in SINDBAD

SINDBAD's cost calculation includes several helper functions for data handling:

- `getDataWithoutNaN`: Returns model and observation data excluding NaN values
- `aggregateData`: Aggregates data based on specified order (TimeSpace or SpaceTime)
- `applySpatialWeight`: Applies area weights to the data
- `getHarmonizedData`: Harmonizes model and observation data for comparison

These functions are automatically used during the cost calculation process.

## Examples

### Using Metrics in Parameter Optimization

```julia
using ErrorMetrics
using TimeSamplers
using Sindbad

# Setup experiment info
info = getExperimentInfo("experiment_config.json")

# Define cost options with metrics
cost_options = [
    (
        variable = :gpp,
        cost_metric = MSE(),
        cost_weight = 1.0,
        temporal_data_aggr = TimeDay(),  # From TimeSamplers.jl
        # ... other options
    ),
    (
        variable = :npp,
        cost_metric = NSE(),
        cost_weight = 0.5,
        temporal_data_aggr = TimeMonth(),  # From TimeSamplers.jl
        # ... other options
    )
]

# Run optimization (metrics are used internally)
optimized_params = optimizeTEM(forcing, observations, info; cost_options=cost_options)
```

### Evaluating Model Performance

```julia
using ErrorMetrics
using Sindbad

# Run model simulation
land_time_series = runTEM(forcing, info)

# Extract model output and observations
model_output = land_time_series.fluxes.gpp
observations = observations.gpp.data
uncertainties = observations.gpp.uncertainty

# Calculate metrics
mse = metric(MSE(), model_output, observations, uncertainties)
nse = metric(NSE(), model_output, observations, uncertainties)
pcor = metric(Pcor(), model_output, observations, uncertainties)
```

## Creating Custom Metrics

To create custom metrics for use in SINDBAD, you should add them to ErrorMetrics.jl following the ErrorMetrics.jl interface. See the [ErrorMetrics.jl documentation](https://landecosystems.github.io/ErrorMetrics.jl) for details on implementing new metrics.

Once implemented in ErrorMetrics.jl, custom metrics can be used directly in SINDBAD's `cost_options`:

```julia
using ErrorMetrics
using Sindbad

# Use your custom metric
cost_options = (
    variable = :gpp,
    cost_metric = MyCustomMetric(),  # From ErrorMetrics.jl
    # ... other options
)
```

## Best Practices

1. **Metric Selection**
   - Choose metrics appropriate for your variable type and optimization goals
   - Consider using multiple metrics for comprehensive evaluation
   - Use inverse metrics (e.g., `NSEInv`) for minimization problems

2. **Weighting**
   - Adjust `cost_weight` to balance the importance of different variables
   - Consider the scale and units of different variables when setting weights

3. **Data Quality**
   - Ensure observations and model outputs are properly aligned
   - Handle missing values appropriately (NaN values are automatically filtered)
   - Consider observational uncertainty when available

4. **Documentation**
   - Document your metric choices in experiment configurations
   - Explain why specific metrics were chosen for your use case

For more information on metric implementation, best practices, and detailed examples, see the [ErrorMetrics.jl documentation](https://landecosystems.github.io/ErrorMetrics.jl).
