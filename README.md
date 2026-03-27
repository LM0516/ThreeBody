# ThreeBody.jl

> **Note:** This is my first Julia project! I'm a physics student learning a new programming language, and I built this project for learning purposes to explore a couple of libraries in the Julia ecosystem.

`ThreeBody.jl` is a high-performance Julia package for simulating and visualizing the classical 3-Body Problem. Leveraging the power of [`OrdinaryDiffEq.jl`](https://github.com/SciML/OrdinaryDiffEq.jl) for accurate time-stepping and [`GLMakie.jl`](https://github.com/MakieOrg/Makie.jl) for rich 2D/3D visualizations, this package offers a complete suite to experiment with gravitational dynamics.

## Features

- **High-Performance Physics**: Computations built on `StaticArrays` for fast, allocation-free vector math.
- **Accurate ODE Solvers**: Uses `Tsit5` with tight tolerances (`1e-8`) by default to conserve energy effectively.
- **Seamless Visualizations**: Immediately plot trajectories, check energy conservation, or animate your setups to MP4 videos.

## Installation

The package is not yet registered in the General registry. You can install it directly from GitHub using Julia's Pkg manager:

```julia
using Pkg
Pkg.add("https://github.com/LM0516/ThreeBody.jl")
```

## Quick Start
```julia
using ThreeBody
using StaticArrays

# Define three bodies with (mass, initial_position, initial_velocity)
# We use SVector{3, Float64} for positions and velocities
m1 = 1.0; r1 = SVector( 1.0, 0.0, 0.0); v1 = SVector(0.0,  0.5, 0.0)
m2 = 1.0; r2 = SVector(-1.0, 0.0, 0.0); v2 = SVector(0.0, -0.5, 0.0)
m3 = 1.0; r3 = SVector( 0.0, 1.0, 0.0); v3 = SVector(-0.5, 0.0, 0.0)

b1 = Body(m1, r1, v1)
b2 = Body(m2, r2, v2)
b3 = Body(m3, r3, v3)

# Run the simulation
# Returns an ODESolution object
sol = simulate(b1, b2, b3; tspan=(0.0, 10.0))
```

## Visualization Tools

`ThreeBody.jl` exports several helper functions to visualize your results automatically:

```julia
# The visualization functions require passing the masses separately as an array
masses = [b1.mass, b2.mass, b3.mass]

# 1. Plot the trajectory of the 3 bodies
fig_traj = plot_trajectory(sol, masses)
display(fig_traj)

# 2. Plot the total energy of the system over time
# Should remain relatively constant if the integration tolerances are strict enough
fig_energy = plot_energy(sol, masses)
display(fig_energy)

# 3. Create an MP4 animation of the simulation
animate_trajectory(sol, masses; filename="simulation_output.mp4", fps=30)
```

## Physics Context
The package solves the classical Newtonian gravitational equations using `G = 6.674e-11`. The state is packed into a flat vector for `DifferentialEquations.jl` to handle and subsequently tracked for variables such as Kinetic Energy and Potential Energy.
