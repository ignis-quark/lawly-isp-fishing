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
        tbl = table.Copy(ent.ItemTable)
        ent:Remove()
    end
    if !tbl.Weight then tbl.Weight = 100 end
    if !tbl.Length then tbl.Length = -1 end
    if !tbl.Worth then tbl.Worth = 0 end
    if LAWLYFISH:GetRarity(tbl.Weight).Name == "Relic" then self:EmitSound("player/taunt_medic_heroic.wav") MsgN("Got a Relic!") end
    table.insert(self.StoredItems, tbl)
    self:SetItemCount(#self.StoredItems)
end

function ENT:RemoveItem(itemnumber)
    table.remove(self.StoredItems, itemnumber)
    self:SetItemCount(#self.StoredItems)
end

function ENT:OpenMenu(ply, cmd)
    LAWLIB:OpenMenu("fishing_bucket", ply, self, self.StoredItems, cmd)
end

function ENT:Use(ply)
    self:OpenMenu(ply)
end