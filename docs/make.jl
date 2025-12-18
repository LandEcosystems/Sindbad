using Pkg
cd(@__DIR__)
Pkg.activate(".")

# Ensure unregistered packages are available (for CI/CD)
# These packages are dependencies of Sindbad but not registered
unregistered_packages = [
    ("OmniTools", "https://github.com/LandEcosystems/OmniTools.jl.git"),
    ("ErrorMetrics", "https://github.com/LandEcosystems/ErrorMetrics.jl.git"),
    ("TimeSamplers", "https://github.com/LandEcosystems/TimeSamplers.jl.git"),
]

for (pkg_name, pkg_url) in unregistered_packages
    try
        # Try to load the package to see if it's available
        eval(Meta.parse("using $pkg_name"))
    catch
        @info "$pkg_name not available, adding from git..."
        Pkg.add(url = pkg_url, rev = "main")
    end
end

Pkg.instantiate()
Pkg.precompile()

using Sindbad

using InteractiveUtils
using DocumenterVitepress
using Documenter
using DocStringExtensions

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

DocumenterVitepress.deploydocs(; 
    repo = "github.com/LandEcosystems/Sindbad", # this must be the full URL!
    target = joinpath(@__DIR__, "build"), # this is where Vitepress stores its output
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true
)
