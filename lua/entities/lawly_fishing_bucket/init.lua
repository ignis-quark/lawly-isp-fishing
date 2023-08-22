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
    for _, item in ipairs(self.StoredItems) do
        if !item.Worth then continue end
        totalMoney = totalMoney + item.Worth
    end
    table.Empty(self.StoredItems)
    self:GivePlyMoney(ply, totalMoney)
end

function ENT:SellTrashOnly(ply)
    local totalMoney = 0
    for i=#self.StoredItems, 1, -1 do
        local item = self.StoredItems[i]
        if item.IsTrash then
            table.remove(self.StoredItems, i)
            if item.Worth then
                totalMoney = totalMoney + item.Worth
            end
        end
    end
    self:GivePlyMoney(ply, totalMoney)
end

function ENT:SellItem(ply, index)
    local totalMoney = 0
    local item = self.StoredItems[index]
    if item.Worth then
        totalMoney = item.Worth
    end
    table.remove(self.StoredItems, index)
    self:GivePlyMoney(ply, totalMoney)
end

function ENT:AddItem(data)
    if !data or #self.StoredItems >= LAWLYFISH.BucketCapacity then return end
    itemData = data
    if IsEntity(data) then
        itemData = data.ItemTable
        data:Remove()
    end
    local item = itemData.Item
    --Error check the catch table so all default values don't need to be present
    if !item.Weight then item.Weight = 100 end
    if !item.Length then item.Length = -1 end
    if !item.Worth then item.Worth = 0 end
    if LAWLYFISH:GetRarity(item.Weight).Name == "Relic" then self:EmitSound("player/taunt_medic_heroic.wav") MsgN("Got a Relic!") end
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