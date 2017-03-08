module GuidingCenter4dSymmetricLoop

    export guiding_center_4d_loop_ode, guiding_center_4d_loop_iode,
           hamiltonian, toroidal_momentum, α, α1, α2, α3, α4, β, β1, β2, β3, b1, b2, b3

    include("magnetic_field_symmetric.jl")

    const μ  = 2.5E-6


    function f_loop(t)
        φ0 = 0.0
        u0 = 4E-03
        r0 = 0.5
        r1 = 0.3

        Rt = r0*cos(2π*t)
        Zt = r1*sin(2π*t)

        qt = [Rt, Zt, φ0, u0]

        return qt
    end

    function f_loop(i, n)
        f_loop(i/n)
    end

    function get_initial_conditions(n)
        q₀ = zeros(4, n)

        for i in 1:n
            q₀[:,i] = f_loop(i, n)
        end

        return q₀
    end


    function guiding_center_4d_loop_ode(n)
        q₀ = get_initial_conditions(n)
        guiding_center_4d_ode(q₀; periodic=false)
    end

    function guiding_center_4d_loop_iode(n)
        q₀ = get_initial_conditions(n)
        guiding_center_4d_iode(q₀; periodic=false)
    end


    include("guiding_center_4d.jl")

end
