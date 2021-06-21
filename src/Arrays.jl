using PhysicalConstants.CODATA2018
using LinearAlgebra
using Combinatorics

# Exports
export AntennaArray
export baselines
export baselines
export λ
export calibrate

function (aa::AntennaArray)(ϕ::Number,θ::Number,freq::Number)
    # Direction of the source
    ŝ = [sind(θ)*cosd(ϕ),sind(θ)*sind(ϕ),cosd(θ)]
    k = @. 2π/λ(freq) * ŝ
    # Phases in the direction of ŝ
    phases = cis.(-[k⋅b for b ∈ aa.locations])
    return (phases ⋅ aa.excitations) / sum(abs.(aa.excitations))
end

"""
Constructing an AntennaArray with locations as non-qunatities will be upcast to meters
"""
function AntennaArray(locations::Array{NTuple{3,T}},excitations::AbstractVector) where {T <: Real}
    AntennaArray([loc.*u"m" for loc ∈ locations],excitations)
end

function Base.show(io::IO,aa::AntennaArray)
    println(io,"An Antenna Array with $(length(aa.excitations)) elements")
    println(io,"\tLocations:")
    for loc ∈ aa.locations
        print(io,"\t\t")
        println(io,loc)
    end
    println(io,"\tExcitations:")
    for a ∈ aa.excitations
        print(io,"\t\t")
        println(io,a)
    end
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

function λ(f::Quantity)
    SpeedOfLightInVacuum/f |> u"m"
end

function λ(f::Real)
    SpeedOfLightInVacuum/(f*u"Hz") |> u"m"
end

"""
    calibrate(array,phase_center)
For a given antenna array `array`, return a new `AntennaArray` whose phase center has been adjusted
to `phase_center`.
"""
function calibrate()

end