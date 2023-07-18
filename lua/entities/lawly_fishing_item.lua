AddCSLuaFile()
LAWLYFISH = LAWLYFISH or {}

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Fishing Item"

ENT.Model = "models/props_junk/watermelon01.mdl"

ENT.ItemTable = {}

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SelectRandomItem()
    end

    function ENT:SelectRandomItem()
        self.ItemTable = LAWLYFISH.FishList[math.random(#LAWLYFISH.FishList)]
        self:SetModel(self.ItemTable.Mdl)
    end
end
if CLIENT then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    end
end