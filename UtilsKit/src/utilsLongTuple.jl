export LongTuple
export foldlLongTuple
export getTupleFromLongTuple
export makeLongTuple

"""
    LongTuple{NSPLIT,T}

A data structure that represents a tuple split into smaller chunks for better memory management and performance.

# Fields
- `data::T`: The underlying tuple data
- `n::Val{NSPLIT}`: The number of splits as a value type

# Type Parameters
- `NSPLIT`: The number of elements in each split
- `T`: The type of the underlying tuple
"""
struct LongTuple{NSPLIT,T <: Tuple}
    data::T
    n::Val{NSPLIT}
    function LongTuple{n}(arg::T) where {n,T<: Tuple}
        return new{n,T}(arg,Val{n}())
    end
    function LongTuple{n}(args...) where n
        s = length(args)
        nt = s ÷ n
        r = mod(s,n) # 5 for our current use case
        nt = r == 0 ? nt : nt + 1
        idx = 1
        tup = ntuple(nt) do i
            nn = r != 0 && i==nt ? r : n
            t = ntuple(x -> args[x+idx-1], nn)
            idx += nn
            return t
        end
        return new{n,typeof(tup)}(tup)
    end
end

Base.map(f, arg::LongTuple{N}) where N = LongTuple{N}(map(tup-> map(f, tup), arg.data))

@inline Base.foreach(f, arg::LongTuple) = foreach(tup-> foreach(f, tup), arg.data)

# Base.getindex(arg::LongTuple{N}, i::Int) where N = getindex(arg.data, (i-1) ÷ N + 1)[(i-1) % N + 1]
Base.getindex(arg::LongTuple{N}, i::Int) where N = begin
    total_elements = 0
    for (_, tup) in enumerate(arg.data)
        len = length(tup)
        if total_elements < i <= total_elements + len
            return tup[i - total_elements]
        end
        total_elements += len
    end
    throw(error("Index $i out of bounds for LongTuple. Total length is $total_elements."))
end


# TODO: inverse step range

Base.getindex(arg::LongTuple{N}, r::UnitRange{Int}) where N = begin
    selected_elements = []
    # Loop over the range
    for i in r
        tuple_idx = (i-1) ÷ N + 1        # Determine which tuple contains the element
        elem_idx = (i-1) % N + 1         # Determine the element's index within the tuple
        push!(selected_elements, arg.data[tuple_idx][elem_idx])
    end
    new_long_tuple = LongTuple{N}(selected_elements...)
    return new_long_tuple
end

Base.lastindex(arg::LongTuple{N}) where N = begin
    # Calculate the total number of elements across all inner tuples
    total_elements = sum(length(tup) for tup in arg.data)
    return total_elements
end

Base.firstindex(arg::LongTuple{N}) where N = 1

function Base.show(io::IO, arg::LongTuple{N}) where N
    printstyled(io, "LongTuple"; color=:bold)
    printstyled(io, ":"; color=:yellow)
    println(io)
    k_tuple = 1
    for (i, tup) in enumerate(arg.data)
        for (j, elem) in enumerate(tup)
            if k_tuple<10
                show_element(io, elem, "  $(k_tuple)  ↓ ")
            else
                show_element(io, elem, "  $(k_tuple) ↓ ")
            end
            k_tuple +=1
        end
    end
end

function show_element(io::IO, elem, indent)
    struct_name = nameof(typeof(elem))
    printstyled(io, indent; color=:light_black)
    printstyled(io, struct_name)
    printstyled(io, ":"; color=:blue)
    parameter_names = fieldnames(typeof(elem))
    l_params = length(parameter_names)
    printstyled(io, " with $(length(parameter_names))"; color=:light_cyan)
    if l_params==1
        printstyled(io, " parameter\n"; color=:light_black)
    else
        printstyled(io, " parameters\n"; color=:light_black)
    end
end


@generated function foldlLongTuple(f, x::LongTuple{NSPL,T}; init) where {T,NSPL}
    exes = []
    N = length(T.parameters)
    lastlength = length(last(T.parameters).parameters)
    for i in 1:N
        N2 = i==N ? lastlength : NSPL
        for j in 1:N2
            push!(exes, :(init = f(x.data[$i][$j], init)))
        end
    end
    return Expr(:block, exes...)
end


"""
    getTupleFromLongTuple(long_tuple)

Convert a LongTuple to a regular tuple.

# Arguments
- `long_tuple`: The input LongTuple

# Returns
- A regular tuple containing all elements from the LongTuple
"""
function getTupleFromLongTuple(long_tuple)
    emp_vec = []
    foreach(long_tuple) do lt
        push!(emp_vec, lt)
    end
    return Tuple(emp_vec)
end



"""
    makeLongTuple(normal_tuple; longtuple_size=5)

Create a LongTuple from a normal tuple.

# Arguments
- `normal_tuple`: The input tuple to convert
- `longtuple_size`: Size to break down the tuple into (default: 5)

# Returns
- A LongTuple containing the elements of the input tuple
"""
function makeLongTuple(normal_tuple::Tuple, longtuple_size=5)
    longtuple_size = min(length(normal_tuple), longtuple_size)
    LongTuple{longtuple_size}(normal_tuple...)
end


"""
    makeLongTuple(normal_tuple; longtuple_size=5)

# Arguments:
- `normal_tuple`: a normal tuple
- `longtuple_size`: size to break down the tuple into
"""
function makeLongTuple(long_tuple::LongTuple, longtuple_size=5)
    long_tuple
end