export addExtensionToFunction
export addExtensionToPackage
export addPackage


# ---------------------------------------------------------------------------
# addExtensionToFunction
# ---------------------------------------------------------------------------

"""
    addExtensionToFunction(function_to_extend::Function, external_package::String; extension_location::Symbol = :Folder) -> String

Create a folder-style Julia extension entry + include file scaffold for the given `function_to_extend`,
and ensure `Project.toml` contains the needed `[weakdeps]` and `[extensions]` mapping.

The include file name is:
- `<InnerModule><Cap(FunctionName)>.jl` when the function lives under a single inner module (e.g. `SimulationSpinup.jl`)
- otherwise `<RootPackage><Cap(FunctionName)>.jl` (e.g. `SindbadSpinup.jl`)

The generated include file contains:
- a short header docstring,
- a list of method signatures with repo-relative file paths,
- and a commented “example” method stub using common arg names and the most common last-arg type (best-effort).

This helper is conservative:
- If both entry and include already exist: errors (no overwrite).
- If entry exists but include missing: warns and creates only the include file.
- If include exists but entry missing: warns and creates the entry file including the existing include file (does not modify include).

## Example

```julia
include(joinpath(@__DIR__, "tmp_test_extension.jl"))
using .TmpTestExtension
using Sindbad

addExtensionToFunction(Sindbad.Simulation.spinup, "NLsolve"; extension_location=:Folder)
```
"""
function addExtensionToFunction(function_to_extend::Function, external_package::String; extension_location::Symbol = :Folder)
    logAction("addExtensionToFunction", "Starting (external_package=$(external_package), extension_location=$(extension_location))")

    local_module = parentmodule(function_to_extend)
    root_pkg = Base.moduleroot(local_module)
    root_pkg_name = String(nameof(root_pkg))
    ext_module_name = "$(root_pkg_name)$(external_package)Ext"

    root_path = pathof(root_pkg)
    isnothing(root_path) && error("Cannot locate package root for $(root_pkg). Ensure it is a package module with a valid `pathof`.")
    package_root = joinpath(dirname(root_path), "..")

    ext_dir = ensureExtDir(package_root)
    ext_path = extension_location === :File ? ext_dir :
               extension_location === :Folder ? ensureExtensionFolder(ext_dir, ext_module_name) :
               error("Invalid `extension_location=$(extension_location)`. Expected :File or :Folder.")

    # Inner module inference (single level)
    root_full = Base.fullname(root_pkg)
    fn_mod = parentmodule(function_to_extend)
    fn_full = Base.fullname(fn_mod)
    rel = (length(fn_full) > length(root_full) && fn_full[1:length(root_full)] == root_full) ? fn_full[length(root_full)+1:end] : ()
    inner = length(rel) == 1 ? String(rel[1]) : nothing

    fn_name = String(nameof(function_to_extend))
    cap_name = uppercasefirst(fn_name)
    codefile = isnothing(inner) ? "$(root_pkg_name)$(cap_name).jl" : "$(inner)$(cap_name).jl"

    entry_file = joinpath(ext_path, "$(ext_module_name).jl")
    code_path = joinpath(ext_path, codefile)
    entry_exists = isfile(entry_file)
    code_exists = isfile(code_path)

    # Method signature strings (dedup default-arg expansions + repo-relative paths)
    template_methods = getMethodSignatures(function_to_extend; path=:relative)
    # Arg name + last-arg type inference (best-effort)
    template_arg_names, template_last_arg_type = _inferCommonArgs(function_to_extend)

    if entry_exists && code_exists
        error("Both extension entry and include exist.\nEntry: $(entry_file)\nInclude: $(code_path)\nDelete the include file to regenerate it.")
    elseif entry_exists && !code_exists
        warnAction("addExtensionToFunction", "Entry exists but include is missing. Creating include only (no overwrite of entry).")
        createExtensionCode(ext_path, codefile; template=(;
            root_package_name=root_pkg_name,
            inner_module=inner,
            external_package_name=external_package,
            function_name=fn_name,
            methods=template_methods,
            arg_names=template_arg_names,
            last_arg_type=template_last_arg_type,
        ))
    elseif !entry_exists && code_exists
        warnAction("addExtensionToFunction", "Include exists but entry is missing. Creating entry that includes existing include (no changes to include).")
        createExtensionEntry(root_pkg_name, inner, external_package, ext_path, ext_module_name, codefile)
    else
        createExtensionEntry(root_pkg_name, inner, external_package, ext_path, ext_module_name, codefile)
        createExtensionCode(ext_path, codefile; template=(;
            root_package_name=root_pkg_name,
            inner_module=inner,
            external_package_name=external_package,
            function_name=fn_name,
            methods=template_methods,
            arg_names=template_arg_names,
            last_arg_type=template_last_arg_type,
        ))
    end

    ensureExtensionMapping(package_root, external_package, ext_module_name)
    logAction("addExtensionToFunction", "Done. Extension module name: $(ext_module_name)")
    return ext_module_name
end

# ---------------------------------------------------------------------------
# addExtensionToPackage
# ---------------------------------------------------------------------------

"""
    addExtensionToPackage(local_package::Module, external_package::String; extension_location::Symbol = :File) -> String

Register a Julia extension for `local_package`:
- create the extension entry file (`*Ext.jl`) with **no include**
- update `Project.toml` (`[weakdeps]` + `[extensions]`)

This does **not** create any include file scaffold; use [`addExtensionToFunction`](@ref) if you want that.
"""
function addExtensionToPackage(local_package::Module, external_package::String; extension_location::Symbol = :File)
    logAction("addExtensionToPackage", "Starting (external_package=$(external_package), extension_location=$(extension_location))")

    root_pkg = Base.moduleroot(local_package)
    root_pkg_name = String(nameof(root_pkg))
    ext_module_name = "$(root_pkg_name)$(external_package)Ext"

    root_path = pathof(root_pkg)
    isnothing(root_path) && error("Cannot locate package root for $(root_pkg). Ensure it is a package module with a valid `pathof`.")
    package_root = joinpath(dirname(root_path), "..")
    ext_dir = ensureExtDir(package_root)
    ext_path = extension_location === :File ? ext_dir :
               extension_location === :Folder ? ensureExtensionFolder(ext_dir, ext_module_name) :
               error("Invalid `extension_location=$(extension_location)`. Expected :File or :Folder.")

    # Optional single inner module name for import statement
    root_full = Base.fullname(root_pkg)
    local_full = Base.fullname(local_package)
    rel = (length(local_full) > length(root_full) && local_full[1:length(root_full)] == root_full) ? local_full[length(root_full)+1:end] : ()
    inner = length(rel) == 1 ? String(rel[1]) : nothing

    createExtensionEntry(root_pkg_name, inner, external_package, ext_path, ext_module_name, nothing)
    ensureExtensionMapping(package_root, external_package, ext_module_name)
    logAction("addExtensionToPackage", "Done. Extension module name: $(ext_module_name)")
    return ext_module_name
end



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
        @info "$the_package_to_add is already installed in $where_to_add. Nothing to do. Return to base environment at $from_where".
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


# ---------------------------------------------------------------------------
# createExtensionCode
# ---------------------------------------------------------------------------

"""
    createExtensionCode(ext_path::String, codefile::Union{Nothing,String}; template=nothing) -> Union{Nothing,String}

Create the include file if missing; errors if it already exists (no overwrite).
"""
function createExtensionCode(ext_path::String, codefile::Union{Nothing,String}; template::Union{Nothing,NamedTuple}=nothing)
    isnothing(codefile) && return nothing
    codepath = joinpath(ext_path, codefile)
    isfile(codepath) && error("Extension include file already exists: $(codepath)\nDelete it to regenerate.")

    logAction("createExtensionCode", "Creating include file: $(codepath)")
    open(codepath, "w") do io
        if isnothing(template)
            println(io, "# Extension code for $(codefile)")
            return
        end

        fn = get(template, :function_name, "unknown_function")
        root_pkg = get(template, :root_package_name, "LocalPackage")
        inner = get(template, :inner_module, nothing)
        ext_pkg = get(template, :external_package_name, "ExternalPkg")
        mlist = get(template, :methods, nothing)
        arg_names = get(template, :arg_names, nothing)
        last_arg_type = get(template, :last_arg_type, nothing)

        qualified_mod = isnothing(inner) ? root_pkg : "$(root_pkg).$(inner)"
        qualified_fn = "$(qualified_mod).$(fn)"

        println(io, "\"\"\"")
        println(io, "Extension methods for `$(qualified_fn)`.")
        println(io, "")
        println(io, "This file is included from the extension module and can use `$(ext_pkg)`.")
        println(io, "\"\"\"")
        println(io, "")
        println(io, "# Bring the target function into scope for adding methods. This should be done using `import` and not `using`.")
        if isnothing(inner)
            println(io, "import $(root_pkg): $(fn)")
        else
            println(io, "import $(root_pkg).$(inner): $(fn)")
        end
        println(io, "")

        println(io, "# get all the types needed to dispatch the function. These types should defined in a corresponding file in $(root_pkg) so that they can be used for dispatching and setup, if that were needed.")
        println(io, "# using $(root_pkg): A, b, c")
        println(io, "")


        if !isnothing(mlist)
            println(io, "# Example methods (for reference):")
            for m in mlist
                println(io, "# - $(m)")
            end
            println(io, "")
        end

        println(io, "# ------------------------------------------------------------------")
        println(io, "# Add your extension methods below. The Example is a tentative placeholder for the method signature and should be replaced with the actual method signature.")
        println(io, "")
        if !isnothing(arg_names) && !isnothing(last_arg_type) && length(arg_names) >= 1
            args = collect(String.(arg_names))
            last_name = args[end]
            prefix_args = length(args) > 1 ? join(args[1:end-1], ", ") * ", " : ""
            println(io, "# function $(fn)($(prefix_args)$(last_name)::$(last_arg_type); kwargs...)")
        else
            println(io, "# function $(fn)(args...; kwargs...)")
        end
        println(io, "#     # TODO: implement")
        println(io, "# end")
    end
    logAction("createExtensionCode", "Wrote: $(codepath)")
    return codepath
end

# ---------------------------------------------------------------------------
# createExtensionEntry
# ---------------------------------------------------------------------------

"""
    createExtensionEntry(main_package_name::String, inner_module::Union{Nothing,String}, extension_package_name::String, ext_path::String, ext_module_name::String, codefile::Union{Nothing,String}) -> String

Create the extension entry file (`<ExtModuleName>.jl`). Errors if it already exists (no overwrite).
"""
function createExtensionEntry(
    main_package_name::String,
    inner_module::Union{Nothing,String},
    extension_package_name::String,
    ext_path::String,
    ext_module_name::String,
    codefile::Union{Nothing,String},
)
    ext_file = joinpath(ext_path, "$(ext_module_name).jl")
    isfile(ext_file) && error("Extension entry file already exists: $(ext_file)\nDelete it to regenerate.")

    logAction("createExtensionEntry", "Creating extension entry file: $(ext_file)")

    extended_target = isnothing(inner_module) ? main_package_name : "$main_package_name.$inner_module"
    # Only emit the `import` in the entry file when we are NOT generating/including an extension code file.
    # If we are including an extension code file, that file is responsible for importing the function(s)
    # being extended (and any needed modules).
    import_stmt = if isnothing(codefile)
        isnothing(inner_module) ? "import $main_package_name" : "import $main_package_name: $inner_module"
    else
        ""
    end
    include_stmt = isnothing(codefile) ? "" : "include(\"$(codefile)\")"
    modify_stmt = isnothing(codefile) ? "" : "Modify the code in the \"$(codefile)\" file to extend the package."

    open(ext_file, "w") do io
        println(io, """
\"\"\"
    $(ext_module_name)

Julia extension module that enables $(extension_package_name) backends for `$(extended_target)`.

# Notes:
- This module is loaded automatically by Julia's package extension mechanism when $(extension_package_name) is available (see root `Project.toml` `[weakdeps]` + `[extensions]`).
- End users typically should not `using $(ext_module_name)` directly; instead `using $(main_package_name)` is sufficient once the weak dependency is installed.
- The extension code is included in the `ext/` directory and is automatically loaded when the extension package is installed.

$(modify_stmt)
\"\"\"
module $(ext_module_name)

    using $(extension_package_name)
    $(import_stmt)
    $(include_stmt)

end
""")
    end

    logAction("createExtensionEntry", "Wrote: $(ext_file)")
    return ext_file
end

# ---------------------------------------------------------------------------
# ensureExtDir / ensureExtensionFolder
# ---------------------------------------------------------------------------

"""
    ensureExtDir(package_root::String) -> String

Ensure `<package_root>/ext` exists.
"""
function ensureExtDir(package_root::String)
    ext_dir = joinpath(package_root, "ext")
    if !isdir(ext_dir)
        mkpath(ext_dir)
        logAction("ensureExtDir", "Created directory: $(ext_dir)")
    end
    return ext_dir
end

"""
    ensureExtensionFolder(ext_dir::String, ext_module_name::String) -> String

Ensure `ext/<ExtModuleName>/` exists.
"""
function ensureExtensionFolder(ext_dir::String, ext_module_name::String)
    ext_path = joinpath(ext_dir, ext_module_name)
    if !isdir(ext_path)
        mkpath(ext_path)
        logAction("ensureExtensionFolder", "Created directory: $(ext_path)")
    end
    return ext_path
end

# ---------------------------------------------------------------------------
# ensureExtensionMapping
# ---------------------------------------------------------------------------

"""
    ensureExtensionMapping(package_root::String, external_package::String, ext_module_name::String) -> Nothing

Ensure `Project.toml` includes `external_package` in `[weakdeps]` and maps
`ext_module_name = "external_package"` in `[extensions]`. May call `Pkg.add(...; target=:weakdeps)`.
"""
function ensureExtensionMapping(package_root::String, external_package::String, ext_module_name::String)
    project_file = joinpath(package_root, "Project.toml")
    project = TOML.parsefile(project_file)

    actions = String[]
    if !haskey(project, "extensions")
        project["extensions"] = Dict{String,Any}()
        push!(actions, "created [extensions] table")
    end

    # Remove reversed mapping if present
    if haskey(project["extensions"], external_package) && project["extensions"][external_package] == ext_module_name
        delete!(project["extensions"], external_package)
        push!(actions, "removed reversed mapping \"$external_package\" = \"$ext_module_name\"")
    end

    if haskey(project, "weakdeps") && haskey(project["weakdeps"], external_package)
        project["extensions"][ext_module_name] = external_package
        push!(actions, "set [extensions] \"$ext_module_name\" = \"$external_package\" (weakdep already present)")
    elseif haskey(project, "deps") && haskey(project["deps"], external_package)
        Pkg.activate(package_root)
        Pkg.remove(external_package)
        Pkg.add(external_package; target=:weakdeps)
        project = TOML.parsefile(project_file)
        project["extensions"][ext_module_name] = external_package
        push!(actions, "moved \"$external_package\" from [deps] → [weakdeps] via Pkg and set [extensions]")
    else
        Pkg.activate(package_root)
        Pkg.add(external_package; target=:weakdeps)
        project = TOML.parsefile(project_file)
        project["extensions"][ext_module_name] = external_package
        push!(actions, "added \"$external_package\" to [weakdeps] via Pkg and set [extensions]")
    end

    open(project_file, "w") do io
        TOML.print(io, project)
    end
    logAction("ensureExtensionMapping", "Updated $(project_file)")
    for a in actions
        logAction("ensureExtensionMapping", "- $(a)")
    end
    return nothing
end

# ---------------------------------------------------------------------------
# extensionCodeFilename
# ---------------------------------------------------------------------------

"""
    extensionCodeFilename(inner_module::Union{Nothing,String}, function_name::String) -> String

Return `<InnerModule><Cap(function_name)>.jl` or `<Cap(function_name)>.jl`.
"""
function extensionCodeFilename(inner_module::Union{Nothing,String}, function_name::String)
    cap = uppercasefirst(function_name)
    prefix = isnothing(inner_module) ? "" : inner_module
    return "$(prefix)$(cap).jl"
end

"""
    logAction(caller::AbstractString, message::AbstractString) -> Nothing

Print a standardized progress message.
"""
function logAction(caller::AbstractString, message::AbstractString)
    println("[$(caller)] $(message)")
    return nothing
end

# ---------------------------------------------------------------------------
# removeExtensionFromPackage
# ---------------------------------------------------------------------------

"""
    removeExtensionFromPackage(local_package::Module, external_package::String) -> String

Remove extension registration from `Project.toml` and attempt to remove `external_package` from the environment
(`Pkg.rm` + `Pkg.resolve`) so the `Manifest.toml` is updated. Prints a shell-mode command to delete the
entry file or folder under `ext/` (auto-detected).
"""
function removeExtensionFromPackage(local_package::Module, external_package::String)
    logAction("removeExtensionFromPackage", "Starting (external_package=$(external_package))")

    root_pkg = Base.moduleroot(local_package)
    root_pkg_name = String(nameof(root_pkg))
    ext_module_name = "$(root_pkg_name)$(external_package)Ext"

    root_path = pathof(root_pkg)
    isnothing(root_path) && error("Cannot locate package root for $(root_pkg).")
    package_root = joinpath(dirname(root_path), "..")
    ext_dir = joinpath(package_root, "ext")

    file_entry = joinpath(ext_dir, "$(ext_module_name).jl")
    folder_entry = joinpath(ext_dir, ext_module_name, "$(ext_module_name).jl")
    ext_folder = joinpath(ext_dir, ext_module_name)
    file_exists = isfile(file_entry)
    folder_exists = isfile(folder_entry)

    project_file = joinpath(package_root, "Project.toml")
    project = TOML.parsefile(project_file)

    if haskey(project, "extensions") && haskey(project["extensions"], ext_module_name)
        delete!(project["extensions"], ext_module_name)
        logAction("removeExtensionFromPackage", "Removed [extensions] mapping: $(ext_module_name) = \"$(external_package)\"")
    else
        warnAction("removeExtensionFromPackage", "No [extensions] mapping found for $(ext_module_name).")
    end
    if haskey(project, "extensions") && haskey(project["extensions"], external_package) && project["extensions"][external_package] == ext_module_name
        delete!(project["extensions"], external_package)
        logAction("removeExtensionFromPackage", "Removed reversed mapping: $(external_package) = \"$(ext_module_name)\"")
    end
    if haskey(project, "weakdeps") && haskey(project["weakdeps"], external_package)
        delete!(project["weakdeps"], external_package)
        logAction("removeExtensionFromPackage", "Removed [weakdeps] entry for $(external_package).")
    end
    if haskey(project, "deps") && haskey(project["deps"], external_package)
        delete!(project["deps"], external_package)
        warnAction("removeExtensionFromPackage", "Removed [deps] entry for $(external_package).")
    end

    open(project_file, "w") do io
        TOML.print(io, project)
    end
    logAction("removeExtensionFromPackage", "Wrote: $(project_file)")

    try
        Pkg.activate(package_root)
        try
            Pkg.rm(external_package)
            logAction("removeExtensionFromPackage", "Ran Pkg.rm(\"$(external_package)\") (Manifest updated).")
        catch
            warnAction("removeExtensionFromPackage", "Pkg.rm(\"$(external_package)\") failed (maybe not installed).")
        end
        try Pkg.resolve() catch end
    catch
        warnAction("removeExtensionFromPackage", "Pkg environment update failed; Manifest may be unchanged.")
    end

    if file_exists && folder_exists
        warnAction("removeExtensionFromPackage", "Both file- and folder-style entries exist. Remove one (or both):")
        warnAction("removeExtensionFromPackage", "  ; rm -f \"$(file_entry)\"")
        warnAction("removeExtensionFromPackage", "  ; rm -rf \"$(ext_folder)\"")
    elseif folder_exists
        warnAction("removeExtensionFromPackage", "Detected folder-style extension. Remove with:\n  ; rm -rf \"$(ext_folder)\"")
    elseif file_exists
        warnAction("removeExtensionFromPackage", "Detected file-style extension. Remove with:\n  ; rm -f \"$(file_entry)\"")
    else
        warnAction("removeExtensionFromPackage", "No extension entry found under ext/. Potential commands:")
        warnAction("removeExtensionFromPackage", "  ; rm -f \"$(file_entry)\"")
        warnAction("removeExtensionFromPackage", "  ; rm -rf \"$(ext_folder)\"")
    end

    logAction("removeExtensionFromPackage", "Done. Extension module name: $(ext_module_name)")
    return ext_module_name
end

# ---------------------------------------------------------------------------
# Internal helpers (not exported)
# ---------------------------------------------------------------------------

function _inferCommonArgs(f::Function)
    arg_name_counts = Dict{Int,Dict{String,Int}}()
    last_type_counts = Dict{String,Int}()
    for m in methods(f)
        sig = Base.unwrap_unionall(m.sig)
        types = sig.parameters[2:end]
        nargs = length(types)
        try
            ci = first(Base.code_lowered(f, Tuple{types...}))
            if length(ci.slotnames) >= nargs + 1
                for i in 1:nargs
                    nm = String(ci.slotnames[i+1])
                    if isempty(nm) || startswith(nm, "#")
                        nm = "arg$(i)"
                    end
                    pos = get!(arg_name_counts, i, Dict{String,Int}())
                    pos[nm] = get(pos, nm, 0) + 1
                end
            end
        catch
        end
        if nargs > 0
            lt = string(types[end])
            last_type_counts[lt] = get(last_type_counts, lt, 0) + 1
        end
    end

    common_arg_names = nothing
    if !isempty(arg_name_counts)
        maxpos = maximum(keys(arg_name_counts))
        common_arg_names = [begin
            d = get(arg_name_counts, i, Dict{String,Int}())
            isempty(d) ? "arg$(i)" : first(sort(collect(d), by=x->x[2], rev=true))[1]
        end for i in 1:maxpos]
    end
    common_last_type = isempty(last_type_counts) ? nothing : first(sort(collect(last_type_counts), by=x->x[2], rev=true))[1]
    return common_arg_names, common_last_type
end

"""
    warnAction(caller::AbstractString, message::AbstractString) -> Nothing

Emit a real Julia warning (via `Logging.@warn`) with a standardized message prefix.
"""
function warnAction(caller::AbstractString, message::AbstractString)
    @warn "[$(caller)] $(message)"
    return nothing
end
