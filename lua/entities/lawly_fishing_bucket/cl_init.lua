include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Draw()
    self:DrawModel()
    local pos = self:GetPos()
    
    if pos:DistToSqr(LocalPlayer():GetPos()) > 10000 then return end
    
    local ang = self:GetAngles()
    local owner = self:GetNWEntity("Owner")

    ang:RotateAroundAxis(ang:Right(), 90)
    ang:RotateAroundAxis(ang:Up(), -90)
    ang.y = LocalPlayer():EyeAngles().y - 90
    
    local stored = self:GetItemCount()

    cam.Start3D2D(pos + self:GetUp() * 20, ang, 0.1)
        surface.SetDrawColor(0,0,0,230)
        surface.DrawRect(-100,0,200,80)
        if IsValid(owner) then
            draw.SimpleText(owner:Nick() .. "'s bucket", "DermaLarge", 0, -40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
        draw.SimpleText("ITEMS:", "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(self:GetItemCount().."/"..LAWLYFISH.BucketCapacity, "DermaLarge", 0, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        surface.SetDrawColor(0,0,0)
        surface.DrawRect(-95,65,190,10)
        if stored >= LAWLYFISH.BucketCapacity then
            surface.SetDrawColor(90,0,0,200)
        else
            surface.SetDrawColor(0,100,0)
        end
        surface.DrawRect(-95,65,190 * math.Clamp(stored/LAWLYFISH.BucketCapacity, 0, 1),10)
    cam.End3D2D()
end