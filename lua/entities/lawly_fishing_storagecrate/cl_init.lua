include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    local pos = self:GetPos()
    local ang = Angle(0,LocalPlayer():EyeAngles().y-90,90)

    cam.Start3D2D(pos + Vector(0,0,80), ang, 0.1)
        draw.NoTexture()
        surface.SetDrawColor(0,0,0, 200)
        surface.DrawRect(-120,-30,240,60)
        draw.SimpleTextOutlined("Storage Crate", "DermaLarge", 0, 0, color_cyan, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
    cam.End3D2D()
end