
using Statistics

using Flux

using MIDI

include("types.jl")



struct Model
    model::Chain
end



function duration_tick(notes)
    starttick = notes[1].position
    endtick = maximum(map(note -> note.position + note.duration, notes))
    return endtick - starttick
end


function create_model(input_dim::UInt)
    chain = Chain(Dense(input_dim, 2, relu), softmax)

    model = Model(chain)
end



function train!(model::Model, training_data_set::Vector{TrainingData})
    # spearate accuracy check data.
    accuracy_check_data_set = training_data_set[end-1:end]
    true_training_data_set = training_data_set[1:end-2]


    inputs = create_inputs(true_training_data_set)
    outputs = create_outputs(true_training_data_set)
    dataset = zip(inputs, outputs)

    acc_inputs = create_inputs(accuracy_check_data_set)
    acc_outputs = create_outputs(accuracy_check_data_set)
    acc_dataset = zip(acc_inputs, acc_outputs)

    loss(x, y) = Flux.crossentropy(model.model(x), y)
    accuracy(x, y) = mean(Flux.onecold(model.model(x)) .== Flux.onecold(y))
    opt = Flux.ADAM()
    Flux.train!(loss, params(model.model), dataset, opt)

end

function create_inputs(training_data_set::Vector{TrainingData})
    ret = Vector{Vector{Float32}}()
    for training_data in training_data_set
        push!(ret, training_data.data)
    end
    ret
end

function create_outputs(training_data_set::Vector{TrainingData})
    ret = Vector{Flux.OneHotVector}()
    for training_data in training_data_set
        push!(ret, onehot(training_data))
    end
    ret
end

function onehot(training_data::TrainingData)
    if training_data.is_attack
        return Flux.OneHotVector(1, 2)
    else
        return Flux.OneHotVector(2, 2)
    end
end

function predict(model::Model, data::Vector{Float32})
    model.model(data)
end
