AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Fishing Bobber"

ENT.Model = "models/props_junk/watermelon01.mdl"

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    end

    function ENT:IsInWater()
        local PointCont = util.PointContents(self:GetPos() - Vector(0,0,5))
        return bit.band(PointCont, CONTENTS_WATER) == CONTENTS_WATER
    end
end
if CLIENT then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    end
end