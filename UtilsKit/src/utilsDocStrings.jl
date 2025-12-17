
export loopWriteTypeDocString
export writeTypeDocString
export getTypeDocString

"""
    getTypeDocString(T::Type)

Generate a docstring for a type in a formatted way.

# Description
This function generates a formatted docstring for a type, including its purpose and type hierarchy.

# Arguments
- `T`: The type for which the docstring is to be generated 

# Returns
- A string containing the formatted docstring for the type.

"""
function getTypeDocString(T::Type; purpose_function=purpose)
    doc_string = ""
    doc_string *= "\n# $(nameof(T))\n\n"
    doc_string *= "$(purpose_function(T))\n\n"
    doc_string *= "## Type Hierarchy\n\n"
    doc_string *= "```$(join(nameof.(supertypes(T)), " <: "))```\n\n"
    sub_types = subtypes(T)
    if length(sub_types) > 0
        doc_string *= "-----\n\n"
        doc_string *= "# Extended help\n\n"
        doc_string *= "## Available methods/subtypes:\n"
        doc_string *= "$(methodsOf(T, is_subtype=true, purpose_function=purpose_function))\n\n"
    end
    return doc_string
end

"""
    writeTypeDocString(o_file, T)

Write a docstring for a type to a file.

# Description
This function writes a docstring for a type to a file.

# Arguments
- `o_file`: The file to write the docstring to
- `T`: The type for which the docstring is to be generated

# Returns
- `o_file`: The file with the docstring written to it

"""
function writeTypeDocString(o_file, T; purpose_function=purpose)
    doc_string = base_doc(T)
    if startswith(string(doc_string), "No documentation found for public symbol")
       write(o_file, "@doc \"\"\"\n$(getTypeDocString(T, purpose_function=purpose_function))\n\"\"\"\n")
    #    write(o_file, "$(nameof(T))\n\n")
       write(o_file, "$(T)\n\n")
    # else
        # write(o_file, "$(T)\n\n")
        # println("Doc string already exists for $(T), $(doc_string)")
    end
    return o_file
 end

"""
    loopWriteTypeDocString(o_file, T)

Write a docstring for a type to a file.

# Description
This function writes a docstring for a type to a file.

# Arguments
- `o_file`: The file to write the docstring to
- `T`: The type for which the docstring is to be generated

# Returns
- `o_file`: The file with the docstring written to it

"""
 function loopWriteTypeDocString(o_file, T; purpose_function=purpose)
    writeTypeDocString(o_file, T, purpose_function=purpose_function)
    sub_types = subtypes(T)
    for sub_type in sub_types
       o_file = loopWriteTypeDocString(o_file, sub_type, purpose_function=purpose_function)
    end
    return o_file
 end

