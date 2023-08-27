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
    local itemData = {Item = LAWLIB:TableWeightedSelect(Catch.List), Mult = 1}
    if Catch.List == LAWLYFISH.TrashList then
        itemData.IsTrash = true
        itemData.Mult = 0
    end
    LAWLYFISH:SelectRandomStats(itemData, seed)
    return itemData
end

function LAWLYFISH:ItemLength(itemData)
    local item = itemData.itemData

    if item.MaxLength then
        return Lerp(itemData.Mult, LAWLYFISH.MinLength, item.MaxLength) 
    end
    return 0
end

function LAWLYFISH:ItemWorth(itemData)
    local item = itemData.Item
    if item.Worth > 0 then
        return item.Worth - math.floor((1-randVal) * item.Worth * LAWLYFISH.LengthCostMod)
    end
    return 0
end

function LAWLYFISH:SelectRandomStats(itemData, seed)
    if seed == nil then seed = CurTime() end

    itemData.Mult = util.SharedRandom(seed, 0, 1)

end

function LAWLYFISH:GetRarity(Weight)
    local rarity = 1
    local lowest = 1000
    for i, rarityData in ipairs(LAWLYFISH.Rarities) do
        if Weight > rarityData.Weight then continue end
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
        local itemData = LAWLYFISH:GetRandomItem()
        newCatch:SetItem(itemData)
        row = row + 1
        if row >= rowCount then
            col = col + 1
            row = 0
        end

        local item = itemData.Item
        if item.Weight then
            if rarityCount[item.Weight] then
                rarityCount[item.Weight] = rarityCount[item.Weight] + 1
            else
                rarityCount[item.Weight] = 1
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
            for _i, eachItem in ipairs(category.List) do
                local itemData = {Item = eachItem, Mult = 0}
                if category.List == LAWLYFISH.TrashList then itemData.IsTrash = true end
                LAWLYFISH:SelectRandomStats(itemData, _i)
                bucket:AddItem(itemData)
            end
        end
        return
    end

    for i=0, 100 do
        local itemData = LAWLYFISH:GetRandomItem(i*i)
        bucket:AddItem(itemData)
    end
end)