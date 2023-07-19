AddCSLuaFile()
LAWLYFISH = LAWLYFISH or {}

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Fishing Item"

ENT.Model = "models/props_junk/watermelon01.mdl"
ENT.BoxModel = "models/props_junk/watermelon01.mdl"

ENT.ItemTable = {}
ENT.WeaponClass = ""

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
    end

    function ENT:SetItem(item)
        self.ItemTable = item
        if self.ItemTable.Class then
            self.WeaponClass = self.ItemTable.Class
        end
        if self.ItemTable.Mdl then
            self:SetModel(self.ItemTable.Mdl)
        else
            self:SetModel(self.BoxModel)
        end
    end
end
if CLIENT then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    end
end