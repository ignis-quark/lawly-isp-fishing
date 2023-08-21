LAWLYFISH = LAWLYFISH or {}

LAWLYFISH.ShopList = {}

LAWLYFISH.ShopList["bucket"] = {Name="Fishing Bucket", Cost=2000, Class="lawly_fishing_bucket", Type="entity"}
LAWLYFISH.ShopList["pole"] = {Name="Fishing Pole", Cost=500, Class="lawly_fishingrod", Type="weapon"}

if SERVER then
    timer.Simple(3, function()
        for itemID, tbl in pairs(LAWLYFISH.ShopList) do
            LAWLIB:AddShopItem(itemID, tbl.Name, tbl.Cost, tbl.Type, tbl.Class)
        end
    end)
end