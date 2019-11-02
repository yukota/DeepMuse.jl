using Test

using Glob

using Plots
using PortAudio
using DSP
using CureMIDI


using WAV
using Revise


include("../src/sample_generator.jl")


include("../src/preprocessing.jl")

include("../src/model.jl")


@testset "hoge" begin

    gm_dir = joinpath(@__DIR__, "..", "src", "res", "soundfont", "gm")
    sf2_paths = glob("*.sf2", gm_dir)
    training_dataset = generate(sf2_paths[1:1], 1)


    preprocessed_dataset = preprocess(training_dataset)
    frames_set =  prepare_dataset(preprocessed_dataset)

    @debug frames_set


#  stream = PortAudio.PortAudioStream(0, 2)
#  PortAudio.write(stream, training_dataset[1].sound)

    # spectrograms = spectrogram(training_dataset[1].sound)
    # ys = freq(spectrograms[1])

    # p = power(spectrograms[1])

    # ts = time(spectrograms[1])

    # xs = 1:size(p)[2]


    # @debug "input sound"
    # @debug "channel " nchannels(training_dataset[1].sound)

    # @debug "frames " nframes(training_dataset[1].sound)
    # @debug "typeof frame " length(training_dataset[1].sound.data[:,1])


    # tick = UInt(ceil(CureMIDI.ms_to_tick(1000, TPQ, BPM)))
    # @debug "predict frame " Int(tick)
    # ms = CureMIDI.tick_to_frame(tick, TPQ, BPM, SAMPLE_RATE)
    # @debug "predict frame " Int(ms)




    # @debug "xs " xs

    # @debug "actural freq " ys

    # @debug  maximum(p)

    # @debug "actual ts" ts

    # # heatmap(xs, ys, p, ylims=(400, 1500))
    # # savefig("myplot.png")

end
