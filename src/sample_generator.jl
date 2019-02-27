module SampleGenerator

  using Random
  using MIDI
  using SampledSignals

  using CureMIDI


  const TPQ = Int16(960)
  const BPM = 60
  const SAMPLE_RATE = 44100

  struct TrainingData
     track::MIDI.MIDITrack
     sound::SampledSignals.SampleBuf
  end

  function generate(sf2_paths::Vector{String}, sample_num_per_sf2::Int)
    training_dataset = Vector{TrainingData}()
    Random.seed!(0)
    for sf2_path in sf2_paths
      @debug sf2_path
      for i in 1:sample_num_per_sf2
        track = create_rand_midi_track()
        sampled_buf = synth(track, TPQ, BPM, SAMPLE_RATE, sf2_path)
        training_data = TrainingData(track, sampled_buf)
        push!(training_dataset, training_data)
      end
    end
    return training_dataset
  end

  function create_rand_midi_track()
    track = MIDI.MIDITrack()
    notes = MIDI.Notes()
    for i in 1:2
      # pitch, velocity, position, duration
      pitch = rand(21:108)
      velocity = 70
      start_time = 1500 * (i - 1)
      note = MIDI.Note(pitch, velocity, start_time, 1500)
      push!(notes, note)
    end
    addnotes!(track, notes)
    return track
  end


end #module
