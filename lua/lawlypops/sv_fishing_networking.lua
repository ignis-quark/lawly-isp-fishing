util.AddNetworkString("lawly_fishing_senddata")

net.Receive("lawly_fishing_senddata", function(len, ply)
    local ent = net.ReadEntity()
    if !IsValid(ent) then return end
    ent:RequestItemList(ply)
end)