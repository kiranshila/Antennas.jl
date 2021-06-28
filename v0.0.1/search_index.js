var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = Antennas","category":"page"},{"location":"#Antennas","page":"Home","title":"Antennas","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for Antennas.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Antennas]","category":"page"},{"location":"#Antennas.AntennaArray","page":"Home","title":"Antennas.AntennaArray","text":"AntennaArray\n\nHolds the antenna array data, isa AbstractDimArray\n\n\n\n\n\n","category":"type"},{"location":"#Antennas.AntennaArray-Tuple{Number, Number, Number}","page":"Home","title":"Antennas.AntennaArray","text":"aa(ϕ,θ,freq)\n\nFinds the relative amplitude of the array factor for the array aa in the azimuth ϕ, elevation θ at frequency freq. Angles in degrees.\n\n\n\n\n\n","category":"method"},{"location":"#Antennas.RadiationPattern","page":"Home","title":"Antennas.RadiationPattern","text":"RadiationPattern\n\nHolds the pattern data, isa AbstractDimArray\n\n\n\n\n\n","category":"type"},{"location":"#Antennas.RadiationPattern-2","page":"Home","title":"Antennas.RadiationPattern","text":"RadiationPattern(f::Function, dim::Dimension [, name])\n\nApply function f across the values of the dimension dim (using broadcast), and return the result as a RadiationPattern with the given dimension. Optionally provide a name for the result.\n\n\n\n\n\n","category":"type"},{"location":"#Antennas.ArrayFactor-Tuple{AntennaArray, Any, Any, AbstractVector{T} where T}","page":"Home","title":"Antennas.ArrayFactor","text":"ArrayFactor(aa)\n\nConstructs a RadiationPattern representative of the array factor of the array aa sampled over azimuth ϕ and elevation θ at frequenc[y|ies] freq.\n\n\n\n\n\n","category":"method"},{"location":"#Antennas.baselines-Tuple{AntennaArray}","page":"Home","title":"Antennas.baselines","text":"\"     baselines(af) Returns all the baseline vectors for the antenna locations in aa.\n\n\n\n\n\n","category":"method"},{"location":"#Antennas.calibrate-Tuple{}","page":"Home","title":"Antennas.calibrate","text":"calibrate(array,phase_center)\n\nFor a given antenna array array, return a new AntennaArray whose phase center has been adjusted to phase_center.\n\n\n\n\n\n","category":"method"},{"location":"#Antennas.read_HFSS_pattern-Tuple{Any}","page":"Home","title":"Antennas.read_HFSS_pattern","text":"read_HFSS_pattern(\"myAntenna.csv\")\n\nUtility function to read the exported fields from HFSS into a RadiationPattern.\n\n\n\n\n\n","category":"method"}]
}