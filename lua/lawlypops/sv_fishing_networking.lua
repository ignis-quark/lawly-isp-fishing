resource.AddFile("models/lawlypops/fish/carp.mdl")
resource.AddFile("models/lawlypops/fish/anabass.mdl")
resource.AddFile("models/lawlypops/fish/basa.mdl")
resource.AddFile("models/lawlypops/fish/bluefin_tuna.mdl")
resource.AddFile("models/weapons/lawlypops/c_fishing_rod.mdl")
resource.AddFile("materials/models/lawlypops/fish/fish_mod_trimsheet.vmt")
resource.AddFile("materials/models/weapons/lawlypops/fishing_rod/diff_c_fishing_rod.vmt")

util.AddNetworkString("lawly_fishing_sell_items")

net.Receive("lawly_fishing_sell_items", function(len, ply)
    local ent = net.ReadEntity()
    local cmd = net.ReadUInt(2)
    if !IsValid(ent) then return end
    if !ent:CheckForShop(ply) then return end
    if cmd == 0 then --Sell All
        ent:SellAll(ply)
    elseif cmd == 1 then --Sell Trash
        ent:SellTrashOnly(ply)
    elseif cmd == 2 then --Sell Specific Item
        local index = net.ReadUInt(16) + 1
        ent:SellItem(ply, index)
    end
end)