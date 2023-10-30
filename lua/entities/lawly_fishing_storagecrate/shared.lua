LAWLYFISH = LAWLYFISH or {}

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Storage Crate"
ENT.Spawnable = true
ENT.Category = "Fishing"

ENT.Model = "models/odessa.mdl"

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    if SERVER then
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
    end
end