export addPackage
export doNothing
export getMethodTypes
export getDefinitions
export methodsOf
export purpose
export showMethodsOf
export valToSymbol


"""
    addPackage(where_to_add, the_package_to_add)

Adds a specified Julia package to the environment of a given module or project.

# Arguments:
- `where_to_add`: The module or project where the package should be added.
- `the_package_to_add`: The name of the package to add.

# Behavior:
- Activates the environment of the specified module or project.
- Checks if the package is already installed in the environment.
- If the package is not installed:
  - Adds the package to the environment.
  - Removes the `Manifest.toml` file and reinstantiates the environment to ensure consistency.
  - Provides instructions for importing the package in the module.
- Restores the original environment after the operation.

# Notes:
- This function assumes that the `where_to_add` module or project is structured with a standard Julia project layout.
- It requires the `Pkg` module for package management, which is re-exported from core Sindbad.

# Example:
```julia
addPackage(MyModule, "DataFrames")
```
"""
function addPackage(where_to_add, the_package_to_add)

    from_where = dirname(Base.active_project())
    dir_where_to_add = joinpath(dirname(pathof(where_to_add)), "../")
    cd(dir_where_to_add)
    Pkg.activate(dir_where_to_add)
    is_installed = any(dep.name == the_package_to_add for dep in values(Pkg.dependencies()))

    if is_installed
        @info "$the_package_to_add is already installed in $where_to_add. Nothing to do. Return to base environment at $from_where"
    else

        Pkg.add(the_package_to_add)
        rm("Manifest.toml")
        Pkg.instantiate()
        @info "Added $(the_package_to_add) to $(where_to_add). Add the following to the imports in $(pathof(where_to_add)) with\n\nusing $(the_package_to_add)\n\n. You may need to restart the REPL/environment at $(from_where)."
    end
    cd(from_where)
    Pkg.activate(from_where)
    Pkg.resolve()
end



"""
    doNothing(dat)

Returns the input as is, without any modifications.

# Arguments:
- `dat`: The input data.

# Returns:
The same input data.
"""
function doNothing(_data)
    return _data
end


"""
    getMethodTypes(fn)

Retrieve the types of the arguments for all methods of a given function.

# Arguments
- `fn`: The function for which the method argument types are to be retrieved.

# Returns
- A vector containing the types of the arguments for each method of the function.

# Example
```julia
function example_function(x::Int, y::String) end
function example_function(x::Float64, y::Bool) end

types = getMethodTypes(example_function)
println(types) # Output: [Int64, Float64]
```
"""
function getMethodTypes(fn)
    # Get the method table for the function
    mt = methods(fn)
    # Extract the types of the first method
    method_types = map(m -> m.sig.parameters[2], mt)
    return method_types
end

"""
    methodsOf(T::Type; ds="", is_subtype=false, bullet=" - ")
    methodsOf(M::Module; the_type=Type, internal_only=true)

Display subtypes and their purposes for a type or module in a formatted way.

# Description
This function provides a hierarchical display of subtypes and their purposes for a given type or module. For types, it shows a tree-like structure of subtypes and their purposes. For modules, it shows all defined types and their subtypes.

# Arguments
- `T::Type`: The type whose subtypes should be displayed
- `M::Module`: The module whose types should be displayed
- `ds::String`: Delimiter string between entries (default: newline)
- `is_subtype::Bool`: Whether to include nested subtypes (default: false)
- `bullet::String`: Bullet point for each entry (default: " - ")
- `the_type::Type`: Type of objects to display in module (default: Type)
- `internal_only::Bool`: Whether to only show internal definitions (default: true)

# Returns
- A formatted string showing the hierarchy of subtypes and their purposes

# Examples
```julia
# Display subtypes of a type
methodsOf(LandEcosystem)

# Display with custom formatting
methodsOf(LandEcosystem; ds=", ", bullet=" * ")

# Display including nested subtypes
methodsOf(LandEcosystem; is_subtype=true)

# Display types in a module
methodsOf(Sindbad)

# Display specific types in a module
methodsOf(Sindbad; the_type=Function)
```

# Extended help
The output format for types is:
```
## TypeName
Purpose of the type

## Available methods/subtypes:
 - subtype1: purpose
 - subtype2: purpose
    - nested_subtype1: purpose
    - nested_subtype2: purpose
```

If no subtypes exist, it will show " - `None`".
"""
function methodsOf end

function methodsOf(T::Type; ds="\n", is_subtype=false, bullet=" - ", purpose_function=purpose)
    sub_types = subtypes(T)
    type_name = nameof(T)
    if !is_subtype
        ds *= "## $type_name\n$(purpose_function(T))\n\n"
        ds *= "## Available methods/subtypes:\n"
    end

    if isempty(sub_types) && !is_subtype
        ds *= " - `None`\n"
    else
        for sub_type in sub_types
            sub_type_name = nameof(sub_type)
            ds *= "$bullet `$(sub_type_name)`: $(purpose_function(sub_type)) \n"
            sub_sub_types = subtypes(sub_type)
            if !isempty(sub_sub_types)
                ds = methodsOf(sub_type; ds=ds, is_subtype=true, bullet="    " * bullet, purpose_function=purpose_function)
            end
        end
    end
    return ds
end

function methodsOf(M::Module; the_type=Type, internal_only=true, purpose_function=purpose)
    defined_types = getDefinitions(M, the_type, internal_only=internal_only)
    ds = "\n"
    foreach(defined_types) do defined_type
        M_type = getproperty(M, nameof(defined_type))
        M_subtypes = subtypes(M_type)
        is_subtype = isempty(M_subtypes)
        ds = is_subtype ? ds : ds * "\n"
        ds = methodsOf(M_type; ds=ds, is_subtype=is_subtype, bullet=" - ", purpose_function=purpose_function)
    end
    return ds
end



"""
    showMethodsOf(T)

Display the subtypes and their purposes of a type in a formatted way.

# Description
This function displays the hierarchical structure of subtypes and their purposes for a given type. It uses `methodsOf` internally to generate the formatted output and prints it to the console.

# Arguments
- `T`: The type whose subtypes and purposes should be displayed

# Returns
- `nothing`

# Examples
```julia
# Display subtypes of LandEcosystem
showMethodsOf(LandEcosystem)

# Display subtypes of a specific model type
showMethodsOf(ambientCO2)
```

# Extended help
The output format is the same as `methodsOf`, showing:
```
## TypeName
Purpose of the type

## Available methods/subtypes:
 - subtype1: purpose
 - subtype2: purpose
    - nested_subtype1: purpose
    - nested_subtype2: purpose
```

This function is a convenience wrapper around `methodsOf` that automatically prints the output to the console.
"""
function showMethodsOf(T; purpose_function=Base.Docs.doc)
    println(methodsOf(T, purpose_function=purpose_function))
    return nothing
end

"""
getDefinitions(a_module, what_to_get; internal_only=true)

Returns all defined (and optionally internal) objects in the SINDBAD framework.

# Arguments
- `a_module`: The module to search for defined things
- `what_to_get`: The type of things to get (e.g., Type, Function)
- `internal_only`: Whether to only include internal definitions (default: true)

# Returns
- An array of all defined things in the SINDBAD framework

# Example
```julia
# Get all defined types in the SINDBAD framework
defined_types = getDefinitions(SindbadTEM, Type)
```
"""
function getDefinitions(a_module, what_to_get; internal_only=true)
    all_defined_things = filter(x -> isdefined(a_module, x) && isa(getproperty(a_module, x), what_to_get), names(a_module))
    defined_things = all_defined_things
    if internal_only
        defined_things = []
        for d_thing in all_defined_things
            d = getproperty(a_module, d_thing)
            d_parent = parentmodule(d)
            if nameof(d_parent) == nameof(a_module)
                push!(defined_things, d)
            end
        end
    end
    return defined_things
end



"""
    purpose(T::Type)

Returns a string describing the purpose of a type in the SINDBAD framework.

# Description
- This is a base function that should be extended by each package for their specific types.
- When in SINDBAD models, purpose is a descriptive string that explains the role or functionality of the model or approach within the SINDBAD framework. If the purpose is not defined for a specific model or approach, it provides guidance on how to define it.
- When in SINDBAD lib, purpose is a descriptive string that explains the dispatch on the type for the specific function. For instance, metricTypes.jl has a purpose for the types of metrics that can be computed.


# Arguments
- `T::Type`: The type whose purpose should be described

# Returns
- A string describing the purpose of the type
    
# Example
```julia
# Define the purpose for a specific model
purpose(::Type{BayesOptKMaternARD5}) = "Bayesian Optimization using Matern 5/2 kernel with Automatic Relevance Determination from BayesOpt.jl"

# Retrieve the purpose
println(purpose(BayesOptKMaternARD5))  # Output: "Bayesian Optimization using Matern 5/2 kernel with Automatic Relevance Determination from BayesOpt.jl"
```
"""
function purpose end

purpose(T) = "Undefined purpose for $(nameof(T)) of type $(typeof(T)). Add `purpose(::Type{$(nameof(T))}) = \"the_purpose\"` in appropriate function/type definition file."



"""
    valToSymbol(val)

Returns the symbol corresponding to the type of the input value.

# Arguments:
- `val`: The input value.

# Returns:
A `Symbol` representing the type of the input value.
"""
function valToSymbol(val)
    return typeof(val).parameters[1]
end