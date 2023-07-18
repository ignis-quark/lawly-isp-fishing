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
SWEP.SpoolSound = Sound("npc/stalker/wood_strain6.wav")
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
SWEP.MinWait = 10
SWEP.MaxWait = 30
SWEP.BobTime = 0
SWEP.LastNibble = 0
SWEP.NibblePullWindow = 2
SWEP.HookedItem = nil

-- :)
function SWEP:SpoolSoundRandom()
    local rnd = math.random(0,1000)
    if rnd <= 1 then return self.JumpscareSound end
    return self.SpoolSound
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "StartChargeTime")
end

if CLIENT then
    function SWEP:DrawHUD()
        draw.NoTexture()
        if self:GetStartChargeTime() != 0 then
            local chargeRatio = math.Clamp((CurTime() - self:GetStartChargeTime()) / self.MaxChargeTime, 0, 1)
            local StrengthHeight = ScrH() * 0.2 * chargeRatio
            surface.SetDrawColor(255*chargeRatio, 255 - 255*chargeRatio, 0, 180)
            surface.DrawRect(ScrW()*0.3, ScrH()*0.6 - StrengthHeight, ScrW()*0.01, StrengthHeight)
        end
    end
    return
end

--NO CLIENT REALM BEYOND THIS POINT

function SWEP:PrimaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    if self.LineStatus == "Out" then self:TugLine() end
end

function SWEP:TugLine()
    if self.LastNibble + self.NibblePullWindow < CurTime() then return end
    self.LineStatus = "ItemHooked"
    self.HookedItem = ents.Create("lawly_fishing_item")
    self.HookedItem:SetPos(self.Bobber:GetPos())
    self.HookedItem:SetParent(self.Bobber)
end

function SWEP:ThrowLine()
    self.LineStatus = "ThrowingOut"
    self.BobberPlaceTime = CurTime()

    local ply = self.Owner
    self:EmitSound(self.ThrowSound)

    local throwSpeed = self.ThrowStrength * self.ChargeTime

    if SERVER then
        MsgN("Creating Bobber")
        self.Bobber = ents.Create("lawly_fishing_bobber")
        self.Bobber:SetPos(self.Owner:EyePos() + ply:EyeAngles():Forward() * 40)
        self.Bobber:Spawn()
        self.Bobber:PhysWake()
        self.Bobber:GetPhysicsObject():SetVelocity(ply:EyeAngles():Forward() * throwSpeed)
        self.Bobber:GetPhysicsObject():SetBuoyancyRatio(1)

        local handBone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
        self.Line = constraint.CreateKeyframeRope( self:GetPos(), 1, "cable/cable2", nil, self.Owner, self.Owner:WorldToLocal(self.Owner:GetBonePosition(handBone)), handBone, self.Bobber, Vector(0,0,0), 0)
    end
end

function SWEP:GetBucket()
    for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 50)) do
        if ent:GetClass() != "lawly_fishing_bucket" then continue end
    end
end

function SWEP:ReturnLine()
    self:EmitSound(self:SpoolSoundRandom())
    self.LineStatus = "PullingIn"
    if IsValid(self.Bobber) and self.LineStatus == "PullingIn" then 
        self.Bobber:GetPhysicsObject():SetVelocity((self.Owner:GetPos() - self.Bobber:GetPos() + Vector(0,0,self.BobberDist/3))*2)
        timer.Simple(2, function()
            if IsValid(self.HookedItem) and IsValid(self:GetBucket()) then self.Bucket:AddItem(self.HookedItem) end
            self.Bobber:Remove()
            self.LineStatus = "In"
        end)
    end
    self.BobberPlaceTime = 0
    self.ChargeTime = 0
end

function SWEP:Think()
    self:Input()

    --Check for when bobber lands in water
    if self.LineStatus == "ThrowingOut" then
        if self.Bobber:IsInWater() then
            MsgN("Line Out")
            self.LineStatus = "Out"
            self:StopSound(self.ThrowSound)
            self:EmitSound(self.TaughtSound)
            self:CalcNextRandTime()
        end
    end

    --Bit of cleanup in case one or the other is removed.
    local bobberExists = IsValid(self.Bobber)
    local lineExists = IsValid(self.Line)

    if !lineExists or !bobberExists then
        if bobberExists then self.Bobber:Remove() end
        if lineExists then self.Line:Remove() end
        return
    end

    --Adjust rope length, and check for cast timeout
    self.BobberDist = self:GetPos():Distance(self.Bobber:GetPos())
    self.Line:SetKeyValue( "length", self.BobberDist + 80 )
    if self.LineStatus == "ThrowingOut" and self.BobberPlaceTime < CurTime() - self.CastTime then
        self.LineStatus = "InvalidPlacement"
        self:ReturnLine()
    end
end



function SWEP:Input()
    local MousePress = self.Owner:KeyPressed(IN_ATTACK)
    local MouseRelease = self.Owner:KeyReleased(IN_ATTACK)
    
    --Start charging throw, holding LMB
    if MousePress and self.LineStatus == "In" then
        MsgN("Charging")
        self.Charging = CurTime()
        self:SetStartChargeTime(self.Charging)
    end
    --Return line on LMB
    if MousePress and self.LineStatus == "Out" then
        MsgN("Returned")
        self:ReturnLine()
    end
    --Throw line after charging
    if MouseRelease and self.Charging > 0 then
        MsgN("Throwing")
        self.ChargeTime = math.min(CurTime() - self.Charging, self.MaxChargeTime)
        self.Charging = 0
        self:SetStartChargeTime(self.Charging)
        self:ThrowLine()
    end

    self:DoCatchTimer()
end

function SWEP:CalcNextRandTime()
    self.RandNibbleTime = math.Rand(self.MinWait, self.MaxWait) + self.BobberPlaceTime
end

function SWEP:DoCatchTimer()
    if self.LineStatus != "Out" then return end
    if self.RandNibbleTime > CurTime() or self.RandNibbleTime == 0 then return end
    self:NibbleLine()
end

function SWEP:NibbleLine()
    self.Bobber:GetPhysicsObject():SetVelocity(Vector(0,0,-100))
    self:CalcNextRandTime()
    self.LastNibble = CurTime()
end