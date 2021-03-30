using CSV
using DataFrames
using DimensionalData

export RadiationPattern
export gain
export read_HFSS_pattern

@dim ϕ "Elevation"
@dim θ "Azimuth"

"""
    RadiationPattern
An antenna radiation pattern in spherical coordinates
θ is elevation (angle off of z in degrees)
ϕ is azimuth (angle off of x in degrees)
"""
struct RadiationPattern{A <: AbstractVector,
                        B <: AbstractVector,
                        C <: AbstractMatrix}
    ϕ::A
    θ::B
    pattern::C
end

function gain(pattern::AbstractMatrix{<:Unitful.Gain})
    pattern
end

function gain(pattern::AbstractMatrix{<:Real})
    @. 20log10(pattern) * u"dB"
end

function gain(pattern::AbstractMatrix{<:Complex})
    @. 20log10(abs(pattern)) * u"dB"
end

function gain(rp::RadiationPattern)
    gain(rp.pattern)
end

"""
    read_HFSS_pattern("myAntenna.csv")
Reads the exported fields from HFSS into a `RadiationPattern`.
"""
function read_HFSS_pattern(file)
    # Read Pattern
    pattern = CSV.File(file,header=["ϕ","θ","gain"],skipto=2) |> DataFrame
    # HFSS requires the data to be sorted, thank goodness
    ϕ = pattern[!,:ϕ] |> unique |> sort!
    θ = pattern[!,:θ] |> unique |> sort!
    gain = reshape(pattern[!,:gain],(length(ϕ),length(θ))) .* u"dB"
    # Create pattern
    RadiationPattern(ϕ,θ,gain)
end