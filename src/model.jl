
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
function prepare_dataset(preprocessed_training_dataset)

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

        # quaterごとに音を切る
        # freq x time
        @debug  "aaaa" size(power(data.spectrogramas[1]))
        @debug  "freq" freq(data.spectrogramas[1])
        @debug  "time" time(data.spectrogramas[1])


        # for eighteen_note_spectrogram in data.spectrogramas
        #     # ステレオで2ch
        #     @debug "eightenn --------------------"

        #     for(freq, time, power) in zip(freq(eighteen_note_spectrogram), time(eighteen_note_spectrogram),  power(eighteen_note_spectrogram))
        #         @debug "one freq----------------"
        #         @debug "freq" freq "len" length(freq)
        #         @debug "time" time "len" length(time)
        #         @debug "power" power "len" length(power)
        #     end

        # end


    end


    # note range 0(as C0)-127
    # power *2
    return frames_set

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

function create_model(input_dim, output_dim)
    # chain = Chain(
    #     Conv((3 ,3), 1->10, relu),
    #     x->reshape(x, : , size(x, 4)),
    #     # 3x3x10
    #     Dense(90, output_dim, tanh)
    #     )

    # model = Model(chain)
end

function convert_to_dataset(preprocessed_training_dataset, training_dataset)
    inputs = Vector()
    outputs = Vector()
    for training_data in training_dataset
        push!(inputs, power(training_data.spectrogramas[1]))

        out = Vector()


    end
end


function train!(model::Model, preprocessed_training_dataset::Vector{PreprocessedTrainingData})
    frame_set = prepare_dataset(preprocessed_training_dataset)

    dataset = convert_to_dataset(preprocessed_training_dataset, frame_set)


    loss(x, y) = mse(model(x), y)
    opt = Descent()
    Flux.train!(loss, params(model), dataset, opt)

end

function output_dim(data::PreprocessedTrainingData)
    tick_per_eighth = TPQ / 2
    notes = MIDI.getnotes(data.track, TPQ)
    # durationをtick per quater /2 2 で割る
    duration_ticks = duration_tick(notes)
    unit_length = Int(floor(duration_ticks / tick_per_eighth))
    return Int(unit_length)
end

function input_dim(data::PreprocessedTrainingData)
    return size(data.spectrogramas[1])
end


function predict(model::Model)
    @debug "hagerarion train"

end
