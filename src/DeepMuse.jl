
using Logging
ENV["JULIA_DEBUG"] = "all"

using Glob

include("sample_generator.jl")

include("preprocessing.jl")

include("model.jl")

include("types.jl")

function create_data()
    @debug "create data"
    # search sf2
    gm_dir = joinpath(@__DIR__, "res", "soundfont", "gm")
    sf2_paths = glob("*.sf2", gm_dir)

    # limit for test
    sf2_paths = sf2_paths[1:2]

    @debug typeof(sf2_paths)
    training_dataset = generate(sf2_paths, 2)
    return training_dataset
end


function main()
    @debug "start DeepMuse"
    # create sample data.
    raw_training_dataset = create_data()

    @debug "start Preprocess"
    preprocessed_training_dataset = preprocess(raw_training_dataset)


    input_dim = input_dim(preprocessed_training_dataset[1])
    output_dim = output_dim(preprocessed_training_dataset[1])

    model = create_model(input_dim, output_dim)
    train!(model, preprocessed_training_dataset)



    predict(model)

    @debug "finish normally"
end


main()
