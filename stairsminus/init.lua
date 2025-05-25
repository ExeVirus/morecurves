--[[
More Blocks: Stairs+

Copyright © 2011-2020 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

-- Nodes will be called <modname>:{stair,slab,panel,micro,slope}_<subname>

local modpath = minetest.get_modpath("morecurves").. "/stairsminus"

stairsminus = {}
stairsminus.expect_infinite_stacks = false

stairsminus.shapes_list = {}

if
	not minetest.get_modpath("unified_inventory")
	and minetest.settings:get_bool("creative_mode")
then
	stairsminus.expect_infinite_stacks = true
end

function stairsminus:prepare_groups(groups)
	local result = {}
	if groups then
		for k, v in pairs(groups) do
			if k ~= "wood" and k ~= "stone" and k ~= "wool" and k ~= "tree" then
				result[k] = v
			end
		end
	end
	if not moreblocks.config.stairsminus_in_creative_inventory then
		result.not_in_creative_inventory = 1
	end
	return result
end

function stairsminus:register_all(modname, subname, recipeitem, fields)
	self:register_micro(modname, subname, recipeitem, fields)
end

function stairsminus:register_alias_all(modname_old, subname_old, modname_new, subname_new)
	self:register_micro_alias(modname_old, subname_old, modname_new, subname_new)
end
function stairsminus:register_alias_force_all(modname_old, subname_old, modname_new, subname_new)
	self:register_micro_alias_force(modname_old, subname_old, modname_new, subname_new)
end

-- luacheck: no unused
local function register_stair_slab_panel_micro(modname, subname, recipeitem, groups, images, description, drop, light)
	stairsminus:register_all(modname, subname, recipeitem, {
		groups = groups,
		tiles = images,
		description = description,
		drop = drop,
		light_source = light
	})
end

dofile(modpath .. "/defs.lua")
dofile(modpath .. "/common.lua")
dofile(modpath .. "/microblocks.lua")
dofile(modpath .. "/registrations.lua")
