# Chapter 5: Collections

# The break statement

n = [12, 53, 19, 64, 16, 8]

for x ∈ n
    if round(√x) == √x
        println("Found a perfect square in the list: ", x)
        break
    end
end

# The continue statement

for n ∈ 1:100
    possibly_prime = true
    x = 2
    while x ≤ √n
        if n % x == 0
            possibly_prime = false
            break
        end
        x += 1
    end
    if !possibly_prime
        continue
    else
        println(n)
    end
end

# Comprehensions and generators

xs = [x^2 for x = 1:10]

[2x for x ∈ [1 2; 3 4]]

[x * y for x ∈ 1:3 for y ∈ 1:3]

[x * y for x ∈ 1:3, y ∈ 1:3]

[x * y for x ∈ 1:9, y ∈ 1:9 if x * y % 2 == 0 && x * y % 7 == 0] |> unique

multiplication_generator = (x * y for x ∈ 1:9, y ∈ 1:9)

[n for n ∈ multiplication_generator if n % 2 == 0 && n % 7 == 0] |> unique

# More ways to join strings

using LaTeXStrings
comma_space = ", "
string("Hello", comma_space, "world", comma_space, "and", comma_space, "Julia")
repeat("Hello", 3)
println(L"e^{iπ}+1=0")

print(raw"a\tb")
print("a\tb")
print("I said \"Hello\".")
print(raw"I said \"Hello\".")

v"1.6.1" < v"1.7.0"

versioninfo()

version = v"1.12.5"
version.major, version.minor, version.patch
b"a2Σ"

s = "abc"
replace(s, "b" => "XX", "c" => "Z")
replace(s, "c" => "Z", "Z" => "WW")

occursin("abc", "abcdef") # true
occursin("abc", "abCdef") # false

findfirst('a', "abcabc")
findlast('a', "abcabc")
findfirst("abc", "abcabc")
findlast("abc", "abcabc")

q = "The quick brown fox jumps over the lazy dog."
q = "To be or not to be, that is the question."
i = 0
locations = []
while i !== nothing
    i = findnext('e', q, i + 1)
    push!(locations, i)
end

print(
    """The letter 'e' occurs at the following locations in the string:""",
    join(locations[1:end-1], ", ", " and "),
    ".",
)

s = "abc<ABC>def"
replace(s, r"<.*>" => "")
replace(s, r"(.*)<(.*)>(.*)" => s"\1\3, \2")

function name_length(name)
    println("Hi. What's your name?")
    println("Hello, $name. Your name has $(length(name)) characters.")
end

name_length("Alice")

# Dictionaries

bd = Dict("one" => 1, "two" => 2, "three" => 3)
bd["two"]
keys(bd)
values(bd)
bd["one"] = 9;
bd

# Sets

s1 = Set(1:5)
s2 = Set(4:8)
typeof(s1), typeof(s2)
intersect(s1, s2)
union(s1, s2)
issubset(4:7, s2)
4:7 ⊆ s2
4:7 ⊇ s2
setdiff(s1, 3:5)
push!(s1, 999)
setdiff!(s1, 1:3)

# Structs

struct Website
    url::String
    title::String
    description::String
end
w = Website(
    "https://www.julia-lang.org/",
    "The Julia Language",
    "A high-level, high-performance programming language for technical computing.",
)
typeof(w)
w.url, w.title, w.description
g = Website(
    "https://www.github.com/",
    "GitHub",
    "A web-based hosting service for version control using Git.",
)
g.url, g.title, g.description

# Named Tuples

nt = (a = 1, b = 2, c = 3);
nt.c

# Initializing Arrays with Functions

repeat(['a' 'b' '|'], 4, 3)
XY = fill(['X' 'Y'], 3, 4)
XY = fill(['X' 'Y'], (3, 4))
XY[1, 4] = ['0' 'Y'];
XY
xy = [['X' 'Y'] for i = 1:3, j = 1:4]
xy[1, 4][1] = '0';
xy
xy[1, :]

zeros(3, 4)

a1 = collect(1:6);
a2 = reshape(a1, (3, 2))
a1[5] = 0;
a2

# BitArrays

s3 = (1:26) .% 3 .== 0
(1:26)[s3]
('a':'z')[s3]
(1:100)[(1:100) .% 17 .== 0]

# Adjoints and Transposes

MR = [1 2; 3 4]
MR'
MR' == adjoint(MR) == permutedims(MR)

M = [[1 + im 2 + 2im]; [3 + 3im 4 + 4im]]
M'
Mt = transpose(M)
conj(M)
M

# Matrix Multiplication

a = π/2
RM = [[cos(a) -sin(a)]; [sin(a) cos(a)]];
RM * [1, 0]

MR^-1
MR
MR^-1 * MR

# Enumeration and Zipping

collect(enumerate([10 20; 30 40]))
collect(pairs([10 20; 30 40]))
collect(pairs("Julia"))
[p.first for p in pairs("Julia")]
[p.second for p in pairs("Julia")]
p1 = "one" => 1
p2 = Pair("two", 2)
Dict([p1, p2])
Dict(pairs("abc"))
zip([1 3; 3 4], ['a' 'b'; 'c' 'd']) |> collect
zip([1, 2, 3, 4], ['a' 'b'; 'c' 'd']) |> collect
zip(1:3, ['a' 'b'; 'c' 'd']) |> collect
zip(1:5, ['a' 'b'; 'c' 'd']) |> collect
