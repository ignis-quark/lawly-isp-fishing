AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:GivePlyMoney(ply, amount)
    self:SetItemCount(#self.StoredItems)
    if DarkRP then
        ply:addMoney(amount)
        amount = DarkRP.formatMoney(amount)
    end
    MsgN(ply:Nick(), " sold fishing items for ", amount)
    LAWLIB:Notify(ply, "Recieved " .. amount .. " for fishing items.")
end

function ENT:SellAll(ply)
    local totalMoney = 0
    for _, itemData in ipairs(self.StoredItems) do
        local item = itemData.Item
        if !item.Worth then continue end
        totalMoney = totalMoney + LAWLYFISH:ItemWorth(itemData)
    end
    table.Empty(self.StoredItems)
    self:GivePlyMoney(ply, totalMoney)
end

function ENT:SellTrashOnly(ply)
    local totalMoney = 0
    for i=#self.StoredItems, 1, -1 do
        local item = self.StoredItems[i].Item
        if item.IsTrash then
            table.remove(self.StoredItems, i)
            if item.Worth then
                totalMoney = totalMoney + LAWLYFISH:ItemWorth(self.StoredItems[i])
            end
        end
    end
    self:GivePlyMoney(ply, totalMoney)
end

function ENT:SellItem(ply, index)
    local totalMoney = 0
    local item = self.StoredItems[index].Item
    if item.Worth then
        totalMoney = item.Worth
    end
    table.remove(self.StoredItems, index)
    self:GivePlyMoney(ply, totalMoney)
end

function ENT:AddItem(itemData)
    if !itemData or #self.StoredItems >= LAWLYFISH.BucketCapacity then return end
    local item = itemData.Item
    if LAWLYFISH:GetRarity(itemData).Name == "Relic" then self:EmitSound("player/taunt_medic_heroic.wav") MsgN("Got a Relic!") end
    table.insert(self.StoredItems, itemData)
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