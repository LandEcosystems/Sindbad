
function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationBBOxnes)
    default_options = (; maxiters = 100)
    opt_options = mergeNamedTuple(default_options, algo_options)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_prob = OptimizationProblem(optim_cost, default_values; lb=lower_bounds, ub=upper_bounds)
    optim_para = solve(optim_prob, BBO_xnes(); opt_options...)
    return optim_para
end

function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationBBOadaptive)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_prob = OptimizationProblem(optim_cost, default_values; lb=lower_bounds, ub=upper_bounds)
    optim_para = solve(optim_prob, BBO_adaptive_de_rand_1_bin_radiuslimited())
    return optim_para
end


function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationBFGS)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_prob = OptimizationProblem(optim_cost, default_values)
    optim_para = solve(optim_prob, BFGS(; initial_stepnorm=0.001))
    return optim_para
end

function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationFminboxGradientDescentFD)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_cost_fd = OptimizationFunction(optim_cost, Optimization.AutoForwardDiff())
    optim_prob = OptimizationProblem(optim_cost_fd, default_values; lb=lower_bounds, ub=upper_bounds)
    optim_para = solve(optim_prob, Fminbox(GradientDescent()))
    return optim_para
end

function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationFminboxGradientDescent)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_cost_fd = OptimizationFunction(optim_cost)
    optim_prob = OptimizationProblem(optim_cost_fd, default_values; lb=lower_bounds, ub=upper_bounds)
    optim_para = solve(optim_prob)
    return optim_para
end


function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationGCMAESDef)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_cost_f = OptimizationFunction(optim_cost)
    optim_prob = OptimizationProblem(optim_cost_f, default_values; lb=lower_bounds, ub=upper_bounds)
    optim_para = solve(optim_prob, GCMAESOpt())
    return optim_para
end


function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationGCMAESFD)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_cost_f = OptimizationFunction(optim_cost, Optimization.AutoForwardDiff())
    optim_prob = OptimizationProblem(optim_cost_f, default_values; lb=lower_bounds, ub=upper_bounds)
    optim_para = solve(optim_prob, GCMAESOpt())
    return optim_para
end

function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationMultistartOptimization)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_prob = OptimizationProblem(optim_cost, default_values; lb=lower_bounds, ub=upper_bounds)
    optim_para = solve(optim_prob, MultistartOptimization.TikTak(100), NLopt.LD_LBFGS())
    return optim_para
end


function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationNelderMead)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_prob = OptimizationProblem(optim_cost, default_values)
    optim_para = solve(optim_prob, NelderMead(), algo_options...)
    return optim_para
end


function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::OptimizationQuadDirect)
    optim_cost = (p, tmp=nothing) -> cost_function(p)
    optim_prob = OptimizationProblem(optim_cost, default_values; lb=lower_bounds, ub=upper_bounds)
    optim_para = solve(optim_prob, QuadDirect(), splits = ([-0.9, 0, 0.9], [-0.8, 0, 0.8]), algo_options...)
    return optim_para
end
