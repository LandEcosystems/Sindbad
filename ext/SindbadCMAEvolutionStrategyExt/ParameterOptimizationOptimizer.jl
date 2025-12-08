function Sindbad.ParameterOptimization.optimizer(cost_function, default_values, lower_bounds, upper_bounds, algo_options, ::CMAEvolutionStrategyCMAES)
    results = CMAEvolutionStrategy.minimize(cost_function, default_values, 1; lower=lower_bounds, upper=upper_bounds, algo_options...)
    optim_para = CMAEvolutionStrategy.xbest(results)
    return optim_para
end
