"""
Extension methods for `Sindbad.MachineLearning.gradientSite`.

This file is included from the extension module and can use `ForwardDiff`.
"""

# Bring the target function into scope for adding methods. This should be done using `import` and not `using`.
import Sindbad.MachineLearning: gradientSite

# get all the types needed to dispatch the function. These types should defined in a corresponding file in Sindbad so that they can be used for dispatching and setup, if that were needed.
using Sindbad: ForwardDiffGrad

# Example methods (for reference):
# - src/MachineLearning/mlGradient.jl:163  gradientSite(::FiniteDiffGrad, ::AbstractArray, ::NamedTuple, ::F) @ Sindbad.MachineLearning
# - src/MachineLearning/mlGradient.jl:147  gradientSite(::PolyesterForwardDiffGrad, ::Any, ::NamedTuple, ::F) @ Sindbad.MachineLearning
# - src/MachineLearning/mlGradient.jl:135  gradientSite(::PolyesterForwardDiffGrad, ::Any, ::Int64, ::F, ::Vararg{Any}) @ Sindbad.MachineLearning
# - src/MachineLearning/mlGradient.jl:176  gradientSite(::EnzymeGrad, ::AbstractArray, ::NamedTuple, ::F) @ Sindbad.MachineLearning
# - src/MachineLearning/mlGradient.jl:158  gradientSite(::ForwardDiffGrad, ::AbstractArray, ::NamedTuple, ::F) @ Sindbad.MachineLearning
# - src/MachineLearning/mlGradient.jl:167  gradientSite(::FiniteDifferencesGrad, ::AbstractArray, ::NamedTuple, ::F) @ Sindbad.MachineLearning
# - src/MachineLearning/mlGradient.jl:172  gradientSite(::ZygoteGrad, ::AbstractArray, ::NamedTuple, ::F) @ Sindbad.MachineLearning

# ------------------------------------------------------------------
# Add your extension methods below. The Example is a tentative placeholder for the method signature and should be replaced with the actual method signature.

function gradientSite(::ForwardDiffGrad, x_vals::AbstractArray, gradient_options::NamedTuple, loss_f::F) where {F}
    # cfg = ForwardDiff.GradientConfig(loss_f, x_vals, Chunk{gradient_options.chunk_size}());
    return ForwardDiff.gradient(loss_f, x_vals)
end