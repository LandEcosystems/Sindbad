```@docs
Sindbad
```
## Functions

### addExtensionToSindbad
```@docs
addExtensionToSindbad
```

:::details Code

```julia
  function addExtensionToSindbad(function_to_extend::Function, external_package::String)
    root_pkg = Base.moduleroot(parentmodule(function_to_extend))
    nameof(root_pkg) == :Sindbad || error("Expected a Sindbad function; got root package $(root_pkg).")
    return add_extension_to_function(function_to_extend, external_package; extension_location=:Folder)
  end
```

:::


----

```@meta
CollapsedDocStrings = false
DocTestSetup= quote
using Sindbad
end
```
