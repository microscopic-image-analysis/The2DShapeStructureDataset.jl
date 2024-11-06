using Documenter
using The2DShapeStructureDataset

makedocs(
    sitename = "The2DShapeStructureDataset",
    format = Documenter.HTML(),
    modules = [The2DShapeStructureDataset],
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/microscopic-image-analysis/The2DShapeStructureDataset.jl.git"
)
