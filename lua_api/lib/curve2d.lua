-- Common Shape Functions
local curve2d = {}

local vector = shapes.vector
local validate_vector = vector.validate_vector
local error = shapes.util.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber
local rotate_vector_uv = shapes.util.rotate_vector_uv

--Single normal used for all pieces, since it's flat
function curve2d.corner_curve_c_clockwise(corner, segments, normal, group, rot)
    ---Validation---
    if not istable(segments) then error("Segements is not a table") end
    if #segments < 2 then error("Segements has fewer than 2 points") end
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    validate_vector(corner)
    if not isnumber(group) then error("4th arg: expected number, got "..type(group)) end
    if not isnumber(rot) then error("5th arg(rotation): expected number, got "..type(group)) end

    local ccorner = rotate_vector_uv(corner, rot)

    ---Creation---
    for i=1,#segments-1,1 do
        local first = segments[i]
        local second = segments[i+1]

        ---Handle Rotation
        local cfirst = rotate_vector_uv(first, rot)
        local csecond = rotate_vector_uv(second, rot)

        add_triangle(
            corner.x, corner.y, corner.z,
            first.x, first.y, first.z,
            second.x, second.y, second.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            ccorner.tx, ccorner.ty,
            cfirst.tx, cfirst.ty,
            csecond.tx, csecond.ty,
            group
        )
    end
end

--Single normal used for all pieces
function curve2d.corner_curve_clockwise(corner, segments, normal, group, rot)
    ---Validation---
    if not istable(segments) then error("Segements is not a table") end
    if #segments < 2 then error("Segements has fewer than 2 points") end
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    validate_vector(corner)
    if not isnumber(group) then error("4th arg: expected number, got "..type(group)) end
    if not isnumber(rot) then error("5th arg(rotation): expected number, got "..type(group)) end

    local ccorner = rotate_vector_uv(corner, rot)
    ---Creation---
    for i=1,#segments-1,1 do
        local first = segments[i]
        local second = segments[i+1]

        ---Handle Rotation
        local cfirst = rotate_vector_uv(first, rot)
        local csecond = rotate_vector_uv(second, rot)

        add_triangle(
            first.x, first.y, first.z,
            corner.x, corner.y, corner.z,
            second.x, second.y, second.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            cfirst.tx, cfirst.ty,
            ccorner.tx, ccorner.ty,
            csecond.tx, csecond.ty,
            group
        )
    end
end

--These segements shouldn't cross... and start at the front and work their way backwards (z to -z)
function curve2d.curve_segements(left_segment, right_segment, normal, group, rot)
    ---Validation---
    local function validate_segments(seg)
        if not istable(seg) then error("Segment is not a table") end
        if #seg < 2 then error("Segment has fewer than 2 points") end
        for i=1,#seg,1 do
            validate_vector(seg[i])
        end
    end
    validate_segments(left_segment)
    validate_segments(right_segment)
    if #left_segment ~= #right_segment then error("Segments must have equal numbers of points") end
    validate_vector(normal)
    if not isnumber(group) then error("4th arg: expected number, got "..type(group)) end
    if not isnumber(rot) then error("5th arg(rotation): expected number, got "..type(group)) end

    ---Creation---
    local tri = shapes.common.tri
    for i=1,#left_segment-1,1 do
        local bl = vector.new(left_segment[i])
        local tl = vector.new(left_segment[i+1])
        local tr = vector.new(right_segment[i+1])
        local br = vector.new(right_segment[i])

        tri(bl,tl,tr,group,rot)
        tri(bl,tr,br,group,rot)
    end
end

function curve2d.wall(segments, height, texHeight, group, rot)
    rot = rot or 1
    ---Validation---
    if not istable(segments) then error("Segements is not a table") end
    if #segments < 2 then error("Segements has fewer than 2 points") end
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    if not isnumber(height) then error("2nd arg: expected number, got "..type(height)) end
    if not isnumber(texHeight) then error("3rd arg: expected number, got "..type(texHeight)) end
    if not isnumber(group) then error("4th arg: expected number, got "..type(group)) end
    if not isnumber(rot) then error("5th arg(rotation): expected number, got "..type(group)) end
    ---Creation---
    local quad = shapes.common.quad
    local function top(v, h, th)
        return vector.new(v.x,v.y+h,v.z,v.nx,v.ny,v.nz,v.tx,v.ty+th)
    end

    for i=1,#segments-1,1 do
        local bl = vector.new(segments[i])
        local br = vector.new(segments[i+1])
        local tl = top(bl, height, texHeight)
        local tr = top(br, height, texHeight)
        
        quad(bl,tl,tr,br,group,rot)
    end
end

function curve2d.wall_only(segments, height, texHeight, group, rot, name)
    if name ~= "no_export" then reset_mesh() end
    ---Validation---
    if not istable(segments) then error("Segements is not a table") end
    if #segments < 2 then error("Segements has fewer than 2 points") end
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    if not isnumber(height) then error("2nd arg: expected number, got "..type(height)) end
    if not isnumber(texHeight) then error("2rd arg: expected number, got "..type(texHeight)) end
    if not isnumber(group) then error("4th arg: expected number, got "..type(group)) end
    if not isnumber(rot) then error("5th arg(rotation): expected number, got "..type(group)) end

    ---Creation---
    local quad = shapes.common.quad
    local function top(v, h, th)
        return vector.new(v.x,v.y+h,v.z,v.nx,v.ny,v.nz,v.tx,v.ty+th)
    end

    for i=1,#segments-1,1 do
        local bl = vector.new(segments[i])
        local br = vector.new(segments[i+1])
        local tl = top(bl, height, texHeight)
        local tr = top(br, height, texHeight)
        
        quad(bl,tl,tr,br,group,rot)
    end
    if name ~= "no_export" then export_mesh(name) end
end

return curve2d