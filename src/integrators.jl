function pack_state(b1::Body, b2::Body, b3::Body)
    return vcat(b1.pos, b1.vel, b2.pos, b2.vel, b3.pos, b3.vel)
end

function unpack_state(u, masses)
    b1 = Body(masses[1], SVector(u[1],u[2],u[3]),   SVector(u[4],u[5],u[6]))
    b2 = Body(masses[2], SVector(u[7],u[8],u[9]),   SVector(u[10],u[11],u[12]))
    b3 = Body(masses[3], SVector(u[13],u[14],u[15]), SVector(u[16],u[17],u[18]))
    return b1, b2, b3
end

function threebody!(u, p, t)
    masses = p
    b1, b2, b3 = unpack_state(u, masses)
    a1, a2, a3 = derivatives(b1, b2, b3)
    return vcat(b1.vel, a1, b2.vel, a2, b3.vel, a3)
end

function simulate(b1::Body, b2::Body, b3::Body; tspan=(0.0, 1.0))
    u0 = pack_state(b1, b2, b3)
    p = [b1.mass, b2.mass, b3.mass]
    prob = ODEProblem{false}(threebody!, u0, tspan, p)
    return solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)
end
