local p_manip = {}

local vector = shapes.vector
local validate_vector = vector.validate_vector
local validate_segment = shapes.points.validate_segment
local error = shapes.util.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber
local copy = shapes.util.copy

--for loop syntactical sugar
function p_manip.func(segment, func)
    validate_segment(segment)
    local fun = {}
    if type(func) ~= "function" then error("func must be a function, that takes a vector") end
    for i=1,#segment,1 do
        fun[i] = func(segment[i])
    end
    return fun
end

--dump
function p_manip.dump(segment)
    p_manip.func(segment, function(v) vector.dump(v) end)
end

--add
function p_manip.add(segment, add)
    validate_segment(segment)
    validate_vector(add)
    return p_manip.func(segment, function(v) return vector.add(v, add) end)
end

--multiply
function p_manip.multiply(segment, mul)
    validate_segment(segment)
    validate_vector(mul)
    return p_manip.func(segment, function(v) return vector.multiply(v, mul) end)
end

--mirror_x
function p_manip.mirror_x(segment)
    validate_segment(segment)
    return p_manip.func(segment, function(v) return vector.multiply(v, vector.new(-1,1,1,1,1,1,1,1)) end)
end

--mirror_z
function p_manip.mirror_z(segment)
    validate_segment(segment)
    return p_manip.func(segment, function(v) return vector.multiply(v, vector.new(1,1,-1,1,1,1,1,1)) end)
end

--reverse
function p_manip.reverse(segment)
    validate_segment(segment)
    local reverse = {}
    for i=1,#segment, 1 do
        reverse[#segment-i+1] = copy(segment[i])
    end
    return reverse
end

return p_manip