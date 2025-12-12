export addToElem, @add_to_elem, addToEachElem, addVec
export getZix
export @pack_nt, @unpack_nt
export repElem, @rep_elem, repVec, @rep_vec
export setComponents
export setComponentFromMainPool, setMainFromComponentPool
export totalS

"""
    @add_to_elem

macro to add to an element of a vector or a static vector.    
    
# Example
```julia
helpers = (; pools =(;
        zeros=(; cOther = 0.0f0,),
        ones = (; cOther = 1.0f0 ))
        )
cOther = [100.0f0, 1.0f0]
# and then add 1.0f0 to the first element of cOther
@add_to_elem 1 ⇒ (cOther, 1, :cOther)
```    
"""
macro add_to_elem(outparams::Expr)
    @assert outparams.head == :call || outparams.head == :(=)
    @assert outparams.args[1] == :(⇒)
    @assert length(outparams.args) == 3
    lhs = esc(outparams.args[2])
    rhs = outparams.args[3]
    rhsa = rhs.args
    tar = esc(rhsa[1])
    indx = rhsa[2]
    hp_pool = rhsa[3]
    outCode = [
        Expr(:(=),
            tar,
            Expr(:call,
                addToElem,
                tar,
                lhs,
                esc(Expr(:., :(helpers.pools.zeros), hp_pool)),
                # esc(:(land.constants.z_zero)),
                esc(indx)))
    ]
    return Expr(:block, outCode...)
end

"""
    addToElem(v::SVector, Δv, v_zero, ind::Int)
    addToElem(v::AbstractVector, Δv, _, ind::Int)

# Arguments
- `v`: a StaticVector or AbstractVector
- `Δv`: the value to be added
- `v_zero`: a StaticVector of zeros
- `ind::Int`: the index of the element to be added

"""
function addToElem end

function addToElem(v::SVector, Δv, v_zero, ind::Int)
    n_0 = zero(first(v_zero))
    n_1 = one(first(v_zero))
    v_zero = v_zero .* n_0
    v_zero = Base.setindex(v_zero, n_1, ind)
    v = v .+ v_zero .* Δv
    return v
end

function addToElem(v::AbstractVector, Δv, _, ind::Int)
    v[ind] = v[ind] + Δv
    return v
end

"""
    addToEachElem(v::SVector, Δv:Real)
    addToEachElem(v::AbstractVector, Δv:Real)

add Δv to each element of v when v is a StaticVector or a Vector.

# Arguments
- `v`: a StaticVector or AbstractVector
- `Δv`: the value to be added to each element
"""
function addToEachElem end

function addToEachElem(v::SVector, Δv::Real)
    v = v .+ Δv
    return v
end

function addToEachElem(v::AbstractVector, Δv::Real)
    v .= v .+ Δv
    return v
end

"""
    addVec(v::SVector, Δv::SVector)
    addVec(v::AbstractVector, Δv::AbstractVector)

add Δv to v when v is a StaticVector or a Vector.

# Arguments
- `v`: a StaticVector or AbstractVector
- `Δv`: a StaticVector or AbstractVector
"""
function addVec end

function addVec(v::SVector, Δv::SVector)
    v = v + Δv
    return v
end

function addVec(v::AbstractVector, Δv::AbstractVector)
    v .= v .+ Δv
    return v
end


"""
    getZix(dat::SubArray)
    getZix(dat::SubArray, zixhelpersPool)
    getZix(dat::Array, zixhelpersPool)
    getZix(dat::SVector, zixhelpersPool)

returns the indices of a view for a subArray

"""
function getZix end

function getZix(dat::SubArray)
    return Tuple(first(parentindices(dat)))
end

function getZix(dat::SubArray, zixhelpersPool)
    return Tuple(first(parentindices(dat)))
end

function getZix(dat::Array, zixhelpersPool)
    return zixhelpersPool
end

function getZix(dat::SVector, zixhelpersPool)
    return zixhelpersPool
end

"""
    @pack_nt

macro to pack variables into a named tuple.

# Example
```julia
@pack_nt begin
    (a, b) ⇒ land.diagnostics
    (c, d, f) ⇒ land.fluxes
end
# or 
@pack_nt (a, b) ⇒ land.diagnostics
# or 
@pack_nt a ⇒ land.diagnostics
```
"""
macro pack_nt(outparams)
    @assert outparams.head == :block || outparams.head == :call || outparams.head == :(=)
    if outparams.head == :block
        outputs = processPackNT.(filter(i -> isa(i, Expr), outparams.args))
        outCode = Expr(:block, outputs...)
    else
        outCode = processPackNT(outparams)
    end
    return outCode
end

"""
    processPackNT(ex)


"""
function processPackNT(ex)
    rename, ex = if ex.head == :(=)
        ex.args[1], ex.args[2]
    else
        nothing, ex
    end
    @assert ex.head == :call
    @assert ex.args[1] == :(⇒)
    @assert length(ex.args) == 3
    lhs = ex.args[2]
    rhs = ex.args[3]
    if lhs isa Symbol
        #println("symbol")
        lhs = [lhs]
    elseif lhs.head == :tuple
        #println("tuple")
        lhs = lhs.args
    else
        error("processPackNT: could not pack:" * lhs * "=" * rhs)
    end
    if rename === nothing
        rename = lhs
    elseif rename isa Expr && rename.head == :tuple
        rename = rename.args
    end
    lines = broadcast(lhs, rename) do s, rn
        depth_field = length(findall(".", string(esc(rhs)))) + 1
        if depth_field == 1
            expr_l = Expr(:(=),
                esc(rhs),
                Expr(:tuple,
                    Expr(:parameters, Expr(:(...), esc(rhs)),
                        Expr(:kw, esc(s), esc(rn)))))
            # expr_l = Expr(:(=), esc(rhs), Expr(:tuple, Expr(:parameters, Expr(:(...), esc(rhs)), Expr(:(=), esc(s), esc(rn)))))
            expr_l
        elseif depth_field == 2
            top = Symbol(split(string(rhs), '.')[1])
            field = Symbol(split(string(rhs), '.')[2])
            tmp = Expr(:(=),
                esc(top),
                Expr(:tuple,
                    Expr(:(...), esc(top)),
                    Expr(:(=),
                        esc(field),
                        (Expr(:tuple,
                            Expr(:parameters, Expr(:(...), esc(rhs)),
                                Expr(:kw, esc(s), esc(rn))))))))
            # tmp = Expr(:(=), esc(top), Expr(:macrocall, Symbol("@set"), :(#= none:1 =#), Expr(:(=), Expr(:ref, Expr(:ref, esc(top), QuoteNode(field)), QuoteNode(s)), esc(rn))))
            tmp
        end
    end
    return Expr(:block, lines...)
end

"""
    processUnpackNT(ex)


"""
function processUnpackNT(ex)
    rename, ex = if ex.head == :(=)
        ex.args[1], ex.args[2]
    else
        nothing, ex
    end
    @assert ex.head == :call
    @assert ex.args[1] == :(⇐)
    @assert length(ex.args) == 3
    lhs = ex.args[2]
    rhs = ex.args[3]
    if lhs isa Symbol
        lhs = [lhs]
    elseif lhs.head == :tuple
        lhs = lhs.args
    else
        error("processUnpackNT: could not unpack:" * lhs * "=" * rhs)
    end
    if rename === nothing
        rename = lhs
    elseif rename isa Expr && rename.head == :tuple
        rename = rename.args
    end
    lines = broadcast(lhs, rename) do s, rn
        return Expr(:(=), esc(rn), Expr(:(.), esc(rhs), QuoteNode(s)))
    end
    return Expr(:block, lines...)
end

"""
    @rep_elem
macro to replace an element of a vector or a static vector.

# Example
```julia
helpers = (; pools =(;
        zeros=(; cOther = 0.0f0,),
        ones = (; cOther = 1.0f0 ))
        )
cOther = [100.0f0, 1.0f0]
# and then replace the first element of cOther with 1.0f0
@rep_elem 1 ⇒ (cOther, 1, :cOther) 
```
"""
macro rep_elem(outparams::Expr)
    @assert outparams.head == :call || outparams.head == :(=)
    @assert outparams.args[1] == :(⇒)
    @assert length(outparams.args) == 3
    lhs = esc(outparams.args[2])
    rhs = outparams.args[3]
    rhsa = rhs.args
    tar = esc(rhsa[1])
    indx = rhsa[2]
    hp_pool = rhsa[3]
    outCode = [
        Expr(:(=),
            tar,
            Expr(:call,
                repElem,
                tar,
                lhs,
                esc(Expr(:., :(helpers.pools.zeros), hp_pool)),
                esc(Expr(:., :(helpers.pools.ones), hp_pool)),
                esc(indx)))
    ]
    return Expr(:block, outCode...)
end

"""
    repElem(v::AbstractVector, v_elem, _, _, ind::Int)
    repElem(v::SVector, v_elem, v_zero, v_one, ind::Int)

# Arguments
- `v`: a StaticVector or AbstractVector
- `v_elem`: the value to be replaced with
- `v_zero`: a StaticVector of zeros
- `v_one`: a StaticVector of ones
- `ind::Int`: the index of the element to be replaced
"""
function repElem end

function repElem(v::AbstractVector, v_elem, _, _, ind::Int)
    v[ind] = v_elem
    return v
end

function repElem(v::SVector, v_elem, v_zero, v_one, ind::Int)
    n_0 = zero(first(v_zero))
    n_1 = one(first(v_zero))
    v_zero = v_zero .* n_0
    v_zero = Base.setindex(v_zero, n_1, ind)
    v_one = v_one .* n_0 .+ n_1
    v_one = Base.setindex(v_one, n_0, ind)
    v = v .* v_one .+ v_zero .* v_elem
    # v = Base.setindex(v, v_elem, vlit_level)
    return v
end

"""
    @rep_vec
macro to replace a vector or a static vector with a new value.

# Example
```julia
_vec = [100.0f0, 2.0f0]
# and then replace the vector with 1.0f0
@rep_vec _vec ⇒ 1.0f0
# or with a new vector
@rep_vec _vec ⇒ [3.0f0, 2.0f0]

```
"""
macro rep_vec(outparams::Expr)
    @assert outparams.head == :call || outparams.head == :(=)
    @assert outparams.args[1] == :(⇒)
    @assert length(outparams.args) == 3
    lhs = esc(outparams.args[2])
    rhs = esc(outparams.args[3])
    outCode = [Expr(:(=), lhs, Expr(:call, repVec, lhs, rhs))]
    return Expr(:block, outCode...)
end

"""
    repVec(v::AbstractVector, v_new)
    repVec(v::SVector, v_new)

replaces the values of a vector with a new value

# Arguments:
- `v`: an AbstractVector or a StaticVector
- `v_new`: a new value to replace the old one

"""
function repVec end

function repVec(v::AbstractVector, v_new)
    v .= v_new
    return v
end

function repVec(v::SVector, v_new)
    n_0 = zero(first(v))
    v = v .* n_0 + v_new
    return v
end

"""
    setComponents(land, helpers, Val{s_main}, Val{s_comps}, Val{zix})

# Arguments:
- `land`: a core SINDBAD NT that contains all variables for a given time step that is overwritten at every timestep
- `helpers`: helper NT with necessary objects for model run and type consistencies
- `::Val{s_main}`: a NT with names of the main pools
- `::Val{s_comps}`: a NT with names of the component pools
- `::Val{zix}`: a NT with zix of each pool
"""
function setComponents(
    land,
    helpers,
    ::Val{s_main},
    ::Val{s_comps},
    ::Val{zix}) where {s_main,s_comps,zix}
    output = quote end
    push!(output.args, Expr(:(=), s_main, Expr(:., :(land.pools), QuoteNode(s_main))))
    foreach(s_comps) do s_comp
        push!(output.args, Expr(:(=), s_comp, Expr(:., :(land.pools), QuoteNode(s_comp))))
        zix_pool = getfield(zix, s_comp)
        c_ix = 1
        foreach(zix_pool) do ix
            push!(output.args, Expr(:(=),
                s_comp,
                Expr(:call,
                    rep_elem,
                    s_comp,
                    Expr(:ref, s_main, ix),
                    Expr(:., :(helpers.pools.zeros), QuoteNode(s_comp)),
                    Expr(:., :(helpers.pools.ones), QuoteNode(s_comp)),
                    :(land.constants.z_zero),
                    :(land.constants.o_one),
                    c_ix)))

            c_ix += 1
        end
        push!(output.args, Expr(:(=),
            :land,
            Expr(:tuple,
                Expr(:(...), :land),
                Expr(:(=),
                    :pools,
                    (Expr(:tuple,
                        Expr(:parameters, Expr(:(...), :(land.pools)),
                            Expr(:kw, s_comp, s_comp))))))))
    end
    return output
end


"""
    setComponentFromMainPool(land, helpers, Val{s_main}, Val{s_comps}, Val{zix})

- sets the component pools value using the values for the main pool
- name are generated using the components in helpers so that the model formulations are not specific for poolnames and are dependent on model structure.json


# Arguments:
- `land`: a core SINDBAD NT that contains all variables for a given time step that is overwritten at every timestep
- `helpers`: helper NT with necessary objects for model run and type consistencies
- `::Val{s_main}`: a NT with names of the main pools
- `::Val{s_comps}`: a NT with names of the component pools
- `::Val{zix}`: a NT with zix of each pool
"""
@generated function setComponentFromMainPool(
    # function setComponentFromMainPool(
    land,
    helpers,
    ::Val{s_main},
    ::Val{s_comps},
    ::Val{zix}) where {s_main,s_comps,zix}
    gen_output = quote end
    push!(gen_output.args, Expr(:(=), s_main, Expr(:., :(land.pools), QuoteNode(s_main))))
    foreach(s_comps) do s_comp
        push!(gen_output.args, Expr(:(=), s_comp, Expr(:., :(land.pools), QuoteNode(s_comp))))
        zix_pool = getfield(zix, s_comp)
        c_ix = 1
        foreach(zix_pool) do ix
            push!(gen_output.args, Expr(:(=),
                s_comp,
                Expr(:call,
                    rep_elem,
                    s_comp,
                    Expr(:ref, s_main, ix),
                    Expr(:., :(helpers.pools.zeros), QuoteNode(s_comp)),
                    Expr(:., :(helpers.pools.ones), QuoteNode(s_comp)),
                    :(land.constants.z_zero),
                    :(land.constants.o_one),
                    c_ix)))

            c_ix += 1
        end
        push!(gen_output.args, Expr(:(=),
            :land,
            Expr(:tuple,
                Expr(:(...), :land),
                Expr(:(=),
                    :pools,
                    (Expr(:tuple,
                        Expr(:parameters, Expr(:(...), :(land.pools)),
                            Expr(:kw, s_comp, s_comp))))))))
    end
    return gen_output
end


"""
    setMainFromComponentPool(land, helpers, Val{s_main}, Val{s_comps}, Val{zix})

- sets the main pool from the values of the component pools
- name are generated using the components in helpers so that the model formulations are not specific for poolnames and are dependent on model structure.json

# Arguments:
- `land`: a core SINDBAD NT that contains all variables for a given time step that is overwritten at every timestep
- `helpers`: helper NT with necessary objects for model run and type consistencies
- `::Val{s_main}`: a NT with names of the main pools
- `::Val{s_comps}`: a NT with names of the component pools
- `::Val{zix}`: a NT with zix of each pool
"""
@generated function setMainFromComponentPool(
    land,
    helpers,
    ::Val{s_main},
    ::Val{s_comps},
    ::Val{zix}) where {s_main,s_comps,zix}
    gen_output = quote end
    push!(gen_output.args, Expr(:(=), s_main, Expr(:., :(land.pools), QuoteNode(s_main))))
    foreach(s_comps) do s_comp
        push!(gen_output.args, Expr(:(=), s_comp, Expr(:., :(land.pools), QuoteNode(s_comp))))
        zix_pool = getfield(zix, s_comp)
        c_ix = 1
        foreach(zix_pool) do ix
            push!(gen_output.args, Expr(:(=),
                s_main,
                Expr(:call,
                    rep_elem,
                    s_main,
                    Expr(:ref, s_comp, c_ix),
                    Expr(:., :(helpers.pools.zeros), QuoteNode(s_main)),
                    Expr(:., :(helpers.pools.ones), QuoteNode(s_main)),
                    :(land.constants.z_zero),
                    :(land.constants.o_one),
                    ix)))
            c_ix += 1
        end
    end
    push!(gen_output.args, Expr(:(=),
        :land,
        Expr(:tuple,
            Expr(:(...), :land),
            Expr(:(=),
                :pools,
                (Expr(:tuple,
                    Expr(:parameters, Expr(:(...), :(land.pools)),
                        Expr(:kw, s_main, s_main))))))))
    return gen_output
end

"""
    totalS(s, sΔ)

return total storage amount given the storage and the current delta storage without creating an allocation for a temporary array
"""
function totalS(s, sΔ)
    sm = zero(eltype(s))
    for si ∈ eachindex(s)
        sm = sm + s[si] + sΔ[si]
    end
    return sm
end

"""
    totalS(s)

return total storage amount given the storage without creating an allocation for a temporary array
"""
function totalS(s)
    sm = zero(eltype(s))
    for si ∈ eachindex(s)
        sm = sm + s[si]
    end
    return sm
end


"""
    @unpack_nt

macro to unpack variables from a named tuple.

# Example

```julia
@unpack_nt (f1, f2) ⇐ forcing # named tuple
@unpack_nt var1 ⇐ land.diagnostics # named tuple
# or 
@unpack_nt begin
    (f1, f2) ⇐ forcing
    var1 ⇐ land.diagnostics
end
```
"""
macro unpack_nt(inparams)
    @assert inparams.head == :block || inparams.head == :call || inparams.head == :(=)
    if inparams.head == :block
        outputs = processUnpackNT.(filter(i -> isa(i, Expr), inparams.args))
        outCode = Expr(:block, outputs...)
    else
        outCode = processUnpackNT(inparams)
    end
    return outCode
end
