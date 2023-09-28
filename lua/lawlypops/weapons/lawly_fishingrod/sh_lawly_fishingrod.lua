SWEP.PrintName = "Fishing Rod"
SWEP.Category = "Fishing"
SWEP.Author = "Lawlypops"
SWEP.Spawnable = true
SWEP.Instructions = "Hold left click to cast. Right click when the bobber is pulled under to catch! You need a bucket near you."

SWEP.ViewModel = "models/weapons/lawlypops/c_fishing_rod.mdl"
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

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
SWEP.SpoolSounds = {
    Sound("physics/wood/wood_strain6.wav")
}

--Configurable Options
SWEP.CastTime = LAWLYFISH.CastTime -- How long to wait for water before auto-reeling.
SWEP.ThrowStrength = LAWLYFISH.ThrowStrength -- Multiplier for physics, based on charge time
SWEP.MaxChargeTime = LAWLYFISH.ChargeTime
SWEP.MinWait = LAWLYFISH.WaitTime[1]
SWEP.MaxWait = LAWLYFISH.WaitTime[2]
SWEP.NibblePullWindow = LAWLYFISH.CatchWindow
SWEP.DebugMode = false

--SWEP Variables
SWEP.LineStatus = "In" // In, Out, ThrowingOut, PullingIn, ItemHooked
SWEP.Catch = nil
SWEP.Bobber = nil
SWEP.Line = nil

SWEP.BobberPlaceTime = 0 -- When the bobber hit water

SWEP.ChargeTime = 0
SWEP.Charging = 0

SWEP.RandNibbleTime = 0
SWEP.BobTime = 0
SWEP.LastNibble = 0
SWEP.HookedItem = nil

SWEP.BobberDist = 0
SWEP.BobberOffset = Vector(0,0,0)
SWEP.RemoveBobberTime = 2

SWEP.Bucket = nil

function SWEP:UpdateConfig()
    self.CastTime = LAWLYFISH.CastTime
    self.ThrowStrength = LAWLYFISH.ThrowStrength
    self.MaxChargeTime = LAWLYFISH.ChargeTime
    self.MinWait = LAWLYFISH.WaitTime[1]
    self.MaxWait = LAWLYFISH.WaitTime[2]
    self.NibblePullWindow = LAWLYFISH.CatchWindow
end

function SWEP:PrimaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    return false
end

function SWEP:Reload()
    return false
end

function SWEP:Idle()

	-- Update idle anim
	local curtime = CurTime()

	if ( curtime < self:GetNextIdle() ) then return false end

	self:SendWeaponAnim( ACT_VM_IDLE )
	self:SetNextIdle( curtime + self:SequenceDuration() )

	return true

end

function SWEP:Deploy()
    self:SetDeploySpeed(0.5)
    self:SendWeaponAnim( ACT_VM_DEPLOY )
    self:UpdateConfig()
end

function SWEP:Debug(text)
    if !self.DebugMode then return end
    MsgN(text)
end

-- :)
function SWEP:SpoolSoundRandom()
    return self.SpoolSounds[math.random(#self.SpoolSounds)]
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "StartChargeTime")
    self:NetworkVar("Entity", 0, "Bobber")
end

function SWEP:GetBucket()
    for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 150)) do
        if ent:GetClass() != "lawly_fishing_bucket" or ent:GetNWEntity("Owner") != self.Owner or ent:GetItemCount() >= LAWLYFISH.BucketCapacity then continue end
        self.Bucket = ent
        return true
    end
    return false
end