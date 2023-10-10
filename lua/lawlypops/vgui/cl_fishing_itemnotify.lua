local ITEMNOTIF = {}

ITEMNOTIF.ItemQueue = {}

function ITEMNOTIF:AddItem(Item, Rarity)
    MsgN("Adding Item")
    if Item == nil then return end
    if Rarity == nil then Rarity = LAWLYFISH.Rarities[1] end
    local qData = {Item, table.Copy(Rarity.Color), CurTime() + LAWLYFISH.ItemDisplayTime}
    table.insert(ITEMNOTIF.ItemQueue, qData)
end

//We definitely don't want to override the global color tables' alpha
local descCol = table.Copy(color_white)
local outlineCol = table.Copy(color_black)

function ITEMNOTIF:DrawUI()
    if #ITEMNOTIF.ItemQueue <= 0 then return end
    local qData = ITEMNOTIF.ItemQueue[1]
    local Item = qData[1]
    local nameCol = qData[2]
    local itemTime = qData[3]
    local _CT = CurTime()

    local description = Item.Desc or ""

    local fadealpha = math.Clamp(itemTime - _CT, 0, 1)*2 * 255
    nameCol.a = fadealpha
    descCol.a = fadealpha
    outlineCol.a = fadealpha

    draw.SimpleTextOutlined(Item.Name, "LAWLIB:ExtraLarge", ScrW()/2, ScrH()*0.7, nameCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, outlineCol)
    draw.SimpleTextOutlined(description, "LAWLIB:Large", ScrW()/2, ScrH()*0.75, descCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outlineCol)

    //Remove item if out of time.
    if itemTime > _CT then return end
    table.remove(ITEMNOTIF.ItemQueue, 1)
end

hook.Add("HUDPaint", "lawlyfishing_drawItemNotifs", function()
    ITEMNOTIF:DrawUI()
end)

net.Receive("lawly_fishing_senditemnotif", function()
    local itemData = net.ReadTable()
    local Item = itemData.Item

    ITEMNOTIF:AddItem(Item, LAWLYFISH:GetRarity(itemData))
end)