
using Logging
ENV["JULIA_DEBUG"] = "all"

using Glob

include("sample_generator.jl")

include("preprocessing.jl")

include("model.jl")

include("types.jl")

function get_soundfont_paths()
    gm_dir = joinpath(@__DIR__, "..", "res", "soundfont", "gm")
    sf2_paths = glob("*.sf2", gm_dir)
end

function create_one_data()
    @debug "create data"
    # search sf2
    soundfont_paths = get_soundfont_paths()

    # limit for test
    sf2_paths = soundfont_paths[1:2]
    training_dataset = generate(sf2_paths, 2)
    training_dataset
end






function main()
    @time @debug "start DeepMuse"
    # create sample data.
    @time  raw_training_dataset = create_one_data()

    @debug "start Preprocess"
    # 入力のパラメータの採取のために作る.
    # TODO パラメータの入力でなんとかしたい.
    sample_of_input = preprocess(raw_training_dataset[1])
    input_dim::Tuple = get_input_dim(sample_of_input)
    output_dim::UInt = get_output_dim(sample_of_input)
    @show input_dim

    model = create_model(input_dim, output_dim)

    for sf_path in get_soundfont_paths()[1:2]
        @debug "learning sf" sf_path
        training_dataset = generate(sf_path, 2)
        input = preprocess(training_dataset)
        @debug "ipnut type" typeof input
        train!(model, input)

    end



    # predict(model)

    @debug "finish normally"
end


main()
