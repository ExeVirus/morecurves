--[[
More Blocks: registrations

Copyright © 2011-2020 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]
local S = morecurves.S

-- default registrations (Minetest Game)
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
		if core.registered_nodes[nodename] then
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
end

-- mcl_core registrations (Mineclonia / MineClone2 / VoxeLibre)
if core.get_modpath("mcl_core") then
	local mcl_nodes = {
		"stone",
		"granite",
		"diorite",
		"andesite",
		"granite_smooth",
		"diorite_smooth",
		"andesite_smooth",
		"cobble",
		"mossycobble",
		"brick",
		"stonebrick",
		"mossy_stonebrick",
		"cracked_stonebrick",
		"carved_stonebrick",
		"sandstone",
		"sandstone_smooth",
		"sandstone_carved",
		"redsandstone",
		"redsandstone_smooth",
		"redsandstone_carved",
		"wood",
		"sprucewood",
		"birchwood",
		"junglewood",
		"acaciawood",
		"darkwood",
		"tree",
		"sprucetree",
		"birchtree",
		"jungletree",
		"acaciatree",
		"darktree",
		"obsidian",
		"glass",
		"ice",
		"packed_ice",
		"goldblock",
		"ironblock",
		"diamondblock",
		"emeraldblock",
		"lapisblock",
		"coalblock",
	}

	for _, name in pairs(mcl_nodes) do
		local nodename = "mcl_core:" .. name
		if core.registered_nodes[nodename] then
			local ndef = table.copy(core.registered_nodes[nodename])
			ndef.sunlight_propagates = true

			if type(ndef.drop) == "string" then
				ndef.drop = ndef.drop:gsub(".+:", "")
			end

			if #ndef.tiles > 1 and ndef.drawtype and ndef.drawtype:find("glass") then
				ndef.tiles = {ndef.tiles[1]}
				ndef.paramtype2 = nil
			end

			stairsminus:register_all("moreblocks", name, nodename, ndef)
		end
	end
end

if core.get_modpath("mcl_deepslate") then
	local deepslate_nodes = {
		"deepslate",
		"cobbled_deepslate",
		"deepslate_bricks",
		"deepslate_tiles",
		"polished_deepslate",
	}

	for _, name in pairs(deepslate_nodes) do
		local nodename = "mcl_deepslate:" .. name
		if core.registered_nodes[nodename] then
			local ndef = table.copy(core.registered_nodes[nodename])
			ndef.sunlight_propagates = true
			stairsminus:register_all("moreblocks", name, nodename, ndef)
		end
	end
end

if core.get_modpath("mcl_nether") then
	local nether_nodes = {
		"netherrack",
		"nether_brick",
		"basalt",
		"blackstone",
		"polished_blackstone",
		"polished_blackstone_bricks",
	}

	for _, name in pairs(nether_nodes) do
		local nodename = "mcl_nether:" .. name
		if core.registered_nodes[nodename] then
			local ndef = table.copy(core.registered_nodes[nodename])
			ndef.sunlight_propagates = true
			stairsminus:register_all("moreblocks", name, nodename, ndef)
		end
	end
end

-- farming registrations
if core.get_modpath("farming") then
	local farming_nodes = {"straw"}
	for _, name in pairs(farming_nodes) do
		local mod = "farming"
		local nodename = mod .. ":" .. name
		if core.registered_nodes[nodename] then
			local ndef = table.copy(core.registered_nodes[nodename])
			ndef.sunlight_propagates = true

			mod = "moreblocks"
			stairsminus:register_all(mod, name, nodename, ndef)
		end
	end
end

if core.get_modpath("mcl_farming") then
	local mcl_farming_nodes = {"straw", "hay_block"}
	for _, name in pairs(mcl_farming_nodes) do
		local nodename = "mcl_farming:" .. name
		if core.registered_nodes[nodename] then
			local ndef = table.copy(core.registered_nodes[nodename])
			ndef.sunlight_propagates = true
			stairsminus:register_all("moreblocks", name, nodename, ndef)
		end
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
		if core.registered_nodes[nodename] then
			local ndef = table.copy(core.registered_nodes[nodename])
			ndef.sunlight_propagates = true

			stairsminus:register_all(mod, name, nodename, ndef)
		end
	end
end

if core.get_modpath("mcl_wool") then
	local mcl_dyes = {"white", "grey", "black", "red", "yellow", "green", "cyan",
	                  "blue", "magenta", "orange", "violet", "brown", "pink",
	                  "dark_grey", "dark_green", "light_blue", "lime"}
	for _, name in pairs(mcl_dyes) do
		local nodename = "mcl_wool:" .. name
		if core.registered_nodes[nodename] then
			local ndef = table.copy(core.registered_nodes[nodename])
			ndef.sunlight_propagates = true

			stairsminus:register_all("mcl_wool", name, nodename, ndef)
		end
	end
end