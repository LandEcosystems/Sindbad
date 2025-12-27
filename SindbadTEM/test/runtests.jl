using SindbadTEM
using Test

@testset "SindbadTEM smoke" begin
    # Module loads and core types are present
    @test isdefined(Main, :SindbadTEM)
    @test isdefined(SindbadTEM, :LandEcosystem)

    # Key submodules reexported by SindbadTEM
    @test isdefined(SindbadTEM, :TEMTypes)
    @test isdefined(SindbadTEM, :Utils)
    @test isdefined(SindbadTEM, :Variables)
    @test isdefined(SindbadTEM, :Processes)
end

@testset "SindbadTEM integration" verbose=true begin
    include("utils_test.jl")
    include("Processes/test_model.jl") 
end