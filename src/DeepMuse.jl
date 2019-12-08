
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
    # search sf2
    soundfont_paths = get_soundfont_paths()

    # limit for test
    sf2_path = soundfont_paths[1]
    training_dataset = generate(sf2_path, 1)
    training_dataset[1]
end






function main()
    sound_file_param = SoundFileParam(960, 120, 44100)

    # learning param.
    INPUT_LENGTH::UInt = 10



    @time @debug "start DeepMuse"
    # create sample data.
    one_sound_data = create_one_data()

    @debug "start Preprocess"
    # 入力のパラメータの採取のために作る.
    # TODO パラメータの入力でなんとかしたい.
    sample_of_input = preprocess(one_sound_data, sound_file_param, INPUT_LENGTH)

    model = create_model(INPUT_LENGTH)

    training_data_set = Vector{TrainingData}()
    for sf2_path in get_soundfont_paths()[1:end-1]
        sound_data::Vector = generate(sf2_path, 1)
        for one_sound_data in sound_data
            training_data::Vector = preprocess(
                one_sound_data,
                sound_file_param,
                INPUT_LENGTH,
            )
            append!(training_data_set, training_data)
        end
    end

    train!(model, training_data_set)



    # predict(model)

    @debug "finish normally"
end


main()
