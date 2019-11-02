using Test

using Glob
using Revise


include("../src/sample_generator.jl")
import .SampleGenerator

@testset "hoge" begin

    gm_dir = joinpath(@__DIR__, "..", "src", "res", "soundfont", "gm")
    sf2_paths = glob("*.sf2", gm_dir)
    training_dataset = SampleGenerator.generate(sf2_paths[1:1], 1)

end
