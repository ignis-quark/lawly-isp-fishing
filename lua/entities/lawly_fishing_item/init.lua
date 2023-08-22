AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
end

function ENT:SetItem(itemData)
    self.ItemData = itemData
    local item = self.ItemData.Item
    if item.Class then
        self.WeaponClass = item.Class
    end
    if item.Mdl then
        self:SetModel(item.Mdl)
    else
        self:SetModel(self.BoxModel)
    end
end