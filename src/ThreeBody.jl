module ThreeBody

# external dependencies
using StaticArrays
using OrdinaryDiffEq
using LinearAlgebra
using GLMakie

# load submodules in dependency order
include("types.jl")
include("physics.jl")
include("integrators.jl")
include("visualization.jl")

# explicitly declare what's public
export Body
export simulate
export plot_trajectory, plot_energy, animate_trajectory


end # module ThreeBody
