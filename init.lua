--[[
======================================================================================
███╗   ███╗ ██████╗ ██████╗ ███████╗ ██████╗██╗   ██╗██████╗ ██╗   ██╗███████╗███████╗
████╗ ████║██╔═══██╗██╔══██╗██╔════╝██╔════╝██║   ██║██╔══██╗██║   ██║██╔════╝██╔════╝
██╔████╔██║██║   ██║██████╔╝█████╗  ██║     ██║   ██║██████╔╝██║   ██║█████╗  ███████╗
██║╚██╔╝██║██║   ██║██╔══██╗██╔══╝  ██║     ██║   ██║██╔══██╗╚██╗ ██╔╝██╔══╝  ╚════██║
██║ ╚═╝ ██║╚██████╔╝██║  ██║███████╗╚██████╗╚██████╔╝██║  ██║ ╚████╔╝ ███████╗███████║
╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝
By Exevirus, with tons of code and inspiration from More Blocks

Copyright © 2025 ExeVirus
Licensed under the Apache 2.0 license. See LICENSE.md.
======================================================================================
--]]

morecurves = {}
local modpath = core.get_modpath("morecurves")
morecurves.S = core.get_translator("morecurves")

dofile(modpath .. "/register_all.lua")

if core.get_modpath("default") then
    dofile(modpath .. "/sounds.lua")
    dofile(modpath .. "/band_saw.lua")
    if not core.get_modpath("moreblocks") then
        dofile(modpath .. "/stairsminus/init.lua") -- for microblocks, cause we don't want to duplicate that functionality
    end
end
-- the external API (single function) for other mods/servers/games
-- Needed to handle creation of microblocks if playing with `default` on
dofile(modpath .. "/add_new_node.lua") 

if core.get_modpath("default") then
    dofile(modpath .. "/default_registrations.lua") --curves
end