AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Cookware = {}

function ENT:DetachTank()
    local ent = self:GetTank()
    if !IsValid(ent) then return end
    ent:SetParent(nil)
    ent:SetPos(self.TankPos + self:GetRight()*-20)
    ent:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav")
    self:SetTank(nil)
end

function ENT:CanRun()
    return IsValid(self:GetTank()) and self:GetTank():GetFuel() > 0
end

function ENT:LookForTank()
    if IsValid(self:GetTank()) then return end
    for _, ent in ipairs(ents.FindInSphere(self.TankPos, self.TankRadius)) do
        if ent:GetClass() != "lawly_fishing_propane" then continue end
        self:SetTank(ent)
        ent:SetPos(self.TankPos)
        ent:SetAngles(self:GetAngles())
        ent:SetParent(self)
        ent:EmitSound("physics/metal/metal_canister_impact_soft" .. math.random(1,3) .. ".wav")
        ent:SetStove(self)
        break
    end
end

function ENT:LookForCookware()
    for _, ent in ipairs(ents.FindInSphere(self.CookTopPos, self.CookTopRadius)) do
        if ent:GetClass() != "lawly_fishing_cookware" then continue end
        ent:HeatUp()
    end
end

function ENT:Cook()
    if self:GetRunning() and !self:CanRun() then 
        self:StopSound(self.FireSound)
        self:SetRunning(false)
        return
    end
    if !self:GetRunning() then return end
    local tank = self:GetTank()
    tank:SetFuel(math.max(0, tank:GetFuel()-1))
end

function ENT:Use()
    self:SetRunning(self:GetRunning() == false and self:CanRun())
    if self:GetRunning() and IsValid(self:GetTank()) then
        self:EmitSound("ambient/fire/mtov_flame2.wav")
        self:EmitSound(self.FireSound)
    else
        self:EmitSound("ambient/machines/squeak_7.wav")
        self:StopSound(self.FireSound)
    end
end