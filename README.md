# The2DShapeStructureDataset.jl

[![Static Badge](https://img.shields.io/badge/docs-main-blue)](https://microscopic-image-analysis.github.io/The2DShapeStructureDataset.jl/dev/)

This is a convenience package for working with
[The 2D Shape Structure Dataset](https://2dshapesstructure.github.io/).
The dataset has the following copyright notice

> Copyright (c) [2016] [A. Carlier, K. Leonard, S. Hahmann, G. Morin, M. Collins]

and is licensed under an MIT-License.

The whole dataset is 1.8 MB large (zipped) and is only downloaded once when you
use this package.

## Quickstart

Install this package from the General Registry:
```julia
julia> ]
pkg> add The2DShapeStructureDataset
```
and make it available:
```julia
julia> using The2DShapeStructureDataset
```

You can then obtain the coordinates for, say, the structure `apple-1`:
```julia
julia> shape_coords("apple-1")
2×112 Matrix{Float64}:
 0.0      0.0      0.0047847  …  0.0      0.0      0.0
 0.41627  0.44498  0.47368       0.38278  0.41148  0.41627
```

Find out what shapes are available by calling `shape_names` or visiting
[the visual explorer](https://2dshapesstructure.github.io/dataset.html).
