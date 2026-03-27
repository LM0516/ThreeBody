function plot_trajectory(sol, masses)

    # extract positions for each body over time
    pos1 = [sol.u[i][1:3]  for i in eachindex(sol.u)]
    pos2 = [sol.u[i][7:9]  for i in eachindex(sol.u)]
    pos3 = [sol.u[i][13:15] for i in eachindex(sol.u)]

    # split into x, y, z components
    x1 = [p[1] for p in pos1]; y1 = [p[2] for p in pos1]
    x2 = [p[1] for p in pos2]; y2 = [p[2] for p in pos2]
    x3 = [p[1] for p in pos3]; y3 = [p[2] for p in pos3]

    fig = Figure(size = (800, 600))
    ax  = Axis(fig[1, 1], title = "Three Body Simulation", xlabel = "x", ylabel = "y")

    # trajectories
    lines!(ax, x1, y1, color = :blue,  label = "Body 1")
    lines!(ax, x2, y2, color = :red,   label = "Body 2")
    lines!(ax, x3, y3, color = :green, label = "Body 3")

    # starting positions
    scatter!(ax, [x1[1]], [y1[1]], color = :blue,  markersize = 12)
    scatter!(ax, [x2[1]], [y2[1]], color = :red,   markersize = 12)
    scatter!(ax, [x3[1]], [y3[1]], color = :green, markersize = 12)

    axislegend(ax)
    return fig
end

function plot_energy(sol, masses)
    energies = map(eachindex(sol.u)) do i
        b1, b2, b3 = unpack_state(sol.u[i], masses)
        total_energy(b1, b2, b3)
    end

    fig = Figure(size = (800, 400))
    ax  = Axis(fig[1, 1], title = "Total Energy over Time", xlabel = "t", ylabel = "E")
    lines!(ax, sol.t, energies, color = :black)
    return fig
end

function animate_trajectory(sol, masses; filename="simulation.mp4", fps=30)

    # extract positions for each body over time
    pos1 = [sol.u[i][1:3]   for i in eachindex(sol.u)]
    pos2 = [sol.u[i][7:9]   for i in eachindex(sol.u)]
    pos3 = [sol.u[i][13:15] for i in eachindex(sol.u)]

    x1 = [p[1] for p in pos1]; y1 = [p[2] for p in pos1]
    x2 = [p[1] for p in pos2]; y2 = [p[2] for p in pos2]
    x3 = [p[1] for p in pos3]; y3 = [p[2] for p in pos3]

    # compute axis limits from all positions
    all_x = vcat(x1, x2, x3)
    all_y = vcat(y1, y2, y3)
    padding = 0.1 * max(maximum(all_x) - minimum(all_x), maximum(all_y) - minimum(all_y))
    xlims = (minimum(all_x) - padding, maximum(all_x) + padding)
    ylims = (minimum(all_y) - padding, maximum(all_y) + padding)

    # how many frames to render
    nframes = length(sol.u)
    trail   = 100  # how many past positions to show as trail

    fig = Figure(size = (800, 600))
    ax  = Axis(fig[1, 1],
        title   = "Three Body Simulation",
        xlabel  = "x",
        ylabel  = "y",
        limits  = (xlims, ylims)
    )

    # observables update on each frame
    idx = Observable(1)

    trail1 = @lift begin
        i = $idx; start = max(1, i - trail)
        Point2f.(x1[start:i], y1[start:i])
    end
    trail2 = @lift begin
        i = $idx; start = max(1, i - trail)
        Point2f.(x2[start:i], y2[start:i])
    end
    trail3 = @lift begin
        i = $idx; start = max(1, i - trail)
        Point2f.(x3[start:i], y3[start:i])
    end

    dot1 = @lift Point2f(x1[$idx], y1[$idx])
    dot2 = @lift Point2f(x2[$idx], y2[$idx])
    dot3 = @lift Point2f(x3[$idx], y3[$idx])

    lines!(ax,   trail1, color = :blue,  linewidth = 1.5, label = "Body 1")
    lines!(ax,   trail2, color = :red,   linewidth = 1.5, label = "Body 2")
    lines!(ax,   trail3, color = :green, linewidth = 1.5, label = "Body 3")
    scatter!(ax, @lift([$dot1]), color = :blue,  markersize = 14)
    scatter!(ax, @lift([$dot2]), color = :red,   markersize = 14)
    scatter!(ax, @lift([$dot3]), color = :green, markersize = 14)

    axislegend(ax)

    record(fig, filename, 1:nframes; framerate = fps) do frame
        idx[] = frame
    end

    return filename
end
