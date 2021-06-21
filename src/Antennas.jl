module Antennas

# Top level imports
using DimensionalData
using Unitful

# Top level types
"""
    RadiationPattern
Holds the pattern data, isa DimArray
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
Describes an array due to N isotropic radiators located at `locations` with
phasor excitations `excitations`.
"""
struct AntennaArray
  locations::AbstractVector{NTuple{3,Unitful.Length}}
  excitations::AbstractVector{Number}
end

include("Patterns.jl")
include("Arrays.jl")
include("Plotting.jl")

end
