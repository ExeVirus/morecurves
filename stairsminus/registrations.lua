--[[
More Blocks: registrations

Copyright © 2011-2020 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]
local S = moreblocks.S
-- default registrations
if core.get_modpath("default") then
	local default_nodes = { -- Default stairs/slabs/panels/microblocks:
		"stone",
		"stone_block",
		"cobble",
		"mossycobble",
		"brick",
		"sandstone",
		"steelblock",
		"goldblock",
		"copperblock",
		"bronzeblock",
		"diamondblock",
		"tinblock",
		"desert_stone",
		"desert_stone_block",
		"desert_cobble",
		"meselamp",
		"glass",
		"tree",
		"wood",
		"jungletree",
		"junglewood",
		"pine_tree",
		"pine_wood",
		"acacia_tree",
		"acacia_wood",
		"aspen_tree",
		"aspen_wood",
		"obsidian",
		"obsidian_block",
		"obsidianbrick",
		"obsidian_glass",
		"stonebrick",
		"desert_stonebrick",
		"sandstonebrick",
		"silver_sandstone",
		"silver_sandstone_brick",
		"silver_sandstone_block",
		"desert_sandstone",
		"desert_sandstone_brick",
		"desert_sandstone_block",
		"sandstone_block",
		"coral_skeleton",
		"ice",
	}

	for _, name in pairs(default_nodes) do
		local mod = "default"
		local nodename = mod .. ":" .. name
		local ndef = table.copy(core.registered_nodes[nodename])
		ndef.sunlight_propagates = true

		-- Stone and desert_stone drop cobble and desert_cobble respectively.
		if type(ndef.drop) == "string" then
			ndef.drop = ndef.drop:gsub(".+:", "")
		end

		-- Use the primary tile for all sides of cut glasslike nodes and disregard paramtype2.
		if #ndef.tiles > 1 and ndef.drawtype and ndef.drawtype:find("glass") then
			ndef.tiles = {ndef.tiles[1]}
			ndef.paramtype2 = nil
		end

		mod = "moreblocks"
		stairsminus:register_all(mod, name, nodename, ndef)
	end
end

-- farming registrations
if core.get_modpath("farming") then
	local farming_nodes = {"straw"}
	for _, name in pairs(farming_nodes) do
		local mod = "farming"
		local nodename = mod .. ":" .. name
		local ndef = table.copy(core.registered_nodes[nodename])
		ndef.sunlight_propagates = true

		mod = "moreblocks"
		stairsminus:register_all(mod, name, nodename, ndef)
	end
end

-- wool registrations
if core.get_modpath("wool") then
	local dyes = {"white", "grey", "black", "red", "yellow", "green", "cyan",
	              "blue", "magenta", "orange", "violet", "brown", "pink",
	              "dark_grey", "dark_green"}
	for _, name in pairs(dyes) do
		local mod = "wool"
		local nodename = mod .. ":" .. name
		local ndef = table.copy(core.registered_nodes[nodename])
		ndef.sunlight_propagates = true

		stairsminus:register_all(mod, name, nodename, ndef)
	end
end