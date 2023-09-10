AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetHullType( HULL_HUMAN )
    self:SetHullSizeNormal()
    self:SetNPCState( NPC_STATE_SCRIPT )
    self:SetSolid( SOLID_BBOX )
    self:CapabilitiesAdd( CAP_ANIMATEDFACE )
    self:CapabilitiesAdd( CAP_TURN_HEAD )
    self:DropToFloor()
    self:SetMaxYawSpeed( 90 )
    self:SetCollisionGroup( 0 )
    self:AddFlags(FL_NOTARGET) // Make enemy NPCs ignore this
    self:SetUseType(SIMPLE_USE)
end

function ENT:OpenMenu(ply)
    LAWLIB:OpenMenu("fishing_shop", ply, self)
end

function ENT:Use(ply)
    self:OpenMenu(ply)
end