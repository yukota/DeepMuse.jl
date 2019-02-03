module SampleGenerator

  using Random
  using MIDI
  using CureMIDI

  function generate(sf2_paths::Vector{String}, sample_num_per_sf2::Int)
    Random.seed!(0)
    for sf2_path in sf2_paths
      @debug sf2_path
      for i in 1:sample_num_per_sf2
        midi_track = create_rand_midi_track()
      end
    end
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
