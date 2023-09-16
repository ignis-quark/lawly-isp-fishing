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
    "Awwww, you're a cute critter aren't ya?",
    "Good seeing you!",
    "How's your " .. LAWLIB:GetTimePhrase(true) .. " going?",
    "Having a good " .. LAWLIB:GetTimePhrase(true) .. "?",
    "I've got wares, if you've got coin. Or fish.",
    "Not much on the shelf today, but it should get you started.",
    "Remember, you can bring your fish here to sell it!",
    "No fish this " .. LAWLIB:GetTimePhrase(true) .. "?",
    "I heard someone caught a \"Holy Mackerel\". Sounds fishy to me though.",
    "Hey, how's it goin'?",
    "Sellin' anything fishy?",
    "Hello my friend.",
    "Someone sold my wife...",
    "There isn't any internet out here...",
    "You got games on yo' phone?",
    
    "I may sell bait in the future."
}

function MENU:PurchaseItem(item)
    if DarkRP then
        local money = 1
    end
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
    
    PNL.BuyLabel = vgui.Create("DLabel", PNL)
    PNL.BuyLabel:Dock(TOP)
    PNL.BuyLabel:DockMargin(0,20,0,20)
    PNL.BuyLabel:SetFont("DermaLarge")
    PNL.BuyLabel:SizeToContentsY()
    PNL.BuyLabel:SetText("Items for Sale to come...")

    PNL.BuyButtons = {}

    //for itemID, tbl in pairs(LAWLYFISH.ShopList) do
    //    table.insert(PNL.BuyButtons, self:NewBuyButton(tbl, itemID))
    //end
end

LAWLIB:RegisterMenu("fishing_shop", MENU)