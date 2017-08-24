
using GeometricIntegrators
using GeometricIntegrators.Utils
using Base.Test

function fx(t, x, fx)
    fx .= x
end

function fq(t, q, p, fq)
    fq .= q
end

function fp(t, q, p, fp)
    fp .= q.^2
end

function fϕ(t, x, fϕ)
    fϕ .= 0
end

function gx(t, x, λ, fx)
    fx .= x
end

function gq(t, q, p, λ, fλ)
    fλ .= q
end

function gp(t, q, p, λ, fλ)
    fλ .= q.^2
end

function gϕ(t, q, p, gϕ)
    gϕ .= p - q.^2
end


include("basis_functions/vandermonde_tests.jl")
include("basis_functions/lagrange_basis_tests.jl")
include("basis_functions/lagrange_polynomials_tests.jl")
include("equations/equations_tests.jl")
include("oscillator.jl")
include("solutions/dataseries_tests.jl")
include("solutions/timeseries_tests.jl")
include("solutions/solutions_tests.jl")
include("tableaus/tableaus_tests.jl")
include("integrators/integrators_test.jl")
include("solvers/linear_solvers_tests.jl")
include("solvers/nonlinear_solvers_tests.jl")
include("diagnostics/poincare_invariant_1st_tests.jl")
include("diagnostics/poincare_invariant_2nd_unittests.jl")
include("diagnostics/poincare_invariant_2nd_tests.jl")

#include("utils/hdf5_tests.jl")
