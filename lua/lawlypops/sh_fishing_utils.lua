LAWLYFISH = LAWLYFISH or {}

if LAWLYFISH.Catches == nil then LAWLYFISH.Catches = {} end
if LAWLYFISH.Rarities == nil then LAWLYFISH.Rarities = {} end
if LAWLYFISH.FishList == nil then LAWLYFISH.FishList = {} end

--Returns one of the lists of possible catch types
function LAWLYFISH:GetRandomCatch()
    return LAWLIB:TableWeightedSelect(LAWLYFISH.Catches)
end

--Returns the actual caught item
function LAWLYFISH:GetRandomItem(seed)
    local Catch = LAWLYFISH:GetRandomCatch()
    local Item = table.Copy(LAWLIB:TableWeightedSelect(Catch.List))
    if Catch.List == LAWLYFISH.TrashList then
        Item.IsTrash = true
        Item.Worth = 1
    end
    LAWLYFISH:SelectRandomStats(Item, seed)
    return Item
end

function LAWLYFISH:SelectRandomStats(item, seed)
    if seed == nil then seed = CurTime() end
    if item.MaxLength then
        local randVal = util.SharedRandom(seed, 0, 1)
        item.RandVal = randVal
        item.Length = Lerp(randVal, LAWLYFISH.MinLength, item.MaxLength)

        if item.Worth > 0 then
            item.Worth = item.Worth - math.floor((1-randVal) * item.Worth * LAWLYFISH.LengthCostMod)
        end
    end
end

function LAWLYFISH:GetRarity(Weight)
    local rarity = 1
    local lowest = 1000
    for i, item in ipairs(LAWLYFISH.Rarities) do
        if Weight > item.Weight then continue end
        rarity = i
    end
    return LAWLYFISH.Rarities[rarity]
end

function LAWLYFISH:CreateRandomItemEnt(pos)
    if pos == nil then
        MsgN("[Fishing] No position provided for generating an item. Escaping.")
        return
    end
    local item = ents.Create("lawly_fishing_item")
    item:Spawn()
    item:SetItem(LAWLYFISH:GetRandomItem())
    return item
end
--[[ Only shows items from the basic fish list currently.
concommand.Add("fishing_listweights", function()
    local tbl = LAWLYFISH.FishList
    for i, item in ipairs(tbl) do
        local wt = item.Weight
        local perc = (wt / tbl.TotalWeight) * 100
        MsgN("List of all fishing weights available:")
        MsgN("[", item.Name, "] ", wt, " | ", perc, "%")
    end
end)
--]]

concommand.Add("fishing_debug_catch", function(ply, cmd, args)
    local counter = 100
    if #args > 0 then
        counter = args[1]
    end
    local rowCount = math.floor(math.sqrt(counter))
    local row = 0
    local col = 0

    local rarityCount = {}

    for i=0, counter-1, 1 do
        local newCatch = ents.Create("lawly_fishing_item")
        newCatch:SetPos(Entity(1):GetPos() + Vector(20*row,20*col,10))
        newCatch:Spawn()
        local data = LAWLYFISH:GetRandomItem()
        newCatch:SetItem(data)
        row = row + 1
        if row >= rowCount then
            col = col + 1
            row = 0
        end
        if data.Weight then
            if rarityCount[data.Weight] then
                rarityCount[data.Weight] = rarityCount[data.Weight] + 1
            else
                rarityCount[data.Weight] = 1
            end
        else
            if rarityCount["Weightless"] then
                rarityCount["Weightless"] = rarityCount["Weightless"] + 1
            else
                rarityCount["Weightless"] = 1
            end
        end
    end
    MsgN("Created " .. counter .. " fishing items. Spawned amount by rarity: ")
    PrintTable(rarityCount)
end)

concommand.Add("fishing_debug_bucket", function(ply, cmd, args)
    local bucket = nil
    for _, ent in ipairs(ents.FindInSphere(ply:GetPos(), 100)) do
        if ent:GetClass() == "lawly_fishing_bucket" then bucket = ent break end
    end
    if !IsValid(bucket) then
        MsgN("No Bucket found. Please ensure you're standing near one.")
    return end
    MsgN("Adding items to bucket.")

    if args[1] == "1" then
        for i, category in ipairs(LAWLYFISH.Catches) do
            for _i, item in ipairs(category.List) do
                if category.List == LAWLYFISH.TrashList then item.IsTrash = true end
                LAWLYFISH:SelectRandomStats(item, _i)
                bucket:AddItem(item)
            end
        end
        return
    end

    for i=0, 100 do
        local newItem = LAWLYFISH:GetRandomItem(i*i)
        bucket:AddItem(newItem)
    end
end)