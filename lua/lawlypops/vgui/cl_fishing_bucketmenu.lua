LAWLYFISH = LAWLYFISH or {}
local MENU = {}
local PNL = nil

MENU.SelectedIndex = 0

MENU.RequiresTable = true

MENU.SortTypes = {
    {Name="RARITY", func=function(tbl) table.SortByMember( tbl, "Weight", true ) end },
    {Name="NAME", func=function(tbl) table.SortByMember( tbl, "Name", true) end },
    {Name="VALUE", func=function(tbl) table.SortByMember( tbl, "Worth", false) end },
    {Name="LENGTH", func=function(tbl) table.SortByMember( tbl, "Length", false) end },
}

function MENU:SellItem(index)
    table.remove(MENU.Table, index)
    PNL.ItemList:PopulateList(MENU.Table)
    self:SendSellToServer(2, index)
end
function MENU:SellTrash()
    for i=#MENU.Table, 1, -1 do
        local item = MENU.Table[i]
        if item.IsTrash then
            table.remove(MENU.Table, i)
        end
    end
    PNL.ItemList:PopulateList(MENU.Table)
    self:SendSellToServer(1)
end
function MENU:SellAll()
    table.Empty(MENU.Table)
    PNL.ItemList:PopulateList(MENU.Table)
    self:SendSellToServer(0)
end

function MENU:SendSellToServer(cmd, index) --CMD: 0-All 1-Trash 2-Item
    net.Start("lawly_fishing_sell_items")
        net.WriteEntity(MENU.Entity)
        net.WriteUInt(cmd, 2)
        if cmd == 2 then
            net.WriteUInt(index-1, 16)
        end
    net.SendToServer()
end

function MENU:ConfirmMenu(index)
    local CMENU = vgui.Create("LConfirm")
    if index == "all" then
        CMENU:SetTitle("Sell ALL items? (" .. MENU.ItemTotal.Count .. " items)")
        CMENU:SetTitleColor(Color(255,0,0))
        CMENU.ConfirmAction = function()
            MENU:SellAll()
            MENU:Deselect()
        end
    elseif index == "trash" then
        CMENU:SetTitle("Sell all trash? (" .. MENU.TrashTotal.Count .. " items)")
        CMENU.ConfirmAction = function()
            MENU:SellTrash()
            MENU:Deselect()
        end
    else
        CMENU:SetTitle("Sell the currently Selected Item?")
        CMENU.ConfirmAction = function()
            MENU:SellItem(index)
            MENU:SelectItem(index)
        end
    end
end

function MENU:Deselect()
    PNL.ModelView:SetVisible(false)
    PNL.ItemRarity:SetVisible(false)
    PNL.ItemPrice:SetVisible(false)
    PNL.ItemLength:SetVisible(false)
    PNL.ItemLengthBar:SetVisible(false)
    PNL.ItemTitle:SetText("No Item Selected")
    if PNL.SellMenu then
        PNL.SellItemBtn:SetVisible(false)
        PNL.SellMenu:InvalidateLayout()
    end
    self.SelectedIndex = 0
end

function MENU:SelectItem(index)
    if !PNL.ItemViewFrame then return end
    surface.PlaySound("items/pickup_quiet_0"..math.random(1,3)..".wav")
    index = math.min(index, #self.Table)
    self.SelectedIndex = index
    local tbl = MENU.Table[index]
    if !tbl then MENU:Deselect() return end
    if PNL.SellMenu then
        PNL.SellItemBtn:SetVisible(true)
        PNL.SellTrashBtn:SetVisible(true)
        PNL.SellAllBtn:SetVisible(true)
    end
    
    local rarity = LAWLYFISH:GetRarity(tbl.Weight)

    PNL.ItemTitle:SetText(tbl.Name)
    PNL.ItemPrice:SetText("$"..tbl.Worth)
    PNL.ItemRarity:SetText(rarity.Name)
    PNL.ItemRarity:SetTextColor(rarity.Color)

    PNL.ItemRarity:SetVisible(true)
    PNL.ItemPrice:SetVisible(true)

    if tbl.Mdl then
        if tbl.Mdl == "FUCK" then
            PNL.ModelView:SetModel("models/props/de_inferno/goldfish.mdl")
            PNL.ModelView:GetEntity():SetMaterial("debug/debugempty")
        else
            PNL.ModelView:SetModel(tbl.Mdl)
        end
        PNL.ModelView:SetVisible(true)
        local ent = PNL.ModelView:GetEntity()
        local scale = ent:GetModelRadius()
        PNL.ModelView:SetCamPos(Vector(scale,scale,scale)*2)
        //PNL.ModelView:SetFOV(scale)
    else
        PNL.ModelView:SetVisible(false)
    end
    if tbl.Length > 0 then
        PNL.ItemLength:SetText("Length: " .. math.Round(tbl.Length,2).."cm")
        local lenCol = Color(255 * (1 - tbl.RandVal), 255 * tbl.RandVal, 0)
        PNL.ItemLength:SetTextColor(lenCol)
        PNL.ItemLength:SetVisible(true)
        PNL.ItemLengthBar:SetVisible(true)
        timer.Simple(FrameTime(), function()
            PNL.ItemLengthBar:SetFraction(tbl.RandVal)
        end)
        PNL.ItemLengthBar:SetFGColor(lenCol)
    else
        PNL.ItemLength:SetVisible(false)
        PNL.ItemLengthBar:SetVisible(false)
    end
end

function MENU:FindShop()
    for _, ent in ipairs(ents.FindInSphere(MENU.Entity:GetPos(), LAWLYFISH.SellDistance)) do
        if ent:GetClass() != "lawly_tackle_shop" then continue end
        return ent
    end
    return nil
end

function MENU:CreateMenu(ent, tbl, cmd)
    MENU.Entity = ent
    MENU.Table = tbl
    PNL = vgui.Create("LFrame")
    PNL:SetTitle("This... Is a Bucket.")
    PNL:SetTitleHoverText("There's More...")
    PNL:SetSize(ScrW()*0.8, ScrH()*0.8)
    PNL:Center()
    PNL:MakePopup()
    surface.PlaySound("items/ammocrate_open.wav")
    PNL.CloseSound = "items/ammocrate_close.wav"

    PNL.ItemListFrame = vgui.Create("DPanel", PNL)
    PNL.ItemListFrame:Dock(LEFT)
    PNL.ItemListFrame:SetWide(PNL:GetWide()/2)
    PNL.ItemListFrame:SetPaintBackground(false)

    PNL.SortButtonText = vgui.Create("LButton", PNL.ItemListFrame)
    PNL.SortButtonText:Dock(TOP)
    PNL.SortButtonText:SetTall(30)
    PNL.SortButtonText.SortType = 1
    PNL.SortButtonText:SetText("SORTED BY: NONE")
    PNL.SortButtonText:SetFont("DermaLarge")
    PNL.SortButtonText:SetBGColor(20,20,20)
    PNL.SortButtonText:SizeToContents()
    function PNL.SortButtonText:OnMousePressed()
        self.SortType = self.SortType + 1
        if self.SortType > #MENU.SortTypes then self.SortType = 1 end
        self:SetText("SORTED BY: " .. MENU.SortTypes[self.SortType].Name)
        MENU.SortTypes[self.SortType].func(MENU.Table)
        PNL.ItemList:PopulateList(MENU.Table)
        surface.PlaySound("buttons/blip1.wav")
    end


    PNL.ItemList = vgui.Create("DScrollPanel", PNL.ItemListFrame)
    PNL.ItemList:Dock(FILL)
    PNL.ItemList:SetWide(PNL:GetWide()/2)
    PNL.ItemList:SetBackgroundColor(Color(0,0,0,100))
    PNL.ItemList:SetPaintBackground(true)
    function PNL.ItemList:PopulateList(_tbl)
        self:Clear()
        MENU.ItemTotal = {
            Count = 0,
            Worth = 0,
            MostExpensive = 0
        }
        MENU.TrashTotal = {
            Count = 0,
            Worth = 0
        }
        if #_tbl == 0 and PNL.SellMenu then
            PNL.SellTrashBtn:SetVisible(false)
            PNL.SellAllBtn:SetVisible(false)
        end
        for i, itemData in ipairs(_tbl) do
            if itemData == nil then continue end
            local item = itemData.Item
            local newItem = vgui.Create("DPanel")
            newItem:SetWide(PNL.ItemList:GetWide())
            newItem:SetTall(40)
            newItem:Dock(TOP)
            newItem:DockMargin(5,5,5,0)
            newItem:SetBackgroundColor(Color(46,46,46))
            newItem:SetMouseInputEnabled(true)
            newItem.Index = i

            function newItem:OnMousePressed()
                MENU:SelectItem(self.Index)
            end

            newItem.txt = vgui.Create("DLabel", newItem)
            newItem.txt:SetText(item.Name)
            newItem.txt:SetFont("DermaLarge")
            newItem.txt:SizeToContentsY()
            newItem.txt:SetWide(newItem:GetWide()/2)
            newItem.txt:CenterVertical()

            if item.Worth then
                local NetWorth = LAWLYFISH:ItemWorth(itemData)
                MENU.ItemTotal.Count = MENU.ItemTotal.Count + 1
                MENU.ItemTotal.Worth = MENU.ItemTotal.Worth + NetWorth
                if item.IsTrash then
                    MENU.TrashTotal.Count = MENU.TrashTotal.Count + 1
                    MENU.TrashTotal.Worth = MENU.TrashTotal.Worth + NetWorth
                end
                if NetWorth > MENU.ItemTotal.MostExpensive then MENU.ItemTotal.MostExpensive = NetWorth end
                newItem.value = vgui.Create("DLabel", newItem)
                newItem.value:SetText("$"..NetWorth)
                newItem.value:SetFont("DermaLarge")
                newItem.value:SizeToContentsX()
                newItem.value:Dock(RIGHT)
            end
            if item.Length > -1 then
                local NetLen = LAWLYFISH:ItemLength(itemData)
                newItem.len = vgui.Create("DLabel", newItem)
                newItem.len:SetText("Length: " .. math.Round(NetLen, 2) .. "cm")
                newItem.len:SetFont("DermaLarge")
                newItem.len:SizeToContents()
                newItem.len:Center()
            end
            
            if item.Weight then
                local rarity = LAWLYFISH:GetRarity(item.Weight)
                newItem.txt:SetTextColor(rarity.Color)
            end
            if item.Class then
                newItem.txt:SetTextColor(Color(198,255,194))
            end
            PNL.ItemList:Add(newItem)
        end
        if PNL.SellMenu then PNL.SellMenu:UpdateTotals() end
    end
    PNL.ItemList:PopulateList(MENU.Table)

    PNL.ItemViewFrame = vgui.Create("DPanel", PNL)
    PNL.ItemViewFrame:DockMargin(10,10,10,10)
    PNL.ItemViewFrame:Dock(TOP)
    PNL.ItemViewFrame:SetBackgroundColor(Color(54,54,54))
    PNL.ItemViewFrame:SetTall(200)

    PNL.ModelView = vgui.Create("DModelPanel", PNL.ItemViewFrame)
    PNL.ModelView:Dock(RIGHT)
    PNL.ModelView:SetVisible(false)
    PNL.ModelView:SetSize(200,200)
    PNL.ModelView:SetCamPos(Vector(100,100,100))
    PNL.ModelView:SetFOV(45)
    PNL.ModelView:SetLookAt(Vector(0,0,0))

    PNL.ItemTitle = vgui.Create("DLabel", PNL.ItemViewFrame)
    PNL.ItemTitle:DockMargin(10,10,0,0)
    PNL.ItemTitle:Dock(TOP)
    PNL.ItemTitle:SetText("No Item Selected")
    PNL.ItemTitle:SetFont("DermaLarge")
    PNL.ItemTitle:SizeToContentsY()
    PNL.ItemTitle:SetTextColor(Color(255,255,255))
    
    PNL.ItemRarity = vgui.Create("DLabel", PNL.ItemViewFrame)
    PNL.ItemRarity:DockMargin(10,10,0,0)
    PNL.ItemRarity:Dock(TOP)
    PNL.ItemRarity:SetText("Unknown")
    PNL.ItemRarity:SetFont("DermaLarge")
    PNL.ItemRarity:SizeToContentsY()
    PNL.ItemRarity:SetVisible(false)

    PNL.ItemPrice = vgui.Create("DLabel", PNL.ItemViewFrame)
    PNL.ItemPrice:DockMargin(10,10,0,0)
    PNL.ItemPrice:Dock(TOP)
    PNL.ItemPrice:SetText("$0")
    PNL.ItemPrice:SetFont("DermaLarge")
    PNL.ItemPrice:SizeToContentsY()
    PNL.ItemPrice:SetVisible(false)
    PNL.ItemPrice:SetTextColor(Color(255,255,255))

    PNL.ItemLength = vgui.Create("DLabel", PNL.ItemViewFrame)
    PNL.ItemLength:DockMargin(10,10,0,0)
    PNL.ItemLength:Dock(TOP)
    PNL.ItemLength:SetText("0cm")
    PNL.ItemLength:SetFont("DermaLarge")
    PNL.ItemLength:SizeToContentsY()
    PNL.ItemLength:SetVisible(false)
    PNL.ItemLength:SetTextColor(Color(255,255,255))

    PNL.ItemLengthBar = vgui.Create("LProgress", PNL.ItemViewFrame)
    PNL.ItemLengthBar:SetFraction(1)
    PNL.ItemLengthBar:DockMargin(10,10,10,10)
    PNL.ItemLengthBar:Dock(FILL)
    PNL.ItemLengthBar:SetTall(10)
    PNL.ItemLengthBar:SetFGColor(Color(255,255,255))
    PNL.ItemLengthBar:SetVisible(false)

    //Show buttons if the bucket is selected from the shop.
    local shop = self:FindShop()
    if shop == nil or #MENU.Table == 0 then return end

    PNL.SellMenu = vgui.Create("DPanel", PNL)
    PNL.SellMenu:Dock(FILL)
    PNL.SellMenu:DockPadding(10,0,10,0)
    PNL.SellMenu:SetPaintBackground(false)

    function PNL.SellMenu:UpdateTotals()
        PNL.MostValText:SetText("Most expensive item: $" .. MENU.ItemTotal.MostExpensive)
        PNL.TotalText:SetText(MENU.ItemTotal.Count .. " Items: $" .. MENU.ItemTotal.Worth)
        PNL.TrashText:SetText(MENU.TrashTotal.Count .. " Trash: $" .. MENU.TrashTotal.Worth)
    end

    PNL.MostValText = vgui.Create("DLabel", PNL.SellMenu)
    PNL.MostValText:Dock(TOP)
    PNL.MostValText:SetText("Most expensive item: $" .. MENU.ItemTotal.MostExpensive)
    PNL.MostValText:SetTextColor(Color(255,255,255))
    PNL.MostValText:SetFont("DermaLarge")
    PNL.MostValText:SizeToContentsY()
    PNL.MostValText:DockMargin(0,0,0,10)

    PNL.TotalText = vgui.Create("DLabel", PNL.SellMenu)
    PNL.TotalText:Dock(TOP)
    PNL.TotalText:SetText(MENU.ItemTotal.Count .. " Items: $" .. MENU.ItemTotal.Worth)
    PNL.TotalText:SetTextColor(Color(255,109,109))
    PNL.TotalText:SetFont("DermaLarge")
    PNL.TotalText:SizeToContentsY()
    PNL.TotalText:DockMargin(0,0,0,10)

    PNL.TrashText = vgui.Create("DLabel", PNL.SellMenu)
    PNL.TrashText:Dock(TOP)
    PNL.TrashText:SetText(MENU.TrashTotal.Count .. " Trash: $" .. MENU.TrashTotal.Worth)
    PNL.TrashText:SetFont("DermaLarge")
    PNL.TrashText:SizeToContentsY()
    PNL.TrashText:DockMargin(0,0,0,30)

    PNL.SellItemBtn = vgui.Create("LButton", PNL.SellMenu)
    PNL.SellItemBtn:DockMargin(20,10,20,10)
    PNL.SellItemBtn:Dock(TOP)
    PNL.SellItemBtn:SetText("Sell This Item")
    PNL.SellItemBtn:SetFont("DermaLarge")
    PNL.SellItemBtn:SetTextColor(Color(91,255,69))
    PNL.SellItemBtn:SetTall(50)
    function PNL.SellItemBtn:OnMousePressed()
        MENU:ConfirmMenu(MENU.SelectedIndex)
    end

    PNL.SellTrashBtn = vgui.Create("LButton", PNL.SellMenu)
    PNL.SellTrashBtn:DockMargin(20,10,20,10)
    PNL.SellTrashBtn:Dock(TOP)
    PNL.SellTrashBtn:SetText("Sell Trash Only")
    PNL.SellTrashBtn:SetFont("DermaLarge")
    PNL.SellTrashBtn:SetTextColor(Color(255,255,255))
    PNL.SellTrashBtn:SetTall(50)
    function PNL.SellTrashBtn:OnMousePressed()
        MENU:ConfirmMenu("trash")
    end

    PNL.SellAllBtn = vgui.Create("LButton", PNL.SellMenu)
    PNL.SellAllBtn:DockMargin(20,10,20,10)
    PNL.SellAllBtn:Dock(TOP)
    PNL.SellAllBtn:SetText("Sell All Items")
    PNL.SellAllBtn:SetFont("DermaLarge")
    PNL.SellAllBtn:SetTextColor(Color(255,0,0))
    PNL.SellAllBtn:SetTall(50)
    function PNL.SellAllBtn:OnMousePressed()
        MENU:ConfirmMenu("all")
    end

    PNL.SellItemBtn:SetVisible(false)
end

LAWLIB:RegisterMenu("fishing_bucket", MENU)