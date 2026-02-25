# Chapter 8: The Type System

# Multiple dispatch

function weather_report(raining::Bool)
    if raining
        n = ""
    else
        n = "not "
    end
    gf = "London"
    println("It is $(n)raining in $gf today.")
end

function weather_report(raining)
    println("Please tell us if it's raining with \"true\" or \"false\".")
    return
end

weather_report(true)
weather_report(false)
weather_report(17)

function weather_report(raining::Bool, city::String)
    if raining
        n = ""
    else
        n = "not "
    end
    println("It is $(n)raining in $city today.")
end

weather_report(true, "Paris")
weather_report(false, "New York")

methods(weather_report)

# Extending built-in functions with new methods

import Base: +
function +(a::Number, b::String)
    if Meta.parse(b) isa Number
        return a + Meta.parse(b)
    else
        return a
    end
end

1 + "16"
1 + "16.0"
1 + "sixteen"
1 // 2 + "0.5"
π + "1"

# Understanding Union Types amd <: Operator

17 isa Union{Number,String}
Real <: Union{Number,String}

abstract type MyNumber <: Number end

# Creating Composite Types

struct EarthLocation
    latitude::Float64
    longitude::Float64
    timezone::String
end

NYC = EarthLocation(40.7128, -74.0060, "EST")
typeof(NYC)
NYC.latitude
NYC.longitude
NYC.timezone

EarthLocation(a, b) = EarthLocation(a, b, "Unknown")
someplace = EarthLocation(59.45607, -135.316681)
someplace.timezone

mutable struct MutableEarthLocation
    latitude::Float64
    longitude::Float64
    timezone::String
end

NYC = MutableEarthLocation(40.7128, -74.0060, "EST")
NYC.timezone = "US/Eastern"
NYC

abstract type Circle end
struct FloatingCircle <: Circle
    r::Real
end
supertypes(FloatingCircle)

struct PositionedCircle <: Circle
    x::Real
    y::Real
    r::Real
end

subtypes(Circle)

function circle_area(c::Circle)
    return π * c.r^2
end

c1 = FloatingCircle(1)
c1.r
circle_area(c1)
c2 = PositionedCircle(2, 2, 1)
c2.x, c2.y
c2.r
circle_area(c2)

function is_inside(c1::PositionedCircle, c2::PositionedCircle)
    d = sqrt((c2.x - c1.x)^2 + (c2.y - c1.y)^2)
    return d + c2.r < c1.r
end

a = PositionedCircle(2, 2, 2)
b = PositionedCircle(1, 1, 0.5)
is_inside(a, b)
c = PositionedCircle(3, 3, 1)
is_inside(a, c)

using Luxor

@pdf begin
    origin(Point(30, 30))
    scale(100, 100)
    fontsize(0.32)
    fontface("JuliaMono")
    setdash("solid")
    circle(Point(2, 2), 2, :stroke)
    text("A", Point(1, 3))
    circle(Point(1, 1), 0.5, :stroke)
    text("B", Point(1, 1))
    circle(Point(3, 3), 1, :stroke)
    text("C", Point(3, 3))
end 500 500 "circles.pdf"

struct ReasonableCircle <: Circle
    r::Real
    ReasonableCircle(r) =
        if r >= 0
            new(r)
        else
            error("Radius must be non-negative.")
        end
end

ReasonableCircle(12).r

# Defining structs with Base.@kwdef

using Base: @kwdef as @kwdef

@kwdef struct Ellipse
    axis1::Real = 1
    axis2::Real = 1
end

oval = Ellipse(axis2 = 2.6)
oval.axis1, oval.axis2
Ellipse(2, 3)

# Performance Tips

function safe_divide(a, b)::Float64
    if b == 0
        return 0.0
    else
        return a / b
    end
end

safe_divide(1, 2)
safe_divide(1, 0)

@code_warntype safe_divide(1, 2)

# Avoid changing the type of a variable in a function

function leibniz(N)
    s = 0.0
    for n ∈ 0:N
        s += (-1)^n / (2n + 1)
    end
    return 4.0 * s
end

@code_warntype leibniz(100)

# Type Aliases

const F64 = Float64
typeof(3.14)
3.14 isa F64

# Parametric Types

typeof(2 + 2im)
typeof(2.0 + 2.0im)
typeof(1 // 2 + 1 // 2im)
typeof([1, 2, 3])
supertype(Vector)
supertype(DenseVector)

@kwdef struct CEllipse{T}
    axis1::T
    axis2::T
end
e1 = CEllipse(12.0, 17.0)
e2 = CEllipse("Clams", "Snails")

@kwdef struct CEllipse2{T<:Number}
    axis1::T
    axis2::T
end

e2 = CEllipse2(1 // 3, 1 // 5)

function eccentricity(e::CEllipse2{<:Real})
    a = max(e.axis1, e.axis2)
    b = min(e.axis1, e.axis2)
    return sqrt(a^2 - b^2 / a)
end

function eccentricity(e::CEllipse2{<:Complex})
    a = max(abs(e.axis1), abs(e.axis2))
    b = min(abs(e.axis1), abs(e.axis2))
    return sqrt(abs(a^2 - b^2) / abs(a))
end

@pdf begin
    scale(100, 100)
    fontsize(0.22)
    fontface("JuliaMono")
    setdash("dash")
    line(Point(-2, 0), Point(2, 0), :stroke)
    line(Point(0, -2), Point(0, 2), :stroke)
    text("Re", Point(1.6, -0.1))
    text("Im", Point(0.1, -1.8))
    setdash("dot") # Ellipse axes
    line(Point(0, 0), Point(sqrt(2), -sqrt(2)), :stroke)
    line(Point(0, 0), Point(-1 / sqrt(2), -1 / sqrt(2)), :stroke)
    text("α", Point(0.25, -0.08))
    setdash("solid") # The ellipse
    rotate(-π / 4)
    ellipse(0, 0, 4, 2, :stroke)
end 500 500 "ellipse.pdf"

function orientation(e::CEllipse2{<:Complex})
    if abs(e.axis1) > abs(e.axis2)
        a = e.axis1
    else
        a = e.axis2
    end
    return angle(a)
end

e45 = CEllipse2(2 + 2im, -1 + im)
eccentricity(e45)
orientation(e45)
orientation(e45) |> rad2deg

# Plot Recipes

using Dates
using RecipesBase

@kwdef struct TempExtremes
    tempunit::String = "°C"
    temps::Vector{Tuple{Float64,Float64}}
end

@kwdef struct WeatherData
    temps::TempExtremes
    rainfall::Vector{Float64}
end

@kwdef struct WeatherReport
    notes::String
    location::Tuple{Float64,Float64}
    data::WeatherData
    start::Dates.Date
end

tmin = randn(60) .+ 15.0
tmax = tmin .+ abs.(randn(60)) .+ 3.0
td = TempExtremes(temps = collect(zip(tmin, tmax)))
wd = WeatherData(rainfall = abs.(randn(60) .+ 5.0 .+ 4), temps = td)
wr = WeatherReport(
    notes = "Rainfall and Temperature Extremes.",
    location = (72.03, -45.47),
    data = wd,
    start = Date(1856, 12, 31),
)

@recipe function f(::Type{Val{:ebxbox}}, x, y, z; cycle = 7)
    if cycle <= 2
        cycle = 7
    end
    ymin = similar(y)
    ymax = similar(y)
    yave = similar(y)
    seriestype := :line
    for m = 1:cycle:length(y)
        nxt = min(m + cycle - 1, length(y))
        ymin[m] = ymax[m] = yave[m] = NaN
        ymin[m+1:nxt] .= minimum(y[m:nxt])
        ymax[m+1:nxt] .= maximum(y[m:nxt])
        yave[m+1:nxt] .= sum(y[m:nxt]) / (nxt - m + 1)
    end
    @series begin
        y := ymax
        linecolor --> "#ff000049"
        linewidth --> 6
    end
    @series begin
        y := ymin
        linecolor --> "#0000ff49"
        linewidth --> 6
    end
    @series begin
        y := yave
        linecolor --> "#66666649"
        linewidth --> 6
    end
end

@recipe function f(::Type{Val{:temprange}}, x, y, z)
    seriestype := :line
    legend := false
    if plotattributes[:series_plotindex] == 1
        merge!(plotattributes[:extra_kwargs], Dict(:nextfr => y[:]))
        linecolor := :blue
        linewidth := 3
    elseif plotattributes[:series_plotindex] == 2
        fillrange := plotattributes[:extra_kwargs][:nextfr]
        linecolor := :red
        linewidth := 3
        fillcolor := "#45f19655"
    else
        x := []
        y := []
    end
end

using Plots

@shorthands temprange
@shorthands ebxbox

tl = [t[1] for t in wd.temps.temps]
th = [t[2] for t in wd.temps.temps]

temprange([tl, th])

ebxbox(wd.rainfall)
plot!(wd.rainfall, label = "Rainfall")

@recipe function f(::Type{Val{:weatherplot}}, plt::AbstractPlot; cycle = 7)
    frames = get(plotattributes, :frames, 1)
    if frames > 1
        layout := (2, 1)
    end
    cycle := cycle
    legend := false
    @series begin
        if frames > 1
            subplot := 1
            xguide := ""
            ylabel := "Temperature (°C)"
        end
        seriestype := :temprange
    end
    if plotattributes[:series_plotindex] == 3
        @series begin
            if frames > 1
                subplot := 2
            end
            seriestype := :ebxbox
        end
        @series begin
            if frames > 1
                subplot := 2
                title := ""
                ylabel := "Rainfall (mm)"
            else
                ylabel := "Rainfall (mm) / Temperature (°C)"
            end
            seriestype := :line
            linecolor := :aqua
            linewidth := 3
            linestyle := :dot
        end
    end
end

@shorthands weatherplot

weatherplot([tl th wd.rainfall])

@recipe function f(::Type{TempExtremes}, v::TempExtremes)
    tmin = [t[1] for t in v.temps]
    tmax = [t[2] for t in v.temps]
    [tmin tmax]
end

@recipe function f(::Type{WeatherData}, wdt::WeatherData)
    tmin = [t[1] for t in wdt.temps.temps]
    tmax = [t[2] for t in wdt.temps.temps]
    [tmin tmax wdt.rainfall]
end

plot(td)
plot(wd)
weatherplot(wd)

# user Recipes

@recipe function f(wr::WeatherReport; frames = 1)
    title := wr.notes
    frames := frames
    xlabel --> "Days from $(wr.start)"
    @series begin
        seriestype := :weatherplot
        wr.data
    end
end

plot(wr, frames = 2)

using SpecialFunctions

@userplot Risep

@recipe function f(carray::Risep)
    seriestype := :line
    x, y = carray.args
    @series begin
        label := "Real Part"
        linestyle := :solid
        x, real.(y)
    end
    @series begin
        label := "Imaginary Part"
        linestyle := :dot
        x, imag.(y)
    end
end

xc = 0.01:0.001:0.1
risep(xc, expint.(1im, xc); lw = 2)