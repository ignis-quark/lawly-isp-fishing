if SERVER then
    AddCSLuaFile("lawlypops/sh_fishing_utils.lua")
    AddCSLuaFile("lawlypops/sh_fishing-config.lua")
    AddCSLuaFile("lawlypops/sh_fishing_catchlist.lua")
    AddCSLuaFile("lawlypops/sh_fishing_baitlist.lua")
end
if CLIENT then
    
end
include("lawlypops/sh_fishing_utils.lua")
include("lawlypops/sh_fishing-config.lua")
include("lawlypops/sh_fishing_catchlist.lua")
include("lawlypops/sh_fishing_baitlist.lua")