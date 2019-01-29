using Logging

module DeepMuse
  function create_data()
    @debug "create data"
  end

  function train()
    @debug "start train"
  end

  function prefict()
    print("hoge")
  end


end # module

function main()
  ENV["JULIA_DEBUG"] = "all"
  @debug "start DeepMuse"
  # create sample data.
  DeepMuse.create_data()


  @debug "finish normally"
end


main()
