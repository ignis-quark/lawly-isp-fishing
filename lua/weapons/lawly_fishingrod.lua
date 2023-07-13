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

SWEP.ThrowSound = Sound("ambient/machines/squeak_1.wav")
SWEP.SpoolSound = Sound("combined/eli_lab/eli_lab_eli_surface_cc.wav")

SWEP.LineStatus = "In" // In, Out, Moving
SWEP.Catch = nil
SWEP.Bobber = nil
SWEP.Line = nil
SWEP.ThrowStrength = 500

SWEP.CastTime = 1 -- How long to wait before letting the bobber be pulled back in.
SWEP.BobberPlaceTime = 0

SWEP.MaxChargeTime = 3
SWEP.ChargeTime = 0
SWEP.Charging = 0

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "StartChargeTime")
end

if CLIENT then
    function SWEP:DrawHUD()
        draw.NoTexture()
        surface.SetDrawColor(200,0,100, 180)
        if self:GetStartChargeTime() != 0 then
            local StrengthHeight = ScrH()*0.2 * math.Clamp((CurTime() - self:GetStartChargeTime()) / self.MaxChargeTime, 0, 1)
            surface.DrawRect(ScrW()*0.3, ScrH()*0.6 - StrengthHeight, ScrW()*0.01, StrengthHeight)
        end
    end
    return
end

function SWEP:PrimaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    if self.LineStatus == "Out" then self:TugLine() end
end

function SWEP:TugLine()

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

function SWEP:ReturnLine()
    self:EmitSound(self.SpoolSound)
    if IsValid(self.Bobber) then 
        self.Bobber:GetPhysicsObject():SetVelocity((self.Owner:GetPos() - self.Bobber:GetPos() + Vector(0,0,self.BobberDist/3))*2)
        timer.Simple(2, function()
            self.Bobber:Remove()
        end)
    end
    self.LineStatus = "In"
    self.BobberPlaceTime = 0
    self.ChargeTime = 0
end

function SWEP:Think()
    local MousePress = self.Owner:KeyPressed(IN_ATTACK)
    local MouseRelease = self.Owner:KeyReleased(IN_ATTACK)

    if MousePress and self.LineStatus == "In" then
        MsgN("Charging")
        self.Charging = CurTime()
        self:SetStartChargeTime(self.Charging)
    end
    if MousePress and self.LineStatus == "Out" then
        MsgN("Returned")
        self:ReturnLine()
    end
    if MouseRelease and self.Charging > 0 then
        MsgN("Throwing")
        self.ChargeTime = math.min(CurTime() - self.Charging, self.MaxChargeTime)
        self.Charging = 0
        self:SetStartChargeTime(self.Charging)
        self:ThrowLine()
    end
    if self.LineStatus == "ThrowingOut" and self.BobberPlaceTime < CurTime() - self.CastTime then
        MsgN("Line Out")
        self.LineStatus = "Out"
    end
    if IsValid(self.Line) and IsValid(self.Bobber) then
        self.BobberDist = self:GetPos():Distance(self.Bobber:GetPos())
        self.Line:SetKeyValue( "length", self.BobberDist + 80 )
    end
end