LAWLYFISH = LAWLYFISH or {}
local MENU = {}
local PNL = nil

function MENU:CreateMenu(ent)
    PNL = vgui.Create("LFrame")
    PNL:SetTitle("Bait and Tackle Shop")
    PNL:SetSize(ScrW()*0.8, ScrH()*0.8)
    PNL:Center()
    PNL:MakePopup()
end

LAWLIB:RegisterMenu("fishing_shop", MENU)