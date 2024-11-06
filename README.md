# The2dShapeStructureDataset.jl

This is a convenience package for working with
[The 2D Shape Structure Dataset](https://2dshapesstructure.github.io/).
The dataset has the following copyright notice
> Copyright (c) [2016] [A. Carlier, K. Leonard, S. Hahmann, G. Morin, M. Collins]
and is licensed under an MIT-License.

## Quickstart

Install this package from the Genreal Registry:
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
2×112 HybridArrays.HybridMatrix{2, StaticArraysCore.Dynamic(), Float64, 2, Matrix{Float64}} with indices SOneTo(2)×Base.OneTo(112):
 0.0      0.0      0.0047847  0.0047847  0.014354  0.019139  0.028708  0.043062  …  0.038278  0.028708  0.019139  0.0095694  0.0047847  0.0      0.0      0.0
 0.41627  0.44498  0.47368    0.50239    0.5311    0.55981   0.58852   0.61722      0.23923   0.26794   0.29665   0.32536    0.35407    0.38278  0.41148  0.41627
```
