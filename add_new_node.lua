morecurves.add_new_node = function(mod_name, node_name, ndef)
    morecurves.register_all(mod_name, node_name, ndef)
    if core.get_modpath("default") or core.get_modpath("mcl_core") then
        if core.get_modpath("moreblocks") and stairsplus then
            stairsplus:register_micro("moreblocks", node_name, "moreblocks:" .. node_name, ndef)
        elseif stairsminus then
            stairsminus:register_micro("moreblocks", node_name, "moreblocks:" .. node_name, ndef)
        end
    end
end