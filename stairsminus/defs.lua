--[[
More Blocks: registrations

Copyright © 2011-2020 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

stairsminus.defs = {
	["micro"] = {
		[""] = {
			node_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, 0, 0, 0, 0.5},
			},
		}
	}
}

for type,a in pairs(stairsminus.defs) do
	for name,b in pairs(stairsminus.defs[type]) do
		table.insert(stairsminus.shapes_list, { type .. "_", name })
	end
end
