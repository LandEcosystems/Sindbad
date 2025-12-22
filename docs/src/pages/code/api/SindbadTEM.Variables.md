```@docs
SindbadTEM.Variables
```
## Functions

### checkMissingVarInfo
```@docs
checkMissingVarInfo
```

 Code

```julia
function checkMissingVarInfo end

function checkMissingVarInfo(appr)
    if supertype(appr) == LandEcosystem
        foreach(subtypes(appr)) do sub_appr
            checkMissingVarInfo(sub_appr)
        end
    else
        in_out_model = getInOutModel(appr, verbose=false)
        d_methods = (:define, :precompute, :compute, :update)
        for d_method in d_methods
            inputs = in_out_model[d_method][:input]
            outputs = in_out_model[d_method][:output]
            io_list = unique([inputs..., outputs...])
            was_displayed = false
            miss_doc = false
            foreach(io_list) do io_item
                var_key = Symbol(String(first(io_item))*"__"*String(last(io_item)))
                var_info = getVariableInfo(var_key, "time")
                miss_doc = isempty(var_info["long_name"])
                if miss_doc
                    checkDisplayVariableDict(var_key, warn_msg=!was_displayed)
                    if !was_displayed
                        was_displayed = true
                        println("Approach: $(appr).jl\nMethod: $(d_method)\nKey: :$(var_key)\nPair: $(io_item)")
                    end
                    checkDisplayVariableDict(var_key, warn_msg=!was_displayed)

                end
            end
            if miss_doc
                println("--------------------------------")
            end
        end    
    end
    return nothing
end

function checkMissingVarInfo(appr)
    if supertype(appr) == LandEcosystem
        foreach(subtypes(appr)) do sub_appr
            checkMissingVarInfo(sub_appr)
        end
    else
        in_out_model = getInOutModel(appr, verbose=false)
        d_methods = (:define, :precompute, :compute, :update)
        for d_method in d_methods
            inputs = in_out_model[d_method][:input]
            outputs = in_out_model[d_method][:output]
            io_list = unique([inputs..., outputs...])
            was_displayed = false
            miss_doc = false
            foreach(io_list) do io_item
                var_key = Symbol(String(first(io_item))*"__"*String(last(io_item)))
                var_info = getVariableInfo(var_key, "time")
                miss_doc = isempty(var_info["long_name"])
                if miss_doc
                    checkDisplayVariableDict(var_key, warn_msg=!was_displayed)
                    if !was_displayed
                        was_displayed = true
                        println("Approach: $(appr).jl\nMethod: $(d_method)\nKey: :$(var_key)\nPair: $(io_item)")
                    end
                    checkDisplayVariableDict(var_key, warn_msg=!was_displayed)

                end
            end
            if miss_doc
                println("--------------------------------")
            end
        end    
    end
    return nothing
end

function checkMissingVarInfo()
    for sm in subtypes(LandEcosystem)
        for appr in subtypes(sm)
            if appr != LandEcosystem
                checkMissingVarInfo(appr)
            end
        end  
    end      
   return nothing
end 
```


----

### getUniqueVarNames
```@docs
getUniqueVarNames
```

 Code

```julia
function getUniqueVarNames(var_pairs)
    pure_vars = getVarName.(var_pairs)
    fields = getVarField.(var_pairs)
    uniq_vars = Symbol[]
    for i in eachindex(pure_vars)
        n_occur = sum(pure_vars .== pure_vars[i])
        var_i = pure_vars[i]
        if n_occur > 1
            var_i = Symbol(String(fields[i]) * "__" * String(pure_vars[i]))
        end
        push!(uniq_vars, var_i)
    end
    return uniq_vars
end
```


----

### getVarFull
```@docs
getVarFull
```

 Code

```julia
function getVarFull(var_pair)
    return Symbol(String(first(var_pair)) * "__" * String(last(var_pair)))
end
```


----

### getVariableInfo
```@docs
getVariableInfo
```

 Code

```julia
function getVariableInfo(vari_b, t_step="day")
    vname = getVarFull(vari_b)
    return getVariableInfo(vname, t_step)
end

function getVariableInfo(vari_b::Symbol, t_step="day")
    # Access Variables module safely - it may not be loaded during Processes.jl initialization
    catalog = try
        getfield(SindbadTEM, :Variables).sindbad_tem_variables
    catch
        # Return default info if Variables module is not yet loaded
        return Dict(
            "standard_name" => split(string(vari_b), "__")[2],
            "long_name" => "",
            "units" => "",
            "land_field" => split(string(vari_b), "__")[1],
            "description" => split(string(vari_b), "__")[2] * "_" * split(string(vari_b), "__")[1]
        )
    end
    default_info = try
        getfield(SindbadTEM, :Variables).defaultVariableInfo(true)
    catch
        # Return default info if Variables module is not yet loaded
        return Dict(
            "standard_name" => split(string(vari_b), "__")[2],
            "long_name" => "",
            "units" => "",
            "land_field" => split(string(vari_b), "__")[1],
            "description" => split(string(vari_b), "__")[2] * "_" * split(string(vari_b), "__")[1]
        )
    end
    default_keys = Symbol.(keys(default_info))
    o_varib = copy(default_info)
    if vari_b ∈ keys(catalog)
        var_info = catalog[vari_b]
        var_fields = keys(var_info)
        all_fields = Tuple(unique([default_keys..., var_fields...]))
        for var_field ∈ all_fields
            field_value = nothing
            if haskey(default_info, var_field)
                field_value = default_info[var_field]
            else
                field_value = var_info[var_field]
            end
            if haskey(var_info, var_field)
                var_prop = var_info[var_field]
                if !isnothing(var_prop) && length(var_prop) > 0
                    field_value = var_info[var_field]
                end
            end
            if var_field == :units
                if !isnothing(field_value)
                    field_value = replace(field_value, "time" => t_step)
                else
                    field_value = ""
                end
            end
            var_field_str = string(var_field)
            o_varib[var_field_str] = field_value
        end
    end
    if isempty(o_varib["standard_name"])
        o_varib["standard_name"] = split(string(vari_b), "__")[2]
    end
    if isempty(o_varib["description"])
        o_varib["description"] = split(string(vari_b), "__")[2] * "_" * split(string(vari_b), "__")[1]
    end
    return Dict(o_varib)
end
```


----

### whatIs
```@docs
whatIs
```

 Code

```julia
function whatIs end

function whatIs(var_name::String)
    @show var_name
    if startswith(var_name, "land")
        var_name = var_name[6:end]
    end
    var_field = string(split(var_name, ".")[1])
    var_sfield = string(split(var_name, ".")[2])
    var_full = getFullVariableKey(var_field, var_sfield)
    println("\nchecking $var_name as :$var_full in sindbad_tem_variables catalog...")
    checkDisplayVariableDict(var_full)
    return nothing
end

function whatIs(var_name::String)
    @show var_name
    if startswith(var_name, "land")
        var_name = var_name[6:end]
    end
    var_field = string(split(var_name, ".")[1])
    var_sfield = string(split(var_name, ".")[2])
    var_full = getFullVariableKey(var_field, var_sfield)
    println("\nchecking $var_name as :$var_full in sindbad_tem_variables catalog...")
    checkDisplayVariableDict(var_full)
    return nothing
end

function whatIs(var_name::Symbol)
    var_name = string(var_name)
    v_field = split(var_name, "__")[1]
    v_sfield = split(var_name, "__")[2]
    whatIs(string(v_field), string(v_sfield))
    return nothing
end

function whatIs(var_field::String, var_sfield::String)
    var_full = getFullVariableKey(var_field, var_sfield)
    println("\nchecking $var_field field and $var_sfield subfield as :$var_full in sindbad_tem_variables catalog...")
    checkDisplayVariableDict(var_full)
    return nothing
end

function whatIs(var_field::Symbol, var_sfield::Symbol)
    var_full = getFullVariableKey(string(var_field), string(var_sfield))
    println("\nchecking :$var_field field and :$var_sfield subfield as :$var_full in sindbad_tem_variables catalog...")
    checkDisplayVariableDict(var_full)
    return nothing
end
```


----

```@meta
CollapsedDocStrings = false
DocTestSetup= quote
using SindbadTEM.Variables
end
```
