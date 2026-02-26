# Chapter 9: Physics

using Unitful
using Unitful.DefaultSymbols
using Latexify
using Measurements
using Plots

u"1m" + u"1cm"
u"1.0m" + u"1cm"
u"1.0m/1s"
m = u"m";
1m + u"1km"
earth_accel = "9.81m/s^2";
kg_weight_earth = uparse("kg * " * earth_accel)
minute = u"minute"
2s + 1minute
typeof(1minute)
typeof(minute)
convert(Float64, u"1m/100cm")
u"1m * 100cm" |> upreferred
uconvert(u"J", u"1erg")
uconvert(u"kg", u"2slug")
vi = 17u"m/s"
vf = 17.0u"m/s"
ustrip(vi)
ustrip(vf)
unit(vi)
9.8u"m/s^2" |> latexify
mass = 6.3u"kg";
velocity = (0:0.05:1)u"m/s";
KE = mass .* velocity .^ 2 ./ 2;
plot(
    velocity,
    KE;
    xlabel = "Velocity (m/s)",
    ylabel = "Kinetic Energy (J)",
    lw = 3,
    title = "Kinetic Energy vs Velocity",
    legend = :topleft,
)

92 ± 3
typeof(ans)
big(1227.0) ± 2
typeof(ans)

π ± 0.001
π ± 0.01

m1 = 2.20394232 ± 0.00343
Measurements.value(m1)
Measurements.uncertainty(m1)
emass = measurement("9.10938356705(28)e-31")
m1 = measurement(2.03942232e7, 0.00343)
emass
2emass
emass + emass
emass / 2
emass / 2emass

mass = 6.3u"kg" ± 0.5u"kg"
mass = 6.3u"kg";
mass = (1 ± 0.5 / 6.3) * mass;

velocity = (0:0.05:1)u"m/s";
KE = mass .* velocity .^ 2 ./ 2;
plot(
    velocity,
    uconvert.(u"J", KE);
    xlabel = "Velocity",
    ylabel = "Kinetic Energy",
    lw = 2,
    legend = :topleft,
    label = "Kinetic Energy",
)