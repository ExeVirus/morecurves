-- |\  /|               /~~                 
-- | \/ | /~\ |/~\ /^/ |   |   | |/~\ \  / /^/ (~
-- |    | \_/ |    \^_  \__ \_/| |     \/  \^_ _)
                                 
-- Quick Note: The groups in minetest are:
-- 1 = top
-- 2 = bottom
-- 3 = left
-- 4 = right
-- 5 = front
-- 6 = back

-----Preloaded locals-----
local points = shapes.points
local vector = shapes.vector
local p_manip = shapes.p_manip
local v = vector.new
local function v3(x,y,z)
    return v(x,y,z,0,0,0,0,0)
end

----------------------------------------------------------------
------------------------------Mesh 45---------------------------
-- Object A
-- 1.2 nodes tall
-- vertical to 45° left curve
-- 1-node width
--
--   /^-.   
--  /    \  
--  -.   |
--   -   |
--   +---+
--
----------------------------------------------------------------

--Calculate the center line of the curve
local curve = points.super_e_curve(math.pi*0/4, math.pi*1/4, 5, 1.5, 1, 1, 1.71, 1.71)

--offset to center on minetest node
curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,0,0))
curve = p_manip.add(curve, v(-1.5,-0.5,0,0,0,0,0))

--inner will be listed in reverse order, to get correct winding
local inner = p_manip.reverse(curve)
inner = p_manip.func(inner, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)

local outer = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
outer = p_manip.func(outer, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)

local function calc_tx(seg)
    points.validate_segment(seg)
    local tx = 0
    seg[1].tx = 0
    for i=2,#seg,1 do
        tx = tx + vector.distance(seg[i],seg[i-1])
        seg[i].tx = tx
    end
end
calc_tx(inner)
calc_tx(outer)

local rev_inner = p_manip.multiply(outer, v(-1,1,1,-1,1,1,0,0))
rev_inner = p_manip.reverse(rev_inner)
calc_tx(rev_inner)

local rev_outer = p_manip.multiply(inner, v(-1,1,1,-1,1,1,0,0))
rev_outer = p_manip.reverse(rev_outer)
calc_tx(rev_outer)

local groupsA = {4,3,2,1,6,5}
local rotationsA = {4,2,2,4,1,3}
local _rotationsA = {4,2,4,2,1,3}
shapes.curve3d.curve2_closed(inner, outer, -0.50,-0.25, 0.00, 0.25,groupsA,rotationsA,"models/45_1.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.00, 0.00, 0.50,groupsA,rotationsA,"models/45_2.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.25, 0.00, 0.75,groupsA,rotationsA,"models/45_3.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.50, 0.00, 1.00,groupsA,rotationsA,"models/45.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50,-0.25, 0.00, 0.25,groupsA,_rotationsA,"models/45_1r.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50, 0.00, 0.00, 0.50,groupsA,_rotationsA,"models/45_2r.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50, 0.25, 0.00, 0.75,groupsA,_rotationsA,"models/45_3r.obj")

----------------------------------------------------------------
------------------------------Mesh 90----------------------------
-- Object B
-- 1 nodes tall
-- 90° left curve
--  ---. 
--  |   ^
--  |    \  
--  +----+
--
----------------------------------------------------------------

curve = points.super_e_curve(math.pi*0/4, math.pi*2/4, 5, 1, 1, 1, 1.71, 1.71)
curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,1,1))
curve = p_manip.add(curve, v3(-0.5,-0.5,0.5))
calc_tx(curve)

local groups_b = {5,6,4,3,1,2}
rotations = {8,2,1,4,2,4}
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50,-0.25, 0.00, 0.25, groups_b, rotations, "models/90_1.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.00, 0.00, 0.50, groups_b, rotations, "models/90_2.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.25, 0.00, 0.75, groups_b, rotations, "models/90_3.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.50, 0.00, 1.00, groups_b, rotations, "models/90.obj")

-- --------------------------------------------------------------
-- ----------------------------Mesh _B---------------------------
-- Object B`
-- 1 nodes tall
-- 90° left curve
--  -._--+
--     ^.|
--      ^|
 
-- --------------------------------------------------------------
curve = p_manip.reverse(curve)
curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))

local groups__b = {5,6,3,4,1,2}
rotations = {6,4,1,8,2,4}
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50,-0.25, 0.00, 0.25, groups__b, rotations, "models/90_outer_1.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.00, 0.00, 0.50, groups__b, rotations, "models/90_outer_2.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.25, 0.00, 0.75, groups__b, rotations, "models/90_outer_3.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.50, 0.00, 1.00, groups__b, rotations, "models/90_outer.obj")

----------------------------------------------------------------
------------------------------Mesh A1---------------------------
-- Object A1
-- 1 nodes tall
-- 90° inverse corner of a A piece and an Ar piece
--  +------+
--  |      |
--  +-_    |
--     \   |
--     +---+
----------------------------------------------------------------
--Create a special function for this pieces
local curve_A1 = function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    groups = groups or {1,2,3,4,5,6}
    rotations = rotations or {1,1,1,1,1,1}
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2 -- Yes, there is some magical number being used for the angles, no I didn't do the math
    local curve = points.super_e_curve(math.pi/4-magic_number, math.pi/4+magic_number, 5, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    curve = p_manip.add(curve, v3(-1.5,bottomh,-1.5))
    curve = p_manip.multiply(curve, v(1,1,-1,-1,1,1,1,1))
    curve = p_manip.reverse(curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = -0.073
        seg[1].tx = tx
        for i=2,#seg,1 do
            tx = tx + vector.distance(seg[i],seg[i-1])
            seg[i].tx = tx
        end
    end
    calc_tx(curve)

    local curve_open = function(curve)
        shapes.curve3d.point_curve_open(v3(0.5,bottomh,-0.5), curve, bottomh, toph, bottom_ty, top_ty,groups,rotations,"no_export")
    end

    curve_open({ v(-0.5,bottomh,-0.5,-1,0,0,0,0), v(curve[1].x, curve[1].y, curve[1].z,-1,0,0,curve[1].z+0.5,0) })    -- left
    curve_open(curve)                                                                                                 -- curve
    curve_open({ v(curve[5].x, curve[5].y, curve[5].z,0,0,1,curve[5].x+0.5,0), v(0.5,bottomh,0.5,0,0,1,1,0) })        -- front
    shapes.curve2d.wall({ v(0.5,bottomh,-0.5,0,0,-1,0,0), v(-0.5,bottomh,-0.5,0,0,-1,1,0) }, toph-bottomh, top_ty, groups[6],rotations[6]) -- back
    shapes.curve2d.wall({ v(0.5,bottomh,0.5,0,0,-1,0,0), v(0.5,bottomh,-0.5,0,0,-1,1,0) }, toph-bottomh, top_ty, groups[3], groups[3])   -- right
    
    export_mesh(name)
end

local groups_a1 = {5,6,2,3,4,1}
rotations = {6,4,3,6,2,2}
-- curve_A1(-0.50,-0.25, 0.00, 0.25, groups_a1, rotations, "models/a1_1.obj")
-- curve_A1(-0.50, 0.00, 0.00, 0.50, groups_a1, rotations, "models/a1_2.obj")
-- curve_A1(-0.50, 0.25, 0.00, 0.75, groups_a1, rotations, "models/a1_3.obj")
-- curve_A1(-0.50, 0.50, 0.00, 1.00, groups_a1, rotations, "models/a1_4.obj")

----------------------------------------------------------------
------------------------------Mesh A2---------------------------
-- Object A2
-- 1 nodes tall
-- 90° inverse of start of an A piece 
--       --+
--       ^.|
--        -|
--        \|
--         +
----------------------------------------------------------------
local curve_A2 = function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    groups = groups or {1,2,3,4,5,6}
    rotations = rotations or {1,1,1,1,1,1}
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2 -- Yes, there is some magical number being used for the angles, no I didn't do the math
    local curve = points.super_e_curve(0, math.pi/4-magic_number, 5, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    curve = p_manip.add(curve, v3(-1.5,bottomh,-0.5))
    curve = p_manip.multiply(curve, v(1,1,-1,-1,1,1,1,1))
    curve = p_manip.reverse(curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = 1
        seg[#seg].tx = tx
        for i=#seg-1,1,-1 do
            tx = tx - vector.distance(seg[i+1],seg[i])
            seg[i].tx = tx
        end
    end
    calc_tx(curve)

    shapes.curve3d.point_curve_open(v3(0.5,bottomh,-0.5), curve, bottomh, toph, bottom_ty, top_ty,groups,rotations,"no_export") --top, bottom, left
    shapes.curve2d.wall({ v(0.5,bottomh,-0.5,0,0,-1,0,0), v(curve[1].x,bottomh,-0.5,0,0,-1,0.5-curve[1].x,0) }, toph-bottomh, top_ty, groups[6], rotations[6]) -- back
    shapes.curve2d.wall({ v(0.5,bottomh,0.5,1,0,0,0,0), v(0.5,bottomh,-0.5,1,0,0,1,0) }, toph-bottomh, top_ty, groups[3], rotations[3]) -- right

    export_mesh(name)
end

local groups_a2 = {6,5,1,3,1,4}
rotations = {5,1,4,2,2,1}
-- curve_A2(-0.50,-0.25, 0.00, 0.25, groups_a2, rotations, "models/a2_1.obj")
-- curve_A2(-0.50, 0.00, 0.00, 0.50, groups_a2, rotations, "models/a2_2.obj")
-- curve_A2(-0.50, 0.25, 0.00, 0.75, groups_a2, rotations, "models/a2_3.obj")
-- curve_A2(-0.50, 0.50, 0.00, 1.00, groups_a2, rotations, "models/a2_4.obj")

local curve_A2R = function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    groups = groups or {1,2,3,4,5,6}
    rotations = rotations or {1,1,1,1,1,1}
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2 -- Yes, there is some magical number being used for the angles, no I didn't do the math
    local curve = points.super_e_curve(math.pi/4+magic_number, math.pi/2, 5, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    curve = p_manip.add(curve, v3(-0.5,bottomh,-1.5))
    curve = p_manip.multiply(curve, v(1,1,-1,-1,1,1,1,1))
    curve = p_manip.reverse(curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = 0.847
        seg[#seg].tx = tx
        for i=#seg-1,1,-1 do
            tx = tx - vector.distance(seg[i+1],seg[i])
            seg[i].tx = tx
        end
    end
    calc_tx(curve)

    shapes.curve3d.point_curve_open(v3(0.5,bottomh,-0.5), curve, bottomh, toph, bottom_ty, top_ty,groups,rotations, "no_export") --top, bottom, left
    shapes.curve2d.wall({ v(0.5,bottomh,-0.5,0,0,-1,0,0), v(-0.5,bottomh,-0.5,0,0,-1,1,0) }, toph-bottomh, top_ty, groups[6], rotations[6]) -- back
    shapes.curve2d.wall({ v(0.5,bottomh,curve[5].z,1,0,0,0.5-curve[5].z,0), v(0.5,bottomh,-0.5,1,0,0,1,0) }, toph-bottomh, top_ty, groups[3], rotations[3]) -- right

    export_mesh(name)
end

-- 1 = top
-- 2 = bottom
-- 3 = right
-- 4 = left
-- 5 = back
-- 6 = front
local groups_a2r = {6,5,4,3,4,1}
rotations = {6,4,1,4,3,2}
-- curve_A2R(-0.50,-0.25, 0.00, 0.25, groups_a2r, rotations, "models/a2_1r.obj")
-- curve_A2R(-0.50, 0.00, 0.00, 0.50, groups_a2r, rotations, "models/a2_2r.obj")
-- curve_A2R(-0.50, 0.25, 0.00, 0.75, groups_a2r, rotations, "models/a2_3r.obj")

----------------------------------------------------------------
------------------------------Mesh AF---------------------------
-- Object AF
-- 2 nodes tall, 2 nodes wide
-- Full 90° inverse of two A pieces
--  +_----------+
--    ^-_       |
--       ^-_    |
--          \   |
--           ^. |
--             -|
--             \|
--              +
----------------------------------------------------------------

local curve_AF = function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    groups = groups or {1,2,3,4,5,6}
    rotations = rotations or {1,1,1,1,1,1}
    reset_mesh()
    local curve = points.super_e_curve(0, math.pi/2, 9, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    curve = p_manip.add(curve, v3(-1.5,bottomh,-1.5))
    curve = p_manip.multiply(curve, v(1,1,-1,-1,1,1,1,1))
    curve = p_manip.reverse(curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = 1
        seg[#seg].tx = tx
        for i=#seg-1,1,-1 do
            tx = tx - vector.distance(seg[i+1],seg[i])
            seg[i].tx = tx
        end
    end
    calc_tx(curve)

    shapes.curve3d.point_curve_open(v3(0.5,bottomh,-0.5), curve, bottomh, toph, bottom_ty, top_ty,groups,rotations, "no_export") --top, bottom, left
    shapes.curve2d.wall({ v(0.5,bottomh,-0.5,0,0,-1,0,0), v(-1.5,bottomh,-0.5,0,0,-1,2,0) }, toph-bottomh, top_ty, groups[6],rotations[6]) -- back
    shapes.curve2d.wall({ v(0.5,bottomh,1.5,1,0,0,0,0), v(0.5,bottomh,-0.5,1,0,0,2,0) }, toph-bottomh, top_ty, groups[3],rotations[3]) -- right

    export_mesh(name)
end

local groups_af = {5,6,2,3,6,1}
rotations = {6,4,4,4,4,2}
curve_AF(-0.50,-0.25, 0.00, 0.25,groups_af,rotations, "models/90_outer_large_1.obj")
curve_AF(-0.50, 0.00, 0.00, 0.50,groups_af,rotations, "models/90_outer_large_2.obj")
curve_AF(-0.50, 0.25, 0.25, 0.75,groups_af,rotations, "models/90_outer_large_3.obj")
curve_AF(-0.50, 0.50, 0.00, 1.00,groups_af,rotations, "models/90_outer_large.obj")

----------------------------------------------------------------
------------------------------Mesh C----------------------------
-- Object C
-- 2 nodes tall, 1 nodes wide
-- inverse of two A pieces that straighten back out
--  +
--  || 
--  |\
--  | ^
--  |  ^.
--  |    \
--  |     \
--  |      ^_
--  |        ^_
--  |          \
--  |           |
--  |            |
--  +------------+
----------------------------------------------------------------

local curve_C= function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    groups = groups or {1,2,3,4,5,6}
    rotations = rotations or {1,1,1,1,1,1}
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2
    --Calculate the top half of the curve
    local curve = points.super_e_curve(0, math.pi/4, 5, 1.5, 1, 1, 1.71, 1.71)
    
    curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,0,0))
    curve = p_manip.add(curve, v(-1.5,bottomh,0,0,0,0,0))
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+3), 0.5)) end)
    curve = p_manip.multiply(curve, v(-1,1,-1,-1,1,1,1,1))

    local other_half = points.super_e_curve(math.pi*0/4, math.pi*1/4, 5, 1.5, 1, 1, 1.71, 1.71)
    other_half = p_manip.multiply(other_half, v(1,1,-1,1,1,1,1,1))
    other_half = p_manip.add(other_half, v(-1.5,bottomh,0,0,0,0,0))
    other_half = p_manip.reverse(other_half)
    other_half = p_manip.func(other_half, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)
    other_half = p_manip.add(other_half, v(1,0,0,0,0,0,0))
    
    --combine the two
    local full_curve = {}
    for i=1,4,1 do
        full_curve[i] = shapes.util.copy(curve[i])
    end
    for i=1,5,1 do
        full_curve[i+4] = shapes.util.copy(other_half[i])
    end
    full_curve = p_manip.reverse(full_curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        for i=1,#seg,1 do
            seg[i].tx = (seg[i].z+0.5)
        end
    end
    calc_tx(full_curve)

    local point = v3(-0.5, bottomh, 0.5)

    shapes.curve3d.point_curve_open(point, full_curve, bottomh, toph, bottom_ty, top_ty, groups,rotations, "no_export") --top, bottom, left
    shapes.curve2d.wall({ v(-0.5,bottomh,-1.5,0,0,-1,0,0), v(-0.5,bottomh,0.5,0,0,-1,2,0) }, toph-bottomh, top_ty, groups[6],rotations[6]) -- back
    shapes.curve2d.wall({ v(-0.5,bottomh,0.5,1,0,0,0,0), v(0.5,bottomh,0.5,1,0,0,1,0) }, toph-bottomh, top_ty, groups[3],rotations[3]) -- right

    export_mesh(name)
end

local groups_C = {6,5,2,3,4,1}
rotations = {7,3,2,6,1,4}
curve_C(-0.50,-0.25, 0.00, 0.25, groups_C, rotations, "models/smooth_offset_1.obj")
curve_C(-0.50, 0.00, 0.00, 0.50, groups_C, rotations, "models/smooth_offset_2.obj")
curve_C(-0.50, 0.25, 0.00, 0.75, groups_C, rotations, "models/smooth_offset_3.obj")
curve_C(-0.50, 0.50, 0.00, 1.00, groups_C, rotations, "models/smooth_offset.obj")

local curve_CR= function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2
    --Calculate the top half of the curve
    local curve = points.super_e_curve(0, math.pi/4, 5, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,0,0))
    curve = p_manip.add(curve, v(-1.5,bottomh,0,0,0,0,0))
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+3), 0.5)) end)
    curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,1,1))

    local other_half = points.super_e_curve(math.pi*0/4, math.pi*1/4, 5, 1.5, 1, 1, 1.71, 1.71)
    other_half = p_manip.multiply(other_half, v(1,1,-1,1,1,1,0,0))
    other_half = p_manip.add(other_half, v(-1.5,bottomh,0,0,0,0,0))
    other_half = p_manip.reverse(other_half)
    other_half = p_manip.func(other_half, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)
    other_half = p_manip.multiply(other_half, v(-1,1,1,-1,1,1,1,1))
    other_half = p_manip.add(other_half, v3(-1,0,0))
    
    --combine the two
    local full_curve = {}
    for i=1,4,1 do
        full_curve[i] = shapes.util.copy(curve[i])
    end
    for i=1,5,1 do
        full_curve[i+4] = shapes.util.copy(other_half[i])
    end

    local point = v3(0.5, bottomh, 0.5)

    local function calc_tx(seg)
        points.validate_segment(seg)
        for i=1,#seg,1 do
            seg[i].tx = (seg[i].z+0.5)
        end
    end
    calc_tx(full_curve)

    --shapes.curve3d.point_curve_closed(point, full_curve, bottomh, toph, bottom_ty, top_ty, {1,2,4,3,5,6}, nil, name)
    shapes.curve3d.point_curve_open(point, full_curve, bottomh, toph, bottom_ty, top_ty, groups,rotations, "no_export") --top, bottom, left
    shapes.curve2d.wall({ v(0.5,bottomh,0.5,0,0,-1,0,0), v(0.5,bottomh,-1.5,0,0,-1,2,0) }, toph-bottomh, top_ty, groups[6],rotations[6]) -- back
    shapes.curve2d.wall({ v(-0.5,bottomh,0.5,1,0,0,0,0), v(0.5,bottomh,0.5,1,0,0,1,0) }, toph-bottomh, top_ty, groups[3],rotations[3]) -- right

    export_mesh(name)
end

local groups_CR = {6,5,2,4,3,1}
rotations = {7,3,4,4,1,2}
curve_CR(-0.50,-0.25, 0.00, 0.25, groups_CR, rotations, "models/smooth_offset_1r.obj")
curve_CR(-0.50, 0.00, 0.00, 0.50, groups_CR, rotations, "models/smooth_offset_2r.obj")
curve_CR(-0.50, 0.25, 0.00, 0.75, groups_CR, rotations, "models/smooth_offset_3r.obj")

----------------------------------------------------------------
------------------------------Mesh C1---------------------------
-- Object C1
-- 1 nodes tall, 1 nodes wide
-- Bottom half of C
--  +----+
--  |     \
--  |      ^_
--  |        ^_
--  |          \
--  |           |
--  |            |
--  +------------+
----------------------------------------------------------------

local curve_C1= function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2
    --Calculate the top half of the curve
    local curve = points.super_e_curve(math.pi/4-magic_number, math.pi/4, 3, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,0,0))
    curve = p_manip.add(curve, v(-1.5,bottomh,0,0,0,0,0))
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+3), 0.5)) end)
    curve = p_manip.multiply(curve, v(-1,1,-1,-1,1,1,1,1))

    local other_half = points.super_e_curve(math.pi*0/4, math.pi*1/4, 5, 1.5, 1, 1, 1.71, 1.71)
    other_half = p_manip.multiply(other_half, v(1,1,-1,1,1,1,0,0))
    other_half = p_manip.add(other_half, v(-1.5,bottomh,0,0,0,0,0))
    other_half = p_manip.reverse(other_half)
    other_half = p_manip.func(other_half, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)
    other_half = p_manip.add(other_half, v(1,0,0,0,0,0,0))
    --combine the two
    local full_curve = {}
    full_curve[1] = shapes.util.copy(curve[1])
    full_curve[2] = shapes.util.copy(curve[2])
    for i=1,5,1 do
        full_curve[i+2] = shapes.util.copy(other_half[i])
    end
    full_curve = p_manip.reverse(full_curve)

    local function calc_tx(seg)
        points.validate_segment(seg)
        for i=1,#seg,1 do
            seg[i].tx = (seg[i].z+0.5)
        end
    end
    calc_tx(full_curve)

    local point = v3(-0.5, bottomh, 0.5)

    shapes.curve3d.point_curve_open(point, full_curve, bottomh, toph, bottom_ty, top_ty, groups, rotations, "no_export") --right curve
    local endp = full_curve[#full_curve]
    shapes.curve3d.point_curve_open(point, {v(endp.x, bottomh, endp.z, 0, 0, 1, 0.5+endp.x,0), v(-0.5,bottomh,-0.5, 0, 0, 1, 1, 0)}, bottomh, toph, bottom_ty, top_ty, groups, rotations, "no_export") --back
    shapes.curve2d.wall({ v(-0.5,bottomh,0.5,0,0,1,0,0), v(0.5,bottomh,0.5,0,0,1,1,0) }, toph-bottomh, top_ty, groups[6], rotations[6]) -- front
    shapes.curve2d.wall({ v(-0.5,bottomh,-0.5,-1,0,0,0,0), v(-0.5,bottomh,0.5,-1,0,0,1,0) }, toph-bottomh, top_ty, groups[3], rotations[3]) -- left

    export_mesh(name)
end

local groups_C1 = {6,5,1,3,4,2}
rotations = {7,3,4,6,1,2}
-- curve_C1(-0.50,-0.25, 0.00, 0.25, groups_C1, rotations, "models/c1_1.obj")
-- curve_C1(-0.50, 0.00, 0.00, 0.50, groups_C1, rotations, "models/c1_2.obj")
-- curve_C1(-0.50, 0.25, 0.00, 0.75, groups_C1, rotations, "models/c1_3.obj")
-- curve_C1(-0.50, 0.50, 0.00, 1.00, groups_C1, rotations, "models/c1_4.obj")

local curve_C1R= function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    reset_mesh()
    local magic_number = (math.sqrt(2)-1)/2
    --Calculate the top half of the curve
    local curve = points.super_e_curve(math.pi/4-magic_number, math.pi/4, 3, 1.5, 1, 1, 1.71, 1.71)
    curve = p_manip.multiply(curve, v(1,1,-1,1,1,1,0,0))
    curve = p_manip.add(curve, v(-1.5,bottomh,0,0,0,0,0))
    curve = p_manip.multiply(curve, v(1,1,1,-1,-1,-1,1,1))
    curve = p_manip.func(curve, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+3), 0.5)) end)
    curve = p_manip.multiply(curve, v(-1,1,-1,-1,1,1,1,1))

    local other_half = points.super_e_curve(math.pi*0/4, math.pi*1/4, 5, 1.5, 1, 1, 1.71, 1.71)
    other_half = p_manip.multiply(other_half, v(1,1,-1,1,1,1,0,0))
    other_half = p_manip.add(other_half, v(-1.5,bottomh,0,0,0,0,0))
    other_half = p_manip.reverse(other_half)
    other_half = p_manip.func(other_half, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,-v.nz+1), 0.5)) end)
    other_half = p_manip.add(other_half, v(1,0,0,0,0,0,0))
    --combine the two
    local full_curve = {}
    full_curve[1] = shapes.util.copy(curve[1])
    full_curve[2] = shapes.util.copy(curve[2])
    for i=1,5,1 do
        full_curve[i+2] = shapes.util.copy(other_half[i])
    end
    full_curve = p_manip.multiply(full_curve, v(-1,1,1,-1,1,1,1,1))

    local function calc_tx(seg)
        points.validate_segment(seg)
        for i=1,#seg,1 do
            seg[i].tx = (seg[i].z+0.5)
        end
    end
    calc_tx(full_curve)

    local point = v3(0.5, bottomh, 0.5)

    shapes.curve3d.point_curve_open(point, full_curve, bottomh, toph, bottom_ty, top_ty, groups, rotations, "no_export") --left curve
    local startp = full_curve[1]
    shapes.curve3d.point_curve_open(point, {v(0.5,bottomh,-0.5, 0, 0, 1, 0, 0), v(startp.x, bottomh, startp.z, 0, 0, 1, startp.x,0)}, bottomh, toph, bottom_ty, top_ty, groups, rotations, "no_export") --back
    shapes.curve2d.wall({ v(-0.5,bottomh,0.5,0,0,1,0,0), v(0.5,bottomh,0.5,0,0,1,1,0) }, toph-bottomh, top_ty, groups[6], rotations[6]) -- front
    shapes.curve2d.wall({v(0.5,bottomh,0.5,1,0,0,0,0), v(0.5,bottomh,-0.5,1,0,0,1,0) }, toph-bottomh, top_ty, groups[3], rotations[3]) -- right

    export_mesh(name)
end

-- 1 = top
-- 2 = bottom
-- 3 = right
-- 4 = left
-- 5 = back
-- 6 = front
local groups_C1R = {6,5,1,4,3,2}
rotations = {7,3,2,4,1,4}
-- curve_C1R(-0.50,-0.25, 0.00, 0.25, groups_C1R, rotations, "models/c1_1r.obj")
-- curve_C1R(-0.50, 0.00, 0.00, 0.50, groups_C1R, rotations, "models/c1_2r.obj")
-- curve_C1R(-0.50, 0.25, 0.00, 0.75, groups_C1R, rotations, "models/c1_3r.obj")

----------------------------------------------------------------
------------------------------Mesh D----------------------------
-- Object D
-- ~1.2 nodes tall, ~1.5 nodes wide
-- Middle of 2 As coming together
--           __--^--__
--      _--^^         ^^--_
--     ^_                 _^   
--       ^_             _^ 
--         ^_         _^  
--           ^_ _^_ _^
--             +   +
----------------------------------------------------------------

local curve_D = function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)

    --function points.super_e_curve(starting_theta, ending_theta, precision, radius, a, b, m, n)
    --x = a * math.pow( math.abs( c ), 2 / m ) * radius
    --local magic_number = math.acos(math.pow( (0.5)/1.5 , 1.71/2 ))
    local magic_number_outer = 1.262
    local outer = points.super_e_curve(math.pi*1/4, magic_number_outer, 5, 1.5, 1, 1, 1.71, 1.71)
    local outer = p_manip.multiply(outer, v(1,1,1,-1,-1,-1,1,1))
    outer = p_manip.func(outer, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    outer = p_manip.add(outer, v(-0.5,0,-1.5,0,0,0,0))
    outer = p_manip.multiply(outer,v(1,1,-1,1,1,-1,1,1))
    local outer2 = p_manip.multiply(outer,v(-1,1,1,-1,1,1,1,1))
    local outer2 = p_manip.reverse(outer2)

    for i=2,#outer2,1 do
        outer[#outer+1] = shapes.util.copy(outer2[i])
    end

    local magic_number_inner = 0.969
    local inner = points.super_e_curve(math.pi*1/4, magic_number_inner, 5, 1.5, 1, 1, 1.71, 1.71)
    inner = p_manip.func(inner, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    inner = p_manip.add(inner, v(-0.5,0,-1.5,0,0,0,0))
    local inner2 = p_manip.multiply(inner,v(-1,1,1,-1,1,1,1,1))
    local inner2 = p_manip.reverse(inner2)

    for i=2,#inner2,1 do
        inner[#inner+1] = shapes.util.copy(inner2[i])
    end

    inner = p_manip.reverse(inner) -- for correct triangle winding
    inner = p_manip.multiply(inner,v(1,1,-1,1,1,-1,1,1))

    local function calc_txy(seg)
        points.validate_segment(seg)
        for i=1,#seg,1 do
            seg[i].tx = seg[i].x
            seg[i].ty = seg[i].z
        end
    end
    calc_txy(inner)
    calc_txy(outer)

    for i=1,#inner,1 do
        inner[i].y = bottomh
        inner[i].ty = bottom_ty
    end

    for i=1,#outer,1 do
        outer[i].y = bottomh
        outer[i].ty = bottom_ty
    end

    local function curve2_closed(left_in, right_in, bottomh, toph, bottom_ty, top_ty, groups, rotations, name)
        rotations = rotations or {1,1,1,1,1,1}
        groups = groups or {3,4,5,6,1,2}

        if name ~= "no_export" then reset_mesh() end
        local left = shapes.util.copy(left_in)
        local right = shapes.util.copy(right_in)

        shapes.curve2d.wall(left, toph-bottomh, top_ty, groups[1], rotations[1])
        shapes.curve2d.wall(right, toph-bottomh, top_ty, groups[2], rotations[2])

        --calculate the Bottom and Top
        local bl, tl, tr, br = 0,0,0,0
        bl = vector.new(left[#left].x,bottomh,left[#left].z,0,0,0,0,bottom_ty)
        br = vector.new(right[1].x,bottomh,right[1].z,0,0,0,1,bottom_ty)
        tr = vector.new(br); tr.y = toph; tr.ty = top_ty
        tl = vector.new(bl); tl.y = toph; tl.ty = top_ty
        shapes.common.quad(bl,tl,tr,br,groups[3], rotations[3])

        bl = vector.new(left[1].x,bottomh,left[1].z,0,0,0,1,bottom_ty)
        br = vector.new(right[#right].x,bottomh,right[#right].z,0,0,0,0,bottom_ty)
        tr = shapes.vector.new(br); tr.y = toph; tr.ty = top_ty
        tl = shapes.vector.new(bl); tl.y = toph; tl.ty = top_ty
        shapes.common.quad(br,tr,tl,bl,groups[4], rotations[4])

        --Calculate the front and back
        --reorder
        local rev = {}
        for i=#left, 1, -1 do
            rev[#rev+1] = left[i]
        end
        left = rev

        --Front
        local tx_offset = left[1].x -0.646
        local ty_offset = left[1].z + 0.649
        for i=1,#left,1 do
            left[i].y = toph
            left[i].tx = (left[i].x - tx_offset)
            left[i].ty = -(left[i].z - ty_offset)
        end

        for i=1,#right,1 do
            right[i].y = toph
            right[i].tx = (right[i].x - tx_offset)
            right[i].ty = -(right[i].z - ty_offset)
        end
        shapes.curve2d.curve_segements(left, right, vector.new(0,1,0,0,0,0,0,0), groups[5], rotations[5])

        --Back
        local tx_offset = right[1].x - 0.354
        local ty_offset = right[1].z + 0.356
        for i=1,#left,1 do
            left[i].y = bottomh
            left[i].tx = left[i].x - tx_offset
            left[i].ty = left[i].z - ty_offset
        end

        for i=1,#right,1 do
            right[i].y = bottomh
            right[i].tx = right[i].x - tx_offset
            right[i].ty = right[i].z - ty_offset
        end

        shapes.curve2d.curve_segements(right, left, vector.new(0,-1,0,0,0,0,0,0), groups[6], rotations[6])

        if name ~= "no_export" then export_mesh(name) end
    end

    curve2_closed(inner,outer,bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
end

-- 1 = top
-- 2 = bottom
-- 3 = right
-- 4 = left
-- 5 = back
-- 6 = front
local groups_D = {4,3,1,2,5,6}
rotations = {3,5,2,4,1,3}
curve_D(-0.50,-0.25, 0.00, 0.25, groups_D, rotations, "models/peak_45_1.obj")
curve_D(-0.50, 0.00, 0.00, 0.50, groups_D, rotations, "models/peak_45_2.obj")
curve_D(-0.50, 0.25, 0.00, 0.75, groups_D, rotations, "models/peak_45_3.obj")
curve_D(-0.50, 0.50, 0.00, 1.00, groups_D, rotations, "models/peak_45.obj")


------------------------------Mesh _D----------------------------
-- Object _D
-- ~0.8 nodes tall, 1 node wide
-- inner arch of of 2 As coming together
--
--       _-^-_
--     _^     ^_
--    /         \
--   /           \
--   |           |
--   +-----------+
--
----------------------------------------------------------------

local arch_curve_D = function(bottomh,toph,bottom_ty,top_ty,groups,rotations,name)
    reset_mesh()
    local magic_number = 0.9694
    local right = points.super_e_curve(math.pi*0/4, magic_number, 5, 1.5, 1, 1, 1.71, 1.71)
    right = p_manip.func(right, function(v) return vector.add(v,vector.multiply(v3(v.nx,0,v.nz), 0.5)) end)
    right = p_manip.add(right, v(-0.5,bottomh,-0.5,0,0,0,0))

    local function calc_tx(seg)
        points.validate_segment(seg)
        local tx = 0.0
        seg[1].tx = tx
        for i=2,#seg,1 do
            tx = tx + vector.distance(seg[i],seg[i-1])
            seg[i].tx = tx
        end
    end
    calc_tx(right)

    local left = p_manip.reverse(p_manip.multiply(right, v(-1,1,1,-1,1,1,1,1)))
    local full_curve = shapes.util.copy(right)
    for i=2,5,1 do
        full_curve[#full_curve+1] = shapes.util.copy(left[i])
    end
    full_curve = p_manip.reverse(full_curve)
    shapes.curve3d.point_curve_open(v3(0.0,bottomh,-0.5), full_curve, bottomh, toph, bottom_ty, top_ty, groups, rotations, "no_export")

    -- Add bottom
    local bl, tl, tr, br = 0,0,0,0
    bl = vector.new(0.5  ,bottomh ,-0.5 ,0  ,0 ,-1  ,0  ,bottom_ty)
    br = vector.new(-0.5 ,bottomh ,-0.5 ,0  ,0 ,-1  ,1  ,bottom_ty)
    tr = vector.new(-0.5 ,toph    ,-0.5 ,0  ,0 ,-1  ,1  ,top_ty)
    tl = vector.new(0.5  ,toph    ,-0.5 ,0  ,0 ,-1  ,0  ,top_ty)
    shapes.common.quad(bl,tl,tr,br,2,1)

    -- Add useless triangle because MT can't skip the first textrue
    shapes.common.tri(bl,tl,tr,1,1)

    
    export_mesh(name)
end

-- 1 = top
-- 2 = bottom
-- 3 = right
-- 4 = left
-- 5 = back
-- 6 = front
local groups_D = {4,3,1,4,5,6}
rotations = {3,5,2,4,1,3}
arch_curve_D(-0.50,-0.25, 0.00, 0.25, groups_D, rotations, "models/inner_peak_45_1.obj")
arch_curve_D(-0.50, 0.00, 0.00, 0.50, groups_D, rotations, "models/inner_peak_45_2.obj")
arch_curve_D(-0.50, 0.25, 0.00, 0.75, groups_D, rotations, "models/inner_peak_45_3.obj")
arch_curve_D(-0.50, 0.50, 0.00, 1.00, groups_D, rotations, "models/inner_peak_45.obj")

------------------------------Mesh Q----------------------------
-- Object Q
-- 45° rectangular prism, centered on standard node origin
--
--                _TL
--             _-   \
--          _-       \
--       _-           \
--    _-               TR
--   BL             _-
--    \          _-
--     \      _-
--      \  _-
--       BR
--
----------------------------------------------------------------
local rect_45 = function(bottomh,toph,name)
    reset_mesh()

    local s = 0.147
    local l = 0.853

    local bl  = vector.new(-l, bottomh, -s, 0, 0, 0, 0, 0)
    local br  = vector.new(-s, bottomh, -l, 0, 0, 0, 0, 0)
    local tl  = vector.new( s, bottomh,  l, 0, 0, 0, 0, 0)
    local tr  = vector.new( l, bottomh,  s, 0, 0, 0, 0, 0)
    local bl2 = vector.new(-l, toph,    -s, 0, 0, 0, 0, 0)
    local br2 = vector.new(-s, toph,    -l, 0, 0, 0, 0, 0)
    local tl2 = vector.new( s, toph,     l, 0, 0, 0, 0, 0)
    local tr2 = vector.new( l, toph,     s, 0, 0, 0, 0, 0)

    -- center the side textures on 0,0, so start at - [sqrt(2) - 1] / 2
    shapes.common.auto_quad(bl2, br2, tr2, tl2, 0, -.207, 4, 4) -- top    - which is a side texture - left   tex
    shapes.common.auto_quad( tr,  br,  bl,  tl, 0, -.207, 3, 1) -- bottom - which is a side texture - right  tex
    shapes.common.auto_quad( bl,  br, br2, bl2, 0, 0.0,   1, 4) -- front  - which is a side texture - top    tex
    shapes.common.auto_quad( tl, tl2, tr2,  tr, 0, 0.0,   2, 1) -- back   - which is a side texture - bottom tex
    shapes.common.auto_quad( tl,  bl, bl2, tl2, 0, 0.0,   5, 3) -- left   - which is a side texture - front  tex
    shapes.common.auto_quad( br,  tr, tr2, br2, 0, 0.0,   6, 3) -- right  - which is a side texture - back   tex

    export_mesh(name)
end

-- 1 = top
-- 2 = bottom
-- 3 = right
-- 4 = left
-- 5 = back
-- 6 = front
rect_45(-0.50,-0.25, "models/connector_angle_1.obj")
rect_45(-0.50, 0.00, "models/connector_angle_2.obj")
rect_45(-0.50, 0.25, "models/connector_angle_3.obj")
rect_45(-0.50, 0.50, "models/connector_angle.obj")

------------------------------Mesh Q----------------------------
-- Object ED
-- 45° rectangular prism smashed into a normal node
--
--        CA------------CB
--        |             |
--       _ML            |
--    _-                |
--   BL                 |
--    \                 |
--     \[CD^    _MR-----CC
--      \    _-
--        BR
--
----------------------------------------------------------------
local end_45 = function(bottomh,toph,name)
    reset_mesh()

    local s = 0.147
    local l = 0.853
    local m = 0.206
    local bl  = vector.new(  -l, bottomh,  -s, 0, 0, 0, 0, 0)
    local br  = vector.new(  -s, bottomh,  -l, 0, 0, 0, 0, 0)
    local bl2 = vector.new(  -l,    toph,  -s, 0, 0, 0, 0, 0)
    local br2 = vector.new(  -s,    toph,  -l, 0, 0, 0, 0, 0)
    local ml  = vector.new(-0.5, bottomh,   m, 0, 0, 0, 0, 0)
    local mr  = vector.new(   m, bottomh,-0.5, 0, 0, 0, 0, 0)
    local ml2 = vector.new(-0.5,    toph,   m, 0, 0, 0, 0, 0)
    local mr2 = vector.new(   m,    toph,-0.5, 0, 0, 0, 0, 0)
    local ca  = vector.new(-0.5, bottomh, 0.5, 0, 0, 0, 0, 0)
    local ca2 = vector.new(-0.5,    toph, 0.5, 0, 0, 0, 0, 0)
    local cb  = vector.new( 0.5, bottomh, 0.5, 0, 0, 0, 0, 0)
    local cb2 = vector.new( 0.5,    toph, 0.5, 0, 0, 0, 0, 0)
    local cc  = vector.new( 0.5, bottomh,-0.5, 0, 0, 0, 0, 0)
    local cc2 = vector.new( 0.5,    toph,-0.5, 0, 0, 0, 0, 0)
    local cd  = vector.new(-0.5, bottomh,-0.5, 0, 0, 0, 0, 0)
    local cd2 = vector.new(-0.5,    toph,-0.5, 0, 0, 0, 0, 0)

    -- center the side textures on 0,0, so start at - [sqrt(2) - 1] / 2
    shapes.common.auto_quad( bl,  br, br2, bl2, 0, 0, 2, 1) -- angled square, bottom
    shapes.common.auto_quad( bl, bl2, ml2,  ml, 0, 0, 4, 1) -- right angle, right
    shapes.common.auto_quad( ca,  ml, ml2, ca2, 0, 0, 4, 1) -- right side, right
    shapes.common.auto_quad( br,  mr, mr2, br2, 0, 0, 3, 1) -- left angle, left
    shapes.common.auto_quad(cc2, mr2,  mr,  cc, 0, 0, 3, 1) -- left angle, left
    shapes.common.auto_quad( cb,  ca, ca2, cb2, 0, 0, 1, 1) -- top side
    shapes.common.auto_quad( cc,  cb, cb2, cc2, 0, 0, 1, 1) -- the other top side
    shapes.common.auto_quad( cd,  ca,  cb,  cc, 0, 0, 5, 1) -- the other top side
    shapes.common.auto_quad(cd2, cc2, cb2, ca2, 0, 0, 6, 1) -- the other top side

    -- four mini triangle sections
    shapes.common.auto_triangle(cd2, ml2, bl2, 0, 0, 6, 4)
    shapes.common.auto_triangle(cd2, br2, mr2, 0, 0, 6, 4)
    shapes.common.auto_triangle( cd,  bl,  ml, 0, 0, 5, 4)
    shapes.common.auto_triangle( cd,  mr,  br, 0, 0, 5, 4)

    export_mesh(name)
end

-- 1 = top
-- 2 = bottom
-- 3 = right
-- 4 = left
-- 5 = back
-- 6 = front
end_45(-0.50,-0.25, "models/connector_end_1.obj")
end_45(-0.50, 0.00, "models/connector_end_2.obj")
end_45(-0.50, 0.25, "models/connector_end_3.obj")
end_45(-0.50, 0.50, "models/connector_end.obj")

------------------------------Mesh P----------------------------
-- Object EW
-- 45° rectangular prism smashed into a normal node
--
--        TLB          TRB
--      /    '.      .'    \
--     /[CA    '.  .'    CB]\
--    /    '     TM     '    \
--   TLA                    TRA
--    -_                    _-
--      '_                _'
--       _LM            RM_
--    _-                    -_
--   BLA                    BRA
--    \    .            .    /
--     \[CD    .'BM'.    CC]/
--      \    .'      '.    /   
--        BLB          BRB
--
----------------------------------------------------------------
local end_4way = function(bottomh,toph,name)
    reset_mesh()

    local s = 0.147
    local l = 0.853
    local m = l - s

    -- corners
    local tla  = vector.new(  -l, bottomh,   s, 0, 0, 0, 0, 0)
    local tla2 = vector.new(  -l,    toph,   s, 0, 0, 0, 0, 0)
    local tlb  = vector.new(  -s, bottomh,   l, 0, 0, 0, 0, 0)
    local tlb2 = vector.new(  -s,    toph,   l, 0, 0, 0, 0, 0)
    local bla  = vector.new(  -l, bottomh,  -s, 0, 0, 0, 0, 0)
    local bla2 = vector.new(  -l,    toph,  -s, 0, 0, 0, 0, 0)
    local blb  = vector.new(  -s, bottomh,  -l, 0, 0, 0, 0, 0)
    local blb2 = vector.new(  -s,    toph,  -l, 0, 0, 0, 0, 0)
    local tra  = vector.new(   l, bottomh,   s, 0, 0, 0, 0, 0)
    local tra2 = vector.new(   l,    toph,   s, 0, 0, 0, 0, 0)
    local trb  = vector.new(   s, bottomh,   l, 0, 0, 0, 0, 0)
    local trb2 = vector.new(   s,    toph,   l, 0, 0, 0, 0, 0)
    local bra  = vector.new(   l, bottomh,  -s, 0, 0, 0, 0, 0)
    local bra2 = vector.new(   l,    toph,  -s, 0, 0, 0, 0, 0)
    local brb  = vector.new(   s, bottomh,  -l, 0, 0, 0, 0, 0)
    local brb2 = vector.new(   s,    toph,  -l, 0, 0, 0, 0, 0)

    -- middle points
    local tm  = vector.new(   0, bottomh,   m, 0, 0, 0, 0, 0)
    local tm2 = vector.new(   0,    toph,   m, 0, 0, 0, 0, 0)
    local rm  = vector.new(   m, bottomh,   0, 0, 0, 0, 0, 0)
    local rm2 = vector.new(   m,    toph,   0, 0, 0, 0, 0, 0)
    local lm  = vector.new(  -m, bottomh,   0, 0, 0, 0, 0, 0)
    local lm2 = vector.new(  -m,    toph,   0, 0, 0, 0, 0, 0)
    local bm  = vector.new(   0, bottomh,  -m, 0, 0, 0, 0, 0)
    local bm2 = vector.new(   0,    toph,  -m, 0, 0, 0, 0, 0)

    -- Normal node corners
    local ca  = vector.new(-0.5, bottomh, 0.5, 0, 0, 0, 0, 0)
    local ca2 = vector.new(-0.5,    toph, 0.5, 0, 0, 0, 0, 0)
    local cb  = vector.new( 0.5, bottomh, 0.5, 0, 0, 0, 0, 0)
    local cb2 = vector.new( 0.5,    toph, 0.5, 0, 0, 0, 0, 0)
    local cc  = vector.new( 0.5, bottomh,-0.5, 0, 0, 0, 0, 0)
    local cc2 = vector.new( 0.5,    toph,-0.5, 0, 0, 0, 0, 0)
    local cd  = vector.new(-0.5, bottomh,-0.5, 0, 0, 0, 0, 0)
    local cd2 = vector.new(-0.5,    toph,-0.5, 0, 0, 0, 0, 0)

    local q = 0.207
    -- Top and bottom plus sign sides
    shapes.common.auto_quad( bla, trb, tra, blb, 0,-q, 3, 1) -- bottom big chunk
    shapes.common.auto_quad(  lm, tla, tlb,  tm, 0, 0, 3, 2) -- bottom side piece
    shapes.common.auto_quad(  rm, bra, brb,  bm, 0, 0, 3, 4) -- bottom side piece2

    shapes.common.auto_quad( bla2, blb2, tra2, trb2,-q, 0, 4, 1) -- top big chunk
    shapes.common.auto_quad(  lm2,  tm2, tlb2, tla2, 0, 0, 4, 4) -- top side piece
    shapes.common.auto_quad(  rm2,  bm2, brb2, bra2, 0, 0, 4, 2) -- top side piece2

    -- The four squares
    shapes.common.auto_quad(  tlb,  tla, tla2, tlb2, 0, 0, 1, 2)
    shapes.common.auto_quad(  trb, trb2, tra2,  tra, 0, 0, 1, 1)
    shapes.common.auto_quad(  blb, blb2, bla2,  bla, 0, 0, 2, 1)
    shapes.common.auto_quad(  brb,  bra, bra2, brb2, 0, 0, 2, 2)

    -- The eight inner corners
    shapes.common.auto_quad(  tlb, tlb2,  tm2,   tm, 0, 0, 6, 1)
    shapes.common.auto_quad(  trb,   tm,  tm2, trb2, 0, 0, 6, 8)
    shapes.common.auto_quad(  blb,   bm,  bm2, blb2, 0, 0, 6, 2)
    shapes.common.auto_quad(  brb, brb2,  bm2,   bm, 0, 0, 6, 5)

    shapes.common.auto_quad(  tla,   lm,  lm2, tla2, 0, 0, 5, 8)
    shapes.common.auto_quad(  bla, bla2,  lm2,   lm, 0, 0, 5, 1)
    shapes.common.auto_quad(  tra, tra2,  rm2,   rm, 0, 0, 5, 5)
    shapes.common.auto_quad(  bra,   rm,  rm2, bra2, 0, 0, 5, 2)

    export_mesh(name)
end

-- 1 = top
-- 2 = bottom
-- 3 = right
-- 4 = left
-- 5 = back
-- 6 = front
end_4way(-0.50,-0.25, "models/connector_all_1.obj")
end_4way(-0.50, 0.00, "models/connector_all_2.obj")
end_4way(-0.50, 0.25, "models/connector_all_3.obj")
end_4way(-0.50, 0.50, "models/connector_all.obj")
