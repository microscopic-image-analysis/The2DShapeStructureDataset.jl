module The2DShapeStructureDataset
@doc read(joinpath(dirname(@__DIR__), "README.md"), String) The2DShapeStructureDataset


using Downloads
using ZipArchives
using JSON3
using Meshes
using HybridArrays
using Unitful

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

Returns a `2 ⨯ n` `HybridMatrix` with all coordinates of the shape with the
given name.
Use [`shape_names`](@ref) to find all possible inputs for this function.

```julia
julia> shape_coords("Bone-1")
2×106 HybridArrays.HybridMatrix{2, StaticArraysCore.Dynamic(), Float64, 2, Matrix{Float64}} with indices SOneTo(2)×Base.OneTo(106):
 0.34174  0.3578   0.37615  0.3922   0.40826  0.42431  0.44037  0.45642  0.47248  …  0.22477  0.24083  0.25688  0.27294  0.28899  0.30505  0.32339  0.33945  0.34174
 0.5      0.52523  0.55046  0.57569  0.60092  0.62615  0.65138  0.67661  0.70183     0.31651  0.34174  0.36697  0.3922   0.41743  0.44266  0.46789  0.49312  0.5
```
"""
function shape_coords(name)
    full_name = "Shapes/$(name).json"
    zip_entry = zip_readentry(ZIPPED_SHAPES, full_name)
    json = JSON3.read(zip_entry)
    stack(json.points) do point
        HybridVector{2}([point.x, point.y])
    end
end

"""
    shape_ring(name)

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
function shape_ring(name)
    coords = shape_coords(name)
    points = map(col -> Point(col...), eachcol(coords))
    Ring(points)
end

"""
    shape_area(name)

Returns the same coordinates as [`shape_coords`](@ref) but as a `PolyArea` from
`Meshes.jl`.

```julia
julia> shape_area("Bone-1")
PolyArea
  outer
  └─ Ring((x: 0.34174 m, y: 0.5 m), ..., (x: 0.34174 m, y: 0.5 m))
```
"""
function shape_area(name)
    ring = shape_ring(name)
    PolyArea(ring)
end

"""
    shape_sample_outline(name, n)

Returns a `2 ⨯ n` `HybridMatrix` of `n` points homogeneously sampled from the
outline of the shape with the given name.

```julia
julia> shape_sample_outline("Bone-1", 10)
2×10 HybridArrays.HybridMatrix{2, StaticArraysCore.Dynamic(), Float64, 2, Matrix{Float64}} with indices SOneTo(2)×Base.OneTo(10):
 0.652387  0.476934  0.220565  0.358224  0.0707124  0.224358  0.446889  0.435535  0.538483  0.786873
 0.765361  0.708831  0.167959  0.369937  0.100747   0.144465  0.661627  0.643784  0.812571  0.894025
```
"""
function shape_sample_outline(name, n)
    ring = shape_ring(name)
    points = sample(ring, HomogeneousSampling(n))
    _point_iter_to_mat(points)
end

"""
    shape_sample_inner(name, n)

Returns a `2 ⨯ n` `HybridMatrix` of `n` points homogeneously sampled from the
interior of the shape with the given name.

```julia
julia> shape_sample_inner("Bone-1", 10)
2×10 HybridArrays.HybridMatrix{2, StaticArraysCore.Dynamic(), Float64, 2, Matrix{Float64}} with indices SOneTo(2)×Base.OneTo(10):
 0.0915315  0.125075   0.751956  0.580064  0.780953  0.0356033  0.143631  0.0505262  0.337685  0.597154
 0.177619   0.0742084  0.907282  0.955151  0.828131  0.141015   0.138244  0.150312   0.466503  0.809213
```
"""
function shape_sample_inner(name, n)
    area = shape_area(name)
    points = sample(area, HomogeneousSampling(n))
    _point_iter_to_mat(points)
end

function _point_iter_to_mat(points)
    stack(points) do point
        (; x, y) = point.coords
        tpl = ustrip.(u"m", (x, y))
        HybridVector{2}([tpl...])
    end
end


end # module The2DShapeStructureDataset
