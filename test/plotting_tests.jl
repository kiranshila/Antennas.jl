using Plots
plotlyjs()
include("../src/Plotting.jl")

x = read_HFSS_pattern("test/data/lens.csv")

sphericalpattern(x)