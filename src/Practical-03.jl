# Chapter 3: Modules and Packages

module M1
export plus_one
"""
    plus_one(x)

Add 1 to the input `x` and return the result.

# Example

For example: `plus_one(5)` will return `6`.
"""
plus_one(x) = x + 1
end

module M2
export minus_one
minus_one(x) = x - 1
end

using .M1
using .M2

# Qualify calls to avoid export collisions in Main.
println(M1.plus_one(99))  # Output: 100
println(M2.minus_one(101)) # Output: 100
