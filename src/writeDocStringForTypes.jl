using Sindbad: SindbadTypes
using Sindbad: subtypes
using UtilsKit: writeTypeDocString
using UtilsKit: loopWriteTypeDocString
using UtilsKit: purpose

# include doc strings for all types in Types
    ds_file = joinpath(@__DIR__, "Types/docStringForTypes.jl")
    println("Writing doc strings for types to $ds_file")
    loc_types = subtypes(SindbadTypes)
    println("Found $(length(loc_types)) types to write doc strings for")
    open(ds_file, "a") do o_file
      writeTypeDocString(o_file, SindbadTypes, purpose_function=purpose)
      for T in loc_types
          o_file = loopWriteTypeDocString(o_file, T, purpose_function=purpose)
          println("Wrote doc string for $T")
      end
    end
    println("Included $ds_file")
    include(ds_file)
 