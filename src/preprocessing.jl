
using Logging

using SampledSignals
using CureMIDI

using Revise

include("types.jl")



function preprocess(
    sound_data::SoundData,
    sound_file_param::SoundFileParam,
    data_length::UInt,
)
    mono_data = mono(sound_data.sound.data)[:, 1]
    attack_indices = _get_index_of_attack(sound_data.track, sound_file_param)
    frame_length = _get_length_of_frame(data_length, sound_file_param)

    training_data = Vector{TrainingData}()
    # attacks
    for attack_index in attack_indices
        sliced_data = slice_and_fill(mono_data, attack_index, data_length)
        push!(training_data, TrainingData(sliced_data, true))
    end

    # not attack
    for _ = 1:10
        attack_index = get_index_of_not_attack(
            attack_indices,
            UInt(1),
            frame_length,
        )
        sliced_data = slice_and_fill(mono_data, attack_index, data_length)
        push!(training_data, TrainingData(sliced_data, false))
    end
    training_data
end


function _get_index_of_attack(
    track::MIDI.MIDITrack,
    sound_file_param::SoundFileParam,
)
    attack_indices = Vector{UInt}()
    for note in MIDI.getnotes(track)
        attack_index = tick_to_frame(
            note.position,
            sound_file_param.tpq,
            sound_file_param.bpm,
            sound_file_param.sample_rate,
        )
        push!(attack_indices, attack_index + 1)
    end
    attack_indices
end

function _get_length_of_frame(
    data_length::UInt,
    sound_file_param::SoundFileParam,
)
    tick_to_frame(
        data_length,
        sound_file_param.tpq,
        sound_file_param.bpm,
        sound_file_param.sample_rate,
    )
end

function slice_and_fill(
    data::AbstractVector,
    index::UInt,
    length_of_sample::UInt,
)
    sliced_data = Vector()
    if length(data) > index + (length_of_sample - 1)
        sliced_data = data[index:index+length_of_sample-1]
    else
        sliced_data = data[index:end]
        remain_num = length_of_sample - length(data)
        append!(sliced_data, zeros(Float32, remain_num))
    end
    sliced_data
end

function get_index_of_not_attack(
    attack_indices::Vector{UInt},
    start_index::UInt,
    end_index::UInt,
)
    range_length = end_index - start_index
    offset = rand(UInt) % range_length
    result_index = start_index + offset
    while result_index in attack_indices
        range_length = end_index - start_index
        offset = rand(UInt) % range_length
        result_index = start_index + offset
    end
    result_index
end
