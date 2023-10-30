local MENU = {}
local PNL = nil

function MENU:CreateMenu(ent, tbl, menu)
    PNL = vgui.Create("LFrame")
    PNL:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    PNL:Center()
    PNL:SetTitle("Storage Crate: Items in here will persist among any of your storage crates.")
end

LAWLIB:RegisterMenu("fishing_storage", MENU)