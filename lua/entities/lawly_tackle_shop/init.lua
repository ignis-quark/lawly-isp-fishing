AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:OpenMenu(ply)
    LAWLIB:OpenMenu("fishing_shop", ply, self)
end

function ENT:Use(ply)
    self:OpenMenu(ply)
end