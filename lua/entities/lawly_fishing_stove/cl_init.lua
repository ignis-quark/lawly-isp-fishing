include("shared.lua")

ENT.OnColor = Color(0,30,0,255)
ENT.OffColor = Color(30,0,0,255)
ENT.FuelBGColor = Color(40,40,0)
ENT.FuelColor = Color(177,177,0)

function ENT:Draw()
    self:DrawModel()
    render.DrawWireframeSphere(self.CookTopPos, self.CookTopRadius, 10, 10, color_white, true)
    local screenWidth = 400
    cam.Start3D2D(self.ScreenPos, self.ScreenAngle, 0.05)
        draw.NoTexture()
        if self:GetRunning() then
            surface.SetDrawColor(self.OnColor)
        else
            surface.SetDrawColor(self.OffColor)
        end
        surface.DrawRect(-screenWidth/2,0,screenWidth,124)
        surface.SetDrawColor(color_white)
        surface.DrawOutlinedRect(-screenWidth/2, 0, screenWidth, 124, 5)
        draw.SimpleTextOutlined("Fishing Stove", "DermaLarge", 0, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
        surface.SetDrawColor(self.FuelBGColor)
        surface.DrawRect(-screenWidth/2+10, 45, screenWidth-20, 27)
        local fuelPerc = 0
        if IsValid(self:GetTank()) then
            fuelPerc = (self:GetTank():GetFuel()/500)
            surface.SetDrawColor(self.FuelColor)
            surface.DrawRect(-screenWidth/2+10, 45, (screenWidth-20) * fuelPerc, 27)
        end
        draw.SimpleTextOutlined("Fuel: " .. math.ceil(fuelPerc*100) .. "%", "DermaLarge", 0, 43, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
    cam.End3D2D()
end