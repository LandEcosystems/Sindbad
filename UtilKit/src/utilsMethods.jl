export doNothing
export getMethodTypes
export getDefinitions
export getMethodSignatures
export methodsOf
export printMethodSignatures
export purpose
export showMethodsOf
export valToSymbol


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



# ---------------------------------------------------------------------------
# getMethodSignatures / printMethodSignatures
# ---------------------------------------------------------------------------

"""
    getMethodSignatures(f::Function; path::Symbol = :relative_pwd) -> Vector{String}

Return method signature strings for `f`, including file/line information.
`path` controls how file paths are shown:
- `:relative_pwd` (default): paths relative to the current working directory (`pwd()`).
- `:relative_root`: paths relative to the root of the defining package.
- `:absolute`: absolute paths.

Default-arg wrapper methods are collapsed: for each unique `(file,line,module)` only the largest-arity method is kept.
"""
function getMethodSignatures(f::Function; path::Symbol = :relative_pwd)
    path in (:relative_pwd, :relative_root, :absolute) ||
        error("Invalid `path=$(path)`. Expected :relative_pwd, :relative_root, or :absolute.")
    root_pkg = Base.moduleroot(parentmodule(f))
    root_path = pathof(root_pkg)
    package_root = isnothing(root_path) ? nothing : normpath(joinpath(dirname(root_path), ".."))
    pwd_root = try
        pwd()
    catch
        nothing
    end

    selected = Dict{Tuple{Any,Int,Module},Method}()
    for m in methods(f)
        key = (m.file, m.line, m.module)
        nargs = length(Base.unwrap_unionall(m.sig).parameters) - 1
        if haskey(selected, key)
            prev = selected[key]
            prev_nargs = length(Base.unwrap_unionall(prev.sig).parameters) - 1
            if nargs > prev_nargs
                selected[key] = m
            end
        else
            selected[key] = m
        end
    end

    sigs = String[]
    for m in values(selected)
        sig = Base.unwrap_unionall(m.sig)
        types = sig.parameters[2:end]
        sig_str = string(nameof(f)) * "(" * join(("::" * string(t) for t in types), ", ") * ")"

        file_str = try
            String(m.file)
        catch
            ""
        end
        loc = ""
        if !isempty(file_str)
            abs_file = try
                abspath(Base.expanduser(file_str))
            catch
                file_str
            end
            shown = if path == :absolute
                abs_file
            elseif path == :relative_root
                if isnothing(package_root)
                    abs_file
                else
                    try
                        relpath(abs_file, package_root)
                    catch
                        abs_file
                    end
                end
            else # :relative_pwd
                if isnothing(pwd_root)
                    abs_file
                else
                    try
                        relpath(abs_file, pwd_root)
                    catch
                        abs_file
                    end
                end
            end
            loc = "$(shown):$(m.line)"
        end
        # Put the location first so terminals/editors are more likely to detect a clickable `path:line` link.
        # (Some linkifiers get confused when `::Type` annotations appear before the `path:line` segment.)
        if isempty(loc)
            push!(sigs, "$(sig_str) @ $(m.module)")
        else
            push!(sigs, "$(loc)  $(sig_str) @ $(m.module)")
        end
    end
    return sigs
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
    printMethodSignatures(f::Function; path::Symbol = :relative_pwd, io::IO = stdout, path_color::Symbol = :cyan) -> Nothing

Print method signatures as a bulleted list.

- The leading `path:line` segment (when present) is colored (defaults to `:cyan`).
- Uses [`getMethodSignatures`](@ref) under the hood.
"""
function printMethodSignatures(f::Function; path::Symbol = :relative_pwd, io::IO = stdout, path_color::Symbol = :cyan)
    for s in getMethodSignatures(f; path=path)
        parts = split(s, "  ", limit=2)
        if length(parts) == 2
            loc, rest = parts[1], parts[2]
            print(io, "- ")
            printstyled(io, loc; color=path_color, bold=true)
            println(io)
            println(io, "  ", rest)
        else
            println(io, "- ", s)
        end
    end
    return nothing
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