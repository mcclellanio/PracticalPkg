# Chapter 9: Physics

# Fluid Dynamics with Oceananigans
using Oceananigans

grid = RectilinearGrid(
    size = (256, 32);
    topology = (Periodic, Flat, Bounded),
    extent = (256, 32),
)

bc = FieldBoundaryConditions(
    top = ValueBoundaryCondition(1.0),
    bottom = ValueBoundaryCondition(20.0),
)

closure = ScalarDiffusivity(ν = 0.05, κ = 0.01)

buoyancy = SeawaterBuoyancy(
    equation_of_state = LinearEquationOfState(
        thermal_expansion = 0.01,
        haline_contraction = 0,
    ),
)

model = NonhydrostaticModel(
    grid;
    buoyancy,
    closure,
    boundary_conditions = (T = bc,),
    tracers = (:T, :S),
)

# simulation = Simulation(model, Δt = 0.01, stop_time = 1800)

