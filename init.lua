

minetest.register_node("morecurves:band_saw",  {
    description = "Band Saw",
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
    --sounds = moreblocks.node_sound_wood_defaults(),
    --on_construct = band_saw.on_construct,
    --can_dig = band_saw.can_dig,
    -- Set the owner of this band saw.
    after_place_node = function(pos, placer)
        local meta = minetest.get_meta(pos)
        local owner = placer and placer:get_player_name() or ""
        local owned_by = owner

        if owner ~= "" then
            owned_by = "owned by " .. owner
        end

        meta:set_string("owner",  owner)
        meta:set_string("infotext", "Band Saw is empty" .. owned_by)
    end,

    -- The amount of items offered per shape can be configured:
    --on_receive_fields = band_saw.on_receive_fields,
    --allow_metadata_inventory_move = band_saw.allow_metadata_inventory_move,
    -- Only input- and recycle-slot are intended as input slots:
    --allow_metadata_inventory_put = band_saw.allow_metadata_inventory_put,
    --allow_metadata_inventory_take = band_saw.allow_metadata_inventory_take,
    -- Taking is allowed from all slots (even the internal microblock slot). Moving is forbidden.
    -- Putting something in is slightly more complicated than taking anything because we have to make sure it is of a suitable material:
    --on_metadata_inventory_put = band_saw.on_metadata_inventory_put,
    --on_metadata_inventory_take = band_saw.on_metadata_inventory_take,
})