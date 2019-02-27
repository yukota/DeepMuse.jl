module DeepMuse

  using Logging
  ENV["JULIA_DEBUG"] = "all"

  using Glob

  include("sample_generator.jl")
  import .SampleGenerator

  include("model.jl")
  import .Model

  function create_data()
    @debug "create data"
    # search sf2
    gm_dir = joinpath(@__DIR__, "res", "soundfont", "gm")
    sf2_paths = glob("*.sf2", gm_dir)

    @debug typeof(sf2_paths)
    training_dataset = SampleGenerator.generate(sf2_paths, 2)
    return traing_dataset

  end

  function train(training_dataset)
    
    @debug "start train"
  end

  function prefict()
    @debug "predict"
  end


end # module

function main()
  @debug "start DeepMuse"
  # create sample data.
  training_dataset = DeepMuse.create_data()
  DeepMuse.train(training_dataset)


  @debug "finish normally"
end


main()
