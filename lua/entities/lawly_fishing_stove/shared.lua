ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Stove"
ENT.Spawnable = true
ENT.Category = "Fishing"

ENT.Model = "models/props_wasteland/kitchen_stove001a.mdl"
ENT.FireSound = "ambient/fire/fire_big_loop1.wav"

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Running")
    self:NetworkVar("Entity", 0, "Tank")
    if SERVER then
        self:SetRunning(false)
    end
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    if SERVER then
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
    end
end

ENT.LastUpdatePosition = nil

function ENT:CalculatePositions()
    local pos = self:GetPos()
    self.CookTopPos = pos + self:GetUp()*self.CookTopOffset.z + self:GetRight()*self.CookTopOffset.x + self:GetForward()*self.CookTopOffset.y
    self.TankPos = pos + self:GetUp()*self.TankOffset.z + self:GetRight()*self.TankOffset.x + self:GetForward()*self.TankOffset.y
    if SERVER then return end
    self.ScreenPos = pos + self:GetUp()*self.ScreenOffset.z + self:GetRight()*self.ScreenOffset.x + self:GetForward()*self.ScreenOffset.y
    self.ScreenAngle = self:GetAngles()
    self.ScreenAngle:RotateAroundAxis(self:GetForward(), 90)
    self.ScreenAngle:RotateAroundAxis(self:GetUp(), 90)
    self.ScreenAngle:RotateAroundAxis(self:GetRight(), 8)
end

function ENT:CreateClientProp()
    if !IsValid(self.TankVisual) then
        self.TankVisual = ClientsideModel("models/props_junk/PropaneCanister001a.mdl", RENDERGROUP_OPAQUE)
        self.TankVisual:SetPos(self.TankPos)
        self.TankVisual:SetAngles(self:GetAngles())
        self.TankVisual:SetParent(self)
        self.TankVisual:SetMaterial("models/wireframe")
    end
end

function ENT:Think()
    local pos = self:GetPos()
    if self.LastUpdatePosition != pos then
        self:CalculatePositions()
        self.LastUpdatePosition = pos
    end

    if CLIENT then
        if !IsValid(self:GetTank()) then
            self:CreateClientProp()
        else
            self.TankVisual:Remove()
        end
        return true
    end
    self:NextThink(CurTime()+0.5)
    self:LookForTank()
    self:LookForCookware()
    self:Cook()
    return true
end

function ENT:OnRemove()
    self:StopSound(self.FireSound)
    if IsValid(self.TankVisual) then
        self.TankVisual:Remove()
    end
    if SERVER then
        self:DetachTank()
    end
end

ENT.CookTopRadius = 15
ENT.CookTopOffset = Vector(-18,0,40)
ENT.CookTopPos = nil

ENT.TankRadius = 10
ENT.TankOffset = Vector(-45,0,15)
ENT.TankPos = nil

ENT.ScreenOffset = Vector(19,14.5,45)
ENT.ScreenPos = nil
ENT.ScreenAngle = nil