using RecipesBase
using UnitfulRecipes

#include("Arrays.jl")
#include("RadiationPattern.jl")
#include("Arrays.jl")

function grid_pattern(ϕ, θ, r, min, max)
    shape = (length(ϕ), length(θ))
    # Preallocate matricies
    x = zeros(Float64, shape)
    y = zeros(Float64, shape)
    z = zeros(Float64, shape)
    # Reshape radius data
    r = [(data + abs(min)) / (max + abs(min)) for data in r]
    # Eliminate negative numbers
    replace!(x -> x < 0 ? 0 : x, r)
    for (i, phi) in enumerate(ϕ), (j, theta) in enumerate(θ)
        x[i,j] = r[i,j] * sind(theta) * cosd(phi)
        y[i,j] = r[i,j] * sind(theta) * sind(phi)
        z[i,j] = r[i,j] * cosd(theta)
    end
    return x, y, z
end

@userplot PolarPattern
@recipe function f(pp::PolarPattern)
    if !(((length(pp.args) == 1) && (pp.args[1] isa RadiationPattern)) ||
         ((length(pp.args) == 2) && (pp.args[1] isa AbstractVector &&
                                     pp.args[2] isa AbstractVector)))
       error("Polar pattern should be given two vectors of θ and gain, or a `RadiationPattern` .
              Got: $(typeof(pp.args))")
   end
    if pp.args[1] isa RadiationPattern
        if length(pp.args[1].dims) == 2
            θ = deg2rad.(pp.args[1].dims[2].val)
            r = gain(pp.args[1]) |> ustrip |> transpose
        else
            θ = deg2rad.(pp.args[1].dims[1].val)
            r = gain(pp.args[1]) |> ustrip
        end
    else
        θ, r = pp.args
    end
    # R is log-scalled, θ was in degrees
    if haskey(plotattributes, :lims)
        if plotattributes[:lims][1] == :auto
            min = minimum(r)
            max = plotattributes[:lims][2]
        elseif plotattributes[:lims][2] == :auto
            min = plotattributes[:lims][1]
            max = maximum(r)
        else
            min, max = plotattributes[:lims]
        end
    else
        min = minimum(r)
        max = maximum(r)
    end
    # Clamp all values less then the minimum to the minimum
    r = [x < min ? min : x for x in r]
    @series begin
        projection := :polar
        lims --> (min, max)
        θ, ustrip(r)
    end
end


@userplot SphericalPattern
@recipe function f(sp::SphericalPattern)
    if !(((length(sp.args) == 1) && (sp.args[1] isa RadiationPattern)) ||
         ((length(sp.args) == 3) && (sp.args[1] isa AbstractVector &&
                                     sp.args[2] isa AbstractVector &&
                                     sp.args[3] isa AbstractMatrix)))
        error("Spherical pattern should be given two vectors and a matrix, or a `RadiationPattern` .
               Got: $(typeof(sp.args))")
    end
    if sp.args[1] isa RadiationPattern
        ϕ = sp.args[1].dims[1].val
        θ = sp.args[1].dims[2].val
        r = gain(sp.args[1])
    else
        ϕ, θ, r = sp.args
    end
    r = ustrip(r)
    if haskey(plotattributes, :lims)
        if plotattributes[:lims][1] == :auto
            min = minimum(r)
            max = plotattributes[:lims][2]
        elseif plotattributes[:lims][2] == :auto
            min = plotattributes[:lims][1]
            max = maximum(r)
        else
            min, max = plotattributes[:lims]
        end
    else
        min = minimum(r)
        max = maximum(r)
    end
    x, y, z = grid_pattern(ϕ, θ, r, min, max)
    c = [x < min ? min : x for x in r]
    @series begin
        grid := false
        seriestype := :surface
        xaxis := false
        yaxis := false
        zaxis := false
        lims := :auto
        fill_z := c
        xlims := extrema(x)
        ylims := extrema(y)
        zlims := extrema(z)
        x, y, z
    end
end