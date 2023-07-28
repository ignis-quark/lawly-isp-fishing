ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Fishing Bucket"
ENT.Spawnable = true

ENT.Model = "models/props_junk/MetalBucket01a.mdl"

ENT.StoredItems = {}

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "ItemCount")
end
