AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Fishing Bobber"

ENT.Model = "models/props_junk/watermelon01.mdl"

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
    end
end
if CLIENT then
function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
end
end