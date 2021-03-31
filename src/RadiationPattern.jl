using CSV
using DataFrames
using DimensionalData
import DimensionalData.formatdims
using Unitful

export RadiationPattern
export gain
export read_HFSS_pattern
export rebuild

@dim ϕ "Elevation"
@dim θ "Azimuth"
@dim f "Frequency"

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

# Single frequency constructor
function RadiationPattern(data::AbstractArray,azimuth,elevation ;name=NoName(), refdims=(), metadata=NoMetadata())
    RadiationPattern(data, formatdims(data, (ϕ(azimuth),θ(elevation))), refdims, name, metadata)
end

# Multi frequency constructor
function RadiationPattern(data::AbstractArray,azimuth,elevation,frequencies;name=NoName(), refdims=(), metadata=NoMetadata())
    RadiationPattern(data, formatdims(data, (ϕ(azimuth),θ(elevation),f(frequencies))), refdims, name, metadata)
end

# Arbitray dims
function RadiationPattern(data::AbstractArray,dims;name=NoName(), refdims=(), metadata=NoMetadata())
    if length(filter(x->x isa Union{ϕ,θ},dims)) != 2
        error("`dims` must contain at least azimuth and elevation")
    end
    RadiationPattern(data, formatdims(data, dims), refdims, name, metadata)
end

# From kwargs
function RadiationPattern(; data, azimuth,elevation, frequencies,refdims=(), name=NoName(), metadata=NoMetadata())
    RadiationPattern(data, formatdims(data, (ϕ(azimuth),θ(elevation),f(frequencies))), refdims, name, metadata)
end

# Construct from another AbstractDimArray
function RadiationPattern(A::AbstractDimArray; data=data(A), dims=dims(A), refdims=refdims(A), name=name(A), metadata=metadata(A))
    if length(filter(x->x isa Union{ϕ,θ},dims)) != 2
        error("`dims` must contain at least azimuth and elevation")
    end
    RadiationPattern(data, formatdims(data, dims), refdims, name, metadata)
end

"""
    RadiationPattern(f::Function, dim::Dimension [, name])
Apply function `f` across the values of the dimension `dim`
(using `broadcast`), and return the result as a RadiationPattern with
the given dimension. Optionally provide a name for the result.
"""
function RadiationPattern(f::Function, dim::Union{ϕ,θ}, name=Symbol(nameof(f), "(", name(dim), ")"))
    RadiationPattern(f.(val(dim)), (dim,), name)
end

@inline function DimensionalData.rebuild(
    A::RadiationPattern, data::AbstractArray, dims::Tuple, refdims::Tuple, name, metadata
)
    RadiationPattern(data, dims, refdims, name, metadata)
end

function gain(pattern::AbstractMatrix{T}) where {T <: Gain}
    pattern
end

function gain(pattern::AbstractMatrix{<:Real})
    @. 20log10(pattern) * u"dB"
end

function gain(pattern::AbstractMatrix{<:Complex})
    @. 20log10(abs(pattern)) * u"dB"
end

function gain(rp::RadiationPattern)
    gain(rp.data)
end

"""
    read_HFSS_pattern("myAntenna.csv")
Reads the exported fields from HFSS into a `RadiationPattern`.
"""
function read_HFSS_pattern(file)
    # Read Pattern
    pattern = CSV.File(file,header=["ϕ","θ","gain"],skipto=2) |> DataFrame
    # HFSS requires the data to be sorted, thank goodness
    az = pattern[!,:ϕ] |> unique |> sort!
    el = pattern[!,:θ] |> unique |> sort!
    az_range = az[1]:az[2]-az[1]:az[end]
    el_range = el[1]:el[2]-el[1]:el[end]
    gain = reshape(pattern[!,:gain],(length(az_range),length(el_range))) .* u"dB"
    # Create pattern
    RadiationPattern(gain,az_range,el_range;name="Gain (dBi)")
end