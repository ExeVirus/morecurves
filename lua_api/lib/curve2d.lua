-- Common Shape Functions
local curve2d = {}

local vector = shapes.vector
local validate_vector = vector.validate_vector
local error = shapes.util.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber

--Single normal used for all pieces
function curve2d.corner_curve_c_clockwise(corner, segments, normal, group)
    ---Validation---
    if not istable(segments) then error("Segements is not a table") end
    if #segments < 2 then error("Segements has fewer than 2 points") end
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    validate_vector(corner)
    if not isnumber(group) then error("4th arg: expected number, got "..type(group)) end
    ---Creation---
    for i=1,#segments-1,1 do
        local first = segments[i]
        local second = segments[i+1]
        add_triangle(
            corner.x, corner.y, corner.z,
            first.x, first.y, first.z,
            second.x, second.y, second.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            corner.tx, corner.ty,
            first.tx, first.ty,
            second.tx, second.ty,
            group
        )
    end
end

--Single normal used for all pieces
function curve2d.corner_curve_clockwise(corner, segments, normal, group)
    ---Validation---
    if not istable(segments) then error("Segements is not a table") end
    if #segments < 2 then error("Segements has fewer than 2 points") end
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    validate_vector(corner)
    if not isnumber(group) then error("4th arg: expected number, got "..type(group)) end
    ---Creation---
    for i=1,#segments-1,1 do
        local first = segments[i]
        local second = segments[i+1]
        add_triangle(
            first.x, first.y, first.z,
            corner.x, corner.y, corner.z,
            second.x, second.y, second.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            normal.x, normal.y, normal.z,
            first.tx, first.ty,
            corner.tx, corner.ty,
            second.tx, second.ty,
            group
        )
    end
end

--These segements shouldn't cross... and start at the front and work their way backwards (z to -z)
function curve2d.curve_segements(left_segment, right_segment, normal, group)
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
    ---Creation---
    local tri = shapes.common.tri
    for i=1,#left_segment-1,1 do
        local bl = vector.new(left_segment[i])
        local tl = vector.new(left_segment[i+1])
        local tr = vector.new(right_segment[i+1])
        local br = vector.new(right_segment[i])
        tri(bl,tl,tr,group)
        tri(bl,tr,br,group)
    end

    
end

function curve2d.wall(segments, height, texHeight, group)
    ---Validation---
    if not istable(segments) then error("Segements is not a table") end
    if #segments < 2 then error("Segements has fewer than 2 points") end
    for i=1,#segments,1 do
        validate_vector(segments[i])
    end
    if not isnumber(height) then error("2nd arg: expected number, got "..type(height)) end
    if not isnumber(texHeight) then error("2nd arg: expected number, got "..type(texHeight)) end
    if not isnumber(group) then error("3rd arg: expected number, got "..type(group)) end
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
        
        quad(bl,tl,tr,br,group)
    end
end

return curve2d