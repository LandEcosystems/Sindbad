"""
Extension methods for `Sindbad.ParameterOptimization.cost`.

This file is included from the extension module and can use `FiniteDiff`.
"""

# Bring the target function into scope for adding methods. This should be done using `import` and not `using`.
import Sindbad.ParameterOptimization: cost

# get all the types needed to dispatch the function. These types should defined in a corresponding file in Sindbad so that they can be used for dispatching and setup, if that were needed.
# using Sindbad: A, b, c

# Example methods (for reference):
# - src/ParameterOptimization/cost.jl:78  cost(::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any) @ Sindbad.ParameterOptimization
# - src/ParameterOptimization/cost.jl:37  cost(::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::CostModelObs) @ Sindbad.ParameterOptimization
# - src/ParameterOptimization/cost.jl:48  cost(::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Vector, ::CostModelObsMT) @ Sindbad.ParameterOptimization
# - src/ParameterOptimization/cost.jl:68  cost(::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::Any, ::CostModelObsPriors) @ Sindbad.ParameterOptimization

# ------------------------------------------------------------------
# Add your extension methods below. The Example is a tentative placeholder for the method signature and should be replaced with the actual method signature.

# function cost(parameter_vector, arg2, selected_models, space_forcing, space_spinup_forcing, loc_forcing_t, output_array, space_output, space_land, tem_info, observations, parameter_updater, cost_options, multi_constraint_method, parameter_scaling_type, arg16, arg17::CostModelObsPriors; kwargs...)
#     # TODO: implement
# end
