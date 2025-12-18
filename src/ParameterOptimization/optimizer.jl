export optimizer

"""
    optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, algorithm <: ParameterOptimizationMethod)

Optimize model parameters using various optimization algorithms.

# Arguments:
  - `cost_function`: A function handle that takes a parameter vector as input and calculates a cost/loss (scalar or vector).
  - `default_values`: A vector of default parameter values to initialize the optimization.
  - `lower_bounds`: A vector of lower bounds for the parameters.
  - `upper_bounds`: A vector of upper bounds for the parameters.
  - `algo_options`: A set of options specific to the chosen optimization algorithm.
  - `algorithm`: The optimization algorithm to be used.

# Returns:
- `optim_para`: A vector of optimized parameter values.

# algorithm:
    
    $(methods_of(ParameterOptimizationMethod))

---

# Extended help

# Notes:
- The function supports a wide range of optimization algorithms, each tailored for specific use cases.
- Some methods do not require bounds for optimization, while others do.
- The `cost_function` should be defined by the user to calculate the loss based on the model output and observations. It is defined in cost.jl.
- The `algo_options` argument allows fine-tuning of the optimization process for each algorithm.
- Some algorithms (e.g., `BayesOptKMaternARD5`, `OptimizationBBOxnes`) require additional configuration steps, such as setting kernels or merging default and user-defined options.

# Examples
```jldoctest
julia> using Sindbad

julia> # Optimize using CMA-ES algorithm
julia> # optim_para = optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, CMAEvolutionStrategyCMAES())

julia> # Optimize using BFGS algorithm
julia> # optim_para = optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, OptimBFGS())

julia> # Optimize using Black Box Optimization (xNES)
julia> # optim_para = optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, OptimizationBBOxnes())
```

# Implementation Details:
- The function internally calls the appropriate optimization library and algorithm based on the `algorithm` argument.
- Each algorithm has its own implementation details, such as handling bounds, configuring options, and solving the optimization problem.
- The results are processed to extract the optimized parameter vector (`optim_para`), which is returned to the user.
"""
function optimizer(::Any, default_values::Any, ::Any, ::Any, ::Any, x::ParameterOptimizationMethod)
    @warn "
    Optimizer `$(nameof(typeof(x)))` not implemented. 
    
    To implement a new optimizer:
    
    - First add a new type as a subtype of `ParameterOptimizationMethod` in `src/Types/ParameterOptimizationTypes.jl`. 
    
    - Then, add a corresponding method:
      - if it can be implemented as an internal Sindbad method without additional dependencies, implement the method in `src/ParameterOptimization/optimizer.jl`.     
      - if it requires additional dependencies, implement the method in `ext/<extension_name>/ParameterOptimizationOptimizer.jl` extension.

    As a fallback, this function will return the default values as the optimized parameters.

    "
    return default_values
end
# function optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::BayesOptKMaternARD5)
#     config = ConfigParameters()   # calls initialize_parameters_to_default of the C API
#     config = merge_namedtuple(config, algo_options)
#     set_kernel!(config, "kMaternARD5")  # calls set_kernel of the C API
#     config.sc_type = SC_MAP
#     _, optimum = bayes_optimization(cost_function, lower_bounds, upper_bounds, config)
#     @show optimum
#     return optimum
# end

# function optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::EvolutionaryCMAES)
#     optim_results = Evolutionary.optimize(cost_function, Evolutionary.BoxConstraints(lower_bounds, upper_bounds), default_values, Evolutionary.CMAES(), Evolutionary.Options(; algo_options...))
#     optim_para = Evolutionary.minimizer(optim_results)
#     return optim_para
# end


# function optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimLBFGS)
#     results = optimize(cost_function, default_values, LBFGS(), Optim.Options(; algo_options...))
#     optim_para = if results.ls_success
#         results.minimizer
#     else
#         @warn "OptimLBFGS did not converge. Returning default as optimized parameters"
#         default
#     end
#     return optim_para
# end

# function optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimBFGS)
#     results = optimize(cost_function, default_values, BFGS(; initial_stepnorm=0.001))
#     optim_para = if results.ls_success
#         results.minimizer
#     else
#         @warn "OptimBFGS did not converge. Returning default as optimized parameters"
#         default
#     end
#     return optim_para
# end
