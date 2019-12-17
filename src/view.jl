using Plots
gr()

include("types.jl")

function attack_not_attack_check(training_data_set::Vector{TrainingData})


    p1_series = Vector{Plots.Plot}()
    p2_series = Vector{Plots.Plot}()
    cols = 2
    p1_count = 0
    for training_data in training_data_set
        if training_data.is_attack
            p = Plots.Plot()
            plot(p, training_data, "attack")
            push!(p1_series, p)
        end
        if length(p1_series) > cols
            break
        end
    end



    for training_data in training_data_set
        if !training_data.is_attack
            p = Plots.Plot()
            plot(p, training_data, "not attack")
            push!(p2_series, p)
        end
        if length(p2_series) > cols
            break
        end
    end

    p1 = Plots.plot(p1_series[1], p2_series[1])
    p2 = Plots.plot(p1_series[2], p2_series[2])
    Plots.plot(p1, p2, layout = (1, cols))

    savefig("test.png")

end

function plot(plt::Plots.Plot, training_data::TrainingData, title)
    x = 1:length(training_data.data)
    y = training_data.data

    Plots.plot!(plt, x, y, title = title)
end
