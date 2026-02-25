# Chaper 7: Diagrams and Animations

using Luxor
using Plots
using Graphs
using GraphRecipes
using Primes: factor

planet_diameters = [4879, 12104, 12756, 3475, 6792, 142984, 120536, 51118, 49528, 2370];
planet_names = [
    "Mercury",
    "Venus",
    "Earth",
    "Moon",
    "Mars",
    "Jupiter",
    "Saturn",
    "Uranus",
    "Neptune",
    "Pluto",
];

dimenx = 1000
dimeny = 500

@png begin
    dscale = 500.0
    origin(Point(planet_diameters[1] / (2 * dscale), dimeny / 2))
    ledge = 0.0
    diameter = 0
    fontface("JuliaMono")
    fontsize(32)
    for i = 1:10
        ledge += diameter / 2.0
        name = planet_names[i]
        diameter = planet_diameters[i] / dscale
        circle(Point(ledge, 0), diameter / 2.0, :stroke)
        txtstart = Point(100 * (i - 1), 100 + 35 * (i % 2))
        text(planet_names[i], txtstart)
        line(txtstart, Point(ledge, 0), :stroke)
    end
end dimenx dimeny "planets.png"

creatures = [
    "Striped bass",
    "Atlantic croaker",
    "White perch",
    "Summer flounder",
    "Clearnose skate",
    "Bay anchovy",
    "Worms",
    "Mysids",
    "Amphipods",
    "Juvenile weakfish",
    "Sand shrimp",
    "Mantis shrimp",
    "Razor clams",
    "Juvenile Atlantic croaker",
]

foodchain = SimpleDiGraph(length(creatures))
food_dict = Dict(creatures[i] => i for i = 1:length(creatures))

function ↪(predator, prey)
    add_edge!(foodchain, food_dict[predator], food_dict[prey])
end

"Striped bass" ↪ "Worms"
"Striped bass" ↪ "Amphipods"
"Striped bass" ↪ "Mysids"
"Striped bass" ↪ "Bay anchovy"
"Atlantic croaker" ↪ "Mysids"
"Atlantic croaker" ↪ "Worms"
"White perch" ↪ "Worms"
"White perch" ↪ "Amphipods"
"Summer flounder" ↪ "Bay anchovy"
"Summer flounder" ↪ "Mysids"
"Summer flounder" ↪ "Juvenile weakfish"
"Summer flounder" ↪ "Sand shrimp"
"Summer flounder" ↪ "Mantis shrimp"
"Clearnose skate" ↪ "Mantis shrimp"
"Clearnose skate" ↪ "Razor clams"
"Clearnose skate" ↪ "Juvenile Atlantic croaker"

graphplot(foodchain; names = creatures, nodeshape = :rect, method = :stress)

foodchain_matrix = adjacency_matrix(foodchain)

function factree(n)
    factors = factor(Vector, n)
    lf = length(factors)
    if lf == 1
        println("$n is prime.")
        return
    end

    names = [n]
    edges = Tuple{Int,Int}[]
    current_idx = 1
    current_val = n

    # Build a binary factorization chain:
    # parent -> (factor, quotient)
    for f in factors[1:end-1]
        q = div(current_val, f)

        push!(names, f)
        f_idx = length(names)
        push!(edges, (current_idx, f_idx))

        push!(names, q)
        q_idx = length(names)
        push!(edges, (current_idx, q_idx))

        current_idx = q_idx
        current_val = q
    end

    nel = length(names)
    a = zeros(Int, nel, nel)
    println("Prime factors: $factors")

    for (src, dst) in edges
        a[src, dst] = 1
    end

    graphplot(
        a;
        nodeshape = :circle,
        nodesize = 0.12 + log10(n) * 0.01,
        axis_buffer = 0.3,
        curves = false,
        lw = 2,
        names = names,
        method = :buchheim,
    )
end

factree(14200)

# Example of a closure: a function that returns a function. The inner function "closes over" the variable n from the outer function.

function power(n)
    return function (x)
        x^n
    end
end

p = power(5)
q = x -> x^5
p(4) == q(4) == 1024

plot([power(n) for n = 1:5], legend = :topleft)

