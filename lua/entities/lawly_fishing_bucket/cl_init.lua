include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
end

ENT.TextColor = Color(255,255,255)

function ENT:RequestItemList()
    
end


function ENT:Draw()
    self:DrawModel()
    local pos = self:GetPos()
    local ang = self:GetAngles()

    ang:RotateAroundAxis(ang:Right(), 90)
    ang:RotateAroundAxis(ang:Up(), -90)
    ang.y = LocalPlayer():EyeAngles().y - 90
    
    cam.Start3D2D(pos + self:GetUp() * 20, ang, 0.1)
        surface.SetDrawColor(0,0,0, 200)
        surface.DrawRect(-100,0,200,100)
        draw.SimpleText("Stored Items:", "DermaDefault", 0, 0, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(self:GetItemCount(), "DermaDefault", 0, 20, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    cam.End3D2D()
end