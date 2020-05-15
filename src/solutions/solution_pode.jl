"""
`SolutionPODE`: Solution of a partitioned ordinary differential equation

Contains all fields necessary to store the solution of an PODE.

### Fields

* `nd`: dimension of the dynamical variable ``q``
* `nt`: number of time steps to store
* `ni`: number of initial conditions
* `t`:  time steps
* `q`:  solution `q[nd, nt+1, ni]` with `q[:,0,:]` the initial conditions
* `p`:  solution `p[nd, nt+1, ni]` with `p[:,0,:]` the initial conditions
* `ntime`: number of time steps to compute
* `nsave`: store every nsave'th time step (default: 1)
* `nwrite`: save data to disk after every nwrite'th time step (default: ntime)
* `counter`: counter for copied solution entries
* `woffset`: counter for file offset
* `h5`: HDF5 file for storage
"""
abstract type SolutionPODE{dType, tType, N} <: DeterministicSolution{dType, tType, N} end

# Create SolutionPODEs with serial and parallel data structures.
for (TSolution, TDataSeries, Tdocstring) in
    ((:SSolutionPODE, :SDataSeries, "Serial Solution of a partitioned ordinary differential equation."),
     (:PSolutionPODE, :PDataSeries, "Parallel Solution of a partitioned ordinary differential equation."))
    @eval begin
        $Tdocstring
        mutable struct $TSolution{dType, tType, N} <: SolutionPODE{dType, tType, N}
            nd::Int
            nt::Int
            ni::Int
            t::TimeSeries{tType}
            q::$TDataSeries{dType,N}
            p::$TDataSeries{dType,N}
            ntime::Int
            nsave::Int
            nwrite::Int
            counter::Vector{Int}
            woffset::Int
            periodicity::Vector{dType}
            h5::HDF5.File

            function $TSolution{dType, tType, N}(nd, nt, ni, t, q, p, ntime, nsave, nwrite, periodicity=zeros(dType, nd)) where {dType <: Number, tType <: Real, N}
                new(nd, nt, ni, t, q, p, ntime, nsave, nwrite, zeros(Int, ni), 0, periodicity)
            end
        end

        function $TSolution(equation::Union{PODE{DT,TT}, IODE{DT,TT}, VODE{DT,TT}}, Δt::TT, ntime::Int;
                            nsave::Int=DEFAULT_NSAVE, nwrite::Int=DEFAULT_NWRITE, filename=nothing) where {DT,TT}
            @assert nsave > 0
            @assert ntime == 0 || ntime ≥ nsave
            @assert nwrite == 0 || nwrite ≥ nsave
            @assert mod(ntime, nsave) == 0

            if nwrite > 0
                @assert mod(nwrite, nsave) == 0
                @assert mod(ntime, nwrite) == 0
            end

            N  = equation.n > 1 ? 3 : 2
            nd = equation.d
            ni = equation.n
            nt = div(ntime, nsave)
            nt = (nwrite == 0 ? nt : div(nwrite, nsave))
            nw = (nwrite == 0 ? ntime : nwrite)

            @assert nd > 0
            @assert ni > 0
            @assert nt ≥ 0
            @assert nw ≥ 0

            t = TimeSeries{TT}(nt, Δt, nsave)
            q = $TDataSeries(DT, nd, nt, ni)
            p = $TDataSeries(DT, nd, nt, ni)
            s = $TSolution{DT,TT,N}(nd, nt, ni, t, q, p, ntime, nsave, nw, periodicity(equation))
            set_initial_conditions!(s, equation)

            if !isnothing(filename)
                isfile(filename) ? @warn("Overwriting existing HDF5 file.") : nothing
                create_hdf5!(s, filename)
            end

            return s
        end

        function $TSolution(t::TimeSeries{TT}, q::$TDataSeries{DT,N}, p::$TDataSeries{DT,N}, ntime::Int) where {DT,TT,N}
            @assert q.nd == p.nd
            @assert q.nt == p.nt
            @assert q.ni == p.ni

            # extract parameters
            nd = q.nd
            ni = q.ni
            nt = t.n
            ns = div(ntime, nt)

            @assert mod(ntime, nt) == 0

            # create solution
            $TSolution{DT,TT,N}(nd, nt, ni, t, q, p, ntime, ns, 0)
        end

        function $TSolution(file::String)
            # open HDF5 file
            get_config(:verbosity) > 1 ? @info("Reading HDF5 file ", file) : nothing
            h5 = h5open(file, "r")

            # read attributes
            ntime = read(attributes(h5)["ntime"])
            nsave = read(attributes(h5)["nsave"])

            # reading data arrays
            t = TimeSeries(read(h5["t"]), nsave)
            q = $TDataSeries(read(h5["q"]))
            p = $TDataSeries(read(h5["p"]))

            # need to close the file
            close(h5)

            # create solution
            $TSolution(t, q, p, ntime)
        end
    end
end


Base.:(==)(sol1::SolutionPODE, sol2::SolutionPODE) = (
                                sol1.nd == sol2.nd
                             && sol1.nt == sol2.nt
                             && sol1.ni == sol2.ni
                             && sol1.t  == sol2.t
                             && sol1.q  == sol2.q
                             && sol1.p  == sol2.p
                             && sol1.ntime == sol2.ntime
                             && sol1.nsave == sol2.nsave
                             && sol1.counter == sol2.counter
                             && sol1.periodicity == sol2.periodicity)

@inline hdf5(sol::SolutionPODE)  = sol.h5
@inline timesteps(sol::SolutionPODE)  = sol.t
@inline ntime(sol::SolutionPODE) = sol.ntime
@inline nsave(sol::SolutionPODE) = sol.nsave
@inline counter(sol::SolutionPODE) = sol.counter
@inline offset(sol::SolutionPODE) = sol.woffset
@inline lastentry(sol::SolutionPODE) = sol.ni == 1 ? sol.counter[1] - 1 : sol.counter .- 1
@inline CommonFunctions.periodicity(sol::SolutionPODE) = sol.periodicity


function set_initial_conditions!(sol::SolutionPODE, equ::Union{PODE,IODE,VODE})
    set_initial_conditions!(sol, equ.t₀, equ.q₀, equ.p₀)
end

function set_initial_conditions!(sol::SolutionPODE{DT,TT}, t₀::TT, q₀::Union{Array{DT}, Array{TwicePrecision{DT}}}, p₀::Union{Array{DT}, Array{TwicePrecision{DT}}}) where {DT,TT}
    set_data!(sol.q, q₀, 0)
    set_data!(sol.p, p₀, 0)
    compute_timeseries!(sol.t, t₀)
    sol.counter .= 1
end

function get_initial_conditions!(sol::SolutionPODE{DT,TT}, asol::AtomicSolutionPODE{DT,TT}, k, n=1) where {DT,TT}
    get_solution!(sol, asol.q, asol.p, n-1, k)
    asol.t  = sol.t[n-1]
    asol.q̃ .= 0
    asol.p̃ .= 0
end

function get_initial_conditions!(sol::SolutionPODE{DT,TT}, q::SolutionVector{DT}, p::SolutionVector{DT}, k, n=1) where {DT,TT}
    get_solution!(sol, q, p, n-1, k)
end

function get_initial_conditions(sol::SolutionPODE, k, n=1)
    get_solution(sol, n-1, k)
end

function get_solution!(sol::SolutionPODE{DT,TT}, q::SolutionVector{DT}, p::SolutionVector{DT}, n, k=1) where {DT,TT}
    for i in eachindex(q) q[i] = sol.q[i, n, k] end
    for i in eachindex(p) p[i] = sol.p[i, n, k] end
end

function get_solution(sol::SolutionPODE, n, k)
    (sol.t[n], Array(sol.q[:, n, k]), Array(sol.p[:, n, k]))
end

function set_solution!(sol::SolutionPODE, t, q, p, n, k)
    set_solution!(sol, q, p, n, k)
end

function set_solution!(sol::SolutionPODE{DT,TT}, asol::AtomicSolutionPODE{DT,TT}, n, k=1) where {DT,TT}
    set_solution!(sol, asol.t, asol.q, asol.p, n, k)
end

function set_solution!(sol::SolutionPODE{DT,TT}, q::SolutionVector{DT}, p::SolutionVector{DT}, n, k=1) where {DT,TT}
    @assert n <= sol.ntime
    @assert k <= sol.ni
    if mod(n, sol.nsave) == 0
        if sol.counter[k] > sol.nt
            @error("Solution overflow. Call write_to_hdf5() and reset!() before continuing the simulation.")
        end
        set_data!(sol.q, q, sol.counter[k], k)
        set_data!(sol.p, p, sol.counter[k], k)
        sol.counter[k] += 1
    end
end

function CommonFunctions.reset!(sol::SolutionPODE)
    reset!(sol.q)
    reset!(sol.p)
    compute_timeseries!(sol.t, sol.t[end])
    sol.counter .= 1
    sol.woffset += sol.nt
end

function Base.close(solution::SolutionPODE)
    close(solution.h5)
end
