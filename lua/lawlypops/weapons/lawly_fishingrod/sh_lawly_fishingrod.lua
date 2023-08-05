SWEP.PrintName = "Fishing Rod"
SWEP.Category = "Fishing"
SWEP.Author = "Lawlypops"
SWEP.Spawnable = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		    = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

SWEP.Weight			    = 5

SWEP.Slot			    = 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.ThrowSound = Sound("weapons/tripwire/ropeshoot.wav")
SWEP.TaughtSound = Sound("physics/wood/wood_strain7.wav")
SWEP.SpoolSound = Sound("physics/wood/wood_strain6.wav")
SWEP.JumpscareSound = Sound("npc/stalker/go_alert2.wav")

SWEP.LineStatus = "In" // In, Out, ThrowingOut, PullingIn, ItemHooked
SWEP.Catch = nil
SWEP.Bobber = nil
SWEP.Line = nil
SWEP.ThrowStrength = 500 -- Multiplier for physics, based on charge time

SWEP.CastTime = 4 -- How long to wait for water before auto-reeling.
SWEP.BobberPlaceTime = 0 -- When the bobber hit water

SWEP.MaxChargeTime = 3
SWEP.ChargeTime = 0
SWEP.Charging = 0

SWEP.RandNibbleTime = 0
SWEP.MinWait = 1
SWEP.MaxWait = 2
SWEP.BobTime = 0
SWEP.LastNibble = 0
SWEP.NibblePullWindow = 2
SWEP.HookedItem = nil

SWEP.BobberDist = 0
SWEP.BobberOffset = Vector(0,0,0)
SWEP.RemoveBobberTime = 2

SWEP.Bucket = nil

SWEP.DebugMode = true

function SWEP:Debug(text)
    if !self.DebugMode then return end
    MsgN(text)
end

-- :)
function SWEP:SpoolSoundRandom()
    local rnd = math.random(0,1000)
    if rnd <= 1 then return self.JumpscareSound end
    return self.SpoolSound
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "StartChargeTime")
    self:NetworkVar("Entity", 0, "Bobber")
end

function SWEP:GetBucket()
    for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 150)) do
        if ent:GetClass() != "lawly_fishing_bucket" or ent:GetItemCount() >= LAWLYFISH.BucketCapacity then continue end
        self.Bucket = ent
        return true
    end
    return false
end