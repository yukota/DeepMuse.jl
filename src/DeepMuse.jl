module DeepMuse

  using Logging
  ENV["JULIA_DEBUG"] = "all"

  using Glob

  include("sample_generator.jl")
  import .SampleGenerator


  function create_data()
    @debug "create data"
    # search sf2
    gm_dir = joinpath(@__DIR__, "res", "soundfont", "gm")
    sf2_paths = glob("*.sf2", gm_dir)

    @debug typeof(sf2_paths)
    SampleGenerator.generate(sf2_paths, 2)
  end

  function train()
    @debug "start train"
  end

  function prefict()
    @debug "predict"
  end


end # module

function main()
  @debug "start DeepMuse"
  # create sample data.
  DeepMuse.create_data()


  @debug "finish normally"
end


main()
