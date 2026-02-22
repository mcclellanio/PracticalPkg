# Chapter 4: The Plotting System

using Plots

# backends()
backend()

x = collect(-1:0.01:1)

surface(
    x,
    x,
    (x, y) -> exp(-(0.05x^2 + y^2) / 0.1);
    fillalpha = 0.5,
    camera = (45, 50),
    xrotation = 45,
    yrotation = 45,
)

heatmap(x, x, (x, y) -> exp(-(0.05x^2 + y^2) / 0.1))

contour(
    x,
    x,
    (x, y) -> exp(-(0.05x^2 + y^2) / 0.1);
    clabel = true,
    levels = [0.1, 0.3, 0.5, 0.7, 0.9, 1.0],
    framestyle = :box,
    fill = true,
)

# 3D Parametric Plotting

t = 0:2π/100:2π;
xp = sin.(3 .* t);
yp = cos.(3 .* t);
zp = t .* 0.2;
plot(xp, yp, zp; lw = 3, gridalpha = 0.4, camera = (30, 50))

# Vector Plot

xc = 0:0.3:π;
yc = sin.(xc);
quiver(xc, yc; quiver = (xc .- π / 2, yc .- 0.25), lw = 3)

# 3D Scatter Plot

x = [];
y = [];
z = [];

for i = 0:20, j = 0:20, k = 0:20
    push!(x, i / 10 - 1)
    push!(y, j / 10 - 1)
    push!(z, k / 10 - 1)
end

pot(x, y, z) = 1 / sqrt(y^2 + z^2)
scatter(x, y, z; ms = min.(pot.(x, y, z), 5), ma = 0.4, legend = false)

