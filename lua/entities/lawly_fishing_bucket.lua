AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Fishing Bucket"

ENT.Model = "models/props_junk/watermelon01.mdl"

ENT.StoredItems = {}

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
    end
    
    function ENT:AddItem(ent)
        if !IsValid(ent) then return end
        local tbl = ent.ItemTable
        table.insert(self.StoredItems, ent.ItemTable)
        ent:Remove()
    end
end
if CLIENT then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    end
end