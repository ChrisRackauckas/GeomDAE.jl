__precompile__()

module Interpolation

    export Interpolator, HermiteInterpolation, evaluate

    include("interpolation/interpolation.jl")
    include("interpolation/hermite_interpolation.jl")

end
