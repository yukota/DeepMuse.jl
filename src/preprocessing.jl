
using Logging

using SampledSignals

using DSP

using Revise

include("types.jl")


# '''
# stft
# http://www.ppgia.pucpr.br/ismir2013/wp-content/uploads/2013/09/243_Paper.pdf
# 500ms,Blackman, L2
# :param wave_data:
# :return:
# '''
# nperseg セグメントの長さ.
# overlap nperseg // 2
#f, t, zxx = stft(wave_data, fs=fs, window='blackman', nperseg=fs // 2)

function preprocess(traing_data::TrainingData)
    track = traing_data.track
    spectrogram = convert_to_spectrogram(traing_data.sound)
    preprocess_data = PreprocessedTrainingData(track, spectrogram)
end

function preprocess(training_dataset::Vector{TrainingData})
    preprocessed_dataset = Vector{PreprocessedTrainingData}()
    for item in training_dataset
        preprocess_data = preprocess(item)
        push!(preprocessed_dataset, preprocess_data)
    end
    preprocessed_dataset
end

function convert_to_spectrogram(buf::AbstractVector, samplerate)
    tick_per_eighteen_note::UInt = ceil(TPQ / 2)
    frame_per_eighteen_node = CureMIDI.tick_to_frame(tick_per_eighteen_note, TPQ, BPM, SAMPLE_RATE)
    n::Int64 = ceil(length(buf) / frame_per_eighteen_node)
    spectrogram = DSP.spectrogram(buf, n, nfft = SAMPLE_RATE, fs = samplerate)
end

function convert_to_spectrogram(sample_buf::SampledSignals.SampleBuf)
    samplerate = SampledSignals.samplerate(sample_buf)
    # left only.
    input = @view sample_buf.data[:, 1]
    spectrogram = convert_to_spectrogram(input, samplerate)
end
