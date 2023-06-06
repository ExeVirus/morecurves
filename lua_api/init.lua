--Lua Api for MoreShapes, see readme.adoc in this folder

--api table
shapes = {}

-- utility functions
shapes.util = dofile("lua_api/lib/util.lua")

-- vector math lib
shapes.vector = dofile("lua_api/lib/vector.lua")

-- Cube, quad, etc
shapes.common = dofile("lua_api/lib/common.lua")

-- superellipse stuff
shapes.points = dofile("lua_api/lib/points.lua")

-- offset, rotation, mirror, length etc.
shapes.p_manip = dofile("lua_api/lib/p_manip.lua")

-- 1curve, 2curve, etc.
shapes.curve2d = dofile("lua_api/lib/curve2d.lua")

-- what our shapes are made of 
shapes.curve3d = dofile("lua_api/lib/curve3d.lua")