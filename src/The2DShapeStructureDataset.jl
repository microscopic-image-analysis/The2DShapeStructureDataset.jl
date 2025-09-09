module The2DShapeStructureDataset
@doc read(joinpath(dirname(@__DIR__), "README.md"), String) The2DShapeStructureDataset

using Downloads
using ZipArchives
using JSON3

export shape_names, shape_coords, shape_ring, shape_area,
    shape_sample_outline, shape_sample_inner

const JSON_URL = "https://2dshapesstructure.github.io/data/ShapesJSON.zip"
const ZIPPED_SHAPES = ZipReader(take!(Downloads.download(JSON_URL, IOBuffer())))

"""
    shape_names()

Returns a vector of names of all shapes in the dataset.

```julia
julia> shape_names()
1256-element Vector{SubString{String}}:
 "Bone-1"
 "Bone-10"
 "Bone-11"
[...]
```
"""
function shape_names()
    sort([
        chopsuffix(chopprefix(raw_name, "Shapes/"), ".json")
        for raw_name in zip_names(ZIPPED_SHAPES)
        if raw_name != "Shapes/"
    ])
end


"""
    shape_coords(name)

Returns a `2 ⨯ n` `Matrix` with all coordinates of the shape with the given
name.
Use [`shape_names`](@ref) to find all possible inputs for this function.

```julia
julia> shape_coords("Bone-1")
2×106 Matrix{Float64}:
 0.34174  0.3578   0.37615  …  0.32339  0.33945  0.34174
 0.5      0.52523  0.55046     0.46789  0.49312  0.5
```
"""
function shape_coords(name)
    full_name = "Shapes/$(name).json"
    zip_entry = zip_readentry(ZIPPED_SHAPES, full_name)
    json = JSON3.read(zip_entry)
    stack(point -> [point.x, point.y], json.points)
end

"""
    shape_ring(name)

!!! info
    Requires the [`Meshes.jl`](https://github.com/JuliaGeometry/Meshes.jl)
    package being loaded.

Returns the same coordinates as [`shape_coords`](@ref) but as a `Ring` from
`Meshes.jl`.

```julia
julia> shape_ring("Bone-1")
Ring
├─ Point(x: 0.34174 m, y: 0.5 m)
├─ Point(x: 0.3578 m, y: 0.52523 m)
├─ Point(x: 0.37615 m, y: 0.55046 m)
├─ Point(x: 0.3922 m, y: 0.57569 m)
├─ Point(x: 0.40826 m, y: 0.60092 m)
⋮
├─ Point(x: 0.28899 m, y: 0.41743 m)
├─ Point(x: 0.30505 m, y: 0.44266 m)
├─ Point(x: 0.32339 m, y: 0.46789 m)
├─ Point(x: 0.33945 m, y: 0.49312 m)
└─ Point(x: 0.34174 m, y: 0.5 m)
```
"""
function shape_ring end

"""
    shape_area(name)

!!! info
    Requires the [`Meshes.jl`](https://github.com/JuliaGeometry/Meshes.jl)
    package being loaded.

Returns the same coordinates as [`shape_coords`](@ref) but as a `PolyArea` from
`Meshes.jl`.

```julia
julia> shape_area("Bone-1")
PolyArea
  outer
  └─ Ring((x: 0.34174 m, y: 0.5 m), ..., (x: 0.34174 m, y: 0.5 m))
```
"""
function shape_area end

"""
    shape_sample_outline(name, n)

!!! info
    Requires the [`Meshes.jl`](https://github.com/JuliaGeometry/Meshes.jl)
    package being loaded.

Returns a `2 ⨯ n` `Matrix` of `n` points homogeneously sampled from the
outline of the shape with the given name.

```julia
julia> shape_sample_outline("Bone-1", 10)
2×10 Matrix{Float64}:
 0.213944   0.0874572  0.695606  …  0.778814  0.681997
 0.0313239  0.0992228  0.753576     0.906329  0.955572
```
"""
function shape_sample_outline end

"""
    shape_sample_inner(name, n)

!!! info
    Requires the [`Meshes.jl`](https://github.com/JuliaGeometry/Meshes.jl)
    package being loaded.

Returns a `2 ⨯ n` `Matrix` of `n` points homogeneously sampled from the
interior of the shape with the given name.

```julia
julia> shape_sample_inner("Bone-1", 10)
2×10 Matrix{Float64}:
 0.0754321  0.727358  0.19444   …  0.645929  0.323449  0.638125
 0.241538   0.747493  0.188188     0.778322  0.370565  0.79197
```
"""
function shape_sample_inner end

end # module The2DShapeStructureDataset
