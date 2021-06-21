using PhysicalConstants.CODATA2018
using LinearAlgebra
using Combinatorics
import DimensionalData.formatdims

# Exports
export AntennaArray
export baselines
export baselines
export λ
export calibrate

function λ(f::Quantity)
    SpeedOfLightInVacuum/f |> u"m"
end

function λ(f::Real)
    SpeedOfLightInVacuum/(f*u"Hz") |> u"m"
end

add_dim(x::AbstractArray) = reshape(x, (size(x)...,1))

function zeros_like(x)
    a = similar(x)
    a .= zero(typeof(a[1]))
end

# 1D Array constructor - implicitly on the x axis
function AntennaArray(excitations::AbstractArray,x ;name=NoName(), refdims=(), metadata=NoMetadata())
    y = zeros_like(x)
    z = zeros_like(x)
    AntennaArray(excitations, formatdims(excitations |> add_dim |> add_dim, (X(x),Y(y),Z(z))), refdims, name, metadata)
end

# 2D Array constructor - implicitly on the x-y plane
function AntennaArray(excitations::AbstractArray,x,y ;name=NoName(), refdims=(), metadata=NoMetadata())
    z = zeros_like(x)
    AntennaArray(excitations, formatdims(excitations |> add_dim, (X(x),Y(y),Z(z))), refdims, name, metadata)
end

# 3D Array constructor
function AntennaArray(excitations::AbstractArray,x,y,z ;name=NoName(), refdims=(), metadata=NoMetadata())
    AntennaArray(excitations, formatdims(excitations, (X(x),Y(y),Z(z))), refdims, name, metadata)
end

"""
    aa(ϕ,θ,freq)
Finds the relative amplitude of the array factor for the array `aa` in the azimuth ϕ,
elevation `θ` at frequency freq. Angles in degrees.
"""
function (aa::AntennaArray)(ϕ::Number,θ::Number,freq::Number)
    # Direction of the source
    ŝ = [sind(θ)*cosd(ϕ),sind(θ)*sind(ϕ),cosd(θ)]
    k = @. 2π/λ(freq) * ŝ
    # Phases in the direction of ŝ
    phases = cis.(-[k⋅b for b ∈ aa.locations])
    return (phases ⋅ aa.excitations) / sum(abs.(aa.excitations))
end

"""
    ArrayFactor(aa)
Constructs a `RadiationPattern` representative of the array factor of the array `aa`
sampled over azimuth `ϕ` and elevation `θ` at frequenc[y|ies] `freq`.
"""
function ArrayFactor(aa::AntennaArray,ϕ,θ,freq::AbstractVector)
    data = [aa(phi,theta,freq,f) for phi ∈ ϕ, theta ∈ θ, f ∈ freq]
    RadiationPattern(data,ϕ,θ,freq)
end

function ArrayFactor(aa::AntennaArray,ϕ,θ,freq::Number)
    data = [aa(phi,theta,freq,freq) for phi ∈ ϕ, theta ∈ θ]
    RadiationPattern(data,ϕ,θ,freq)
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