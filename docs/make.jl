using Antennas
using Documenter

DocMeta.setdocmeta!(Antennas, :DocTestSetup, :(using Antennas); recursive=true)

makedocs(;
    modules=[Antennas],
    authors="Kiran Shila <me@kiranshila.com> and contributors",
    repo="https://github.com/kiranshila/Antennas.jl/blob/{commit}{path}#{line}",
    sitename="Antennas.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://kiranshila.github.io/Antennas.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/kiranshila/Antennas.jl",
)
