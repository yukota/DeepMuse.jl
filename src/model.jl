module Model
  using Flux

  function prepare_dataset()
  end

  function define_model()
    model = Chain(
      # conv1d
     # Conv((10,), 1 => 8, relu),

      Dense(1, 100),
      Dense(100, 1, tanh)
      #softmax
    )

    return model
  end

  function train()
    model = define_model()
  end

  function predict()
  end


end # module

