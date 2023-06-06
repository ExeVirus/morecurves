local vector = {}
--Localizations
local validate = shapes.validate
local copy = shapes.util.copy
local error = shapes.util.error
local istable = shapes.util.istable
local isnumber = shapes.util.isnumber

math.hypot = function(x,y)
    return math.sqrt(math.pow(x,2) + math.pow(y,2))
end

function vector.validate_vector(v)
    --check type
    if not istable(v) then error("vertex is not a table.") end

    v.x = v.x or 0
    v.y = v.y or 0
    v.z = v.z or 0
    v.nx = v.nx or 0
    v.ny = v.ny or 0
    v.nz = v.nz or 0
    v.tx = v.tx or 0
    v.ty = v.ty or 0

    --check all are numeric types and number of variables
    local count = 0
    for var,val in pairs(v) do
        if not isnumber(val) then error(var .. " is not a number") end
        count = count + 1
    end
    if count ~= 8 then error("vertex table doesn't contain exactly x, y, z, nx, ny, nz, tx, and ty variables") end
    
    return true
end

local validate_vector = vector.validate_vector

function vector.new(x,y,z,nx,ny,nz,tx,ty)
    if istable(x) then
        local v = copy(x)
        validate_vector(v)
        return v
    else 
        return {x=x,y=y,z=z,nx=nx,ny=ny,nz=nz,tx=tx,ty=ty}
    end
end

function vector.dump(v)
    local r = function(val) return string.format("%.3f",shapes.util.round(val,3)) end
    validate_vector(v)
    print("("..r(v.x)..","..r(v.y)..","..r(v.z)..") ".."("..r(v.nx)..","..r(v.ny)..","..r(v.nz)..") ".."("..r(v.tx)..","..r(v.ty)..")")
end

function vector.equals(a, b)
    validate_vector(a)
    validate_vector(b)
    return a.x == b.x and a.y == b.y and a.z == b.z and
        a.nx == b.nx and a.ny == b.ny and a.nz == b.nz and
        a.tx == b.tx and a.ty == b.ty
end

function vector.length(v)
    validate_vector(v)
	return math.hypot(v.x, math.hypot(v.y, v.z)), math.hypot(v.nx, math.hypot(v.ny, v.nz)), math.hypot(v.tx, v.ty)
end

function vector.normalize(v)
	local len, len_n, len_t = vector.length(v) --validates for us
    local r = vector.new(v)
    r.x = (len == 0) and 0 or r.x / len
    r.y = (len == 0) and 0 or r.y / len
    r.z = (len == 0) and 0 or r.z / len
    r.nx = (len_n == 0) and 0 or r.nx / len_n
    r.ny = (len_n == 0) and 0 or r.ny / len_n
    r.nz = (len_n == 0) and 0 or r.nz / len_n
    r.tx = (len_t == 0) and 0 or r.tx / len_t
    r.ty = (len_t == 0) and 0 or r.ty / len_t
    return r
end

function vector.floor(v)
    local r = vector.new(v)
    for _,val in pairs(r) do
        val = math.floor(val)
    end
    return r
end

function vector.round(v)
    local r = vector.new(v)
    for _,val in pairs(r) do
        val = math.round(val)
    end
    return r
end

function vector.apply(v, func)
    local r = vector.new(v)
    for _,val in pairs(r) do
        val = func(val)
    end
    return r
end

function vector.distance(a, b)
	local v = vector.subtract(a,b)
	return vector.length(v)
end

function vector.direction(pos1, pos2)
    local v = vector.subtract(pos2,pos1)
    return vector.normalize(v)
end

function vector.angle(a, b)
	local dotp = vector.dot(a, b)
	local cp = vector.cross(a, b)
	local crossplen = vector.length(cp)
	return math.atan2(crossplen, dotp)
end

function vector.dot(a, b)
    validate_vector(a)
    validate_vector(b)
	return a.x * b.x + a.y * b.y + a.z * b.z,
        a.nx * b.nx + a.ny * b.ny + a.nz * b.nz,
        a.tx * b.tx + a.ty * b.ty
end

function vector.cross(a, b)
    validate_vector(a)
    validate_vector(b)
	return {
		x = a.y * b.z - a.z * b.y,
		y = a.z * b.x - a.x * b.z,
		z = a.x * b.y - a.y * b.x,
        nx = a.ny * b.z - a.z * b.y,
		ny = a.nz * b.x - a.x * b.z,
		nz = a.nx * b.y - a.y * b.x,
        tx = 0,
		ty = 0
	}
end

function vector.add(a, b)
    local r = vector.new(a)
	if istable(b) then
        validate_vector(b)
        for var,val in pairs(r) do
            r[var] = val + b[var]
        end
	elseif isnumber(b) then
        for var,val in pairs(r) do
            r[var] = val + b
        end
	else
        error("argument 2: expected number or table, got " .. type(b))
    end
    return r
end

function vector.subtract(a, b)
    local r = vector.new(a)
	if istable(b) then
        validate_vector(b)
        for var,val in pairs(r) do
            r[var] = val - b[var]
        end
	elseif isnumber(b) then
        for var,val in pairs(r) do
            r[var] = val - b
        end
	else
        error("argument 2: expected number or table, got " .. type(b))
    end
    return r
end

function vector.multiply(a, b)
    local r = vector.new(a)
	if istable(b) then
        validate_vector(b)
        for var,val in pairs(r) do
            r[var] = val * b[var]
        end
	elseif isnumber(b) then
        for var,val in pairs(r) do
            r[var] = val * b
        end
	else
        error("argument 2: expected number or table, got " .. type(b))
    end
    return r
end

function vector.divide(a, b)
    local r = vector.new(a)
	if istable(b) then
        validate_vector(b)
        for var,val in airs(r) do
            r[var] = val / b[var]
        end
	elseif isnumber(b) then
        for var,val in pairs(r) do
            r[var] = val / b
        end
	else
        error("argument 2: expected number or table, got " .. type(b))
    end
    return r
end

function vector.determinant(a,b,c)
    validate_vector(a)
    validate_vector(b)
    validate_vector(c)
    return (a.x*(b.y*c.z-b.z*c.y)-a.y*(b.x*c.z-b.z*c.x)+a.z*(b.x*c.y-b.y*c.x))
end

local function sin(x)
	if x % math.pi == 0 then
		return 0
	else
		return math.sin(x)
	end
end

local function cos(x)
	if x % math.pi == math.pi / 2 then
		return 0
	else
		return math.cos(x)
	end
end

function vector.rotate_around_axis(v, axis, angle)
    validate_vector(v)
	local cosangle = cos(angle)
	local sinangle = sin(angle)
	axis = vector.normalize(axis)
	-- https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
	local dot_axis = vector.multiply(axis, vector.dot(axis, v))
	local cross = vector.cross(v, axis)
	return vector.new(
		cross.x * sinangle + (v.x - dot_axis.x) * cosangle + dot_axis.x,
		cross.y * sinangle + (v.y - dot_axis.y) * cosangle + dot_axis.y,
		cross.z * sinangle + (v.z - dot_axis.z) * cosangle + dot_axis.z,
        cross.nx * sinangle + (v.nx - dot_axis.nx) * cosangle + dot_axis.nx,
		cross.ny * sinangle + (v.ny - dot_axis.ny) * cosangle + dot_axis.ny,
		cross.nz * sinangle + (v.nz - dot_axis.nz) * cosangle + dot_axis.nz,
        v.tx,
        v.ty
	)
end

function vector.rotate(v, rot)
	local sinpitch = sin(-rot.x)
	local sinyaw = sin(-rot.y)
	local sinroll = sin(-rot.z)
	local cospitch = cos(rot.x)
	local cosyaw = cos(rot.y)
	local cosroll = math.cos(rot.z)
	-- Rotation matrix that applies yaw, pitch and roll
	local matrix = {
		{
			sinyaw * sinpitch * sinroll + cosyaw * cosroll,
			sinyaw * sinpitch * cosroll - cosyaw * sinroll,
			sinyaw * cospitch,
		},
		{
			cospitch * sinroll,
			cospitch * cosroll,
			-sinpitch,
		},
		{
			cosyaw * sinpitch * sinroll - sinyaw * cosroll,
			cosyaw * sinpitch * cosroll + sinyaw * sinroll,
			cosyaw * cospitch,
		},
	}
	-- Compute matrix multiplication: `matrix` * `v`
	return vector.new(
		matrix[1][1] * v.x + matrix[1][2] * v.y + matrix[1][3] * v.z,
		matrix[2][1] * v.x + matrix[2][2] * v.y + matrix[2][3] * v.z,
		matrix[3][1] * v.x + matrix[3][2] * v.y + matrix[3][3] * v.z,
        matrix[1][1] * v.nx + matrix[1][2] * v.ny + matrix[1][3] * v.nz,
		matrix[2][1] * v.nx + matrix[2][2] * v.ny + matrix[2][3] * v.nz,
		matrix[3][1] * v.nx + matrix[3][2] * v.ny + matrix[3][3] * v.nz,
        v.tx,
        v.ty
	)
end

return vector