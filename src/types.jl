# Three body initial conditions structure
struct Body
    mass::Float64               # Mass of the body
    pos::SVector{3, Float64}    # Initial position
    vel::SVector{3, Float64}    # Initial velocity
end
