# Chapter 8: The Type System

using Plots
using Graphs
using GraphRecipes

typemax(Int16)
typemin(Int16)
floatmax(Float16)
floatmin(Float16)
isa(17, Int64)
17 isa Number
factorial(20)

plot(factorial.(big.(1:50)), yscale = :log10, label = "Factorial", legend = :topleft)
big(1.0 / 3)
precision(big(1.0))
precision(float(1.0))
π
typeof(π)
typeof(big(π))
big(π)
ℯ
big(ℯ)
log(ℯ)

typeof(17)
supertype(Int64)
supertype(Signed)
supertype(Integer)
supertype(Real)
supertype(Number)
supertype(Any)

sometypes = [
    Any,
    Complex,
    Float64,
    Int64,
    Number,
    Signed,
    Irrational,
    AbstractFloat,
    Real,
    AbstractIrrational,
    Integer,
    String,
    Char,
    AbstractString,
    AbstractChar,
    Rational,
    Int32,
    Vector,
    DenseVector,
    AbstractVector,
    Array,
    DenseArray,
    AbstractArray,
]

type_tree = SimpleDiGraph(length(sometypes))

for t in sometypes[2:end]
    add_edge!(type_tree, indexin([supertype(t)], sometypes)[1], indexin([t], sometypes)[1])
end

graphplot(
    type_tree;
    names = [string(t) for t in sometypes],
    nodeshape = :rect,
    fontsize = 4,
    nodesize = 0.17,
    nodecolor = :white,
    method = :buchheim,
)

supertypes(Irrational)
subtypes(Real)

17::Number
17::Int64

function greetings()
    println("Who are you?")
    yourname = "Michael"
    greeting = ("Hello, " * yourname * ".")
    return greeting::String
end

greetings()

a::Int16 = 17
typeof(a)
a = 32767

global gf::Float64

gf = 17
gf
typeof(gf)

function weather_report(raining)
    if !(raining isa Bool)
        println("Please tell us if it's raining or not.")
        return
    else
        if raining
            n = ""
        else
            n = "not "
        end
        local gf::String
        gf = "London"
        return "It is $(n)raining in $gf today."
    end
end

weather_report(true)
weather_report(false)

function type_dec_demo()
    a = 17
    println("a = $a and has the type $(typeof(a)).")
    local a::Int16
end

type_dec_demo()

function changing_type_demo()
    a = 17
    println("a = $a and has the type $(typeof(a)).")
    a = a + 1.0
    println("a = $a and has the type $(typeof(a)).")
end
changing_type_demo()

