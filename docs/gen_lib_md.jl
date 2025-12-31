using Sindbad
using SindbadTEM
using OmniTools  # Needed for get_definitions function used in this script
using Sindbad.Simulation
using Sindbad.Setup
using Sindbad.DataLoaders
using Sindbad.MachineLearning
using Logging

packages_list = (:Sindbad, :SindbadTEM)
sindbad_modules = (:Types, :Setup, :DataLoaders, :Simulation, :ParameterOptimization, :MachineLearning, :Visualization)
sindbadTEM_modules = (:TEMTypes, :Utils, :Variables)
output_dir = joinpath(@__DIR__, "src/pages/code/api")
mkpath(output_dir)
lib_path = joinpath(@__DIR__, "../lib")

# Get source directories
sindbad_src_dir = dirname(pathof(Sindbad))
sindbadTEM_src_dir = dirname(pathof(SindbadTEM))

# Function to extract function code from a source file
# Returns all methods of the function
function extract_function_code(file_path::String, func_name::String)
    if !isfile(file_path)
        return nothing
    end
    
    code = read(file_path, String)
    lines = split(code, '\n')
    
    # Find all function definitions - look for "function func_name"
    # Escape special regex characters in function name
    escaped_name = escape_string(func_name, raw"\^$[]().*+?{}|")
    func_pattern = Regex("^\\s*function\\s+$escaped_name", "i")
    
    function_starts = Int[]
    for (i, line) in enumerate(lines)
        if occursin(func_pattern, line)
            push!(function_starts, i)
        end
    end
    
    if isempty(function_starts)
        return nothing
    end
    
    # Extract all methods
    all_methods = String[]
    for function_start in function_starts
        # Extract function body until matching 'end' at same or less indentation
        function_lines = String[]
        start_line = lines[function_start]
        start_indent_match = match(r"^(\s*)", start_line)
        base_indent = start_indent_match === nothing ? 0 : length(start_indent_match.captures[1])
        
        for i in function_start:length(lines)
            line = lines[i]
            push!(function_lines, line)
            
            # Check for 'end' at the same or less indentation (but not the first line)
            if i > function_start
                end_match = match(r"^(\s*)end\s*$", line)
                if end_match !== nothing
                    end_indent = length(end_match.captures[1])
                    if end_indent <= base_indent
                        break
                    end
                end
            end
        end
        
        method_code = join(function_lines, '\n')
        # Skip empty function declarations
        trimmed_code = strip(method_code)
        no_ws = replace(trimmed_code, r"\s" => "")
        is_empty_single = no_ws == "function$(func_name)end"
        
        non_empty_lines = [strip(l) for l in function_lines if !isempty(strip(l))]
        is_empty_two = length(non_empty_lines) == 2 && 
                      occursin(Regex("^function\\s+$escaped_name\\s*\$"), non_empty_lines[1]) &&
                      non_empty_lines[2] == "end"
        
        is_empty = is_empty_single || is_empty_two
        
        # Only include if not empty and has actual implementation
        if !is_empty && length(non_empty_lines) > 2
            push!(all_methods, method_code)
        end
    end
    
    if isempty(all_methods)
        return nothing
    end
    
    # Remove duplicates while preserving order
    unique_methods = String[]
    seen = Set{String}()
    for method in all_methods
        if !(method in seen)
            push!(unique_methods, method)
            push!(seen, method)
        end
    end
    
    # Return all unique methods joined together
    return join(unique_methods, "\n\n")
end

# Find which source file contains a function
function find_function_file(func_name::String, package_name::Symbol, module_name::Union{Symbol, Nothing}=nothing)
    # Map package names to their source directories
    package_dirs = Dict(
        :Sindbad => sindbad_src_dir,
        :SindbadTEM => sindbadTEM_src_dir,
        :Setup => joinpath(sindbad_src_dir, "Setup"),
        :DataLoaders => joinpath(sindbad_src_dir, "DataLoaders"),
        :ParameterOptimization => joinpath(sindbad_src_dir, "ParameterOptimization"),
        :Simulation => joinpath(sindbad_src_dir, "Simulation"),
        :MachineLearning => joinpath(sindbad_src_dir, "MachineLearning"),
        :Visualization => joinpath(sindbad_src_dir, "Visualization"),
        :Processes => joinpath(sindbadTEM_src_dir, "Processes"),
        :Types => sindbadTEM_src_dir,  # TEMTypes.jl is in src/
        :Utils => sindbadTEM_src_dir,   # TEMUtils.jl is in src/
        :Variables => sindbadTEM_src_dir,  # TEMVariables.jl is in src/
    )
    
    # If module_name is provided, use it; otherwise use package_name
    lookup_name = module_name !== nothing ? module_name : package_name
    src_dir = get(package_dirs, lookup_name, sindbad_src_dir)
    
    # Search all .jl files in the directory recursively
    for (root, dirs, files) in walkdir(src_dir)
        for file in files
            if endswith(file, ".jl")
                file_path = joinpath(root, file)
                if isfile(file_path)
                    code = read(file_path, String)
                    # Simple string search
                    search_pattern1 = "function $func_name"
                    search_pattern2 = "function $(func_name)("
                    if occursin(search_pattern1, code) || occursin(search_pattern2, code)
                        return file_path
                    end
                end
            end
        end
    end
    
    return nothing
end


# Helper function to generate documentation for a module
function generate_module_docs(module_path::String, module_expr::String, module_name::Symbol, package_name::Symbol)
    doc_path = joinpath(output_dir, "$(module_path).md")
    open(doc_path, "w") do o_file
        write(o_file, "```@docs\n$(module_expr)\n```\n")
        write(o_file, "## Functions\n\n")
        
        # Get the module
        the_package = getfield(Main, package_name)
        the_module = getfield(the_package, module_name)
        
        lib_functions = get_definitions(the_module, Function)
        if !isempty(lib_functions)
            foreach(lib_functions) do function_name
                write(o_file, "### $(function_name)\n")
                write(o_file, "```@docs\n$(function_name)\n```\n")
                
                # Add code section right after the docstring
                func_file = find_function_file(string(function_name), package_name, module_name)
                if func_file !== nothing
                    func_code = extract_function_code(func_file, string(function_name))
                    if func_code !== nothing && strip(func_code) != ""
                        write(o_file, "\n Code\n\n")
                        write(o_file, "```julia\n")
                        write(o_file, func_code)
                        write(o_file, "\n```\n\n")
                    end
                end
                
                write(o_file, "\n----\n\n")
            end
        end
        
        lib_methods = get_definitions(the_module, Method)
        if !isempty(lib_methods)
            write(o_file, "## Methods\n\n")
            foreach(lib_methods) do method_name
                write(o_file, "### $(method_name)\n")
                write(o_file, "```@docs\n$(method_name)\n```\n")
                
                # Add code section right after the docstring
                func_file = find_function_file(string(method_name), package_name, module_name)
                if func_file !== nothing
                    func_code = extract_function_code(func_file, string(method_name))
                    if func_code !== nothing && strip(func_code) != ""
                        write(o_file, "\n Code\n\n")
                        write(o_file, "```julia\n")
                        write(o_file, func_code)
                        write(o_file, "\n```\n\n")
                    end
                end
                
                write(o_file, "\n----\n\n")
            end
        end

        lib_types = get_definitions(the_module, Type)
        if !isempty(lib_types)
            write(o_file, "## Types\n\n")
            foreach(lib_types) do type_name
                write(o_file, "### $(type_name)\n")
                write(o_file, "```@docs\n$(type_name)\n```\n")
                write(o_file, "\n----\n\n")
            end
        end
        
        write(o_file, "```@meta\nCollapsedDocStrings = false\nDocTestSetup= quote\nusing $(package_name).$(module_name)\nend\n```\n")
    end
end

# Generate documentation for top-level packages
foreach(packages_list) do package_name
    doc_path = joinpath(output_dir, "$(package_name).md")
    open(doc_path, "w") do o_file
        write(o_file, "```@docs\n$(package_name)\n```\n")
        write(o_file, "## Functions\n\n")
        the_package = getfield(Main, package_name)
        lib_functions = get_definitions(the_package, Function)
        if !isempty(lib_functions)
            foreach(lib_functions) do function_name
                write(o_file, "### $(function_name)\n")
                write(o_file, "```@docs\n$(function_name)\n```\n")
                
                # Add code section right after the docstring
                func_file = find_function_file(string(function_name), package_name)
                if func_file !== nothing
                    func_code = extract_function_code(func_file, string(function_name))
                    if func_code !== nothing && strip(func_code) != ""
                        write(o_file, "\n Code\n\n")
                        write(o_file, "```julia\n")
                        write(o_file, func_code)
                        write(o_file, "\n```\n\n")
                    end
                end
                
                write(o_file, "\n----\n\n")
            end
        end
        lib_methods = get_definitions(the_package, Method)
        if !isempty(lib_methods)
            write(o_file, "## Methods\n\n")
            foreach(lib_methods) do method_name
                write(o_file, "### $(method_name)\n")
                write(o_file, "```@docs\n$(method_name)\n```\n")
                
                # Add code section right after the docstring
                func_file = find_function_file(string(method_name), package_name)
                if func_file !== nothing
                    func_code = extract_function_code(func_file, string(method_name))
                    if func_code !== nothing && strip(func_code) != ""
                        write(o_file, "\n Code\n\n")
                        write(o_file, "```julia\n")
                        write(o_file, func_code)
                        write(o_file, "\n```\n\n")
                    end
                end
                
                write(o_file, "\n----\n\n")
            end
        end

        lib_types = get_definitions(the_package, Type)
        if !isempty(lib_types)
            write(o_file, "## Types\n\n")
            foreach(lib_types) do type_name
                write(o_file, "### $(type_name)\n")
                write(o_file, "```@docs\n$(type_name)\n```\n")
                write(o_file, "\n----\n\n")
            end
        end
        write(o_file, "```@meta\nCollapsedDocStrings = false\nDocTestSetup= quote\nusing $(package_name)\nend\n```\n")
    end
end

# Generate documentation for Sindbad modules
foreach(sindbad_modules) do module_name
    module_path = "$(module_name)"
    module_expr = "Sindbad.$(module_name)"
    generate_module_docs(module_path, module_expr, module_name, :Sindbad)
end

# Helper function to generate documentation for a file (not a module)
function generate_file_docs(file_name::String, package_name::Symbol)
    # Remove .jl extension if present
    base_name = replace(file_name, ".jl" => "")
    doc_path = joinpath(output_dir, "$(base_name).md")
    
    # Find the file
    file_path = joinpath(sindbadTEM_src_dir, file_name)
    if !isfile(file_path)
        @warn "File not found: $(file_path)"
        return
    end
    
    # Read the file to extract exports
    file_content = read(file_path, String)
    
    # Extract exported names (functions, types, etc.)
    # Handle both single exports and grouped exports: export a, b, c
    export_pattern = r"^export\s+([\w\s,]+)"m
    exports = String[]
    for m in eachmatch(export_pattern, file_content)
        export_line = m.captures[1]
        # Split by comma and trim whitespace
        for item in split(export_line, ',')
            item = strip(item)
            if !isempty(item)
                push!(exports, item)
            end
        end
    end
    
    if isempty(exports)
        @warn "No exports found in $(file_name)"
        return
    end
    
    open(doc_path, "w") do o_file
        write(o_file, "# $(base_name)\n\n")
        write(o_file, "This file contains the following exports:\n\n")
        
        # Group by type (try to determine if it's a function or type)
        functions_list = String[]
        types_list = String[]
        
        the_package = getfield(Main, package_name)
        for export_name in exports
            try
                exported_item = getfield(the_package, Symbol(export_name))
                if isa(exported_item, Type)
                    push!(types_list, export_name)
                else
                    push!(functions_list, export_name)
                end
            catch
                # If we can't access it, try to infer from file content
                # Check if it's defined as a type (abstract type, struct, mutable struct, etc.)
                type_patterns = [
                    Regex("abstract\\s+type\\s+$(export_name)"),
                    Regex("struct\\s+$(export_name)"),
                    Regex("mutable\\s+struct\\s+$(export_name)"),
                    Regex("primitive\\s+type\\s+$(export_name)"),
                ]
                is_type = any(pattern -> occursin(pattern, file_content), type_patterns)
                
                if is_type
                    push!(types_list, export_name)
                else
                    push!(functions_list, export_name)
                end
            end
        end
        
        # Write functions section
        if !isempty(functions_list)
            write(o_file, "## Functions\n\n")
            foreach(functions_list) do func_name
                write(o_file, "### $(func_name)\n")
                write(o_file, "```@docs\n$(func_name)\n```\n")
                
                # Add code section - check in the specific file first
                func_file = file_path  # Use the file we're documenting
                func_code = extract_function_code(func_file, func_name)
                if func_code === nothing
                    # Fallback to general search
                    func_file = find_function_file(func_name, package_name)
                    if func_file !== nothing
                        func_code = extract_function_code(func_file, func_name)
                    end
                end
                
                if func_code !== nothing && strip(func_code) != ""
                    write(o_file, "\n Code\n\n")
                    write(o_file, "```julia\n")
                    write(o_file, func_code)
                    write(o_file, "\n```\n\n")
                end
                
                write(o_file, "\n----\n\n")
            end
        end
        
        # Write types section
        if !isempty(types_list)
            write(o_file, "## Types\n\n")
            foreach(types_list) do type_name
                write(o_file, "### $(type_name)\n")
                write(o_file, "```@docs\n$(type_name)\n```\n")
                write(o_file, "\n----\n\n")
            end
        end
        
        write(o_file, "```@meta\nCollapsedDocStrings = false\nDocTestSetup= quote\nusing $(package_name)\nend\n```\n")
    end
end

# Generate documentation for SindbadTEM modules
foreach(sindbadTEM_modules) do module_name
    # All sindbadTEM_modules are now Symbols (modules)
    module_path = "SindbadTEM.$(module_name)"
    module_expr = "SindbadTEM.$(module_name)"
    generate_module_docs(module_path, module_expr, module_name, :SindbadTEM)
end