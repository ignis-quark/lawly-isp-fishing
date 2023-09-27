SWEP.LastAimSelect = CurTime()
local AimLoc = Vector(0,0,0)
local randOffset = Vector(0,0,0)
local smoothApproachX = 0
local smoothApproachY = 0

local barX, barY = ScrW()*0.4, ScrH()*0.4
local barW, barH = ScrW()*0.01, ScrH() * 0.2

function SWEP:DrawHUD()
    draw.NoTexture()
    if !self:GetBucket() then
        draw.SimpleTextOutlined("No bucket with space available. Catch and Release only.", "DermaDefault", ScrW()/2, ScrH()/2 - 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_red)
    end
    if self:GetStartChargeTime() != 0 then
        local chargeRatio = math.Clamp((CurTime() - self:GetStartChargeTime()) / self.MaxChargeTime, 0, 1)
        local StrengthHeight = barH * chargeRatio
        surface.SetDrawColor(0,0,0,200)
        surface.DrawOutlinedRect(barX-2, barY-2, barW+4, barH+4, 2)
        surface.SetDrawColor(39,39,39,200)
        surface.DrawRect(barX-2, barY-2, barW+4, barH+4)
        surface.SetDrawColor(255*math.floor(chargeRatio), 255 - 255*math.floor(chargeRatio), 255 - 255*math.floor(chargeRatio), 180)
        surface.DrawRect(barX, ScrH()*0.6 - StrengthHeight, barW, StrengthHeight)
    end

    if !IsValid(self:GetBobber()) then return end
end