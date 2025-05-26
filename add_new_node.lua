

morecurves.add_new_node = function(mod_name, node_name, ndef)
    morecurves.register_all(mod_name, node_name, ndef)
    if core.get_modpath("default") then
        if core.get_modpath("moreblocks") then
            stairsplus:register_micro("moreblocks", node_name, "moreblocks:" .. node_name, ndef)
        else
            stairsminus:register_micro("moreblocks", node_name, "moreblocks:" .. node_name, ndef)
        end
    end
end