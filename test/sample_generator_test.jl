using Test

using Glob
using Revise


import .SampleGenerator

@testset "hoge" begin
  gm_dir = joinpath(@__DIR__, "..", "src", "res", "soundfont", "gm")
  sf2_paths = glob("*.sf2", gm_dir)
  print(sf2_paths[1:1])
end
