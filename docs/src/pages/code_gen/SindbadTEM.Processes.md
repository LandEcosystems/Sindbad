```@docs
SindbadTEM.Processes
```
## Functions

### @add_to_elem
```@docs
@add_to_elem
```

----

### @bounds
```@docs
@bounds
```

----

### @describe
```@docs
@describe
```

----

### @pack_nt
```@docs
@pack_nt
```

----

### @rep_elem
```@docs
@rep_elem
```

----

### @rep_vec
```@docs
@rep_vec
```

----

### @timescale
```@docs
@timescale
```

----

### @units
```@docs
@units
```

----

### @unpack_nt
```@docs
@unpack_nt
```

----

### addToEachElem
```@docs
addToEachElem
```

 Code

```julia
function addToEachElem end

function addToEachElem(v::SVector, Δv::Real)
    v = v .+ Δv
    return v
end

function addToEachElem(v::SVector, Δv::Real)
    v = v .+ Δv
    return v
end

function addToEachElem(v::AbstractVector, Δv::Real)
    v .= v .+ Δv
    return v
end
```


----

### addToElem
```@docs
addToElem
```

 Code

```julia
function addToElem end

function addToElem(v::SVector, Δv, v_zero, ind::Int)
    n_0 = zero(first(v_zero))
    n_1 = one(first(v_zero))
    v_zero = v_zero .* n_0
    v_zero = Base.setindex(v_zero, n_1, ind)
    v = v .+ v_zero .* Δv
    return v
end

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
```


----

### addVec
```@docs
addVec
```

 Code

```julia
function addVec end

function addVec(v::SVector, Δv::SVector)
    v = v + Δv
    return v
end

function addVec(v::SVector, Δv::SVector)
    v = v + Δv
    return v
end

function addVec(v::AbstractVector, Δv::AbstractVector)
    v .= v .+ Δv
    return v
end
```


----

### adjustPackPoolComponents
```@docs
adjustPackPoolComponents
```

 Code

```julia
function adjustPackPoolComponents(land, helpers, ::cCycleBase_GSI)
    @unpack_nt (cVeg,
        cLit,
        cSoil,
        cVegRoot,
        cVegWood,
        cVegLeaf,
        cVegReserve,
        cLitFast,
        cLitSlow,
        cSoilSlow,
        cSoilOld,
        cEco) ⇐ land.pools

    zix = helpers.pools.zix
    for (lc, l) in enumerate(zix.cVeg)
        @rep_elem cEco[l] ⇒ (cVeg, lc, :cVeg)
    end

    for (lc, l) in enumerate(zix.cVegRoot)
        @rep_elem cEco[l] ⇒ (cVegRoot, lc, :cVegRoot)
    end

    for (lc, l) in enumerate(zix.cVegWood)
        @rep_elem cEco[l] ⇒ (cVegWood, lc, :cVegWood)
    end

    for (lc, l) in enumerate(zix.cVegLeaf)
        @rep_elem cEco[l] ⇒ (cVegLeaf, lc, :cVegLeaf)
    end

    for (lc, l) in enumerate(zix.cVegReserve)
        @rep_elem cEco[l] ⇒ (cVegReserve, lc, :cVegReserve)
    end

    for (lc, l) in enumerate(zix.cLit)
        @rep_elem cEco[l] ⇒ (cLit, lc, :cLit)
    end

    for (lc, l) in enumerate(zix.cLitFast)
        @rep_elem cEco[l] ⇒ (cLitFast, lc, :cLitFast)
    end

    for (lc, l) in enumerate(zix.cLitSlow)
        @rep_elem cEco[l] ⇒ (cLitSlow, lc, :cLitSlow)
    end

    for (lc, l) in enumerate(zix.cSoil)
        @rep_elem cEco[l] ⇒ (cSoil, lc, :cSoil)
    end

    for (lc, l) in enumerate(zix.cSoilSlow)
        @rep_elem cEco[l] ⇒ (cSoilSlow, lc, :cSoilSlow)
    end

    for (lc, l) in enumerate(zix.cSoilOld)
        @rep_elem cEco[l] ⇒ (cSoilOld, lc, :cSoilOld)
    end
    @pack_nt (cVeg,
        cLit,
        cSoil,
        cVegRoot,
        cVegWood,
        cVegLeaf,
        cVegReserve,
        cLitFast,
        cLitSlow,
        cSoilSlow,
        cSoilOld,
        cEco) ⇒ land.pools
    return land
end
```


----

### bounds
```@docs
bounds
```

----

### computeTEM
```@docs
computeTEM
```

 Code

```julia
function computeTEM(tem_processes::Tuple, forcing, land, model_helpers, ::DoDebugModel) # debug the tem_processes
    otype = typeof(land)
    return foldl_tuple_unrolled(tem_processes; init=land) do _land, model
        println("compute: $(typeof(model))")
        @time _land = Processes.compute(model, forcing, _land, model_helpers)::otype
    end
end

function computeTEM(tem_processes::Tuple, forcing, land, model_helpers, ::DoNotDebugModel) # do not debug the tem_processes 
    return computeTEM(tem_processes, forcing, land, model_helpers) 
end

function computeTEM(tem_processes::LongTuple, forcing, _land, model_helpers) 
    return foldl_longtuple(tem_processes, init=_land) do model, _land
        Processes.compute(model, forcing, _land, model_helpers)
    end
end

function computeTEM(tem_processes::Tuple, forcing, land, model_helpers) 
    return foldl_tuple_unrolled(tem_processes; init=land) do _land, model
        _land = Processes.compute(model, forcing, _land, model_helpers)
    end
end
```


----

### definePrecomputeTEM
```@docs
definePrecomputeTEM
```

 Code

```julia
function definePrecomputeTEM(tem_processes::Tuple, forcing, land, model_helpers)
    return foldl_tuple_unrolled(tem_processes; init=land) do _land, model
        _land = Processes.define(model, forcing, _land, model_helpers)
        _land = Processes.precompute(model, forcing, _land, model_helpers)
    end
end

function definePrecomputeTEM(tem_processes::LongTuple, forcing, _land, model_helpers)
    return foldl_longtuple(tem_processes, init=_land) do model, _land
        _land = Processes.define(model, forcing, _land, model_helpers)
        _land = Processes.precompute(model, forcing, _land, model_helpers)
    end
end
```


----

### describe
```@docs
describe
```

----

### getApproachDocString
```@docs
getApproachDocString
```

 Code

```julia
    function getApproachDocString(appr)
        doc_string = "\n"

        doc_string *= "$(purpose(appr))\n\n"
        in_out_model = getInOutModel(appr, verbose=false)
        doc_string *= "# Parameters\n"
        params = in_out_model[:parameters]
        if length(params) == 0
            doc_string *= " -  None\n"
        else
            doc_string *= " - **Fields**\n"
            for (_, param) in enumerate(params)
                ds="     - `$(first(param))`: $(last(param))\n"
                doc_string *= ds
            end
        end

        # Methods
        d_methods = (:define, :precompute, :compute, :update)
        doc_string *= "\n# Methods:\n"
        undefined_str = ""
        for d_method in d_methods
            inputs = in_out_model[d_method][:input]
            outputs = in_out_model[d_method][:output]
            if length(inputs) == 0 && length(outputs) == 0
                undefined_str *= "$(d_method), "
                continue
            else
                doc_string *= "\n`$(d_method)`:\n"
            end
            doc_string *= "- **Inputs**\n"
            doc_string = getModelDocStringForIO(doc_string, inputs)
            doc_string *= "- **Outputs**\n"
            doc_string = getModelDocStringForIO(doc_string, outputs)
        end
        if length(undefined_str) > 0
            doc_string *= "\n`$(undefined_str[1:end-2])` methods are not defined\n"        
        end
        appr_name = string(nameof(appr))
        doc_string *= "\n*End of `getModelDocString`-generated docstring for `$(appr_name).jl`.\nCheck the Extended help for user-defined information.*"
        return doc_string
    end
```


----

### getZix
```@docs
getZix
```

 Code

```julia
function getZix end

function getZix(dat::SubArray)
    return Tuple(first(parentindices(dat)))
end

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
```


----

### precomputeTEM
```@docs
precomputeTEM
```

 Code

```julia
function precomputeTEM(tem_processes::Tuple, forcing, land, model_helpers, ::DoDebugModel) # debug the tem_processes
    otype = typeof(land)
    return foldl_tuple_unrolled(tem_processes; init=land) do _land, model
        println("precompute: $(typeof(model))")
        @time _land = Processes.precompute(model, forcing, _land, model_helpers)::otype
    end
end

function precomputeTEM(tem_processes::Tuple, forcing, land, model_helpers, ::DoNotDebugModel) # do not debug the tem_processes 
    return precomputeTEM(tem_processes, forcing, land, model_helpers) 
end

function precomputeTEM(tem_processes::LongTuple, forcing, _land, model_helpers)
    return foldl_longtuple(tem_processes, init=_land) do model, _land
        Processes.precompute(model, forcing, _land, model_helpers)
    end
end

function precomputeTEM(tem_processes::Tuple, forcing, land, model_helpers)
    return foldl_tuple_unrolled(tem_processes; init=land) do _land, model
        _land = Processes.precompute(model, forcing, _land, model_helpers)
    end
end
```


----

### repElem
```@docs
repElem
```

 Code

```julia
function repElem end

function repElem(v::AbstractVector, v_elem, _, _, ind::Int)
    v[ind] = v_elem
    return v
end

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
```


----

### repVec
```@docs
repVec
```

 Code

```julia
function repVec end

function repVec(v::AbstractVector, v_new)
    v .= v_new
    return v
end

function repVec(v::AbstractVector, v_new)
    v .= v_new
    return v
end

function repVec(v::SVector, v_new)
    n_0 = zero(first(v))
    v = v .* n_0 + v_new
    return v
end
```


----

### setComponentFromMainPool
```@docs
setComponentFromMainPool
```

----

### setComponents
```@docs
setComponents
```

 Code

```julia
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
```


----

### setMainFromComponentPool
```@docs
setMainFromComponentPool
```

----

### spin_cCycle_CASA
```@docs
spin_cCycle_CASA
```

 Code

```julia
function spin_cCycle_CASA(forcing, land, helpers, NI2E)
    @unpack_nt f_airT ⇐ forcing

    @unpack_nt begin
        cEco ⇐ land.pools
        (c_allocation, cEco, p_autoRespiration_km4su, p_cFlow_A, p_cTau_k) ⇐ land.history
        gpp ⇐ land.fluxes
        (p_giver, p_taker) ⇐ land.cFlow
        YG ⇐ land.diagnostics
        (z_zero, o_one) ⇐ land.constants
    end

    ## calculate variables
    # START fCt - final time series of pools
    fCt = cEco
    sCt = cEco
    # updated states / diagnostics & fluxessT = s
    dT = d
    fxT = fx
    # helpers
    nPix = 1
    nTix = info.helpers.sizes.nTix
    # matrices for the calculations
    cLossRate = zero(cEco)
    cGain = cLossRate
    cLoxxRate = cLossRate
    ## some debugging
    # if!isfield(land.history, "p_autoRespiration_km4su")
    # p_autoRespiration_km4su = cLossRate
    # end
    # if!isfield(p, "raAct")
    # p.autoRespiration.YG = 1.0
    # elseif!isfield(land.raAct, "YG")
    # p.autoRespiration.YG = 1.0
    # end
    ## ORDER OF CALCULATIONS [1 to the end of pools]
    zixVec = getZix(cEco, helpers.pools.zix.cEco)
    # BUT, we sort from left to right [veg to litter to soil] & prioritize
    # without loops
    kmoves = 0
    zixVecOrder = zixVec
    zixVecOrder_veg = []
    zixVecOrder_nonVeg = []
    for zix ∈ zixVec
        move = false
        ndxGainFrom = find(p_taker == zix)
        c_lose_to_zix = p_taker[p_giver==zix]
        for ii ∈ eachindex(ndxGainFrom)
            c_giver = p_giver[ndxGainFrom[ii]]
            if any(c_giver == c_lose_to_zix)
                move = true
                kmoves = kmoves + 1
            end
        end
        if move
            zixVecOrder[zixVecOrder==zix] = []
            zixVecOrder = [zixVecOrder zix]
        end
    end
    for zv ∈ zixVecOrder
        if any(zv == helpers.pools.zix.cVeg)
            zixVecOrder_veg = [zixVecOrder_veg zv]
        else
            zixVecOrder_nonVeg = [zixVecOrder_nonVeg zv]
        end
    end
    zixVecOrder = [zixVecOrder_veg zixVecOrder_nonVeg]
    # zixVecOrder = [2 1 3 4 5]
    # if kmoves > 0
    # zixVecOrder = [zixVecOrder zixVecOrder[end-kmoves+1:end]]
    # end
    ## solve it for each pool individually
    for zix ∈ zixVecOrder
        # general k loss
        cLossRate[zix, :] = clamp_zero_one(p_cTau_k[zix]) #1 replaced by 0.9999 to avoid having denom in line 140 > 0.
        # so that pools are not NaN
        if any(zix == helpers.pools.zix.cVeg)
            # additional losses [RA] in veg pools
            cLoxxRate[zix, :] = min(1.0 - p_autoRespiration_km4su[zix], 1)
            # gains in veg pools
            gppShp = reshape(gpp, nPix, 1, nTix) # could be fxT?
            cGain[zix, :] = c_allocation[zix, :] * gppShp * YG
        end
        if any(zix == p_taker)
            # no additional gains from outside
            if !any(zix == helpers.pools.zix.cVeg)
                cLoxxRate[zix, :] = 1.0
            end
            # gains from other carbon pools
            ndxGainFrom = find(p_taker == zix)
            for ii ∈ eachindex(ndxGainFrom)
                c_taker = p_taker[ndxGainFrom[ii]] # @nc : c_taker always has to be the same as zix c_giver = p_giver[ndxGainFrom[ii]]
                denom = (1.0 - cLossRate[c_giver, :])
                adjustGain = p_cFlow_A[c_taker, c_giver, :]
                adjustGain3D = reshape(adjustGain, nPix, 1, nTix)
                cGain[c_taker, :] =
                    cGain[c_taker, :] +
                    (fCt[c_giver, :] / denom) * cLossRate[c_giver, :] * adjustGain3D
            end
        end
        ## GET THE POOLS GAINS [Gt] AND LOSSES [Lt]
        # CALCULATE At = 1 - Lt
        At = squeeze((1.0 - cLossRate[zix, :]) * cLoxxRate[zix, :])
        #sujan 29.10.2019: the squeeze removes the first dimension while
        #running for a single point when nPix == 1
        if size(cLossRate, 1) == 1
            # At = At"; # commented out for julia compilation. make sure it works.
            # Bt = squeeze(cGain[zix, :])" * At; # commented out for julia compilation. make sure it works.
        else
            Bt = squeeze(cGain[zix, :]) * At
        end
        #sujan end squeeze fix
        # CARBON AT THE END FOR THE FIRST SPINUP PHASE; npp IN EQUILIBRIUM
        Co = cEco[zix]
        # THE NEXT LINES REPRESENT THE ANALYTICAL SOLUTION FOR THE SPIN UP
        # EXCEPT FOR THE LAST 3 POOLS: SOIL MICROBIAL; SLOW AND OLD. IN THIS
        # CASE SIGNIFICANT APPROXIMATION IS CALCULATED [CHECK NOTEBOOKS].
        piA1 = (prod(At, 2))^(NI2E)
        At2 = [At ones(size(At, 1), 1)]
        sumB_piA = NaN(size(f_airT))
        for ii ∈ 1:nTix
            sumB_piA[ii] = Bt[ii] * prod(At2[(ii+1):(nTix+1)], 2)
        end
        sumB_piA = sum(sumB_piA)
        T2 = 0:1:(NI2E-1)
        piA2 = (prod(At, 2) * ones(1, length(T2)))^(ones(size(At, 1), 1) * T2)
        piA2 = sum(piA2)
        # FINAL CARBON AT POOL zix
        Ct = Co * piA1 + sumB_piA * piA2
        sCt[zix] = Ct
        cEco[zix] = Ct
        cEco_prev[zix] = Ct
        # CREATE A YEARLY TIME SERIES OF THE POOLS EXCHANGE TO USE IN THE NEXT
        # POOLS CALCULATIONS
        out = runForward(selected_models, forcing, out, modelnames, helpers)
        # FEED fCt
        # fCt[zix, :] = cEco[zix, :]
        fCt = cEco
    end
    # make the fx consistent with the pools
    cEco = sCt
    cEco_prev = sCt
    out = runForward(selected_models, forcing, out, modelnames, helpers)

    ## pack land variables
    @pack_nt cEco ⇒ land.pools
    return land
end
```


----

### totalS
```@docs
totalS
```

 Code

```julia
function totalS(s, sΔ)
    sm = zero(eltype(s))
    for si ∈ eachindex(s)
        sm = sm + s[si] + sΔ[si]
    end
    return sm
end

function totalS(s)
    sm = zero(eltype(s))
    for si ∈ eachindex(s)
        sm = sm + s[si]
    end
    return sm
end
```


----

### units
```@docs
units
```

----

### unsatK
```@docs
unsatK
```

 Code

```julia
function unsatK(land, helpers, sl, ::kSaxton1986)
    @unpack_nt begin
        (st_clay, st_sand) ⇐ land.properties
        soil_layer_thickness ⇐ land.properties
        (n100, n1000, n2, n24, n3600, e1, e2, e3, e4, e5, e6, e7) ⇐ land.soilProperties
        soilW ⇐ land.pools
    end

    ## calculate variables
    clay = st_clay[sl] * n100
    sand = st_sand[sl] * n100
    soilD = soil_layer_thickness[sl]
    θ = soilW[sl] / soilD
    K = e1 * (exp(e2 + e3 * sand + (e4 + e5 * sand + e6 * clay + e7 * clay^n2) * (o_one / θ))) * n1000 * n3600 * n24

    ## pack land variables
    return K
end
```


----

## Types

### EVI
```@docs
EVI
```

----

### EVI_constant
```@docs
EVI_constant
```

----

### EVI_forcing
```@docs
EVI_forcing
```

----

### LAI
```@docs
LAI
```

----

### LAI_cVegLeaf
```@docs
LAI_cVegLeaf
```

----

### LAI_constant
```@docs
LAI_constant
```

----

### LAI_forcing
```@docs
LAI_forcing
```

----

### NDVI
```@docs
NDVI
```

----

### NDVI_constant
```@docs
NDVI_constant
```

----

### NDVI_forcing
```@docs
NDVI_forcing
```

----

### NDWI
```@docs
NDWI
```

----

### NDWI_constant
```@docs
NDWI_constant
```

----

### NDWI_forcing
```@docs
NDWI_forcing
```

----

### NIRv
```@docs
NIRv
```

----

### NIRv_constant
```@docs
NIRv_constant
```

----

### NIRv_forcing
```@docs
NIRv_forcing
```

----

### PET
```@docs
PET
```

----

### PET_Lu2005
```@docs
PET_Lu2005
```

----

### PET_PriestleyTaylor1972
```@docs
PET_PriestleyTaylor1972
```

----

### PET_forcing
```@docs
PET_forcing
```

----

### PFT
```@docs
PFT
```

----

### PFT_constant
```@docs
PFT_constant
```

----

### WUE
```@docs
WUE
```

----

### WUE_Medlyn2011
```@docs
WUE_Medlyn2011
```

----

### WUE_VPDDay
```@docs
WUE_VPDDay
```

----

### WUE_VPDDayCo2
```@docs
WUE_VPDDayCo2
```

----

### WUE_constant
```@docs
WUE_constant
```

----

### WUE_expVPDDayCo2
```@docs
WUE_expVPDDayCo2
```

----

### ambientCO2
```@docs
ambientCO2
```

----

### ambientCO2_constant
```@docs
ambientCO2_constant
```

----

### ambientCO2_forcing
```@docs
ambientCO2_forcing
```

----

### autoRespiration
```@docs
autoRespiration
```

----

### autoRespirationAirT
```@docs
autoRespirationAirT
```

----

### autoRespirationAirT_Q10
```@docs
autoRespirationAirT_Q10
```

----

### autoRespirationAirT_none
```@docs
autoRespirationAirT_none
```

----

### autoRespiration_Thornley2000A
```@docs
autoRespiration_Thornley2000A
```

----

### autoRespiration_Thornley2000B
```@docs
autoRespiration_Thornley2000B
```

----

### autoRespiration_Thornley2000C
```@docs
autoRespiration_Thornley2000C
```

----

### autoRespiration_none
```@docs
autoRespiration_none
```

----

### cAllocation
```@docs
cAllocation
```

----

### cAllocationLAI
```@docs
cAllocationLAI
```

----

### cAllocationLAI_Friedlingstein1999
```@docs
cAllocationLAI_Friedlingstein1999
```

----

### cAllocationLAI_none
```@docs
cAllocationLAI_none
```

----

### cAllocationNutrients
```@docs
cAllocationNutrients
```

----

### cAllocationNutrients_Friedlingstein1999
```@docs
cAllocationNutrients_Friedlingstein1999
```

----

### cAllocationNutrients_none
```@docs
cAllocationNutrients_none
```

----

### cAllocationRadiation
```@docs
cAllocationRadiation
```

----

### cAllocationRadiation_GSI
```@docs
cAllocationRadiation_GSI
```

----

### cAllocationRadiation_RgPot
```@docs
cAllocationRadiation_RgPot
```

----

### cAllocationRadiation_gpp
```@docs
cAllocationRadiation_gpp
```

----

### cAllocationRadiation_none
```@docs
cAllocationRadiation_none
```

----

### cAllocationSoilT
```@docs
cAllocationSoilT
```

----

### cAllocationSoilT_Friedlingstein1999
```@docs
cAllocationSoilT_Friedlingstein1999
```

----

### cAllocationSoilT_gpp
```@docs
cAllocationSoilT_gpp
```

----

### cAllocationSoilT_gppGSI
```@docs
cAllocationSoilT_gppGSI
```

----

### cAllocationSoilT_none
```@docs
cAllocationSoilT_none
```

----

### cAllocationSoilW
```@docs
cAllocationSoilW
```

----

### cAllocationSoilW_Friedlingstein1999
```@docs
cAllocationSoilW_Friedlingstein1999
```

----

### cAllocationSoilW_gpp
```@docs
cAllocationSoilW_gpp
```

----

### cAllocationSoilW_gppGSI
```@docs
cAllocationSoilW_gppGSI
```

----

### cAllocationSoilW_none
```@docs
cAllocationSoilW_none
```

----

### cAllocationTreeFraction
```@docs
cAllocationTreeFraction
```

----

### cAllocationTreeFraction_Friedlingstein1999
```@docs
cAllocationTreeFraction_Friedlingstein1999
```

----

### cAllocation_Friedlingstein1999
```@docs
cAllocation_Friedlingstein1999
```

----

### cAllocation_GSI
```@docs
cAllocation_GSI
```

----

### cAllocation_fixed
```@docs
cAllocation_fixed
```

----

### cAllocation_none
```@docs
cAllocation_none
```

----

### cBiomass
```@docs
cBiomass
```

----

### cBiomass_simple
```@docs
cBiomass_simple
```

----

### cBiomass_treeGrass
```@docs
cBiomass_treeGrass
```

----

### cBiomass_treeGrass_cVegReserveScaling
```@docs
cBiomass_treeGrass_cVegReserveScaling
```

----

### cCycle
```@docs
cCycle
```

----

### cCycleBase
```@docs
cCycleBase
```

----

### cCycleBase_CASA
```@docs
cCycleBase_CASA
```

----

### cCycleBase_GSI
```@docs
cCycleBase_GSI
```

----

### cCycleBase_GSI_PlantForm
```@docs
cCycleBase_GSI_PlantForm
```

----

### cCycleBase_GSI_PlantForm_LargeKReserve
```@docs
cCycleBase_GSI_PlantForm_LargeKReserve
```

----

### cCycleBase_simple
```@docs
cCycleBase_simple
```

----

### cCycleConsistency
```@docs
cCycleConsistency
```

----

### cCycleConsistency_simple
```@docs
cCycleConsistency_simple
```

----

### cCycleDisturbance
```@docs
cCycleDisturbance
```

----

### cCycleDisturbance_WROASTED
```@docs
cCycleDisturbance_WROASTED
```

----

### cCycleDisturbance_cFlow
```@docs
cCycleDisturbance_cFlow
```

----

### cCycle_CASA
```@docs
cCycle_CASA
```

----

### cCycle_GSI
```@docs
cCycle_GSI
```

----

### cCycle_simple
```@docs
cCycle_simple
```

----

### cFlow
```@docs
cFlow
```

----

### cFlowSoilProperties
```@docs
cFlowSoilProperties
```

----

### cFlowSoilProperties_CASA
```@docs
cFlowSoilProperties_CASA
```

----

### cFlowSoilProperties_none
```@docs
cFlowSoilProperties_none
```

----

### cFlowVegProperties
```@docs
cFlowVegProperties
```

----

### cFlowVegProperties_CASA
```@docs
cFlowVegProperties_CASA
```

----

### cFlowVegProperties_none
```@docs
cFlowVegProperties_none
```

----

### cFlow_CASA
```@docs
cFlow_CASA
```

----

### cFlow_GSI
```@docs
cFlow_GSI
```

----

### cFlow_none
```@docs
cFlow_none
```

----

### cFlow_simple
```@docs
cFlow_simple
```

----

### cTau
```@docs
cTau
```

----

### cTauLAI
```@docs
cTauLAI
```

----

### cTauLAI_CASA
```@docs
cTauLAI_CASA
```

----

### cTauLAI_none
```@docs
cTauLAI_none
```

----

### cTauSoilProperties
```@docs
cTauSoilProperties
```

----

### cTauSoilProperties_CASA
```@docs
cTauSoilProperties_CASA
```

----

### cTauSoilProperties_none
```@docs
cTauSoilProperties_none
```

----

### cTauSoilT
```@docs
cTauSoilT
```

----

### cTauSoilT_Q10
```@docs
cTauSoilT_Q10
```

----

### cTauSoilT_none
```@docs
cTauSoilT_none
```

----

### cTauSoilW
```@docs
cTauSoilW
```

----

### cTauSoilW_CASA
```@docs
cTauSoilW_CASA
```

----

### cTauSoilW_GSI
```@docs
cTauSoilW_GSI
```

----

### cTauSoilW_none
```@docs
cTauSoilW_none
```

----

### cTauVegProperties
```@docs
cTauVegProperties
```

----

### cTauVegProperties_CASA
```@docs
cTauVegProperties_CASA
```

----

### cTauVegProperties_none
```@docs
cTauVegProperties_none
```

----

### cTau_mult
```@docs
cTau_mult
```

----

### cTau_none
```@docs
cTau_none
```

----

### cVegetationDieOff
```@docs
cVegetationDieOff
```

----

### cVegetationDieOff_forcing
```@docs
cVegetationDieOff_forcing
```

----

### capillaryFlow
```@docs
capillaryFlow
```

----

### capillaryFlow_VanDijk2010
```@docs
capillaryFlow_VanDijk2010
```

----

### constants
```@docs
constants
```

----

### constants_numbers
```@docs
constants_numbers
```

----

### deriveVariables
```@docs
deriveVariables
```

----

### deriveVariables_simple
```@docs
deriveVariables_simple
```

----

### drainage
```@docs
drainage
```

----

### drainage_dos
```@docs
drainage_dos
```

----

### drainage_kUnsat
```@docs
drainage_kUnsat
```

----

### drainage_wFC
```@docs
drainage_wFC
```

----

### evaporation
```@docs
evaporation
```

----

### evaporation_Snyder2000
```@docs
evaporation_Snyder2000
```

----

### evaporation_bareFraction
```@docs
evaporation_bareFraction
```

----

### evaporation_demandSupply
```@docs
evaporation_demandSupply
```

----

### evaporation_fAPAR
```@docs
evaporation_fAPAR
```

----

### evaporation_none
```@docs
evaporation_none
```

----

### evaporation_vegFraction
```@docs
evaporation_vegFraction
```

----

### evapotranspiration
```@docs
evapotranspiration
```

----

### evapotranspiration_simple
```@docs
evapotranspiration_simple
```

----

### evapotranspiration_sum
```@docs
evapotranspiration_sum
```

----

### fAPAR
```@docs
fAPAR
```

----

### fAPAR_EVI
```@docs
fAPAR_EVI
```

----

### fAPAR_LAI
```@docs
fAPAR_LAI
```

----

### fAPAR_cVegLeaf
```@docs
fAPAR_cVegLeaf
```

----

### fAPAR_cVegLeafBareFrac
```@docs
fAPAR_cVegLeafBareFrac
```

----

### fAPAR_constant
```@docs
fAPAR_constant
```

----

### fAPAR_forcing
```@docs
fAPAR_forcing
```

----

### fAPAR_vegFraction
```@docs
fAPAR_vegFraction
```

----

### getPools
```@docs
getPools
```

----

### getPools_simple
```@docs
getPools_simple
```

----

### gpp
```@docs
gpp
```

----

### gppAirT
```@docs
gppAirT
```

----

### gppAirT_CASA
```@docs
gppAirT_CASA
```

----

### gppAirT_GSI
```@docs
gppAirT_GSI
```

----

### gppAirT_MOD17
```@docs
gppAirT_MOD17
```

----

### gppAirT_Maekelae2008
```@docs
gppAirT_Maekelae2008
```

----

### gppAirT_TEM
```@docs
gppAirT_TEM
```

----

### gppAirT_Wang2014
```@docs
gppAirT_Wang2014
```

----

### gppAirT_none
```@docs
gppAirT_none
```

----

### gppDemand
```@docs
gppDemand
```

----

### gppDemand_min
```@docs
gppDemand_min
```

----

### gppDemand_mult
```@docs
gppDemand_mult
```

----

### gppDemand_none
```@docs
gppDemand_none
```

----

### gppDiffRadiation
```@docs
gppDiffRadiation
```

----

### gppDiffRadiation_GSI
```@docs
gppDiffRadiation_GSI
```

----

### gppDiffRadiation_Turner2006
```@docs
gppDiffRadiation_Turner2006
```

----

### gppDiffRadiation_Wang2015
```@docs
gppDiffRadiation_Wang2015
```

----

### gppDiffRadiation_none
```@docs
gppDiffRadiation_none
```

----

### gppDirRadiation
```@docs
gppDirRadiation
```

----

### gppDirRadiation_Maekelae2008
```@docs
gppDirRadiation_Maekelae2008
```

----

### gppDirRadiation_none
```@docs
gppDirRadiation_none
```

----

### gppPotential
```@docs
gppPotential
```

----

### gppPotential_Monteith
```@docs
gppPotential_Monteith
```

----

### gppSoilW
```@docs
gppSoilW
```

----

### gppSoilW_CASA
```@docs
gppSoilW_CASA
```

----

### gppSoilW_GSI
```@docs
gppSoilW_GSI
```

----

### gppSoilW_Keenan2009
```@docs
gppSoilW_Keenan2009
```

----

### gppSoilW_Stocker2020
```@docs
gppSoilW_Stocker2020
```

----

### gppSoilW_none
```@docs
gppSoilW_none
```

----

### gppVPD
```@docs
gppVPD
```

----

### gppVPD_MOD17
```@docs
gppVPD_MOD17
```

----

### gppVPD_Maekelae2008
```@docs
gppVPD_Maekelae2008
```

----

### gppVPD_PRELES
```@docs
gppVPD_PRELES
```

----

### gppVPD_expco2
```@docs
gppVPD_expco2
```

----

### gppVPD_none
```@docs
gppVPD_none
```

----

### gpp_coupled
```@docs
gpp_coupled
```

----

### gpp_min
```@docs
gpp_min
```

----

### gpp_mult
```@docs
gpp_mult
```

----

### gpp_none
```@docs
gpp_none
```

----

### gpp_transpirationWUE
```@docs
gpp_transpirationWUE
```

----

### groundWRecharge
```@docs
groundWRecharge
```

----

### groundWRecharge_dos
```@docs
groundWRecharge_dos
```

----

### groundWRecharge_fraction
```@docs
groundWRecharge_fraction
```

----

### groundWRecharge_kUnsat
```@docs
groundWRecharge_kUnsat
```

----

### groundWRecharge_none
```@docs
groundWRecharge_none
```

----

### groundWSoilWInteraction
```@docs
groundWSoilWInteraction
```

----

### groundWSoilWInteraction_VanDijk2010
```@docs
groundWSoilWInteraction_VanDijk2010
```

----

### groundWSoilWInteraction_gradient
```@docs
groundWSoilWInteraction_gradient
```

----

### groundWSoilWInteraction_gradientNeg
```@docs
groundWSoilWInteraction_gradientNeg
```

----

### groundWSoilWInteraction_none
```@docs
groundWSoilWInteraction_none
```

----

### groundWSurfaceWInteraction
```@docs
groundWSurfaceWInteraction
```

----

### groundWSurfaceWInteraction_fracGradient
```@docs
groundWSurfaceWInteraction_fracGradient
```

----

### groundWSurfaceWInteraction_fracGroundW
```@docs
groundWSurfaceWInteraction_fracGroundW
```

----

### interception
```@docs
interception
```

----

### interception_Miralles2010
```@docs
interception_Miralles2010
```

----

### interception_fAPAR
```@docs
interception_fAPAR
```

----

### interception_none
```@docs
interception_none
```

----

### interception_vegFraction
```@docs
interception_vegFraction
```

----

### percolation
```@docs
percolation
```

----

### percolation_WBP
```@docs
percolation_WBP
```

----

### percolation_rain
```@docs
percolation_rain
```

----

### plantForm
```@docs
plantForm
```

----

### plantForm_PFT
```@docs
plantForm_PFT
```

----

### plantForm_fixed
```@docs
plantForm_fixed
```

----

### rainIntensity
```@docs
rainIntensity
```

----

### rainIntensity_forcing
```@docs
rainIntensity_forcing
```

----

### rainIntensity_simple
```@docs
rainIntensity_simple
```

----

### rainSnow
```@docs
rainSnow
```

----

### rainSnow_Tair
```@docs
rainSnow_Tair
```

----

### rainSnow_forcing
```@docs
rainSnow_forcing
```

----

### rainSnow_rain
```@docs
rainSnow_rain
```

----

### rootMaximumDepth
```@docs
rootMaximumDepth
```

----

### rootMaximumDepth_fracSoilD
```@docs
rootMaximumDepth_fracSoilD
```

----

### rootWaterEfficiency
```@docs
rootWaterEfficiency
```

----

### rootWaterEfficiency_constant
```@docs
rootWaterEfficiency_constant
```

----

### rootWaterEfficiency_expCvegRoot
```@docs
rootWaterEfficiency_expCvegRoot
```

----

### rootWaterEfficiency_k2Layer
```@docs
rootWaterEfficiency_k2Layer
```

----

### rootWaterEfficiency_k2fRD
```@docs
rootWaterEfficiency_k2fRD
```

----

### rootWaterEfficiency_k2fvegFraction
```@docs
rootWaterEfficiency_k2fvegFraction
```

----

### rootWaterUptake
```@docs
rootWaterUptake
```

----

### rootWaterUptake_proportion
```@docs
rootWaterUptake_proportion
```

----

### rootWaterUptake_topBottom
```@docs
rootWaterUptake_topBottom
```

----

### runoff
```@docs
runoff
```

----

### runoffBase
```@docs
runoffBase
```

----

### runoffBase_Zhang2008
```@docs
runoffBase_Zhang2008
```

----

### runoffBase_none
```@docs
runoffBase_none
```

----

### runoffInfiltrationExcess
```@docs
runoffInfiltrationExcess
```

----

### runoffInfiltrationExcess_Jung
```@docs
runoffInfiltrationExcess_Jung
```

----

### runoffInfiltrationExcess_kUnsat
```@docs
runoffInfiltrationExcess_kUnsat
```

----

### runoffInfiltrationExcess_none
```@docs
runoffInfiltrationExcess_none
```

----

### runoffInterflow
```@docs
runoffInterflow
```

----

### runoffInterflow_none
```@docs
runoffInterflow_none
```

----

### runoffInterflow_residual
```@docs
runoffInterflow_residual
```

----

### runoffOverland
```@docs
runoffOverland
```

----

### runoffOverland_Inf
```@docs
runoffOverland_Inf
```

----

### runoffOverland_InfIntSat
```@docs
runoffOverland_InfIntSat
```

----

### runoffOverland_Sat
```@docs
runoffOverland_Sat
```

----

### runoffOverland_none
```@docs
runoffOverland_none
```

----

### runoffSaturationExcess
```@docs
runoffSaturationExcess
```

----

### runoffSaturationExcess_Bergstroem1992
```@docs
runoffSaturationExcess_Bergstroem1992
```

----

### runoffSaturationExcess_Bergstroem1992MixedVegFraction
```@docs
runoffSaturationExcess_Bergstroem1992MixedVegFraction
```

----

### runoffSaturationExcess_Bergstroem1992VegFraction
```@docs
runoffSaturationExcess_Bergstroem1992VegFraction
```

----

### runoffSaturationExcess_Bergstroem1992VegFractionFroSoil
```@docs
runoffSaturationExcess_Bergstroem1992VegFractionFroSoil
```

----

### runoffSaturationExcess_Bergstroem1992VegFractionPFT
```@docs
runoffSaturationExcess_Bergstroem1992VegFractionPFT
```

----

### runoffSaturationExcess_Zhang2008
```@docs
runoffSaturationExcess_Zhang2008
```

----

### runoffSaturationExcess_none
```@docs
runoffSaturationExcess_none
```

----

### runoffSaturationExcess_satFraction
```@docs
runoffSaturationExcess_satFraction
```

----

### runoffSurface
```@docs
runoffSurface
```

----

### runoffSurface_Orth2013
```@docs
runoffSurface_Orth2013
```

----

### runoffSurface_Trautmann2018
```@docs
runoffSurface_Trautmann2018
```

----

### runoffSurface_all
```@docs
runoffSurface_all
```

----

### runoffSurface_directIndirect
```@docs
runoffSurface_directIndirect
```

----

### runoffSurface_directIndirectFroSoil
```@docs
runoffSurface_directIndirectFroSoil
```

----

### runoffSurface_indirect
```@docs
runoffSurface_indirect
```

----

### runoffSurface_none
```@docs
runoffSurface_none
```

----

### runoff_simple
```@docs
runoff_simple
```

----

### runoff_sum
```@docs
runoff_sum
```

----

### saturatedFraction
```@docs
saturatedFraction
```

----

### saturatedFraction_none
```@docs
saturatedFraction_none
```

----

### snowFraction
```@docs
snowFraction
```

----

### snowFraction_HTESSEL
```@docs
snowFraction_HTESSEL
```

----

### snowFraction_binary
```@docs
snowFraction_binary
```

----

### snowFraction_none
```@docs
snowFraction_none
```

----

### snowMelt
```@docs
snowMelt
```

----

### snowMelt_Tair
```@docs
snowMelt_Tair
```

----

### snowMelt_TairRn
```@docs
snowMelt_TairRn
```

----

### soilProperties
```@docs
soilProperties
```

----

### soilProperties_Saxton1986
```@docs
soilProperties_Saxton1986
```

----

### soilProperties_Saxton2006
```@docs
soilProperties_Saxton2006
```

----

### soilTexture
```@docs
soilTexture
```

----

### soilTexture_constant
```@docs
soilTexture_constant
```

----

### soilTexture_forcing
```@docs
soilTexture_forcing
```

----

### soilWBase
```@docs
soilWBase
```

----

### soilWBase_smax1Layer
```@docs
soilWBase_smax1Layer
```

----

### soilWBase_smax2Layer
```@docs
soilWBase_smax2Layer
```

----

### soilWBase_smax2fRD4
```@docs
soilWBase_smax2fRD4
```

----

### soilWBase_uniform
```@docs
soilWBase_uniform
```

----

### sublimation
```@docs
sublimation
```

----

### sublimation_GLEAM
```@docs
sublimation_GLEAM
```

----

### sublimation_none
```@docs
sublimation_none
```

----

### transpiration
```@docs
transpiration
```

----

### transpirationDemand
```@docs
transpirationDemand
```

----

### transpirationDemand_CASA
```@docs
transpirationDemand_CASA
```

----

### transpirationDemand_PET
```@docs
transpirationDemand_PET
```

----

### transpirationDemand_PETfAPAR
```@docs
transpirationDemand_PETfAPAR
```

----

### transpirationDemand_PETvegFraction
```@docs
transpirationDemand_PETvegFraction
```

----

### transpirationSupply
```@docs
transpirationSupply
```

----

### transpirationSupply_CASA
```@docs
transpirationSupply_CASA
```

----

### transpirationSupply_Federer1982
```@docs
transpirationSupply_Federer1982
```

----

### transpirationSupply_wAWC
```@docs
transpirationSupply_wAWC
```

----

### transpirationSupply_wAWCvegFraction
```@docs
transpirationSupply_wAWCvegFraction
```

----

### transpiration_coupled
```@docs
transpiration_coupled
```

----

### transpiration_demandSupply
```@docs
transpiration_demandSupply
```

----

### transpiration_none
```@docs
transpiration_none
```

----

### treeFraction
```@docs
treeFraction
```

----

### treeFraction_constant
```@docs
treeFraction_constant
```

----

### treeFraction_forcing
```@docs
treeFraction_forcing
```

----

### vegAvailableWater
```@docs
vegAvailableWater
```

----

### vegAvailableWater_rootWaterEfficiency
```@docs
vegAvailableWater_rootWaterEfficiency
```

----

### vegAvailableWater_sigmoid
```@docs
vegAvailableWater_sigmoid
```

----

### vegFraction
```@docs
vegFraction
```

----

### vegFraction_constant
```@docs
vegFraction_constant
```

----

### vegFraction_forcing
```@docs
vegFraction_forcing
```

----

### vegFraction_scaledEVI
```@docs
vegFraction_scaledEVI
```

----

### vegFraction_scaledLAI
```@docs
vegFraction_scaledLAI
```

----

### vegFraction_scaledNDVI
```@docs
vegFraction_scaledNDVI
```

----

### vegFraction_scaledNIRv
```@docs
vegFraction_scaledNIRv
```

----

### vegFraction_scaledfAPAR
```@docs
vegFraction_scaledfAPAR
```

----

### wCycle
```@docs
wCycle
```

----

### wCycleBase
```@docs
wCycleBase
```

----

### wCycleBase_simple
```@docs
wCycleBase_simple
```

----

### wCycle_combined
```@docs
wCycle_combined
```

----

### wCycle_components
```@docs
wCycle_components
```

----

### wCycle_simple
```@docs
wCycle_simple
```

----

### waterBalance
```@docs
waterBalance
```

----

### waterBalance_simple
```@docs
waterBalance_simple
```

----

```@meta
CollapsedDocStrings = false
DocTestSetup= quote
using SindbadTEM.Processes
end
```
