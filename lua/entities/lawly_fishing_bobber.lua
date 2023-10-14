ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Fishing Bobber"

ENT.Model = "models/XQM/Rails/trackball_1.mdl"

ENT.IsInWater = false
ENT.InWaterTime = 0

function ENT:CheckIsInWater()
    local PointCont = util.PointContents(self:GetPos() - Vector(0,0,10))
    return bit.band(PointCont, CONTENTS_WATER) == CONTENTS_WATER
end

function ENT:Think()
    self.IsInWater = self:CheckIsInWater()
    if SERVER then
        if !IsValid(self.Owner) or !IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() != "lawly_fishingrod" then
            self:Remove()
        end

        if self.IsInWater then
            self:GetPhysicsObject():SetDragCoefficient(20)
            self.InWaterTime = CurTime()
        else
            self:GetPhysicsObject():SetDragCoefficient(2)
        end
    end
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMaterial("models/lawlypops/bobber")
    if SERVER then
        self:SetCollisionGroup(COLLISION_GROUP_WORLD)
        self:ManipulateBoneScale( 0, Vector( 0.2, 0.2, 0.2 ) )
        self:PhysicsInit(SOLID_VPHYSICS)
    end
end
