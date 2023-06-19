-- Common Shape Functions
local curve3d = {}

local vector = shapes.vector
local validate_vector = vector.validate_vector
local error = shapes.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber
local validnumber = shapes.util.validnumber
local validstring = shapes.util.validstring
local validate_segment = shapes.points.validate_segment

function curve3d.curve2_closed(left_in, right_in, bottomh, toph, bottom_ty, top_ty, groups, rotations, name)
    rotations = rotations or {1,1,1,1,1,1}
    groups = groups or {3,4,5,6,1,2}
    validate_segment(left_in)
    validate_segment(right_in)
    validnumber(bottomh)
    validnumber(toph)
    validnumber(bottom_ty)
    validnumber(top_ty)
    validstring(name, "name")
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
    local tx_offset = left[1].x
    local ty_offset = left[1].z
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
    local tx_offset = right[1].x
    local ty_offset = right[1].z
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

function curve3d.point_curve_open(left_point_in, right_in, bottomh, toph, bottom_ty, top_ty, groups, rotations, name)
    groups = groups or {1,2,3,4,5,6}
    rotations = rotations or {1,1,1,1,1,1}
    validate_vector(left_point_in, "left_point_in")
    validate_segment(right_in, "right_in")
    validnumber(bottomh, "bottomh")
    validnumber(toph, "toph")
    validnumber(bottom_ty, "bottom_ty")
    validnumber(top_ty, "top_ty")
    validstring(name, "name")
    if name ~= "no_export" then reset_mesh() end
    local left = shapes.util.copy(left_point_in)
    local right = shapes.util.copy(right_in)

    --Outer Curve
    shapes.curve2d.wall(right, toph-bottomh, top_ty, groups[4], rotations[4])

    --Top
    local tx_offset = left.x
    local ty_offset = left.z
    left.y = toph

    for i=1,#right,1 do
        right[i].y = toph
        right[i].tx = right[i].x - tx_offset
        right[i].ty = right[i].z - ty_offset
    end

    shapes.curve2d.corner_curve_c_clockwise(left, right, vector.new(0,1,0,0,0,0,0,0), groups[1], rotations[1])

    --Bottom
    left.y = bottomh

    for i=1,#right,1 do
        right[i].y = bottomh
    end

    shapes.curve2d.corner_curve_clockwise(left, right, vector.new(0,-1,0,0,0,0,0,0), groups[2], rotations[2])

    if name ~= "no_export" then export_mesh(name) end
end

function curve3d.point_curve_closed(left_point_in, right_in, bottomh, toph, bottom_ty, top_ty, groups, rotations, name)
    rotations = rotations or {1,1,1,1,1,1}
    groups = groups or {1,2,3,4,5,6}
    if name ~= "no_export" then reset_mesh() end
    curve3d.point_curve_open(left_point_in, right_in, bottomh, toph, bottom_ty, top_ty, groups, rotations, "no_export")
    local left = shapes.util.copy(left_point_in)
    local right = shapes.util.copy(right_in)

    --Front and Back
    local bl, tl, tr, br = 0,0,0,0
    bl = vector.new(left.x,bottomh,left.z,0,0,0,0,bottom_ty)
    br = vector.new(right[1].x,bottomh,right[1].z,0,0,0,1,bottom_ty)
    tr = vector.new(br); tr.y = toph; tr.ty = top_ty
    tl = vector.new(bl); tl.y = toph; tl.ty = top_ty
    shapes.common.quad(bl,tl,tr,br,groups[5], rotations[5])

    bl = vector.new(right[#right].x,bottomh,right[#right].z,0,0,0,0,bottom_ty)
    br = vector.new(left.x,bottomh,left.z,0,0,0,1,bottom_ty)
    tr = shapes.vector.new(br); tr.y = toph; tr.ty = top_ty
    tl = shapes.vector.new(bl); tl.y = toph; tl.ty = top_ty
    shapes.common.quad(bl,tl,tr,br,groups[6], rotations[6])

    if name ~= "no_export" then export_mesh(name) end
    print(shapes.util.inspect(groups))
    print(shapes.util.inspect(rotations))
end

return curve3d