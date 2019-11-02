using Test

using Revise

include("../src/model.jl")

@testset "attack" begin
    test_input = Vector{EighthFrame}()
    for _ in 0:9
        attack = EighthFrame()
        push!(test_input, attack)
    end
    last_attack = EighthFrame(true)
    push!(test_input, last_attack)
    ret = attacks(test_input)
end
