
using Random
using MIDI
using SampledSignals

using CureMIDI


# tick per quater note
const TPQ = Int16(960)
const BPM = 120
const SAMPLE_RATE = 44100


function generate(sf2_path::String, sample_num_per_sf2::Int)
    training_dataset = Vector{SoundData}()
    Random.seed!(0)
    for i in 1:sample_num_per_sf2
        track = create_rand_midi_track()
        sampled_buf = synth(track, TPQ, BPM, SAMPLE_RATE, sf2_path)
        training_data = SoundData(track, sampled_buf)
        push!(training_dataset, training_data)
    end
    training_dataset
end

function generate(sf2_paths::Vector{String}, sample_num_per_sf2::Int)
    training_dataset = Vector{SoundData}()
    for sf2_path in sf2_paths
        trainig_data_of_path = generate(sf2_path, sample_num_per_sf2)
        append!(training_dataset, trainig_data_of_path)
    end
    training_dataset
end



function create_rand_midi_track()
    track = MIDI.MIDITrack()
    notes = MIDI.Notes()
    start_pitch = 69

    tick_per_eighth = TPQ / 2

    for i in 1:2

        # pitch, velocity, position, duration
        pitch = start_pitch  + 2 * i
        velocity = 70
        start_tick = 2 * tick_per_eighth * (i - 1)
        duration_tick = tick_per_eighth * 2

        note = MIDI.Note(pitch, velocity, start_tick, duration_tick)
        push!(notes, note)
    end

    addnotes!(track, notes)
    return track
end
