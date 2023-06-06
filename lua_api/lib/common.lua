-- Common Shape Functions

local common = {}

local vector = shapes.vector
local validate_vector = vector.validate_vector
local error = shapes.util.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber

function common.quad(bl,tl,tr,br,group)
    validate_vector(bl)
    validate_vector(tl)
    validate_vector(tr)
    validate_vector(br)
    -- verify_all_one_one_plane
    local p1 = vector.subtract(tl,bl)
    local p2 = vector.subtract(tr,bl)
    local p3 = vector.subtract(br,bl)
    if vector.determinant(p1,p2,p3) > 0.001 then
        error("Points provided are not co-planar")
    end
    if not isnumber(group) then error("5th arg: expected number, got "..type(group)) end

    local n = vector.cross(vector.subtract(bl,tl),vector.subtract(bl,tr))

    add_triangle(
        tl.x, tl.y, tl.z,
        bl.x, bl.y, bl.z,
        tr.x, tr.y, tr.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        tl.tx, tl.ty,
        bl.tx, bl.ty,
        tr.tx, tr.ty,
        group
    )

    add_triangle(
        br.x, br.y, br.z,
        tr.x, tr.y, tr.z,
        bl.x, bl.y, bl.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        br.tx, br.ty,        
        tr.tx, tr.ty,
        bl.tx, bl.ty,
        group
    )
end

function common.tri(bl,tl,tr,group)
    if not isnumber(group) then error("4th arg: expected number, got "..type(group)) end
    validate_vector(bl)
    validate_vector(tl)
    validate_vector(tr)
    local n = vector.cross(vector.subtract(bl,tl),vector.subtract(bl,tr))
    add_triangle(
        tl.x, tl.y, tl.z,
        bl.x, bl.y, bl.z,
        tr.x, tr.y, tr.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        n.x, n.y, n.z,
        tl.tx, tl.ty,
        bl.tx, bl.ty,
        tr.tx, tr.ty,
        group
    )
end

function common.rect(bl, tl, tr, group)
    validate_vector(bl)
    validate_vector(tl)
    validate_vector(tr)
    local br = vector.add(vector.subtract(bl,tl),tr)

    common.quad(bl,tl,tr,br,group)
end

function common.axis_aligned_rectangular_prism(middle, dimensions, tesselated, g1, g2, g3, g4, g5, g6)
    validate_vector(middle)
    validate_vector(dimensions)
    tesselated = tesselated or false
    if not isnumber(g1) then g1=1 end
    if not isnumber(g2) then g2=2 end
    if not isnumber(g3) then g3=3 end
    if not isnumber(g4) then g4=4 end
    if not isnumber(g5) then g5=5 end
    if not isnumber(g6) then g6=6 end

--      .+-top--+
--    .' |    .'|
--   +---+--+'  |-back
--   |   |  |   |
--   |  ,+--+---+
--   |.'    | .' 
--   +-front+'  right -->
-- -Z = front, +X = right, +Y = top. 

    -- blf == bottom, left, front
    local d = dimensions
    local m = middle
    local new = vector.new
    blf = new(m.x - d.x/2, m.y - d.y/2, m.z + d.z/2, m.nx, m.ny, m.nz, m.tx, m.ty)
    blb = new(blf); blb.z = blb.z - d.z
    brf = new(blf); brf.x = brf.x + d.x
    brb = new(brf); brb.z = brb.z - d.z
    tlf = new(blf); tlf.y = tlf.y + d.y
    tlb = new(tlf); tlb.z = tlb.z - d.z
    trf = new(tlf); trf.x = trf.x + d.x
    trb = new(trf); trb.z = trb.z - d.z
    
    local t = 0
    if tesselated then
        t = function(bl,tl,tr,g,tx,ty) --overwrite texture coords, using provided tx, ty
        return  new(bl.x,bl.y,bl.z,bl.nx,bl.ny,bl.nz,0,0),
                new(tl.x,tl.y,tl.z,tl.nx,tl.ny,tl.nz,0,ty),
                new(tr.x,tr.y,tr.z,tr.nx,tr.ny,tr.nz,tx,ty), g
        end
    else
        t = function(bl,tl,tr,g) --overwrite texture coords, assuming stretch
            return  new(bl.x,bl.y,bl.z,bl.nx,bl.ny,bl.nz,0,0),
                    new(tl.x,tl.y,tl.z,tl.nx,tl.ny,tl.nz,0,1),
                    new(tr.x,tr.y,tr.z,tr.nx,tr.ny,tr.nz,1,1), g
        end
    end

    -- now output the rectangles
    local r = common.rect
    r(t(tlf,tlb,trb,g1,d.x,d.z))  --top
    r(t(blb,blf,brf,g2,d.x,d.z))  --bottom
    r(t(blf,tlf,trf,g3,d.x,d.y))  --front
    r(t(brb,trb,tlb,g4,d.x,d.y))  --back
    r(t(brf,trf,trb,g5,d.z,d.y))  --right
    r(t(blb,tlb,tlf,g6,d.z,d.y))  --left
end

return common