using Pkg

# Generate docs pages for Sindbad extensions (weakdeps)
#
# Output:
# - docs/src/pages/code/api/extensions/index.md
# - docs/src/pages/code/api/extensions/<ExtName>.md
#
# This is intentionally "fully generated": no hand-written extension pages.

function parse_extensions_from_project(project_toml_path::String)
    project_txt = read(project_toml_path, String)
    # Very small TOML parse without bringing an extra dependency into docs env:
    # Find the [extensions] section and read `Name = "Pkg"` pairs until next [section].
    lines = split(project_txt, '\n')
    in_ext = false
    ext_map = Dict{String, String}()
    for line in lines
        s = strip(line)
        isempty(s) && continue
        startswith(s, "#") && continue
        if startswith(s, "[") && endswith(s, "]")
            in_ext = s == "[extensions]"
            continue
        end
        if in_ext
            # e.g. SindbadZygoteExt = "Zygote"
            if occursin('=', s)
                k, v = strip.(split(s, "=", limit=2))
                v = strip(v, ['"', ' '])
                ext_map[k] = v
            end
        end
    end
    return ext_map
end

function generate_extension_docs()
    repo_root = normpath(joinpath(@__DIR__, ".."))
    project_toml = joinpath(repo_root, "Project.toml")
    ext_root = joinpath(repo_root, "ext")
    out_dir = joinpath(@__DIR__, "src/pages/code/api/extensions")
    mkpath(out_dir)

    ext_map = parse_extensions_from_project(project_toml)
    ext_names = sort(collect(keys(ext_map)))

    # Index page
    open(joinpath(out_dir, "index.md"), "w") do io
        write(io, "# Extensions\n\n")
        write(io, "This section is auto-generated from `Project.toml` `[extensions]` and the `ext/` folder.\n\n")
        write(io, "## Available extensions\n\n")
        for ext in ext_names
            write(io, "- [`$(ext)`]($(ext).md): enabled when `$(ext_map[ext])` is available\n")
        end
    end

    # Individual extension pages
    for ext in ext_names
        weakdep = ext_map[ext]
        ext_dir = joinpath(ext_root, ext)
        main_file = joinpath(ext_dir, "$(ext).jl")
        rel_main_file = isfile(main_file) ? relpath(main_file, repo_root) : nothing

        open(joinpath(out_dir, "$(ext).md"), "w") do io
            write(io, "# $(ext)\n\n")
            write(io, "**Trigger package**: `$(weakdep)`\n\n")
            write(io, "This extension is loaded automatically by Julia when `$(weakdep)` is available.\n\n")
            if rel_main_file !== nothing
                rel_url = replace(rel_main_file, "\\" => "/")
                write(io, "**Source**: [`$(rel_main_file)`](https://github.com/LandEcosystems/Sindbad/blob/main/$(rel_url))\n\n")
            end

            # List files in the extension folder (useful for navigation)
            if isdir(ext_dir)
                files = sort(filter(f -> endswith(f, ".jl"), readdir(ext_dir)))
                if !isempty(files)
                    write(io, "## Includes\n\n")
                    for f in files
                        rel_path = relpath(joinpath(ext_dir, f), repo_root)
                        rel_url = replace(rel_path, "\\" => "/")
                        write(io, "- [`$(f)`](https://github.com/LandEcosystems/Sindbad/blob/main/$(rel_url))\n")
                    end
                end
            end
        end
    end

    return nothing
end

generate_extension_docs()


