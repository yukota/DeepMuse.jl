using Test

#@time @testset "private method test" begin include("sample_generator_test.jl") end
@time @testset "model test" begin include("model_test.jl") end
