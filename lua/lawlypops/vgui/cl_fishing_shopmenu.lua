LAWLYFISH = LAWLYFISH or {}
local MENU = {}
local PNL = nil
MENU.Entity = nil
MENU.Buckets = {}
MENU.BucketSelection = 0

MENU.ShopMonologue = {
    "Just here to do some shopping?",
    "What can I get for ya?",
    "You're gonna need a pole, right?",
    "I hear the fishing is quite good today.",
    "Awwww, you're a cute horse aren't ya?",
    "Good seeing you!",
    "How's your " .. LAWLIB:GetTimePhrase(true) .. " going?",
    "Having a good " .. LAWLIB:GetTimePhrase(true) .. "?",
    "I've got wares, if you've got coin. Or fish.",
    "Not much on the shelf today, but it should get you started.",
    "Remember, you can bring your fish here to sell it!",
    "No fish this " .. LAWLIB:GetTimePhrase(true) .. "?",
    "I heard someone caught a \"Holy Mackerel\". Sounds fishy to me though."
}

function MENU:PurchaseItem(item)
    if DarkRP then
        local money = 1
    end
end

function MENU:FindBucket()
    table.Empty(MENU.Buckets)
    for _, ent in ipairs(ents.FindInSphere(MENU.Entity:GetPos(), LAWLYFISH.SellDistance)) do
        if ent:GetClass() != "lawly_fishing_bucket" then continue end
        table.insert(MENU.Buckets, ent)
        if #MENU.Buckets >= 99 then break end
    end
    return #MENU.Buckets > 0
end

function MENU:NewBuyButton(tbl, itemID)
    local _pnl = vgui.Create("LButton", PNL)
    _pnl:Dock(TOP)
    _pnl:SetText(tbl.Name)
    _pnl:SetFont("DermaLarge")
    _pnl:SetTall(40)
    _pnl.BuyItem = itemID
    
    function _pnl:OnMousePressed()
        LAWLIB:PurchaseItem(self.BuyItem, MENU.Entity:GetPos() + MENU.Entity:GetForward()*30 + Vector(0,0,20))
    end

    return _pnl
end

function MENU:CreateMenu(ent)
    MENU.Entity = ent

    PNL = vgui.Create("LFrame")
    PNL:SetTitle("Bait and Tackle Shop")
    PNL:SetSize(ScrW()*0.8, ScrH()*0.8)
    PNL:Center()
    PNL:MakePopup()
    
    PNL.GreetingText = vgui.Create("DLabel", PNL)
    PNL.GreetingText:Dock(TOP)
    PNL.GreetingText:SetText(MENU.ShopMonologue[math.random(#MENU.ShopMonologue)])
    PNL.GreetingText:SetFont("DermaLarge")
    PNL.GreetingText:SizeToContentsY()
    PNL.GreetingText:SetPaintBackground(true)
    PNL.GreetingText:SetBGColor(Color(49,49,49))
    local bCount = 0
    if self:FindBucket() then
        bCount = #MENU.Buckets
        if bCount == 1 then
            PNL.GreetingText:SetText("That's a lovely bucket my friend.")
        elseif bCount <= 3 then
            PNL.GreetingText:SetText("Quite a catch today huh?")
        elseif bCount <= 6 then
            PNL.GreetingText:SetText("How many buckets do you need?")
        else
            PNL.GreetingText:SetText("Dear God...")
        end
        self.BucketSelection = 1
    else
        self.BucketSelection = 0
    end

    PNL.BucketSelectionFrame = vgui.Create("DPanel", PNL)
    PNL.BucketSelectionFrame:Dock(TOP)
    PNL.BucketSelectionFrame:SetTall(30)
    PNL.BucketSelectionFrame:SetBackgroundColor(Color(59,59,59))

    PNL.BucketSelectBtnP = vgui.Create("LButton", PNL.BucketSelectionFrame)
    PNL.BucketSelectBtnP:Dock(LEFT)
    PNL.BucketSelectBtnP:SetText(" < ")
    PNL.BucketSelectBtnP:SetFont("DermaLarge")
    PNL.BucketSelectBtnP:SizeToContentsX()
    function PNL.BucketSelectBtnP:OnMousePressed()
        MENU.BucketSelection = MENU.BucketSelection - 1
        if MENU.BucketSelection < 1 then
            MENU.BucketSelection = bCount
        end
        PNL.BucketSelectText:UpdateText()
    end
    
    PNL.BucketSelectText = vgui.Create("DLabel", PNL.BucketSelectionFrame)
    PNL.BucketSelectText:DockMargin(5,0,5,0)
    PNL.BucketSelectText:Dock(LEFT)
    PNL.BucketSelectText:SetFont("DermaLarge")
    PNL.BucketSelectText:SetText("Bucket 10/10")
    PNL.BucketSelectText:SetContentAlignment(5)
    PNL.BucketSelectText:SizeToContentsX()
    function PNL.BucketSelectText:UpdateText()
        self:SetText("Bucket " .. MENU.BucketSelection .. "/" .. bCount)
    end
    PNL.BucketSelectText:UpdateText()

    PNL.BucketSelectBtnN = vgui.Create("LButton", PNL.BucketSelectionFrame)
    PNL.BucketSelectBtnN:Dock(LEFT)
    PNL.BucketSelectBtnN:SetText(" > ")
    PNL.BucketSelectBtnN:SetFont("DermaLarge")
    PNL.BucketSelectBtnN:SizeToContentsX()
    function PNL.BucketSelectBtnN:OnMousePressed()
        MENU.BucketSelection = MENU.BucketSelection + 1
        if MENU.BucketSelection > bCount then
            MENU.BucketSelection = math.min(1,bCount)
        end
        PNL.BucketSelectText:UpdateText()
    end

    PNL.BucketSelectBtnMenu = vgui.Create("LButton", PNL.BucketSelectionFrame)
    PNL.BucketSelectBtnMenu:DockMargin(10,0,0,0)
    PNL.BucketSelectBtnMenu:Dock(LEFT)
    PNL.BucketSelectBtnMenu:SetText(" SELECT ")
    PNL.BucketSelectBtnMenu:SetFont("DermaLarge")
    PNL.BucketSelectBtnMenu:SizeToContentsX()

    function PNL.BucketSelectBtnMenu:OnMousePressed()
        local bucket = MENU.Buckets[MENU.BucketSelection]
        if IsValid(bucket) then 
            PNL:Remove()
            LAWLIB:OpenEntMenu(bucket, "shopbuttons")
        end
    end

    if bCount == 0 then
        PNL.BucketSelectionFrame:SetVisible(false)
    end

    PNL.BuyLabel = vgui.Create("DLabel", PNL)
    PNL.BuyLabel:Dock(TOP)
    PNL.BuyLabel:DockMargin(0,20,0,20)
    PNL.BuyLabel:SetFont("DermaLarge")
    PNL.BuyLabel:SizeToContentsY()
    PNL.BuyLabel:SetText("Here's What I'm Selling:")

    PNL.BuyButtons = {}

    for itemID, tbl in pairs(LAWLYFISH.ShopList) do
        table.insert(PNL.BuyButtons, self:NewBuyButton(tbl, itemID))
    end
end

LAWLIB:RegisterMenu("fishing_shop", MENU)