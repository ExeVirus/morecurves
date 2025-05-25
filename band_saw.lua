local S = morecurves.S
local F = core.formspec_escape

band_saw = {}

-- This is populated by stairsminus:register_all:
band_saw.known_nodes = {}

-- This is populated by stairsminus:register_micro:
band_saw.microblocks = {}
if core.get_modpath("moreblocks") then
    band_saw.microblocks = circular_saw.microblocks
    band_saw.known_nodes = circular_saw.known_nodes
end

-- How many microblocks does this shape at the output inventory cost:
-- It may cause slight loss, but no gain.
band_saw.cost_in_microblocks = {
	1, 1, 1, 1, 1, 1, 1, 2,
	2, 3, 2, 4, 2, 4, 5, 6,
	7, 1, 1, 2, 4, 6, 7, 8,
	1, 2, 2, 3, 1, 1, 2, 4,
	4, 2, 6, 7, 3, 7, 7, 4,
	8, 3, 2, 6, 2, 1, 3, 4
}

band_saw.names = {
	{"slope", "_inner_cut_half_raised"},
	{"slope", "_outer"},
	{"slope", "_outer_half"},
	{"slope", "_outer_half_raised"},
	{"slope", "_outer_cut"},
	{"slope", "_outer_cut_half"},
	{"slope", "_outer_cut_half_raised"},
	{"slope", "_cut"},
}

function band_saw:get_cost(inv, stackname)
	local name = core.registered_aliases[stackname] or stackname
	for i, item in pairs(inv:get_list("output")) do
		if item:get_name() == name then
			return band_saw.cost_in_microblocks[i]
		end
	end
end

function band_saw:get_output_inv(modname, material, amount, max)
	if (not max or max < 1 or max > 99) then max = 99 end

	local list = {}
	local pos = #list

	-- If there is nothing inside, display empty inventory:
	if amount < 1 then
		return list
	end

	for i = 1, #band_saw.names do
		local t = band_saw.names[i]
		local cost = band_saw.cost_in_microblocks[i]
		local balance = math.min(math.floor(amount/cost), max)
		local nodename = modname .. ":" .. t[1] .. "_" .. material .. t[2]
		if core.registered_nodes[nodename] then
			pos = pos + 1
			list[pos] = nodename .. " " .. balance
		end
	end
	return list
end


-- Reset empty band_saw after last full block has been taken out
-- (or the band_saw has been placed the first time)
-- Note: max_offered is not reset:
function band_saw:reset(pos)
	local meta = core.get_meta(pos)
	local inv  = meta:get_inventory()
	local owned_by = meta:get_string("owner")

	if owned_by and owned_by ~= "" then
		owned_by = (" ("..S("owned by @1", meta:get_string("owner"))..")")
	else
		owned_by = ""
	end

	inv:set_list("input",  {})
	inv:set_list("micro",  {})

	local microblockcount = inv:get_stack("micro",1):get_count()
	meta:set_int("anz", microblockcount)
	if microblockcount == 0 then
		meta:set_string("infotext", S("Band Saw is empty") .. owned_by)
		inv:set_list("output", {})
	end
end

-- Player has taken something out of the box or placed something inside
-- that amounts to count microblocks:
function band_saw:update_inventory(pos, amount)
	local meta          = core.get_meta(pos)
	local inv           = meta:get_inventory()

	amount = meta:get_int("anz") + amount

	-- The material is recycled automatically.
	inv:set_list("recycle",  {})

	if amount < 1 then -- If the last block is taken out.
		self:reset(pos)
		return
	end

	local stack = inv:get_stack("input", 1)
	local microstack = inv:get_stack("micro",1)

	-- At least one (micro)block is necessary to see what kind of curves are requested.
	if stack:is_empty() and microstack:is_empty() then
		self:reset(pos)
		return
	end

	local node_name = band_saw.microblocks[microstack:get_name()] or stack:get_name() or ""
	local node_def = stack:get_definition()
	local name_parts = band_saw.known_nodes[node_name] or ""
	local modname  = name_parts[1]
	local material = name_parts[2]
	local owned_by = meta:get_string("owner")

	if owned_by and owned_by ~= "" then
		owned_by = (" ("..S("owned by @1", meta:get_string("owner"))..")")
	else
		owned_by = ""
	end

	inv:set_list("input", { -- Display as many full blocks as possible:
		node_name.. " " .. math.floor(amount / 8)
	})

	-- 0-7 microblocks may remain left-over:
	inv:set_list("micro", {
		"moreblocks" .. ":micro_" .. material .. " " .. (amount % 8)
	})

	-- Display:
	inv:set_list("output",
		self:get_output_inv(modname, material, amount,
				meta:get_int("max_offered")))
	-- Store how many microblocks are available:
	meta:set_int("anz", amount)

	meta:set_string("infotext",
		S("Band Saw is working on @1",
			node_def and node_def.description or material
		) .. owned_by
	)
end

-- The amount of items offered per shape can be configured:
function band_saw.on_receive_fields(pos, formname, fields, sender)
	local meta = core.get_meta(pos)
	local max = tonumber(fields.max_offered)
	if max and max > 0 then
		meta:set_string("max_offered",  max)
		-- Update to show the correct number of items:
		band_saw:update_inventory(pos, 0)
	end
end


-- Moving the inventory of the band_saw around is not allowed because it
-- is a fictional inventory. Moving inventory around would be rather
-- impractical and make things more difficult to calculate:
function band_saw.allow_metadata_inventory_move(
    pos, from_list, from_index, to_list, to_index, count, player)
return 0
end

-- Only input- and recycle-slot (and microblock slot when empty) are intended as input slots:
function band_saw.allow_metadata_inventory_put(pos, listname, index, stack, player)
    -- The player is not allowed to put something in there:
    if listname == "output" then
        return 0
    end

    local meta = core.get_meta(pos)
    local inv  = meta:get_inventory()
    local stackname = stack:get_name()
    local count = stack:get_count()

    -- Only allow those items that are offered in the output inventory to be recycled:
    if listname == "recycle" then
        if not inv:contains_item("output", stackname) then
            return 0
        end
        local stackmax = stack:get_stack_max()
        local instack = inv:get_stack("input", 1)
        local microstack = inv:get_stack("micro", 1)
        local incount = instack:get_count()
        local incost = (incount * 8) + microstack:get_count()
        local maxcost = (stackmax * 8) + 7
        local cost = band_saw:get_cost(inv, stackname)
        if (incost + cost) > maxcost then
            return math.max((maxcost - incost) / cost, 0)
        end
        return count
    end

    -- Only accept certain blocks as input which are known to be craftable into stairs:
    if listname == "input" then
        if not inv:is_empty("input") then
            if inv:get_stack("input", index):get_name() ~= stackname then
                return 0
            end
        end
        if not inv:is_empty("micro") then
            local microstackname = inv:get_stack("micro", 1):get_name():gsub("^.+:micro_", "", 1)
            local cutstackname = stackname:gsub("^.+:", "", 1)
            if microstackname ~= cutstackname then
                return 0
            end
        end
        for name, t in pairs(band_saw.known_nodes) do
            if name == stackname and inv:room_for_item("input", stack) then
                return count
            end
        end
        return 0
    end

    if listname == "micro" then
        if not (inv:is_empty("input") and inv:is_empty("micro")) then return 0 end
        for name, t in pairs(band_saw.microblocks) do
            if name == stackname and inv:room_for_item("input", stack) then
                return count
            end
        end
        return 0
    end
end

-- Taking is allowed from all slots (even the internal microblock slot).
-- Putting something in is slightly more complicated than taking anything
-- because we have to make sure it is of a suitable material:
band_saw.on_metadata_inventory_put = function(pos, listname, index, stack, player)
	-- We need to find out if the band_saw is already set to a
	-- specific material or not:
	local meta = core.get_meta(pos)
	local inv  = meta:get_inventory()
	local stackname = stack:get_name()
	local count = stack:get_count()

	-- Putting something into the input slot is only possible if that had
	-- been empty before or did contain something of the same material:
	if listname == "input" then
		-- Each new block is worth 8 microblocks:
		band_saw:update_inventory(pos, 8 * count)
	elseif listname == "micro" then
		band_saw:update_inventory(pos, count)
	elseif listname == "recycle" then
		-- Lets look which shape this represents:
		local cost = band_saw:get_cost(inv, stackname)
		local input_stack = inv:get_stack("input", 1)
		-- check if this would not exceed input itemstack max_stacks
		if input_stack:get_count() + ((cost * count) / 8) <= input_stack:get_stack_max() then
			band_saw:update_inventory(pos, cost * count)
		end
	end
end

band_saw.allow_metadata_inventory_take = function (pos, listname, index, stack, player)
	local meta          = core.get_meta(pos)
	local inv           = meta:get_inventory()
	local input_stack = inv:get_stack(listname,  index)
	local player_inv = player:get_inventory()
	if not player_inv:room_for_item("main", input_stack) then
		return 0
	else return stack:get_count()
	end
end

band_saw.on_metadata_inventory_take = function(pos, listname, index, stack, player)
	-- Prevent (inbuilt) swapping between inventories with different blocks
	-- corrupting player inventory or Saw with 'unknown' items.
	local meta          = core.get_meta(pos)
	local inv           = meta:get_inventory()
	local input_stack = inv:get_stack(listname,  index)
	if not input_stack:is_empty() and input_stack:get_name()~=stack:get_name() then
		local player_inv = player:get_inventory()

		-- Prevent arbitrary item duplication.
		inv:remove_item(listname, input_stack)

		if player_inv:room_for_item("main", input_stack) then
			player_inv:add_item("main", input_stack)
		end

		band_saw:reset(pos)
		return
	end

	-- If it is one of the offered stairs: find out how many
	-- microblocks have to be subtracted:
	if listname == "output" then
		-- We do know how much each block at each position costs:
		local cost = band_saw.cost_in_microblocks[index]
				* stack:get_count()
		band_saw:update_inventory(pos, -cost)
	elseif listname == "micro" then
		-- Each microblock costs 1 microblock:
		band_saw:update_inventory(pos, -stack:get_count())
	elseif listname == "input" then
		-- Each normal (= full) block taken costs 8 microblocks:
		band_saw:update_inventory(pos, 8 * -stack:get_count())
	end
	-- The recycle field plays no role here since it is processed immediately.
end

function band_saw.on_construct(pos)
	local meta = core.get_meta(pos)
	-- prepend background and slot styles from default if available
	local fancy_inv = default.gui_bg..default.gui_bg_img..default.gui_slots

	meta:set_string(
		"formspec", "size[11,10]"..fancy_inv..
		"label[0,0;" ..S("Input material").. "]" ..
		"list[current_name;input;1.7,0;1,1;]" ..
		"label[0,1;" ..F(S("Left-over")).. "]" ..
		"list[current_name;micro;1.7,1;1,1;]" ..
		"label[0,2;" ..F(S("Recycle output")).. "]" ..
		"list[current_name;recycle;1.7,2;1,1;]" ..
		"field[0.3,3.5;1,1;max_offered;" ..F(S("Max")).. ":;${max_offered}]" ..
		"button[1,3.2;1.7,1;Set;" ..F(S("Set")).. "]" ..
		"list[current_name;output;2.8,0;8,5;]" ..
		"list[current_player;main;1.5,6.25;8,4;]" ..
		"listring[current_name;output]" ..
		"listring[current_player;main]" ..
		"listring[current_name;input]" ..
		"listring[current_player;main]" ..
		"listring[current_name;micro]" ..
		"listring[current_player;main]" ..
		"listring[current_name;recycle]" ..
		"listring[current_player;main]"
	)

	meta:set_int("anz", 0) -- No microblocks inside yet.
	meta:set_string("max_offered", 99) -- How many items of this kind are offered by default?
	meta:set_string("infotext", S("Band Saw is empty"))

	local inv = meta:get_inventory()
	inv:set_size("input", 1)    -- Input slot for full blocks of material x.
	inv:set_size("micro", 1)    -- Storage for 1-7 surplus microblocks.
	inv:set_size("recycle", 1)  -- Surplus partial blocks can be placed here.
	inv:set_size("output", 6*8) -- 6x8 versions of stair-parts of material x.

	band_saw:reset(pos)
end


function band_saw.can_dig(pos,player)
	local meta = core.get_meta(pos)
	local inv = meta:get_inventory()
	if not inv:is_empty("input") or
	   not inv:is_empty("micro") or
	   not inv:is_empty("recycle") then
		return false
	end
	-- Can be dug by anyone when empty, not only by the owner:
	return true
end

core.register_node("morecurves:band_saw",  {
    description = S("Band Saw"),
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}, -- Base
            {-0.5, -0.375, -0.5, -0.375, 0.5, -0.3125}, -- Tower
            {-0.375, 0.0625, -0.5, 0.375, 0.5, -0.3125}, -- Arm
            {0.27, -0.375, -0.45, 0.29, 0.0625, -0.45}, -- Saw blade
        },
    },
    tiles = {"default_chest_top.png",
        "default_chest_top.png",
        "default_chest_top.png",
        "default_chest_top.png",
        "[combine:16x16:0,0=default_chest_top.png\\^[resize\\:16x16:12,7=default_clay.png\\^[resize\\:1x7^[transformFX",
        "[combine:16x16:0,0=default_chest_top.png\\^[resize\\:16x16]:12,7=default_clay.png\\^[resize\\:1x7"},
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    groups = {choppy = 2,oddly_breakable_by_hand = 2},
    is_ground_content = false,
    --sounds = morecurves.node_sound_wood_defaults(),
    on_construct = band_saw.on_construct,
    can_dig = band_saw.can_dig,
    -- Set the owner of this band saw.
    after_place_node = function(pos, placer)
        local meta = core.get_meta(pos)
        local owner = placer and placer:get_player_name() or ""
        local owned_by = owner

		if owner ~= "" then
			owned_by = (" (%s)"):format(S("owned by @1", owner))
		end

        meta:set_string("owner",  owner)
        meta:set_string("infotext", S("Band Saw is empty") .. owned_by)
    end,

    -- The amount of items offered per shape can be configured:
    on_receive_fields = band_saw.on_receive_fields,
    allow_metadata_inventory_move = band_saw.allow_metadata_inventory_move,
    -- Only input- and recycle-slot are intended as input slots:
    allow_metadata_inventory_put = band_saw.allow_metadata_inventory_put,
    allow_metadata_inventory_take = band_saw.allow_metadata_inventory_take,
    -- Taking is allowed from all slots (even the internal microblock slot). Moving is forbidden.
    -- Putting something in is slightly more complicated than taking anything because we have to make sure it is of a suitable material:
    on_metadata_inventory_put = band_saw.on_metadata_inventory_put,
    on_metadata_inventory_take = band_saw.on_metadata_inventory_take,
})

core.register_craft({
    output = "morecurves:band_saw",
    recipe = {
        { "group:wood",  "group:wood",  "group:wood"          },
        { "group:wood",            "",  "default:steel_ingot" },
        { "group:wood",  "group:wood",  "group:wood"          },
    }
})

for _, t in pairs(band_saw.names) do
	core.register_alias("morecurves:" .. t[1] .. "_jungle_wood" .. t[2],
			"morecurves:" .. t[1] .. "_junglewood" .. t[2])
end