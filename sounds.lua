--[[
Ported directly from `More Blocks`: sound definitions

Copyright © 2011-2021 Hugo Locurcio and contributors.
Licensed under the zlib license. See More Blocks LICENSE.md.
--]]

for _, sound in ipairs({"dirt", "wood", "stone", "metal", "glass", "leaves"}) do
    -- use sound-function from default or mcl_sounds if available
    -- otherwise fall back to a no-op function (no sounds)
    local sound_function_name = "node_sound_" .. sound .. "_defaults"
    if core.get_modpath("default") and default and default[sound_function_name] then
        morecurves[sound_function_name] = default[sound_function_name]
    elseif core.get_modpath("mcl_sounds") and mcl_sounds and mcl_sounds[sound_function_name] then
        morecurves[sound_function_name] = mcl_sounds[sound_function_name]
    else
        morecurves[sound_function_name] = function() return {} end
    end
end