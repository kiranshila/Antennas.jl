using PhysicalConstants.CODATA2018
using LinearAlgebra
using Combinatorics
import DimensionalData.formatdims

# Exports
export AntennaArray
export ArrayFactor
export baselines
export calibrate

function λ(f::Quantity)
    SpeedOfLightInVacuum/f |> u"m"
end

function λ(f::Real)
    SpeedOfLightInVacuum/(f*u"Hz") |> u"m"
end

function phase_location(b::AbstractArray,ϕ::Number,θ::Number,freq::Number)
    # Direction of the source
    ŝ = [sind(θ)*cosd(ϕ),sind(θ)*sind(ϕ),cosd(θ)]
    k = @. 2π/λ(freq) * ŝ
    # Phase
    cis(-k⋅b)
end

"""
   AntennaArray(locations,ϕ,θ)
Creates a new `AntennaArray` which represents the `locations` phased in the direction of `ϕ` and `θ`.
"""
function AntennaArray(locations,ϕ,θ,freq)
    AntennaArray(phase_location.(locations,ϕ,θ,freq),locations)
end


"""
    aa(ϕ,θ,freq)
Finds the relative amplitude of the array factor for the array `aa` in the azimuth ϕ,
elevation `θ` at frequency freq. Angles in degrees.
"""
function (aa::AntennaArray)(ϕ::Number,θ::Number,freq::Number)
    (phase_location.(aa.locations,ϕ,θ,freq) ⋅ aa.excitations) / sum(abs.(aa.excitations))
end

"""
    ArrayFactor(aa)
Constructs a `RadiationPattern` representative of the array factor of the array `aa`
sampled over azimuth `ϕ` and elevation `θ` at frequenc[y|ies] `freq`.
"""
function ArrayFactor(aa::AntennaArray,ϕ,θ,freq::AbstractVector)
    data = [aa(phi,theta,f) for phi ∈ ϕ, theta ∈ θ, f ∈ freq]
    RadiationPattern(data,ϕ,θ,freq)
end

function ArrayFactor(aa::AntennaArray,ϕ,θ,freq::Number)
    data = [aa(phi,theta,freq) for phi ∈ ϕ, theta ∈ θ]
    RadiationPattern(data,ϕ,θ)
end

""""
    baselines(af)
Returns all the baseline vectors for the antenna locations in `aa`.
"""
function baselines(aa::AntennaArray)
    [.-(pair...) for pair ∈ combinations(aa.locations,2)]
end

"""
    calibrate(array,phase_center)
For a given antenna array `array`, return a new `AntennaArray` whose phase center has been adjusted
to `phase_center`.
"""
function calibrate()

end
