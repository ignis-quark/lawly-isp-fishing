SWEP.LastAimSelect = CurTime()
local AimLoc = Vector(0,0,0)
local randOffset = Vector(0,0,0)
local smoothApproachX = 0
local smoothApproachY = 0

SWEP.WhiteColor = Color(255,255,255)
SWEP.RedColor = Color(255,0,0)

function SWEP:DrawHUD()
    draw.NoTexture()
    if !self:GetBucket() then
        draw.SimpleTextOutlined("No bucket detected. Catch and Release only.", "DermaDefault", ScrW()/2 - 20, ScrH()/2, self.WhiteColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, self.RedColor)
    end
    if self:GetStartChargeTime() != 0 then
        local chargeRatio = math.Clamp((CurTime() - self:GetStartChargeTime()) / self.MaxChargeTime, 0, 1)
        local StrengthHeight = ScrH() * 0.2 * chargeRatio
        surface.SetDrawColor(255*chargeRatio, 255 - 255*chargeRatio, 0, 180)
        surface.DrawRect(ScrW()*0.3, ScrH()*0.6 - StrengthHeight, ScrW()*0.01, StrengthHeight)
    end

    if !IsValid(self:GetBobber()) then return end
end