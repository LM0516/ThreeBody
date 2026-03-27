using ThreeBody
using StaticArrays
using GLMakie
using BenchmarkTools
using Test

# ── initial conditions ──────────────────────────────────────────────
body1 = Body(1.0e10, SVector(-0.97000436,  0.24308753, 0.0), SVector(0.93240737/2,  0.86473146/2, 0.0))
body2 = Body(1.0e10, SVector( 0.97000436, -0.24308753, 0.0), SVector(0.93240737/2,  0.86473146/2, 0.0))
body3 = Body(1.0e10, SVector( 0.0,         0.0,        0.0), SVector(-0.93240737,  -0.86473146,   0.0))
masses = [body1.mass, body2.mass, body3.mass]

# ── warmup ──────────────────────────────────────────────────────────
println("Warming up...")
simulate(body1, body2, body3, tspan=(0.0, 0.1))
sol_warm = simulate(body1, body2, body3, tspan=(0.0, 0.1))
plot_trajectory(sol_warm, masses)
plot_energy(sol_warm, masses)
animate_trajectory(sol_warm, masses)
println("Warmup done.")

# ── tests ───────────────────────────────────────────────────────────
@testset "Physics" begin

    @testset "visualization" begin
        sol  = simulate(body1, body2, body3, tspan=(0.0, 6.0))

        fig1 = plot_trajectory(sol, masses)
        save("trajectory.png", fig1)
        @test fig1 isa Figure

        fig2 = plot_energy(sol, masses)
        save("energy.png", fig2)
        @test fig2 isa Figure

        filename = "test_simulation.mp4"
        animate_trajectory(sol, masses, filename=filename)

        # check the file was created
        # @test isfile(filename)

        # check the file is not empty
        # @test filesize(filename) > 0

        # check the returned filename matches what we asked for
        # @test result == filename

        # cleanup after test
        # rm(filename)
    end

end

# ── benchmarks ──────────────────────────────────────────────────────
# println("\nBenchmarks:")
# println("simulate:               "); display(@benchmark simulate($body1, $body2, $body3, tspan=(0.0, 2.0)))
# println("plot_trajectory:        "); display(@benchmark plot_trajectory($sol_warm, $masses))
# println("plot_energy:            "); display(@benchmark plot_energy($sol_warm, $masses))
# println("animate_trajectory:     "); display(@benchmark animate_trajectory($sol_warm, $masses))
