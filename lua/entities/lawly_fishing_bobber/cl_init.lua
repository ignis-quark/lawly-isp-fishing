include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Draw()
    self:DrawModel()
    local color = self.InWaterColor
    if !self.IsInWater then
        color = self.NotInWaterColor
    end
    self:SetColor(color)
end