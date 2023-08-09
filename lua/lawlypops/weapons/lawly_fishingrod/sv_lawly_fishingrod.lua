
function SWEP:PrimaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    //if self.LineStatus == "Out" then self:TugLine() end
end

function SWEP:TugLine()
    self:Debug("Tugging")
    if !IsValid(self.Bobber) then self:RemoveBobber() return end
    if self.LastNibble + self.NibblePullWindow < CurTime() then return end
    self:Debug("Hooked Item")
    self.LineStatus = "ItemHooked"
    self.HookedItem = LAWLYFISH:CreateRandomItemEnt(self.Bobber:GetPos())
    self.HookedItem:SetParent(self.Bobber)
    self:ReturnLine()
end

--[[ Will be used when more sophisticated catch method is implemented.
function SWEP:TugLine()
    if !IsValid(self.Bobber) then self:RemoveBobber() return end
    local offset = self.BobberOffset
    offset:Normalize()
    self.Bobber:GetPhysicsObject():ApplyForceCenter(offset * 40 * self.BobberMass)
    if self.LastNibble + self.NibblePullWindow < CurTime() then return end
    self.LineStatus = "ItemHooked"
    self.HookedItem = LAWLYFISH:CreateRandomItemEnt(self.Bobber:GetPos())
    self.HookedItem:SetParent(self.Bobber)
    MsgN("CAUGHT SOMETHING!")
end
--]]
function SWEP:ThrowLine()
    self.LineStatus = "ThrowingOut"
    self.BobberPlaceTime = CurTime()

    local ply = self.Owner
    self:EmitSound(self.ThrowSound)

    local throwSpeed = self.ThrowStrength * self.ChargeTime

    if SERVER then
        self:Debug("Creating Bobber")
        self.Bobber = ents.Create("lawly_fishing_bobber")
        self.Bobber:SetPos(self.Owner:EyePos() + ply:EyeAngles():Forward() * 40)
        self.Bobber:Spawn()
        self.Bobber:PhysWake()
        self.Bobber:GetPhysicsObject():SetVelocity(ply:EyeAngles():Forward() * throwSpeed)
        self.Bobber:GetPhysicsObject():SetBuoyancyRatio(0.7)
        self.BobberMass = self.Bobber:GetPhysicsObject():GetMass()
        self:SetBobber(self.Bobber)
        local plyMdl = self.Owner:GetModel()
        local handBone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if ply.IsPony and ply:IsPony() then
            handBone = self.Owner:LookupBone("Lrig_LEG_FL_FrontHoof")
        end
        if !handBone then handBone = 0 end
        self.Line = constraint.CreateKeyframeRope( self:GetPos(), 1, "cable/cable2", nil, self.Owner, self.Owner:WorldToLocal(self.Owner:GetBonePosition(handBone)), handBone, self.Bobber, Vector(0,0,0), 0)
    end
end

function SWEP:PullLine()
    if !IsValid(self.Bobber) then self:RemoveBobber() return end
    local offset = self.BobberOffset
    offset:Normalize()

    self.Bobber:GetPhysicsObject():ApplyForceCenter(offset * 10 * self.BobberMass)
    local horizontalDist = math.abs(self.Bobber:GetPos().x - self.Owner:GetPos().x) + math.abs(self.Bobber:GetPos().y - self.Owner:GetPos().y)
    if horizontalDist < 100 then self:ReturnLine() return end
end

function SWEP:ReturnLine()
    self:EmitSound(self:SpoolSoundRandom())
    self.LineStatus = "PullingIn"
    if IsValid(self.Bobber) then 
        self.Bobber:GetPhysicsObject():SetDragCoefficient(1)
        self.Bobber:GetPhysicsObject():SetVelocity((self.BobberOffset + Vector(0,0,self.BobberDist/3))*2)
    end
    self.BobberPlaceTime = 0
    self.ChargeTime = 0
end

function SWEP:RemoveBobber()
    self:Debug(self.Bucket)
    self.LineStatus = "In"
    if IsValid(self.HookedItem) and self:GetBucket() then
        self.HookedItem:SetParent(nil)
        self.Bucket:AddItem(self.HookedItem)
        self:EmitSound("items/ammo_pickup.wav")
    else
        self:EmitSound("items/pickup_quiet_03.wav")
    end
    if !IsValid(self.Bobber) then return end
    self.Bobber:Remove()
end

function SWEP:FishPullLine()
    if !IsValid(self.Bobber) then self:RemoveBobber() return end
    local pullDir = self.Bobber:GetPos() - self.Owner:GetPos()
    pullDir:Normalize()
    pullDir = pullDir / 2 * VectorRand(0,300)
    pullDir.z = math.Clamp(pullDir.z, -200, 0)
    self.Bobber:GetPhysicsObject():ApplyForceCenter( pullDir )
end

SWEP.WaitingForReturn = false

function SWEP:Think()
    self:DoInput()

    --Check for when bobber lands in water
    if self.LineStatus == "ThrowingOut" then
        if self.Bobber.IsInWater then
            self:Debug("Line Out")
            self.LineStatus = "Out"
            self:StopSound(self.ThrowSound)
            self:EmitSound(self.TaughtSound)
            self:CalcNextRandTime()
        end
    end

    if self.LineStatus == "ItemHooked" then
        self:FishPullLine()
    end

    if self.LineStatus == "Out" then
        if self.Bobber.IsInWater then
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

    self.BobberDist = self:GetPos():Distance(self.Bobber:GetPos())
    self.BobberOffset = self.Owner:GetPos() - self.Bobber:GetPos()


    if self.LineStatus == "PullingIn" then
        if !self.ReturnTimerStarted then
            timer.Simple(self.RemoveBobberTime, function()
                self.ReturnTimerStarted = false
                self:RemoveBobber()
            end)
            self.ReturnTimerStarted = true
        end
        if self.BobberDist < 150 then
            self:RemoveBobber()
        end
    end

    --Adjust rope length, and check for cast timeoutcode
    self.Line:SetKeyValue( "length", self.BobberDist + 80 )



    if self.LineStatus == "ThrowingOut" and self.BobberPlaceTime < CurTime() - self.CastTime then
        self.LineStatus = "InvalidPlacement"
        self:ReturnLine()
    end

    self:DoCatchTimer()
end



function SWEP:DoInput()
    local MousePress = self.Owner:KeyPressed(IN_ATTACK)
    local MousePressAlt = self.Owner:KeyPressed(IN_ATTACK2)
    local MouseRelease = self.Owner:KeyReleased(IN_ATTACK)
    

    --Start charging throw, holding LMB
    if MousePress and self.LineStatus == "In" then
        self:Debug("Charging")
        self.Charging = CurTime()
        self:SetStartChargeTime(self.Charging)
    end
    --Return line on RMB
    if MousePressAlt then
        self:TugLine()
    end
    --Reel in Line
    if self.Owner:KeyDown(IN_ATTACK) and self.LineStatus == "Out" then
        self:PullLine()
    end
    --Throw line after charging
    if MouseRelease and self.Charging > 0 then
        self:Debug("Throwing")
        self.ChargeTime = math.min(CurTime() - self.Charging, self.MaxChargeTime)
        self.Charging = 0
        self:SetStartChargeTime(self.Charging)
        self:ThrowLine()
    end

end

function SWEP:CalcNextRandTime()
    self.RandNibbleTime = math.Rand(self.MinWait, self.MaxWait) + CurTime()
end

function SWEP:DoCatchTimer()
    if self.LineStatus != "Out" then return end
    if self.RandNibbleTime > CurTime() or self.RandNibbleTime == 0 then return end
    self:NibbleLine()
end

function SWEP:NibbleLine()
    self:Debug(self.RandNibbleTime)
    self.Bobber:GetPhysicsObject():SetVelocity(Vector(0,0,-100))
    self:CalcNextRandTime()
    self.LastNibble = CurTime()

    local effectdata = EffectData()
    effectdata:SetOrigin( self.Bobber:GetPos() )
    effectdata:SetScale(5)
    util.Effect( "gunshotsplash", effectdata )
end