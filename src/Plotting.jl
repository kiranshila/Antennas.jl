using RecipesBase
using Unitful
include("Arrays.jl")
include("RadiationPattern.jl")

function grid_pattern(pattern::RadiationPattern;min,max)
    shape = (length(pattern.ϕ),length(pattern.θ))
    # Preallocalte matricies
    x = zeros(Float64,shape)
    y = zeros(Float64,shape)
    z = zeros(Float64,shape)
    # Grab gain data
    gain = gain(pattern)
    # Reshape radius data
    r = [(data + abs(min))/(max+abs(min)) for data in pattern.pattern]
    # Eliminate negative numbers
    replace!(x->x<0 ? 0 : x,r)

    for (i,phi) in enumerate(pattern.ϕ), (j,theta) in enumerate(pattern.θ)
        x[i,j] = r[i,j] * sind(theta) * cosd(phi)
        y[i,j] = r[i,j] * sind(theta) * sind(phi)
        z[i,j] = r[i,j] * cosd(theta)
    end
    return x,y,z
end

@userplot PatternPlot
@recipe function f(pp:PatternPlot)
    # Check what we are plotting
    # args could be θ,pattern ϕ,θ,pattern, or a RadiationPattern, or a ArrayFactor
end

@recipe function f(rp::RadiationPattern)
    # Grid the pattern data
    x,y,z = grid_pattern(rp)
    # Gen color data, with clamping
    color = [x < min ? min : x for x in pattern.pattern]
