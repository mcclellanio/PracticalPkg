# Chapter 10: Statistics

# Random numbers

using Plots
using Printf
using Random
using Statistics
using StatsBase

ra = rand(100000)
scatter(ra, markersize = 1, label = nothing)
rgen = MersenneTwister(7654);
rand(rgen)

# The Monty Hall problem

N = 3000
stay = zeros(Int32, N)
switch = zeros(Int32, N)

for game ∈ 1:N
    doors = 1:3
    prize = rand(doors)
    choice = rand(doors)
    if choice == prize
        stay[game] = 1
    end
end

for game ∈ 1:N
    doors = 1:3
    prize = rand(doors)
    choice = rand(doors)
    if choice != prize
        switch[game] = 1
    end
end

stayra = [sum(stay[1:i]) / i for i = 1:N]
switchra = [sum(switch[1:i]) / i for i = 1:N]

plot(
    1:N,
    [stayra, switchra, ones(N) * 1 / 3, ones(N) * 2 / 3],
    label = ["Stay" "Switch" "" ""],
)

annotate!(2700, 1 / 3 + 0.05, "1/3")
annotate!(2700, 2 / 3 + 0.05, "2/3")

binomial(30, 9)

# Common Statistics Functions

Statistics.median([1, 2, 3, 4, 5])
StatsBase.mode([1, 3, 2, 9, 9])
StatsBase.mode([1, 3, 2, 9, 9, 4, 4])
Statistics.mean([1, 2, 3, 4, 5])
Statistics.mean(x -> x^2, [1, 2, 3, 4, 5])
Statistics.mean(2 .* [1, 2, 3, 4, 5])

# The Normal distribution

N = 10000
averages = zeros(N)
for i ∈ 1:N
    averages[i] = Statistics.mean(rand(1000))
end
histogram(averages, label = "Empirical")

using Distributions

σ = std(averages)
nd = Normal(0.5, σ)
plot!(rand(nd, 10000), seriestype = :scatterhist, label = "Normal sample")

histogram(averages, label = "Empirical", normalize = true)
plot!(rand(nd, 10000), seriestype = :scatterhist, label = "Normal sample", normalize = true)
plot!(0.46:0.001:0.54, pdf.(nd, 0.46:0.001:0.54), lw = 5, label = "Normal PDF")

ra = randn(100000)
scatter(ra, markersize = 1, label = nothing)

# Missing values
m = missing
3m
3 + m
missing / 3
typeof(m)

function plotmissing()
    a::Vector{Union{Missing,Float64}} = sin.(0:0.03:2π) .+ rand(210) / 4
    a[49:54] .= missing
    plot(a, legend = nothing, lw = 3)
end

plotmissing()

a = [1, missing, 2, 3, missing, 4]
sum(skipmissing(a))
for i ∈ skipmissing(a)
    println(i)
end

coalesce.(a, NaN)

import Missings
a = rand(4)
a = Missings.allowmissing(a)
a[3] = missing;
a

# Logic with Missing Values

true | missing
true & missing
false | missing
false & missing
xor(true, missing)
xor(false, missing)
!missing
missing == missing
missing === missing

