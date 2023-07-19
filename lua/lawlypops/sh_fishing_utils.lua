LAWLYFISH = LAWLYFISH or {}

if LAWLYFISH.Catches == nil then LAWLYFISH.Catches = {} end
if LAWLYFISH.Rarities == nil then LAWLYFISH.Rarities = {} end
if LAWLYFISH.FishList == nil then LAWLYFISH.FishList = {} end

//Functions for fancy stuff :3
function LAWLYFISH:ApplyWeights(tbl)
    local total = 0
    for i, item in ipairs(tbl) do
        total = total + item.Weight
    end
    tbl.TotalWeight = total
end


function LAWLYFISH:SelectFromList(tbl)
    if !tbl.TotalWeight then
        if table.IsSequential(tbl) then
            return tbl[math.random(#tbl)]
        end
        return table.Random(tbl)
    end
    local rnd = math.random() * tbl.TotalWeight
    for i, item in ipairs(tbl) do
        rnd = rnd - item.Weight
        if rnd < 0 then
            return item
        end
    end
end

--Returns one of the lists of possible catch types
function LAWLYFISH:GetRandomCatch()
    return LAWLYFISH:SelectFromList(LAWLYFISH.Catches)
end

--Returns the actual caught item
function LAWLYFISH:GetRandomItem()
    local Catch = LAWLYFISH:GetRandomCatch()
    return LAWLYFISH:SelectFromList(Catch.List)
end

function LAWLYFISH:GetRarity(Weight)
    local rarity = 1
    for i, item in ipairs(LAWLYFISH.Rarities) do
        if Weight > item.Weight then continue end
        rarity = i
    end
    return rarity
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
