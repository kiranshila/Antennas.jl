using PhysicalConstants.CODATA2018
using LinearAlgebra
using Combinatorics
using Unitful

# Exports
export ArrayFactor
export baselines

"""
    ArrayFactor
Describes an array due to N isotropic radiators located at `locations` with
phasor excitations `excitations`.
"""
struct ArrayFactor
  locations::AbstractVector{NTuple{3,Unitful.Length}}
  excitations::AbstractVector{Number}
end

function (af::ArrayFactor)(ϕ,θ,freq)
    # Direction of the source
    ŝ = [sind(θ)*cosd(ϕ),sind(θ)*sind(ϕ),cosd(θ)]
    k = @. 2π/λ(freq) * ŝ
    # Phases in the direction of ŝ
    phases = cis.(-[k⋅b for b ∈ af.locations])
    return (phases ⋅ af.excitations) / sum(abs.(af.excitations))
end

"""
Constructing an ArrayFactor with locations as non-qunatities will be upcast to meters
"""
function ArrayFactor(locations::Array{NTuple{3,T}},excitations::AbstractVector) where {T <: Real}
    ArrayFactor([loc.*u"m" for loc ∈ locations],excitations)
end

function Base.show(io::IO,af::ArrayFactor)
    println(io,"An Array Factor with $(length(af.excitations)) elements")
    println(io,"\tLocations:")
    for loc ∈ af.locations
        print(io,"\t\t")
        println(io,loc)
    end
    println(io,"\tExcitations:")
    for a ∈ af.excitations
        print(io,"\t\t")
        println(io,a)
    end
end

""""
    baselines(af)
Returns all the baseline vectors for the antenna locations in `af`.
"""
function baselines(af::ArrayFactor)
    [.-(pair...) for pair ∈ combinations(af.locations,2)]
end

function λ(f::Quantity)
    SpeedOfLightInVacuum/f |> u"m"
end

function λ(f::Real)
    SpeedOfLightInVacuum/(f*u"Hz") |> u"m"
end

"""
    calibrate(array,phase_center)
"""
function calibrate()

end