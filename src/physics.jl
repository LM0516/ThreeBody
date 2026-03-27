const G = 6.674e-11  # gravitational constant

function kinetic_energy(body::Body)
    return 0.5 * body.mass * sum(body.vel .^ 2)
end

function potential_energy(a::Body, b::Body)
    r = norm(b.pos - a.pos)
    return -G * a.mass * b.mass / r
end

function total_energy(b1::Body, b2::Body, b3::Body)
    ke = kinetic_energy(b1) + kinetic_energy(b2) + kinetic_energy(b3)
    pe = potential_energy(b1, b2) + potential_energy(b1, b3) + potential_energy(b2, b3)
    return ke + pe
end

function gravitational_force(a::Body, b::Body)
    r = b.pos - a.pos
    dist = norm(r)
    return G * a.mass * b.mass / dist^2 * normalize(r)
end

function acceleration(body::Body, others::Body...)
    a = SVector(0.0, 0.0, 0.0)
    for other in others
        a += gravitational_force(body, other) / body.mass
    end
    return a
end

function derivatives(b1::Body, b2::Body, b3::Body)
    a1 = acceleration(b1, b2, b3)
    a2 = acceleration(b2, b1, b3)
    a3 = acceleration(b3, b1, b2)
    return a1, a2, a3
end
