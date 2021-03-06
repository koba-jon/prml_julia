using Distributions
using LinearAlgebra
using Plots

# Set Parameters
M = 9  # total number of training data
N = 9  # degree of a polynomial
lambda_ = 1.75e-6  # regularization parameter

# Set Function to Generate Data
dist = Normal(0.0, 0.1)
base(x) = sin.(2pi*x)
gen(x) = base(x) + rand(dist, length(x))

# Set Function to Generate Polynomial Matrix
function polynomial_matrix(x, N)
    m = length(x)
    X = fill(1.0, m)
    for j in 1:N
        x_vec = x .^ j
        X = hcat(X, x_vec)
    end
    return X
end

# Set Function to Calculate Coefficient
function weight(x, y, N, lambda_)
    X = polynomial_matrix(x, N)
    w = (X' * X + lambda_ * Matrix{Float64}(I, N+1, N+1)) \ X' * y
    return w
end

# Set Function to Output Value
function f(x, w)
    X = polynomial_matrix(x, length(w)-1)
    y = X * w
    return y
end

# Generate Data
step = 1.0 / (M - 1)
x = collect(0.0:step:1.0)
y = gen(x)
println("x = ", x)
println("y = ", y)

# Calculate Coefficient of Polynomial
w = weight(x, y, N, lambda_)
println("w = ", w)

# Output Graph
gr()
scatter(x, y, xlabel="x", ylabel="y", label="data")
graph_x = collect(0.0:0.01:1.0)
graph_y = f(graph_x, w)
plot!(graph_x, base(graph_x), label="base")
plot!(graph_x, graph_y, label=string("f(x, w)"))

# Save Image
savefig("graph")
