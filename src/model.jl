
using Flux

using MIDI

include("types.jl")

const TPQ = Int16(960)


struct Model
    model::Chain
end


# TPQ is 960
# BPM is 120
# SAPMLE_RATE is 44100
# 1000ms * 10

# 八分音符960/2tick

function duration_tick(notes)
    starttick = notes[1].position
    endtick = maximum(map(note->note.position + note.duration, notes))
    return endtick - starttick
end


mutable struct EighthFrame
    is_attack::Bool
end
EighthFrame() = EighthFrame(false)

"""
八分音符ごとに区切る。
アタックのタイミングでフラグを上げる
"""
function prepare_dataset(preprocessed_training_dataset::Vector{PreprocessedTrainingData})

    # Xs = Array()
    # Xy = Array()
    @debug "prepare_dataset" preprocessed_training_dataset
    tick_per_eighth = TPQ / 2
    frames_set = Vector{Vector{EighthFrame}}()
    for data in preprocessed_training_dataset
        notes = MIDI.getnotes(data.track, TPQ)
        # durationをtick per quater /2 2 で割る
        duration_ticks = duration_tick(notes)
        unit_length = Int(floor(duration_ticks / tick_per_eighth))
        frames = fill(EighthFrame(), Int(unit_length))
        @debug "note" notes
        for note in notes
            #noteのpostionと一致する箇所をアタックとする
            frame_no = Int(floor(note.position / tick_per_eighth)) + 1
            frames[frame_no] = EighthFrame(true)
        end
        push!(frames_set, frames)
    end


    return frames_set

end


function create_model(input_dim::Tuple, output_dim::UInt)
    chain = Chain(Conv(input_dim, 1 => 10, relu),
        x->reshape(x, :, size(x, 4)),
        # 3x3x10
        Dense(90, output_dim, tanh))

    model = Model(chain)
end

function attacks(frames::Vector{EighthFrame})
    local ret = Vector{Int}()
    for frame in frames
        if frame.is_attack
            push!(ret, 1)
        else
            push!(ret, 0)
        end
    end
    ret
end

function convert_to_dataset(preprocessed_training_dataset::Vector{PreprocessedTrainingData}, eight_frames::Vector{Vector{EighthFrame}})
    inputs = Vector()
    outputs = Vector()
    for (one_input, one_output) in zip(preprocessed_training_dataset, eight_frames)
        push!(inputs, power(one_input.spectrogram))
        push!(outputs, attacks(one_output))
    end

    zip(inputs, outputs)
end


function train!(model::Model, preprocessed_training_dataset::Vector{PreprocessedTrainingData})
    frame_set = prepare_dataset(preprocessed_training_dataset)

    dataset = convert_to_dataset(preprocessed_training_dataset, frame_set)


    loss(x, y) = binarycrossentropy(model(x), y)
    opt = Descent()
    Flux.train!(loss, params(model), dataset, opt)

end

function get_output_dim(data::PreprocessedTrainingData)
    tick_per_eighth = TPQ / 2
    notes = MIDI.getnotes(data.track, TPQ)
    # durationをtick per quater /2 2 で割る
    duration_ticks = duration_tick(notes)
    unit_length = Int(floor(duration_ticks / tick_per_eighth))
end

function get_input_dim(data::PreprocessedTrainingData)
    size(power(data.spectrogram))
end


function predict(model::Model)
    @debug "hagerarion train"

end
