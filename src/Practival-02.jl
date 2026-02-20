# Chaptwr 2: Language Basics


# Types of Numbers

typeof(1) # Int64
typeof(1.0) # Float64
typeof(1 + 2im) # Complex{Int64}
typeof(1.0 + 2.0im) # Complex{Float64}

typeof(2.0e20) # Float64

1 / 2 # 0.5
1 ÷ 2 # 0
1 // 2 + 1 // 3 # 5//6
1 // 2 + 1 // 2 # 1//1
1 // 2 + 0.5 # 1.0

2^3 # 8
2^0.5 # 1.414213562373095
2^-1 # 0.5
(1 + im)^2 #
(1 + im)^(1 + im) # 0.2739572538301212 + 0.5837007587586145im
0^-1
(0 // 1)^-1
5 % 2 # 1

w = 2
2w # 4
2^2w # 16
2^2 * w
1 / 2w
1 / 2 * w

## Ecpression Blocks

c = 'x'
typeof(c) # Char
c = Int('x') # 120
typeof(c) # Int64
5 ≥ 5
j = 0
while j < 5
    println(j^2)
    j += 1
end

n = 6.0
if n % 2 === 0
    println("That number is Even")
elseif n % 2 === 1
    println("That number is Odd")
else
    println("That number is not an integer")
end
[1, 2, 3, 4, 5]
a = [4, [5.0, 6], 7]
a[1] # 4
a[end] # 7
a[2]
a[2][2] # 6.0
collect(1:5)
[collect(1:2:10), collect(2.5:-0.5:0)]
v = collect(0:5:20)
v[2:4] # [5, 10, 15]
v[end:-2:1] # [20, 10, 0]
m = [5 6; 7 8]
v = [[5, 6], [7, 8]]
m[1, 1] # 5
m[2, :] # [7, 8]
m = [11 12 13 14; 15 16 17 18; 19 20 21 22]
length(m) # 12
size(m) # (3, 4)
m[2, [2, 3]] # [16, 17]
m[[1, 2], [3, 4]]
m[[2 3; 4 5]]
m[[end 1 9; 9 1 end]]

# Tuples

t1 = (5, 6)
t2 = (5, 6)
t1 === t2 # true
2 ∈ [1, 2, 3] # true
2 ∉ [1, 2, 3] # false
2 ∈ [1, 2.0, 3]
[2, 3] ∈ [2, 3, 4]
[2, 3] ∈ [[2, 3], 4]
'a' + 1
'c' - 'a'
'a' ∈ "abc"
n = "Michael"
n[1] # 'M'
n[end] # 'l'
length(n) # 7

# for Blocks

for j = 1:5
    println(j^2)
end

for q ∈ 8:-2:1
    println(1 / q)
end

for i ∈ 0:3, j ∈ 4:6
    println([i, j, i + j])
end

for x ∈ [[-19 23 0]; [-1 22 17]]
    println(abs(x))
end

for c in n
    print(c * " ")
end

# Functions

function double(x)
    2x
end

double(-3.1) # -6.2

function length3d(x, y, z)
    if x < 0 || y < 0 || z < 0
        return "I only work with non-negative numbers"
    end
    sqrt(x^2 + y^2 + z^2)
end

length3d(1, 2, 3) # 3.7416573867739413
length3d(1, 1, 1) # 1.7320508075688772
length3d(1, 1, -1)

function tellme(f, x)
    print("The result is: ")
    f(x)
end
tellme(double, 5) # The result is: 10
tellme(abs, -17) # The result is: 17

# Composing Functions

double(double(3)) # 12
(double ∘ double)(3) # 12
3 |> double |> double # 12

function string_decorator(s)
    decorated = ""
    for c in s
        decorated *= c * " • "
    end
    decorated[1:end-5]
end
string_decorator("Michael")
string_decorator("Julia")

function better_string_decorator(s)
    a = String[]
    for c ∈ s
        push!(a, c * " • ")
    end
    join(a)[1:end-5]
end

better_string_decorator("Michael")
better_string_decorator("Julia")

split("a        b c")
split("a||b||c", "||")