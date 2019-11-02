
using Logging

using SampledSignals

using DSP

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


function preprocess(training_dataset::Vector{TrainingData})
    preprocessed_dataset = Vector{PreprocessedTrainingData}()
    for item in training_dataset
        track = item.track
        spectrogramas = spectrogram(item.sound)
        preprocess_data = PreprocessedTrainingData(track, spectrogramas)

        push!(preprocessed_dataset, preprocess_data)
    end
    return preprocessed_dataset
end

function spectrogram(sample_buf::SampledSignals.SampleBuf)
    samplerate = SampledSignals.samplerate(sample_buf)

    spectrograms = Vector()
    for ch in 1:nchannels(sample_buf)
        input = sample_buf.data[:, ch]

        #n=div(length(s), 8)
        # n 8部音符ごと
        tick_per_eighteen_note::UInt = ceil(TPQ / 2)
        frame_per_eighteen_node = CureMIDI.tick_to_frame(tick_per_eighteen_note, TPQ, BPM, SAMPLE_RATE)
        n::Int64 = ceil(length(input) / frame_per_eighteen_node)
        @debug "num of data" n input
        spectrogram = DSP.spectrogram(input, n, nfft=SAMPLE_RATE, fs=samplerate)

        push!(spectrograms, spectrogram)
    end
    return spectrograms
end
