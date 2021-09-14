module Antennas

# Top level imports
using DimensionalData
using Unitful

# Top level types
"""
    RadiationPattern
Holds the pattern data, isa AbstractDimArray
"""
struct RadiationPattern{T<:Number,
    N,
    D<:Tuple,
    R<:Tuple,
    A<:AbstractArray{T,N},
    Na,
    Me} <: AbstractDimArray{T,N,D,A}
data::A
dims::D
refdims::R
name::Na
metadata::Me
end

"""
    AntennaArray
Holds the antenna array data
"""
struct AntennaArray
    excitations
    locations
end

include("Patterns.jl")
include("Arrays.jl")
include("Plotting.jl")

end