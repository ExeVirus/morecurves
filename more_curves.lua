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
------------------------------Mesh A----------------------------
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
shapes.curve3d.curve2_closed(inner, outer, -0.50,-0.25, 0.00, 0.25,groupsA,rotationsA,"models/a_1.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.00, 0.00, 0.50,groupsA,rotationsA,"models/a_2.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.25, 0.00, 0.75,groupsA,rotationsA,"models/a_3.obj")
shapes.curve3d.curve2_closed(inner, outer, -0.50, 0.50, 0.00, 1.00,groupsA,rotationsA,"models/a_4.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50,-0.25, 0.00, 0.25,groupsA,_rotationsA,"models/a_1r.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50, 0.00, 0.00, 0.50,groupsA,_rotationsA,"models/a_2r.obj")
shapes.curve3d.curve2_closed(rev_inner, rev_outer, -0.50, 0.25, 0.00, 0.75,groupsA,_rotationsA,"models/a_3r.obj")

----------------------------------------------------------------
------------------------------Mesh B----------------------------
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
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50,-0.25, 0.00, 0.25, groups_b, rotations, "models/b_1.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.00, 0.00, 0.50, groups_b, rotations, "models/b_2.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.25, 0.00, 0.75, groups_b, rotations, "models/b_3.obj")
shapes.curve3d.point_curve_closed(v3(-0.5,-0.5,0.5), curve, -0.50, 0.50, 0.00, 1.00, groups_b, rotations, "models/b_4.obj")

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
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50,-0.25, 0.00, 0.25, groups__b, rotations, "models/_b_1.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.00, 0.00, 0.50, groups__b, rotations, "models/_b_2.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.25, 0.00, 0.75, groups__b, rotations, "models/_b_3.obj")
shapes.curve3d.point_curve_closed(v3(0.5,-0.5,-0.5), curve, -0.50, 0.50, 0.00, 1.00, groups__b, rotations, "models/_b_4.obj")

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
curve_A1(-0.50,-0.25, 0.00, 0.25, groups_a1, rotations, "models/a1_1.obj")
curve_A1(-0.50, 0.00, 0.00, 0.50, groups_a1, rotations, "models/a1_2.obj")
curve_A1(-0.50, 0.25, 0.00, 0.75, groups_a1, rotations, "models/a1_3.obj")
curve_A1(-0.50, 0.50, 0.00, 1.00, groups_a1, rotations, "models/a1_4.obj")

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
curve_A2(-0.50,-0.25, 0.00, 0.25, groups_a2, rotations, "models/a2_1.obj")
curve_A2(-0.50, 0.00, 0.00, 0.50, groups_a2, rotations, "models/a2_2.obj")
curve_A2(-0.50, 0.25, 0.00, 0.75, groups_a2, rotations, "models/a2_3.obj")
curve_A2(-0.50, 0.50, 0.00, 1.00, groups_a2, rotations, "models/a2_4.obj")

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
curve_A2R(-0.50,-0.25, 0.00, 0.25, groups_a2r, rotations, "models/a2_1r.obj")
curve_A2R(-0.50, 0.00, 0.00, 0.50, groups_a2r, rotations, "models/a2_2r.obj")
curve_A2R(-0.50, 0.25, 0.00, 0.75, groups_a2r, rotations, "models/a2_3r.obj")

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
curve_AF(-0.50,-0.25, 0.00, 0.25,groups_af,rotations,"models/af_1.obj")
curve_AF(-0.50, 0.00, 0.00, 0.50,groups_af,rotations, "models/af_2.obj")
curve_AF(-0.50, 0.25, 0.25, 0.75,groups_af,rotations, "models/af_3.obj")
curve_AF(-0.50, 0.50, 0.00, 1.00,groups_af,rotations, "models/af_4.obj")

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
curve_C(-0.50,-0.25, 0.00, 0.25, groups_C, rotations, "models/c_1.obj")
curve_C(-0.50, 0.00, 0.00, 0.50, groups_C, rotations, "models/c_2.obj")
curve_C(-0.50, 0.25, 0.00, 0.75, groups_C, rotations, "models/c_3.obj")
curve_C(-0.50, 0.50, 0.00, 1.00, groups_C, rotations, "models/c_4.obj")

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
curve_CR(-0.50,-0.25, 0.00, 0.25, groups_CR, rotations, "models/c_1r.obj")
curve_CR(-0.50, 0.00, 0.00, 0.50, groups_CR, rotations, "models/c_2r.obj")
curve_CR(-0.50, 0.25, 0.00, 0.75, groups_CR, rotations, "models/c_3r.obj")

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
curve_C1(-0.50,-0.25, 0.00, 0.25, groups_C1, rotations, "models/c1_1.obj")
curve_C1(-0.50, 0.00, 0.00, 0.50, groups_C1, rotations, "models/c1_2.obj")
curve_C1(-0.50, 0.25, 0.00, 0.75, groups_C1, rotations, "models/c1_3.obj")
curve_C1(-0.50, 0.50, 0.00, 1.00, groups_C1, rotations, "models/c1_4.obj")

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
curve_C1R(-0.50,-0.25, 0.00, 0.25, groups_C1R, rotations, "models/c1_1r.obj")
curve_C1R(-0.50, 0.00, 0.00, 0.50, groups_C1R, rotations, "models/c1_2r.obj")
curve_C1R(-0.50, 0.25, 0.00, 0.75, groups_C1R, rotations, "models/c1_3r.obj")

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