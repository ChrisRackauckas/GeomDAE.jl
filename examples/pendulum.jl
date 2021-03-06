
using GeomDAE
using PyPlot

const Δt    = 0.1
const ntime = 100000
const neps  = 1E-14
const nmax  = 20

function f(t, x, fx)
    fx[1] = x[2]
    fx[2] = sin(x[1])
    nothing
end

function run_pendulum(tableau, filename)
    x0 = [acos(0.4), 0.0]
    ode = ODE(f, x0)
    int = Integrator(ode, tableau, Δt)
    sol = Solution(ode, Δt, ntime)

    integrate!(int, sol)
    set_initial_conditions!(sol, ode)

    print("Running ", tableau.name, "...")
    @time integrate!(int, sol)

    fig = figure(figsize=(6,6))
    plot(sol.x[1,:,1], sol.x[2,:,1])
    xlim(0, 6)
    ylim(-2,+2)
    savefig(filename)
end

run_pendulum(getTableauExplicitEuler(), "pendulum_explicit_euler.png")
run_pendulum(getTableauExplicitMidpoint(), "pendulum_explicit_midpoint.png")
run_pendulum(getTableauHeun(), "pendulum_heun.png")
run_pendulum(getTableauKutta(), "pendulum_kutta.png")
run_pendulum(getTableauERK4(), "pendulum_explicit_rk4.png")
run_pendulum(getTableauERK438(), "pendulum_explicit_rk438.png")

run_pendulum(getTableauImplicitEuler(), "pendulum_implicit_euler.png")
run_pendulum(getTableauGLRK1(), "pendulum_implicit_glrk1.png")
run_pendulum(getTableauGLRK2(), "pendulum_implicit_glrk2.png")
run_pendulum(getTableauGLRK3(), "pendulum_implicit_glrk3.png")


function qf(x, fx)
    fx[1] = x[1]
    nothing
end

function pf(t, x, fx)
    fx[1] = sin(x[1])
    nothing
end

function run_pendulum_partitioned(tableau, filename)
    q0 = [acos(0.4)]
    p0 = [0.0]

    ode = PODE(qf, pf, q0, p0)
    int = Integrator(ode, tableau, Δt)
    sol = Solution(ode, Δt, ntime)

    integrate!(int, sol)
    set_initial_conditions!(sol, ode)

    print("Running ", tableau.name, "...")
    @time integrate!(int, sol)

    fig = figure(figsize=(6,6))
    plot(sol.x[1,1,:,1], sol.x[2,1,:,1])
    # plot(sol[1], sol[2])
    xlim(0, 6)
    ylim(-2,+2)
    savefig(filename)
end

run_pendulum_partitioned(getTableauSymplecticEulerA(), "pendulum_symplectic_euler_a.png")
run_pendulum_partitioned(getTableauSymplecticEulerB(), "pendulum_symplectic_euler_b.png")
run_pendulum_partitioned(TableauEPRK(:PERK4, 4, getTableauERK4(), getTableauERK4()), "pendulum_explicit_prk4.png")
