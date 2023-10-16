AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:OpenMenu(ply)
    LAWLIB:OpenMenu("fishing_storage", ply, self)
end

function ENT:Use(ply)
    self:OpenMenu(ply)
end