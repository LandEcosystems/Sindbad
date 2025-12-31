```@docs
Sindbad.Visualization
```
## Functions

### namedTupleToFlareJSON
```@docs
namedTupleToFlareJSON
```

:::details Code

```julia
function namedTupleToFlareJSON(info::NamedTuple)
    function _convert_to_flare(nt::NamedTuple, name="sindbad_info")
        children = []
        for field in propertynames(nt)
            value = getfield(nt, field)
            if value isa NamedTuple
                push!(children, _convert_to_flare(value, string(field)))
            else
                # println("field: $field, value: $value")
                push!(children, Dict("name" => string(field), "value" => 1))
            end
        end
        return Dict("name" => name, "children" => children)
    end
    
    return _convert_to_flare(info)
end
```

:::


----

### plotIOModelStructure
```@docs
plotIOModelStructure
```

:::details Code

```julia
function plotIOModelStructure(info, which_function=:compute, which_field=[:input, :output])
    print_info(plotIOModelStructure, @__FILE__, @__LINE__, "plotting IO model structure for $(which_function) with fields $(which_field)", n_f=4)

    in_out_models = getInOutModels(info.models.forward, which_function);
    unique_variables = getAllVariables(in_out_models, which_field)
    if isa(which_field, Vector)
        which_field = join(which_field, "_")
    end
    if isa(which_field, Vector)
        which_field = join(which_field, "_")
    end

    model_names = collect(keys(in_out_models))
    
    
    locs_in = []
    locs_out = []
    model_variables = []
    model_variables_in = []
    model_variables_out = []
    for (v_i, the_variable) in enumerate(unique_variables)
        for (m_i, model_name) in enumerate(model_names)
            if isa(which_field, String)
                the_fields = Symbol.(split(which_field, "_"))
                model_variables = SindbadTEM.Variables.orD()
                foreach(the_fields) do w_field
                    model_variables[w_field] = in_out_models[model_name][w_field]
                end
            else
                model_variables_in = in_out_models[model_name][which_field]
            end
            if isa(model_variables, SindbadTEM.Variables.orD)
                model_variables_in = model_variables[:input]
                model_variables_out = model_variables[:output]
            end
            if the_variable in model_variables_in
                push!(locs_in, (m_i, v_i))
            end
            if the_variable in model_variables_out
                push!(locs_out, (m_i, v_i))
            end
        end
    end
        
    unique_variables_names = string.(["$i. $(first(unique_variable)).$(last(unique_variable))" for (i, unique_variable) in enumerate(unique_variables)])

    model_names_str = ["$(i). $(string(model_name))" for (i, model_name) in enumerate(model_names)]
    plots_default(titlefont=(20, "times"), legendfontsize=18, tickfont=(15, :blue))
    
    n_grid_lines = 5
    grid_lines_color = :dimgray
    n_annotations = 10

    plot_width = 2000
    plot_height = plot_width * length(unique_variables_names) / length(model_names_str)
    xtick_locs = collect((1:length(model_names_str)) .- 0.5)
    ytick_locs = collect((1:length(unique_variables_names)) .- 0.5)



    title_str = "IO Visualization: $which_field of $(which_function) of Models in $(info.experiment.basics.id)"
    plots_vline([0], color=grid_lines_color, linewidth=1.5, title=title_str, label="")
    plots_vline!([xtick_locs[xi] for xi in n_grid_lines:n_grid_lines:length(xtick_locs)], color=grid_lines_color, linewidth=0.9, label="")
    plots_hline!([ytick_locs[xi] for xi in n_grid_lines:n_grid_lines:length(ytick_locs)], color=grid_lines_color, linewidth=0.9, label="")
    plots_hline!([0], color=grid_lines_color, linewidth=1.5, label="")


    ax = plots_scatter!(first.(locs_in) .- 0.5, last.(locs_in) .- 0.5, marker=:square, markersize=9, color=:turquoise1, markerstrokewidth=0.15, markerstrokecolor=:yellow2, size=(plot_width, plot_height), xrotation=90, xticks=(xtick_locs, model_names_str), yticks=(ytick_locs, unique_variables_names), colorbar=false, left_margin=50plots_mm, bottom_margin=25plots_mm, c=:greens, grid=true, gridcolor=:gainsboro, gridlinewidth=1, gridalpha=0.5, widen=false, tickdirection=:out, legend=false, xtickfontcolor=:blue, ytickfontcolor=:green, label="Input\n", legend_columns=1, legend_frame=false)

    if isa(which_field, String)
        plots_scatter!(first.(locs_out) .- 0.5, last.(locs_out) .- 0.5, marker=:x, markersize=4, color=:orangered1, markerstrokewidth=0.2, label="Output\n")
    end

    plots_plot!(ax, legend=(-0.15, -0.04), legendfontsize=9)  # Move legend after plotting
    annotations_y = [(xtick_locs[xi] + 0.5, ytick_locs[i] - 0.5, plots_text("↑\n$i", :green, :center, 7)) for xi in n_annotations:n_annotations:length(xtick_locs) for i in n_annotations:n_annotations:length(ytick_locs)]
    annotations = [(xtick_locs[xi] - 0.7, ytick_locs[i] - 0.5, plots_text("$(xi)→", :blue, :center, 7)) for xi in n_annotations:n_annotations:length(xtick_locs) for i in 1:n_annotations:length(ytick_locs)]
    plots_annotate!(annotations)
    plots_annotate!(annotations_y)

    plots_ylims!(ax, (-1, length(unique_variables_names) + 1))
    plots_xlims!(ax, (-1, length(model_names) + 1))
    # Guard: if there is nothing to plot, Plots' layout can end up with 0mm plot area and assert on save.
    # This happens for some `which_function` values (e.g. :precompute) depending on selected models.
    if isempty(model_names) || isempty(unique_variables)
        field_tag = isa(which_field, AbstractString) ? which_field : string(which_field)
        title_str = "IO Visualization: $field_tag of $(which_function) of Models in $(info.experiment.basics.id)"
        print_info(plotIOModelStructure, @__FILE__, @__LINE__,
                 "No IO variables/models found for $(which_function) ($(field_tag)); writing placeholder plot.", n_f=4)
        ax = plots_scatter([0.0], [0.0], markersize=0, label="", legend=false, grid=false,
                           size=(900, 400), title=title_str, xlims=(-1, 1), ylims=(-1, 1), widen=false)
        plots_annotate!(ax, (0.0, 0.0, plots_text("No variables to plot", :gray30, :center, 12)))
        plots_savefig(joinpath(info.output.dirs.figure, "$(field_tag)_variables_$(info.experiment.basics.id)_$(which_function).pdf"))
        return ax
    end

    plots_savefig(joinpath(info.output.dirs.figure, "$(which_field)_variables_$(info.experiment.basics.id)_$(which_function).pdf"))
    return ax
end
```

:::


----

### plotPerformanceHistograms
```@docs
plotPerformanceHistograms
```

:::details Code

```julia
function plotPerformanceHistograms(out_opti)
    opt_dat = out_opti.output.optimized
    def_dat = out_opti.output.default
    obs_array = out_opti.observation
    info = out_opti.info
    costOpt = out_opti.cost_options
    run_helpers = out_opti.run_helpers
    plots_default(titlefont=(20, "times"), legendfontsize=18, tickfont=(15, :blue))

    domain = info.experiment.basics.domain
    fig_prefix = joinpath(info.output.dirs.figure, "comparison_histograms_" * info.experiment.basics.name * "_" * domain)
    losses = map(costOpt) do var_row
        v = var_row.variable
        v_key = v
        println("plot performance comparison:: $v")
        v = (var_row.mod_field, var_row.mod_subfield)
        vinfo = getVariableInfo(v, info.experiment.basics.temporal_resolution)
        v = vinfo["standard_name"]
        lossMetric = var_row.cost_metric
        loss_name = nameof(typeof(lossMetric))
        if loss_name in (:NNSEInv, :NSEInv)
            lossMetric = NSE()
        end
        (obs_var, obs_σ, def_var) = getData(def_dat, obs_array, var_row);
        (_, _, opt_var) = getData(opt_dat, obs_array, var_row);

        (obs_var_no_nan, obs_σ_no_nan, def_var_no_nan) = getDataWithoutNaN(obs_var, obs_σ, def_var);
        (obs_var_no_nan, obs_σ_no_nan, opt_var_no_nan) = getDataWithoutNaN(obs_var, obs_σ, opt_var);

        loss_space = map([run_helpers.space_ind...]) do lsi
            opt_pix = view_at_trailing_indices(opt_var, lsi)
            def_pix = view_at_trailing_indices(def_var, lsi)
            obs_pix = view_at_trailing_indices(obs_var, lsi)
            obs_σ_pix = view_at_trailing_indices(obs_σ, lsi)
            (obs_pix_no_nan, obs_σ_pix_no_nan, opt_pix_no_nan) = getDataWithoutNaN(obs_pix, obs_σ_pix, opt_pix)
            (_, _, def_pix_no_nan) = getDataWithoutNaN(obs_pix, obs_σ_pix, def_pix)
            [metric(lossMetric, def_pix_no_nan, obs_pix_no_nan, obs_σ_pix_no_nan), metric(lossMetric, opt_pix_no_nan, obs_pix_no_nan, obs_σ_pix_no_nan)]
        end


        b_range = range(-1, 1, length=50)
        p_title = "$(var_row.variable) ($(nameof(typeof(lossMetric))))"
        plots_histogram(first.(loss_space); title=p_title, size=(2000, 1000),bins=b_range, alpha=0.9, label="default", color="#FDB311")
        plots_vline!([metric(lossMetric, def_var_no_nan, obs_var_no_nan, obs_σ_no_nan)], label="default_spatial", color="#FDB311", lw=3)
        plots_histogram!(last.(loss_space); size=(2000, 1000), bins=b_range, alpha=0.5, label="optimized", color="#18A15C")
        plots_vline!([metric(lossMetric, opt_var_no_nan, obs_var_no_nan, obs_σ_no_nan)], label="optimized_spatial", color="#18A15C", lw=3)
        plots_xlabel!("")
        plots_savefig(fig_prefix * "_$(v).png")
    end
    return nothing
end
```

:::


----

### plotTimeSeriesDebug
```@docs
plotTimeSeriesDebug
```

:::details Code

```julia
function plotTimeSeriesDebug(info, opt_dat, def_dat)

    # plot debug figures
    output_array_opt = values(opt_dat)
    output_array_def = values(def_dat)
    output_vars = info.output.variables

    plots_default(titlefont=(20, "times"), legendfontsize=18, tickfont=(15, :blue))
    domain = info.experiment.basics.domain
    fig_prefix = joinpath(info.output.dirs.figure, "debug_" * info.experiment.basics.name * "_" * domain)
    for (o, v) in enumerate(output_vars)
        def_var = mean(output_array_def[o], dims=3)[:, :, 1]
        opt_var = mean(output_array_opt[o], dims=3)[:, :, 1]
        vinfo = getVariableInfo(v, info.experiment.basics.temporal_resolution)
        v = vinfo["standard_name"]
        println("plot debug::", v)
        xdata = [info.helpers.dates.range...]
        if size(opt_var, 2) == 1
            plots_plot(xdata, def_var[:, 1]; label="def ($(round(mean(def_var[:, 1]), digits=2)))", size=(2000, 1000), title="$(vinfo["long_name"]) ($(vinfo["units"]))", left_margin=1plots_cm, color=:steelblue2)
            plots_plot!(xdata, opt_var[:, 1], color=:seagreen3; label="opt ($(round(mean(opt_var[:, 1]), digits=2)))")
            plots_ylabel!("$(vinfo["standard_name"])", font=(20, :green))
            plots_savefig(fig_prefix * "_$(v).png")
        else
            foreach(axes(opt_var, 2)) do ll
                plots_plot(xdata, def_var[:, ll]; label="def ($(round(mean(def_var[:, ll]), digits=2)))", size=(2000, 1000), title="$(domain): $(vinfo["long_name"]), layer $(ll),  ($(vinfo["units"]))", left_margin=1plots_cm, color=:steelblue2)
                plots_plot!(xdata, opt_var[:, ll]; color=:seagreen3, label="opt ($(round(mean(opt_var[:, ll]), digits=2)))")
                plots_ylabel!("$(vinfo["standard_name"])", font=(20, :green))
                plots_savefig(fig_prefix * "_$(v)_$(ll).png")
            end
        end
    end
    return nothing
end
```

:::


----

### plotTimeSeriesWithObs
```@docs
plotTimeSeriesWithObs
```

:::details Code

```julia
function plotTimeSeriesWithObs(out_opti)
    opt_dat = out_opti.output.optimized
    def_dat = out_opti.output.default
    obs_array = out_opti.observation
    info = out_opti.info
    costOpt = out_opti.cost_options
    plots_default(titlefont=(20, "times"), legendfontsize=18, tickfont=(15, :blue))

    domain = info.experiment.basics.domain

    fig_prefix = joinpath(info.output.dirs.figure, "comparison_time_series_" * info.experiment.basics.name * "_" * domain)
    foreach(costOpt) do var_row
        v = var_row.variable
        println("plot time series comparison:: $v")
        v = (var_row.mod_field, var_row.mod_subfield)
        vinfo = getVariableInfo(v, info.experiment.basics.temporal_resolution)
        v = vinfo["standard_name"]
        lossMetric = var_row.cost_metric
        loss_name = nameof(typeof(lossMetric))
        if loss_name in (:NNSEInv, :NSEInv)
            lossMetric = NSE()
        end
        valids = var_row.valids
        (obs_var, obs_σ, def_var) = getData(def_dat, obs_array, var_row)
        (_, _, opt_var) = getData(opt_dat, obs_array, var_row)
        obs_var_TMP = nanmean(obs_var, dims=2)

        # obs_var_TMP = obs_var[:, 1, 1]
        non_nan_index = findall(x -> !isnan(x), obs_var_TMP)
        if length(non_nan_index) < 2
            tspan = 1:length(obs_var_TMP)
        else
            tspan = first(non_nan_index):last(non_nan_index)
        end
        obs_var = obs_var_TMP[tspan]
        obs_σ = obs_σ[tspan]
        # obs_var = obs_var[tspan]

        def_var_TMP = mean(def_var, dims=3)
        opt_var_TMP = mean(opt_var, dims=3)
        def_var = def_var_TMP[tspan]
        opt_var = opt_var_TMP[tspan]
        valids = valids[tspan]

        xdata = [info.helpers.dates.range[tspan]...]

        metr_def = metric(lossMetric, def_var[valids], obs_var[valids], obs_σ[valids])
        metr_opt = metric(lossMetric, opt_var[valids], obs_var[valids], obs_σ[valids])

        plots_plot(xdata, obs_var; label="obs", seriestype=:scatter, mc=:black, ms=4, lw=0, ma=0.65, left_margin=1plots_cm)
        plots_plot!(xdata, def_var, lw=1.5, ls=:dash, left_margin=1plots_cm, legend=:outerbottom, legendcolumns=3, label="def ($(round(metr_def, digits=2)))", size=(2000, 1000), title="$(domain): $(vinfo["long_name"]) ($(vinfo["units"])) -> $(nameof(typeof(lossMetric)))", color=:steelblue2)
        plots_plot!(xdata, opt_var; color=:seagreen3, label="opt ($(round(metr_opt, digits=2)))", lw=1.5, ls=:dash)
        plots_savefig(fig_prefix * "_$(v).png")
    end

    return nothing
end

function plotTimeSeriesWithObs(out,obs_array,cost_options)
    costOpt = cost_options
    info    = out.info
    domain  = info.experiment.basics.domain
    plots_default(titlefont=(20, "times"), legendfontsize=18, tickfont=(15, :blue))


    fig_prefix = joinpath(info.output.dirs.figure, "comparison_time_series_1_" * info.experiment.basics.name * "_" * domain)
    foreach(costOpt) do var_row
        v = var_row.variable
        println("plot time series comparison:: $v")
        v = (var_row.mod_field, var_row.mod_subfield)
        vinfo = getVariableInfo(v, info.experiment.basics.temporal_resolution)
        v = vinfo["standard_name"]
        lossMetric = var_row.cost_metric
        loss_name = nameof(typeof(lossMetric))
        if loss_name in (:NNSEInv, :NSEInv)
            lossMetric = NSE()
        end
        valids = var_row.valids
        (obs_var, obs_σ, def_var) = getData(out.output, obs_array, var_row)
        obs_var_TMP = nanmean(obs_var, dims=2)

        # obs_var_TMP = obs_var[:, 1, 1]
        non_nan_index = findall(x -> !isnan(x), obs_var_TMP)
        if length(non_nan_index) < 2
            tspan = 1:length(obs_var_TMP)
        else
            tspan = first(non_nan_index):last(non_nan_index)
        end
        obs_var = obs_var_TMP[tspan]
        obs_σ = obs_σ[tspan]
        # obs_var = obs_var[tspan]

        def_var_TMP = mean(def_var, dims=3)
        def_var = def_var_TMP[tspan]
        valids = valids[tspan]

        xdata = [info.helpers.dates.range[tspan]...]

        metr_def = metric(lossMetric, def_var[valids], obs_var[valids], obs_σ[valids])

        plots_plot(xdata, obs_var; label="obs", seriestype=:scatter, mc=:black, ms=4, lw=0, ma=0.65, left_margin=1plots_cm)
        plots_plot!(xdata, def_var, lw=1.5, ls=:dash, left_margin=1plots_cm, legend=:outerbottom, legendcolumns=2, label="def ($(round(metr_def, digits=2)))", size=(2000, 1000), title="$(domain): $(vinfo["long_name"]) ($(vinfo["units"])) -> $(nameof(typeof(lossMetric)))", color=:steelblue2)
        plots_savefig(fig_prefix * "_$(v).png")
    end

    return nothing
end
```

:::


----

```@meta
CollapsedDocStrings = false
DocTestSetup= quote
using Sindbad.Visualization
end
```
