using Test
ENV["JULIA_DEBUG"] = "all"

# @time @testset "private method test" begin include("sample_generator_test.jl") end
#@time @testset "preprocessing_test" begin include("preprocessing_test.jl") end

# @time @testset "model test" begin include("model_test.jl") end
@time @testset "model test" begin include("model_helper_test.jl") end
