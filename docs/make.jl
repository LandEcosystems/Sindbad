using Pkg
cd(@__DIR__)
Pkg.activate(".")

# Ecosystem dependencies are registered; instantiate normally.
Pkg.instantiate()
Pkg.precompile()

using Sindbad

using InteractiveUtils
using DocumenterVitepress
using Documenter
using DocStringExtensions

# Generate documentation files
include("gen_models_md.jl")
include("gen_lib_md.jl")
include("gen_ext_md.jl")

makedocs(; sitename="Sindbad",
    authors="Sindbad Development Team",
    clean=true,
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/LandEcosystems/Sindbad",
    ),
    remotes=nothing,
    draft=false,
    warnonly=true,
    source="src",
    build="build",
    )

final_site_dir = joinpath(@__DIR__,"build/final_site/")
if !isdir(final_site_dir)
    final_site_dir = joinpath(@__DIR__,"build/1/")
end

if !isdir(joinpath(final_site_dir, "/pages/concept/sindbad_info"))
    cp(joinpath(@__DIR__,"src/pages/concept/sindbad_info"), joinpath(final_site_dir, "pages/concept/sindbad_info"); force=true)
end

#
# Deployment
#
# Avoid attempting to deploy during local builds. Deploy explicitly by setting:
# - CI=true (typical in GitHub Actions), or
# - SINDBAD_DOCS_DEPLOY=true
#
should_deploy = get(ENV, "CI", "false") == "true" || get(ENV, "SINDBAD_DOCS_DEPLOY", "false") == "true"

if should_deploy
    DocumenterVitepress.deploydocs(; 
        repo = "github.com/LandEcosystems/Sindbad", # this must be the full URL!
        target = joinpath(@__DIR__, "build"), # this is where Vitepress stores its output
        branch = "gh-pages",
        devbranch = "main",
        push_preview = true
    )
end
