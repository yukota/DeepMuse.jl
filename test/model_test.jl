using Test

using Plots
gr()


using Flux
using Statistics
using Flux.Tracker: TrackedReal, data
using Flux: mse
using Base.Iterators: repeated, flatten


# 訓練データ数
N = 100

X = range(0, stop = pi, length = N)
Y = sin.(X)

# 訓練データをプロットしておく
plot(X, Y)


data_x = [[x] for x in X]
data_y = [[y] for y in Y]
data_xf = Iterators.flatten(repeated(data_x, 100))
data_yf = Iterators.flatten(repeated(data_y, 100))
dataset = zip(data_xf, data_yf)

m = Chain(
    Dense(1, 20, relu),
    Dense(20, 1, σ))


loss(x, y) = mse(m(x), y)

accuracy(x, y) = mean(onecold(m(x)) .== onecold(y))
opt = Descent()
Flux.train!(loss, params(m), dataset, opt)



Nt = 100
Xt = range(0, stop = pi, length = Nt)
input_xt = [[x] for x in Xt]
expect_yt = m.(input_xt)

Yt = collect(Iterators.flatten(expect_yt))
Yt2 = data.(Yt)
plot!(Xt, Yt2)


png("result.png")
# # One-hot-encode the labels


# m = Chain(
#   Dense(1, 32, relu),
#   Dense(32, 1,relu))

# loss(x, y) = crossentropy(m(x), y)

# accuracy(x, y) = mean(onecold(m(x)) .== onecold(y))

# opt = ADAM()

# Flux.train!(loss, params(m), dataset, opt)

# accuracy(X, Y)

# # Test set accuracy
# #tX = hcat(float.(reshape.(MNIST.images(:test), :))...) |> gpu
# #tY = onehotbatch(MNIST.labels(:test), 0:9) |> gpu

# #accuracy(tX, tY)