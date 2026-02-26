# Chapter 12: Mathematics

using Symbolics

@variables a b c ϕ z;

RM = [cos(ϕ) -sin(ϕ); sin(ϕ) cos(ϕ)]

RM * [1, 0]
RM * [0, 1]
RM * [1, 1]
RM * [0.5, 0]
RM * [0.5, 0.6]

substitute(RM * [1, 0], Dict(ϕ => π / 2))

ex = a^2 * z^2 + a^4 * z^4;
substitute(ex, Dict(a => sqrt(b)))
substitute(ex, Dict(a => b^(1 // 2)))

z^3 * z^5
a^5 / a^3

# Bessel functions

function Jm(x, m::Int, N)
    s = 0
    for k ∈ N:-1:0
        s += (-1)^k * x^(2k + m) / (2^(2k + m) * factorial(k) * factorial(k + m))
    end
    return s
end

J19 = Jm(z, 1, 9)

substitute(J19, Dict(z => 1.2))

Jm(1.2, 1, 9)

using Latexify
latexify(J19)

Differential(z)(J19) |> expand_derivatives

using Plots
using LaTeXStrings

# Differentiating the Bessel function
dnJ19 = [Differential(z)(J19) |> expand_derivatives];
for ord = 2:10
    push!(dnJ19, Differential(z)(dnJ19[ord-1]) |> expand_derivatives)
end

plot(
    J19;
    lw = 2,
    xrange = (0, 6),
    yrange = (-0.6, 0.6),
    legend = false,
    xlabel = L"z",
    ylabel = L"J_1, J_1^′, J_1^{\prime\prime}, ...",
)

for ord ∈ 1:10
    plot!(dnJ19[ord]; linestyle = :auto)
end

# Views

R = rand(5, 5)
row1Rview = @view R[1, :]
row1Rview .= 17;
R
@views row1RviewAgain = R[1, :];
row1RviewAgain === row1Rview

# Linear algebra

A = [1 3; 2 4]
b = [1, 7]
A \ b
A * [8.5, -2.5]
inv(A) * b
inv(A) == A^(-1)
A * inv(A)
I22 = A * inv(A);
I22 * A == A * I22 == A

using LinearAlgebra

tr(A) # trace of A
det(A) # determinant of A
eigen(A) # eigenvectors and eigenvalues of A

N = 3000;
G = rand(N, N);
sG = (G + G') / maximum(G + G'); # symmetric matrix
using BenchmarkTools
@btime eigen($G)
@btime eigen($sG)

SsG = Symmetric(sG);
SsG == sG
typeof(SsG)
@btime eigen($SsG)

N = 3000;
G = rand(N, N);
UTt = UpperTriangular(G);
typeof(UTt)
UT = Matrix(UTt);
typeof(UT)
UT == UTt
@btime eigen($UT)
@btime eigen($UTt)

# Equation Solving and factorize()

N = 8000;
G = rand(N, N);
g = rand(N);
fG = factorize(G);
@btime fG \ $g
@btime G \ $g

g = rand(3000)
@btime sG \ $g
@btime SsG \ $g
fSsG = factorize(SsG);
@btime fSsG \ $g;

