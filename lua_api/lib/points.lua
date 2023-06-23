local points = {}

local vector = shapes.vector
local validate_vector = vector.validate_vector
local error = shapes.util.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber

function points.superellipse_polar_point(theta, radius, a, b, m, n)
    --(a, 0)
    local c = math.cos(theta)
    local d = math.sin(theta)
    local x = a * math.pow( math.abs( c ), 2 / m ) * radius
    -- a = 1, b = 1, 
    if c < 0 then
        x = -x
    end
    local y = b * math.pow( math.abs( d ), 2 / n ) * radius
    if d < 0 then
        y = -y
    end
    return x,y
end

function points.super_e_curve(starting_theta, ending_theta, precision, radius, a, b, m, n)
    ---Validate---
    if not isnumber(starting_theta) then error("arg1: Expected number, got "..type(starting_theta)) end
    if not isnumber(ending_theta) then error("arg2: Expected number, got "..type(ending_theta)) end
    if not isnumber(precision) then error("arg3: Expected number, got "..type(precision)) end
    if not isnumber(radius) then error("arg4: Expected number, got "..type(radius)) end
    if not isnumber(a) then error("arg5: Expected number, got "..type(a)) end
    if not isnumber(b) then error("arg6: Expected number, got "..type(b)) end
    if not isnumber(m) then error("arg7: Expected number, got "..type(m)) end
    if not isnumber(n) then error("arg8: Expected number, got "..type(n)) end
    ---Create---
    local sep = points.superellipse_polar_point

    local function v2(x,z)
        local function v(x,z)
            return vector.new(x,0,z,0,0,0,0,0)
        end
        local n = vector.multiply(vector.normalize(v(x,z)),-1)
        return vector.new(x,0,z,n.x,0,n.z,0,0)
    end

    local segment = {}
    for theta=starting_theta, ending_theta, (ending_theta-starting_theta)/(precision-1) do
        table.insert(segment,v2(sep(theta, radius, a, b, m, n)))
    end
    return segment
end

function points.validate_segment(segment)
    if not istable(segment) then error("Segment is not a table") end
    if #segment < 2 then error("Segment has less than 2 vectors") end
    for i=1, #segment do
        validate_vector(segment[i])
    end
end

return points