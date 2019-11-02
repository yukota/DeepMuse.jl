using Test

using CureMIDI

@testset "hoge" begin
    @debug "8PT"


    ms = CureMIDI.tick_to_ms(UInt(960 / 2) , Int16(960), 120)
    @debug "8pt" ms
end
