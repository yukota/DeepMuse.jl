
using SampledSignals
using MIDI

struct SoundFileParam
    tpq::Int16
    bpm::Real
    sample_rate::Real
end


struct SoundData
    track::MIDI.MIDITrack
    sound::SampledSignals.SampleBuf
end


struct TrainingData
    data::Vector{Float32}
    is_attack::Bool
end
