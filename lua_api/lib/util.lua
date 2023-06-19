local util = {}

function util.copy(orig)
    local orig_type = type(orig)
    local copyit
    if orig_type == 'table' then
        copyit = {}
        for orig_key, orig_value in next, orig, nil do
            copyit[util.copy(orig_key)] = util.copy(orig_value)
        end
        setmetatable(copyit, util.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copyit = orig
    end
    return copyit
end

util.inspect = dofile("lua_api/lib/inspect.lua")

function util.error(string)
    print(debug.traceback())
    error("---->" .. string)
end

function util.istable(v)
    return type(v) == "table"
end

function util.isnumber(v)
    return type(v) == "number"
end

function util.isstring(v)
    return type(v) == "string"
end

function util.validnumber(v,noun)
    if not util.isnumber(v) then util.error("Provided "..noun.." is a "..type(v)..", not a number. ") end
end

function util.validstring(v,noun)
    if not util.isstring(v) then util.error("Provided "..noun.." is a "..type(v)..", not a string. ") end
end

function util.round(val,precision)
    return val>=0 and math.floor(val*math.pow(10,precision)+0.5)/math.pow(10,precision) or math.ceil(val*math.pow(10,precision)-0.5)/math.pow(10,precision)
end

-- x' = (x)cos(rot°) - (y)sin(rot°)
-- y' = (y)cos(rot°) + (x)sin(rot°)
-- always rotate UV's around 0.5,0.5 - which is the origin for them
function util.rotate_uv(tx, ty, rot)
    rot = rot or 1
    if rot > 4 then -- Flip Horizontally around 0.5
        rot = rot - 4
        tx = 1 - tx
    end

    --Rotate around 0.5,0.5. Add that offset first
    tx = tx + 0.5
    ty = ty + 0.5

    -- Now actually rotate
    local tempx, tempy = tx, ty
    if rot == 1 then -- 0
    -- do nothing
    elseif rot == 2 then -- 90
        tempx = - ty
        tempy = tx
    elseif rot == 3 then -- 180
        tempx = - tx
        tempy = - ty
    else --270
        tempx = ty
        tempy = - tx
    end

    -- subtract the offset now that rotation is done
    tempx = tempx - 0.5
    tempy = tempy - 0.5

    return tempx, tempy
end

function util.rotate_vector_uv(v,rot)
    if not util.istable(v) then util.error("vector wasn't a vector.") end
    local cv = util.copy(v)
    cv.tx, cv.ty = util.rotate_uv(cv.tx, cv.ty, rot)
    return cv
end

return util