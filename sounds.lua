--[[
Ported directly from `More Blocks`: sound definitions

Copyright © 2011-2021 Hugo Locurcio and contributors.
Licensed under the zlib license. See More Blocks LICENSE.md.
--]]

for _, sound in ipairs({"dirt", "wood", "stone", "metal", "glass", "leaves"}) do
    -- use sound-function from default if available
    -- otherwise fall back to a no-op function (no sounds)
    local sound_function_name = "node_sound_" .. sound .. "_defaults"
    if has_default_mod then
        -- use default sounds
        morecurves[sound_function_name] = default[sound_function_name]
    else
        -- no-op
        morecurves[sound_function_name] = function() end
    end
end
