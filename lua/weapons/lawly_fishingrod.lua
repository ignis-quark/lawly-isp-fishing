AddCSLuaFile("lawlypops/weapons/lawly_fishingrod/sh_lawly_fishingrod.lua")
AddCSLuaFile("lawlypops/weapons/lawly_fishingrod/cl_lawly_fishingrod.lua")

include("lawlypops/weapons/lawly_fishingrod/sh_lawly_fishingrod.lua")
if SERVER then
    include("lawlypops/weapons/lawly_fishingrod/sv_lawly_fishingrod.lua")
    return
end
include("lawlypops/weapons/lawly_fishingrod/cl_lawly_fishingrod.lua")