using Plots
plotlyjs()
include("../src/Plotting.jl")

x = read_HFSS_pattern("test/data/lens.csv")

sphericalpattern(x)

phi = 0:360
theta = 0:360

freq = 38u"GHz"
lens_diameter = 15.8u"mm"
zero = 0u"mm"
gap = 0.1u"mm"
positions = [(-(lens_diameter + gap),zero,zero),
             (-(lens_diameter + gap) / 2,-√(3) * (lens_diameter + gap) / 2,zero),
             ((lens_diameter + gap) / 2,-√(3) * (lens_diameter + gap) / 2,zero),
             (lens_diameter + gap,zero,zero),
             ((lens_diameter + gap) / 2,√(3) * (lens_diameter + gap) / 2,zero),
             (-(lens_diameter + gap) / 2,√(3) * (lens_diameter + gap) / 2,zero),
             (zero,zero,zero)]

af = ArrayFactor(positions,[1,1,1,1,1,1,1])

plot(af,legend=false)

pattern = [af(p,t,freq) for p ∈ phi, t ∈ theta]

buh = RadiationPattern(pattern,phi,theta)

r = ustrip(gain(buh[ϕ(At(0))]))
theta = deg2rad.(Array(buh.dims[2].val))

p = polarpattern(theta,r,lims=(-30,10))
