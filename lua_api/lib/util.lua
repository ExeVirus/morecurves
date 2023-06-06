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

return util