module MeshesExt

using The2DShapeStructureDataset
import The2DShapeStructureDataset: shape_ring, shape_area, shape_sample_outline, shape_sample_inner
using Meshes
using Meshes.Unitful

function shape_ring(name)
    coords = shape_coords(name)
    points = map(col -> Point(col...), eachcol(coords))
    Ring(points)
end

function shape_area(name)
    ring = shape_ring(name)
    PolyArea(ring)
end

function shape_sample_outline(name, n)
    ring = shape_ring(name)
    points = sample(ring, HomogeneousSampling(n))
    _point_iter_to_mat(points)
end

function shape_sample_inner(name, n)
    area = shape_area(name)
    points = sample(area, HomogeneousSampling(n))
    _point_iter_to_mat(points)
end

function _point_iter_to_mat(points)
    stack(points) do point
        (; x, y) = point.coords
        ustrip.(u"m", (x, y))
    end
end

end
