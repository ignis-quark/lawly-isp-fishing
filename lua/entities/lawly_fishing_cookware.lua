AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Cookware"
ENT.Category = "Fishing"
ENT.Spawnable = true

ENT.Model = "models/props_c17/metalPot002a.mdl"

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Temp")
    if SERVER then
        self:SetTemp(0)
    end
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
    end
end

if SERVER then
    function ENT:Think()
        self:NextThink(CurTime()+0.5)
        self:SetTemp(math.max(0, self:GetTemp()-1))
        if self:GetTemp() > 20 then
        end
        return true
    end

    function ENT:HeatUp()
        self:SetTemp(math.min(40, self:GetTemp()+3))
    end
end

if SERVER then return end

ENT.LastPos = nil

ENT.ScreenPos = nil
ENT.ScreenAng = nil

function ENT:Draw()
    self:DrawModel()

    if self.LastPos != self:GetPos() then
        self.LastPos = self:GetPos()
        self.ScreenPos = self:GetPos() + Vector(0,0,10) + self:GetForward()*5
    end
    self.ScreenAng = Angle(0,(CurTime()*100)%360,90)

    cam.Start3D2D(self.ScreenPos, self.ScreenAng, 0.1)
        draw.NoTexture()
        surface.SetDrawColor(0,0,0)
        surface.DrawRect(-100,0-25,200,50)
        draw.SimpleText("Temp: " .. self:GetTemp(), "DermaLarge", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end