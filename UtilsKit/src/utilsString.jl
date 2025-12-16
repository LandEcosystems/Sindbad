export toUpperCaseFirst


"""
    toUpperCaseFirst(s::String, prefix="")

Converts the first letter of each word in a string to uppercase, removes underscores, and adds a prefix.

# Arguments:
- `s`: The input string.
- `prefix`: A prefix to add to the resulting string (default: "").

# Returns:
A `Symbol` with the transformed string.
"""
function toUpperCaseFirst(s::String, prefix="")
    return Symbol(prefix * join(uppercasefirst.(split(s,"_"))))
end
