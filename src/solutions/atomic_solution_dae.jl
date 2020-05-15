"""
Atomic solution for an DAE.

### Parameters

* `DT`: data type
* `TT`: time step type
* `AT`: array type
* `IT`: internal variable types

### Fields

* `t`: time of current time step
* `t̅`: time of previous time step
* `q`: current solution of q
* `q̅`: previous solution of q
* `q̃`: compensated summation error of q
* `λ`: current solution of λ
* `λ̅`: previous solution of λ
* `v`: vector field of q
* `v̅`: vector field of q̅
* `u`: projective vector field of q
* `u̅`: projective vector field of q̅
"""
mutable struct AtomicSolutionDAE{DT, TT, AT <: AbstractArray{DT}, IT <: NamedTuple} <: AtomicSolution{DT,TT}
    t::TT
    t̅::TT

    q::AT
    q̅::AT
    q̃::AT

    λ::AT
    λ̅::AT

    v::AT
    v̅::AT

    u::AT
    u̅::AT

    internal::IT

    function AtomicSolutionDAE{DT,TT,AT,IT}(nd, nm, internal::IT) where {DT <: Number, TT <: Real, AT, IT <: NamedTuple}
        new(zero(TT), zero(TT),
            AT(zeros(DT, nd)), AT(zeros(DT, nd)), AT(zeros(DT, nd)),
            AT(zeros(DT, nm)), AT(zeros(DT, nm)),
            AT(zeros(DT, nd)), AT(zeros(DT, nd)),
            AT(zeros(DT, nd)), AT(zeros(DT, nd)),
            internal)
    end

    function AtomicSolutionDAE{DT,TT,AT,IT}(t::TT, q::AT, λ::AT, internal::IT) where {DT <: Number, TT <: Real, AT <: AbstractArray{DT}, IT <: NamedTuple}
        new(zero(t), zero(t),
            zero(q), zero(q), zero(q),
            zero(λ), zero(λ),
            zero(q), zero(q),
            zero(λ), zero(λ),
            internal)
    end
end

AtomicSolutionDAE(DT, TT, AT, nd, nm, internal::IT=NamedTuple()) where {IT} = AtomicSolutionDAE{DT,TT,AT,IT}(nd, nm, internal)
AtomicSolutionDAE(t::TT, q::AT, λ::AT, internal::IT=NamedTuple()) where {DT, TT, AT <: AbstractArray{DT}, IT} = AtomicSolutionDAE{DT,TT,AT,IT}(t, q, λ, internal)

function set_solution!(asol::AtomicSolutionDAE, sol)
    t, q, λ = sol
    asol.t  = t
    asol.q .= q
    asol.λ .= λ
    asol.v .= 0
end

function get_solution(asol::AtomicSolutionDAE)
    (asol.t, asol.q, asol.λ)
end

function CommonFunctions.reset!(asol::AtomicSolutionDAE, Δt)
    asol.t̅  = asol.t
    asol.q̅ .= asol.q
    asol.λ̅ .= asol.λ
    asol.v̅ .= asol.v
    asol.u̅ .= asol.u
    asol.t += Δt
end

function update!(asol::AtomicSolutionDAE{DT}, y::Vector{DT}, λ::Vector{DT}) where {DT}
    for k in eachindex(y)
        update!(asol, y[k], k)
    end
    for k in eachindex(λ)
        asol.λ[k] = λ[k]
    end
end

function update!(asol::AtomicSolutionDAE{DT}, y::DT, k::Union{Int,CartesianIndex}) where {DT}
    asol.q[k], asol.q̃[k] = compensated_summation(y, asol.q[k], asol.q̃[k])
end
