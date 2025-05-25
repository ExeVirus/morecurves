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

dofile(modpath .. "/register.lua")

if core.get_modpath("default") then
    dofile(modpath .. "/sounds.lua")
    dofile(modpath .. "/band_saw.lua")
    if not core.get_modpath("moreblocks") then
        dofile(modpath .. "/stairsminus/init.lua")
    end
end