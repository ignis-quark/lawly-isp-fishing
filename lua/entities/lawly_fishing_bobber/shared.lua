ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Fishing Bobber"

ENT.Model = "models/XQM/Rails/trackball_1.mdl"

ENT.InWaterColor = Color(0,0,255)
ENT.NotInWaterColor = Color(255,0,0)
ENT.IsInWater = false

function ENT:CheckIsInWater()
    local PointCont = util.PointContents(self:GetPos() - Vector(0,0,10))
    return bit.band(PointCont, CONTENTS_WATER) == CONTENTS_WATER
end

function ENT:Think()
    self.IsInWater = self:CheckIsInWater()
    if SERVER then
        if self.IsInWater then
            self:GetPhysicsObject():SetDragCoefficient(20)
        else
            self:GetPhysicsObject():SetDragCoefficient(2)
        end
    end
end