
for original_full_node_name, name_parts in pairs(band_saw.known_nodes) do
	local node_name = name_parts[2]
    local src_def = core.registered_nodes[original_full_node_name] or {}
    morecurves.register_all("morecurves", node_name, src_def)
end