# Chapter 6: Functions, Metaprogramming, and Errors

# Splatting 

function add_three(a, b, c)
    return a + b + c
end;
add_three(1, 2, 3)
v3 = [1, 2, 3];
add_three(v3...)

function addthreeWithCoefficients(a, b, c; f1 = 1, f2 = 1, f3 = 1)
    return f1 * a + f2 * b + f3 * c
end;
coeffs = (f1 = 100, f2 = 10);
addthreeWithCoefficients(v3...; coeffs...)
csd = Dict(:f1 => 100, :f2 => 10);
addthreeWithCoefficients(v3...; csd...)

# Slurping

function addonlythreeWithNote(a, b, c, more...)
    if length(more) > 0
        println("Ignoring $(length(more)) additional arguments.")
    end
    return a + b + c
end;

addonlythreeWithNote(1, 2, 3, 99, 100, 101)

function examine_strings(s; checks...)
    if :palindrome in keys(checks)
        if s == reverse(s)
            println("\"$s\" is a palindrome")
        end
    end
    if :onlyascii in keys(checks)
        if isascii(s)
            println("\"$s\" contains only ASCII characters.")
        else
            println("\"$s\" contains non-ASCII characters.")
        end
    end
end;

examine_strings
examine_strings("step on no pets"; kw1 = 17, palindrome = 1, onlyascii = 1)

kws = Dict(:palindrome => 1, :anyotherkeyword => 17);
examine_strings("step on no pets"; kws...)

# Destructuring

x, y = (3, 4);

struct Fco
    f1::Any
    f2::Any
    f3::Any
end;
someco = Fco(100, 10, 1)
function addthreeWithCoefficients(a, b, c, (; f1, f2, f3))
    return f1 * a + f2 * b + f3 * c
end;
addthreeWithCoefficients(1, 2, 3, someco)

+(1, 2, 3)
*(8, 2)

function ⊟(a, b)
    return sqrt((b[1] - a[1])^2 + (b[2] - a[2])^2)
end;

v1 = [0, 1];
v2 = [1, 0];
v1 ⊟ v2
3 .* v1 ⊟ 4 .* v2
v1a = [v1, v1, v1]
v2a = [v2, v2, [0, 0]]
v2a .⊟ v1a

# The Mapping, Filtering, and Reducing Opeators

double(x) = 2x
map(double, [2 3; 4 5])
map(+, [2 3], [4 5], [6 7])
map(+, 20:10:40, [2 3; 4 5])
map(+, 20:10:90, [2 3; 4 5])
double.([2 3; 4 5])
[20 30] .+ [2 3; 4 5]
[20, 30] .+ [2 3; 4 5]
map(+, [20, 30], [2 3; 4 5])

filter(x -> x % 17 == 0, 1:100)

q(a, b) = a / b
reduce(q, 1:3)
(1 / 2) / 3
foldl(q, 1:3)
foldr(q, 1:3)
reduce(+, [1 2; 10 20]; dims = 2)
reduce(+, [1 2; 10 20]; dims = 1)
[1 2; 10 20]
reduce(+, []; init = 0)
prod(1:7)
factorial(7)
maximum(sin.(1:0.1:2π))
minimum(sin.(1:0.1:2π))
any(iseven, 3:2:11)
all(isodd, 3:2:11)
mapreduce(x -> x^2, +, 1:100)
reduce(+, map(x -> x^2, 1:100))

# do Blocks
foldl(q, 3:-1:0)
foldl(3:-1:0) do x, y
    if y == 0
        return x
    else
        return x / y
    end
end

# Symbols and Metaprogramming

ex = quote
    a = 3
    a + 2
end;
typeof(ex)
eval(ex)
a
w = 3
ex = :(w * 5)
ey = :($w * 5)
eval(ex)
eval(ey)
w = 4
eval(ex)
eval(ey)
mkvar(s, v) = eval(:($(Symbol(s)) = $v))
mkvar("Arthur", 42)
Arthur

# Macros
macro mkvarmacro(s, v)
    ss = Symbol(s)
    return esc(:($ss = $v))
end

@mkvarmacro "color" 17
color
macro during(condition, body)
    return quote
        while $condition
            $(esc(body))
        end
    end
end

i = 0
@during i < 10 (println(i^2); i += 1)
i

macro until(condition, body)
    return quote
        while !$condition
            $(esc(body))
        end
    end
end
i = 0
@until i == 11 (println(i^3); i += 1)

# The Broadcast macro

r = 1:10
[r (@. exp(r) > r^4) (exp.(r) .> r .^ 4)]

sum((1:10) .^ 2)
@. $sum((1:10)^2)

"hello" |> uppercase |> reverse

using BenchmarkTools
using Chain

@chain "hello" begin
    uppercase
    reverse
    occursin("OL", _)
end

@btime sum((1:1e8) .^ 2)

const d = 1.0045338347428372e6

@btime sum(i / d for i = 1:1e9)
@btime @fastmath sum(i / d for i = 1:1e9)

using Printf
@printf "10! is about %.2e and √2 is approximately %.4f" factorial(10) sqrt(2)

@__DIR__
@__FILE__

# Error Handling

function aa(n)
    bb(n)
end

function bb(n)
    n -= 1
    cc(n)
end

function cc(n)
    n -= 1
    dd(n)
end

function dd(n)
    n -= 1
    ee(n)
end

function ee(n)
    return log(n)
end

aa(5)

function friendly_log(n)
    try
        return log(n)
    catch oops
        if oops isa DomainError
            @warn "you may have supplied a negative number: $n"
            @info "Trying with $(-n) instead."
            log(-n)
        elseif oops isa MethodError
            @error "please supply a positive number, not $n"
        end
    end
end

function call_fl(n)
    friendly_log(n)
end

call_fl(-3)

function finite_log(n)
    if n == 0
        throw(DomainError(n, "please supply a positive argument; log(0) = -Inf."))
    end
    return log(n)
end

finite_log(2)
finite_log(0)
log(0)

# Combining throw() with try...catch Blocks

function fa(n)
    try
        fb(n)
    catch oops
        if oops[1] == 0
            @warn "$(oops[2]) Attempted to call log(0) = Inf."
        else
            @error "$(oops[2]) Attempted to call log($(oops[1]))."
        end
    end
end

function fb(n)
    n -= 1
    fc(n)
end

function fc(n)
    n -= 1
    fd(n)
end

function fd(n)
    n -= 1
    fe(n)
end

function fe(n)
    if n < 0
        throw((n, "Got a negative number."))
    elseif n == 0
        throw((0, "Got zero."))
    end
    return log(n)
end

fa(5)
fa(3)
fa(2)

#  The finally Clause

function fa(n)
    try
        fb(n)
    catch oops
        if oops[1] == 0
            @warn "$(oops[2]) Attempted to call log(0) = Inf."
        else
            @error "$(oops[2]) Attempted to call log($(oops[1]))."
        end
    finally
        println("Calculation completed with input n = $n.")
    end
end

fa(5)
fa(2)

