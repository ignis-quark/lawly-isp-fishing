AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:AddItem(ent)
    if !ent then MsgN("A") return end
    tbl = ent
    if IsEntity(ent) then
        tbl = ent.ItemTable
        ent:Remove()
    end
    if !tbl.Weight then tbl.Weight = 100 end
    if !tbl.Length then tbl.Length = -1 end
    if !tbl.Worth then tbl.Worth = 0 end
    table.insert(self.StoredItems, tbl)
    self:SetItemCount(#self.StoredItems)
end

function ENT:RemoveItem(itemnumber)
    table.remove(self.StoredItems, itemnumber)
    self:SetItemCount(#self.StoredItems)
end

function ENT:Use(ply)
    net.Start("lawly_fishing_openmenu")
        net.WriteUInt(0, 2)
        net.WriteEntity(self)
        net.WriteTable(self.StoredItems)
    net.Send(ply)
end