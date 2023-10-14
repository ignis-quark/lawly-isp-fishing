AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Propane Tank"
ENT.Category = "Fishing"
ENT.Spawnable = true

ENT.Model = "models/props_junk/PropaneCanister001a.mdl"

ENT.Stove = nil

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Fuel")

    if SERVER then
        self:SetFuel(500)
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

function ENT:SetStove(ent)
    self.Stove = ent
end

function ENT:GetPercent()
    return self:GetFuel() / 500
end

if CLIENT then return end

ENT.NextUse = CurTime()

function ENT:Use(ply)
    if self.NextUse > CurTime() then return end
    self.NextUse = CurTime() + 1
    if IsValid(self.Stove) then
        self.Stove:DetachTank()
        self.Stove = nil
    else
        local perc = math.floor(self:GetPercent()*100)
        if perc == 100 then
            ply:ChatPrint("It sounds full.")
        elseif perc == 0 then
            ply:ChatPrint("It sounds empty.")
        else
            ply:ChatPrint("It's about " .. perc .. "% full.")
        end
        self:EmitSound("physics/metal/metal_canister_impact_soft" .. math.random(1,3) .. ".wav")
    end
end