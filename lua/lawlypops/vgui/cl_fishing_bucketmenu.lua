LAWLYFISH = LAWLYFISH or {}
local MENU = {}
local PNL = nil

MENU.RequiresTable = true

MENU.SortTypes = {
    {Name="RARITY", func=function(tbl) table.SortByMember( tbl, "Weight", true ) end },
    {Name="NAME", func=function(tbl) table.SortByMember( tbl, "Name", true) end },
    {Name="VALUE", func=function(tbl) table.SortByMember( tbl, "Worth", false) end },
    {Name="LENGTH", func=function(tbl) table.SortByMember( tbl, "Length", false) end },
}

function MENU:SelectItem(index)
    if !PNL.ItemViewFrame then return end
    local tbl = MENU.Table[index]
    MsgN("Selecting item of index " .. index)
    MsgN("Table: ")
    PrintTable(tbl)
    
    PNL.ItemTitle:SetText(tbl.Name)

    if tbl.Mdl then
        if tbl.Mdl == "FUCK" then tbl.Mdl = "models/props_phx/facepunch_logo.mdl" end
        PNL.ModelView:SetModel(tbl.Mdl)
        PNL.ModelView:SetVisible(true)
        local ent = PNL.ModelView:GetEntity()
        local scale = ent:GetModelRadius()
        PNL.ModelView:SetCamPos(Vector(scale,scale,scale)*2)
        //PNL.ModelView:SetFOV(scale)
    else
        PNL.ModelView:SetVisible(false)
    end
end

function MENU:CreateMenu(ent, tbl)
    MENU.Entity = ent
    MENU.Table = tbl
    PNL = vgui.Create("LFrame")
    PNL:SetTitle("This... Is a Bucket.")
    PNL:SetTitleHoverText("There's More...")
    PNL:SetSize(ScrW()*0.8, ScrH()*0.8)
    PNL:Center()
    PNL:MakePopup()

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
    end


    PNL.ItemList = vgui.Create("DScrollPanel", PNL.ItemListFrame)
    PNL.ItemList:Dock(FILL)
    PNL.ItemList:SetWide(PNL:GetWide()/2)
    PNL.ItemList:SetBackgroundColor(Color(0,0,0,100))
    PNL.ItemList:SetPaintBackground(true)
    function PNL.ItemList:PopulateList(_tbl)
        self:Clear()
        for i, item in ipairs(_tbl) do
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
                newItem.value = vgui.Create("DLabel", newItem)
                newItem.value:SetText("$"..item.Worth)
                newItem.value:SetFont("DermaLarge")
                newItem.value:SizeToContentsX()
                newItem.value:Dock(RIGHT)
            end
            if item.Length > -1 then
                newItem.len = vgui.Create("DLabel", newItem)
                newItem.len:SetText("Length: " .. math.Round(item.Length, 2) .. "cm")
                newItem.len:SetFont("DermaLarge")
                newItem.len:SizeToContents()
                newItem.len:Center()
            end
            
            if item.Weight then
                local rarity = LAWLYFISH:GetRarity(item.Weight)
                newItem.txt:SetTextColor(LAWLYFISH.Rarities[rarity].Color)
            end
            if item.Class then
                newItem.txt:SetTextColor(Color(255,255,0))
            end
            PNL.ItemList:Add(newItem)
        end
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

    PNL.ItemPrice = vgui.Create("DLabel", PNL.ItemViewFrame)
    PNL.ItemPrice:DockMargin(10,10,0,0)
    PNL.ItemPrice:Dock(TOP)
    PNL.ItemPrice:SetText("$")
    PNL.ItemPrice:SetFont("DermaLarge")
    PNL.ItemPrice:SizeToContentsY()

    PNL.ItemLength = vgui.Create("DLabel", PNL.ItemViewFrame)
    PNL.ItemLength:DockMargin(10,10,0,0)
    PNL.ItemLength:Dock(TOP)
    PNL.ItemLength:SetText("0cm")
    PNL.ItemLength:SetFont("DermaLarge")
    PNL.ItemLength:SizeToContentsY()

    PNL.ItemRarity = vgui.Create("DLabel", PNL.ItemViewFrame)
    PNL.ItemRarity:DockMargin(10,10,0,0)
    PNL.ItemRarity:Dock(TOP)
    PNL.ItemRarity:SetText("0cm")
    PNL.ItemRarity:SetFont("DermaLarge")
    PNL.ItemRarity:SizeToContentsY()

end

LAWLIB:RegisterMenu("fishing_bucket", MENU)