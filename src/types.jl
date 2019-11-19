
using SampledSignals
using MIDI
using DSP


struct TrainingData
    track::MIDI.MIDITrack
    sound::SampledSignals.SampleBuf
end

struct PreprocessedTrainingData
    track::MIDI.MIDITrack
    # left sound only.
    spectrogram::DSP.Periodograms.Spectrogram
end
