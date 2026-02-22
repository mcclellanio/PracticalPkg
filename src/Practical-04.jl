# Chapter 4: The Plotting System

using Plots

backends()
backend()

plot([0, 3, 1, 4, 1])

plot([0, 0.13, 0.38, 0.88, 1.88], [0, 3, 1, 4, 1])

f(x) = sin(1 / x)

x = π/1000:π/1000:π
y = f.(x)
plot(x, y)

plot([sin, cos, f], -π, π, label = ["sin" "cos" "f"])

x = 0:5π/1000:5π
plot([x; 5π .+ x], [sin.(x); -exp.(-x .* 0.2) .* sin.(x)])

plot(sin, -π, π)
plot!(cos)
plot!(f)

parabola = plot(x -> x^2);
ps = plot(sin, 0, 2π);
plot!(ps, cos);
plot(ps, plot(f), plot(s -> s^3), parabola)

circle = plot(sin, cos, 0, 2π, aspect_ratio = 1)
spiral = plot(r -> r * sin(r), r -> r * cos(r), 0, 8)
plot(circle, spiral, layout = (1, 2))

plot(0:2π/500:2π, t -> 1 + 0.2 * sin(8t); proj = :polar)
plot(0:8π/200:8π, t -> t; proj = :polar)

function ginger(x, y, a)
    x2 = 1.0 - y + a * abs(x)
    y2 = x
    x2, y2
end

x = [20.0];
y = [9.0];
for i ∈ 1:4000
    x2, y2 = ginger(x[end], y[end], 1.76)
    push!(x, x2)
    push!(y, y2)
end

scatter(x, y, ms = 0.5, legend = false)

g(x, y = 2) = x + y
g(4)
g(4, 9)

p(x; y = 2) = x + y
p(4)
p(4; y = 5)

p1 = plot(
    sin,
    cos,
    0,
    2π;
    title = "A Circle",
    ratio = 1,
    grid = false,
    ticks = false,
    legend = false,
)
p2 = plot(
    x -> x^2,
    -1,
    1;
    title = "A Parabola",
    gridalpha = 0.4,
    gridstyle = :dot,
    legend = false,
)
plot(p1, p2; plot_title = "Two Shapes", plot_titlefontsize = 20)

using Plots.PlotMeasures

plot()
for n = 1:5
    plot!(x -> x^n, lw = 3, ls = :auto, label = n)
end
plot!(; legend = :topleft, legend_title = "Exponent")

plot()
for n = 1:5
    xlabel = (0.2 + 0.12n)
    ylabel = xlabel^n
    plot!(
        x -> x^n,
        lw = 3,
        ls = :auto,
        annotation = (xlabel, ylabel, n),
        annotationfontsize = 25,
    )
end

using LaTeXStrings

plot!(;
    legend = false,
    xguide = "x",
    yguide = "y",
    guidefontsize = 20,
    title = L"x^n \textrm{(-labeled-by-)n}",
    titlefontsize = 30,
)

sc = scatter(
    x,
    y;
    smooth = true,
    ms = 1,
    legend = false,
    xguide = "x",
    yguide = "y",
    guidefontsize = 18,
)

pl = plot(x[1:100]; smooth = true, legend = false)

pl = plot!(
    x[1:100];
    lc = :lightgray,
    legend = false,
    xguide = "iteration",
    yguide = x,
    guidefontsize = 18,
)

plot(sc, pl, plot_title = "Gingerbread map with a = 1.6", plot_titlefontsize = 20)

plot()
x = [20.0];
y = [9.0];
for i ∈ 1:20000
    x2, y2 = ginger(x[end], y[end], 1.4)
    push!(x, x2)
    push!(y, y2)
end

scatter(x, y; ms = 0.1, legend = false)
lens!(
    [-16, -12],
    [11, 18];
    inset = (1, bbox(0.1, 0, 0.3, 0.3)),
    ticks = false,
    framestyle = :box,
    subplot = 2,
    linecolor = :green,
    linestyle = :dot,
)

