ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Stove"

ENT.Model = "models/XQM/Rails/trackball_1.mdl"

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
end
