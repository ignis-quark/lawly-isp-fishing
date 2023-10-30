AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Item"
ENT.Category = "Fishing"
ENT.Spawnable = true

ENT.Model = "models/props_c17/metalPot002a.mdl"

ENT.ItemType = nil

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Temp")
    self:NetworkVar("String", 0, "Item")
    self:NetworkVar("Int", 1, "Amount")
    if SERVER then
        self:SetTemp(0)
        self:SetAmount(0)
    end
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
    end
end