AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

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
        MsgN(self.ItemTable.Mdl)
        self:SetModel(self.ItemTable.Mdl)
    else
        self:SetModel(self.BoxModel)
    end
end