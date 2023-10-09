
--Attempt to catch a fish.
function SWEP:TugLine()
    self:Debug("Tugging")
    if !IsValid(self.Bobber) then self:RemoveBobber() return end
    if self.LastNibble + self.NibblePullWindow < CurTime() then return end
    self.ItemHooked = true
    self:Debug("Hooked Item")
    self:ReturnLine()
end

function SWEP:ThrowLine()
    self.LineStatus = "ThrowingOut"
    self.BobberPlaceTime = CurTime()

    local ply = self.Owner
    ply:EmitSound(self.ThrowSound)
	self:SendWeaponAnim( ACT_VM_MISSCENTER )
    self.CastPlayerPosition = ply:GetPos()


    local throwSpeed = self.ThrowStrength * (self.ChargeTime/self.MaxChargeTime)

    if SERVER then
        self:Debug("Creating Bobber")
        self.Bobber = ents.Create("lawly_fishing_bobber")
        self.Bobber:SetPos(ply:EyePos() + ply:EyeAngles():Forward() * 40)
        self.Bobber:Spawn()
        self.Bobber:PhysWake()
        self.Bobber:GetPhysicsObject():SetVelocity(ply:EyeAngles():Forward() * throwSpeed)
        self.Bobber:GetPhysicsObject():SetBuoyancyRatio(0.7)
        self.BobberMass = self.Bobber:GetPhysicsObject():GetMass()
        self:SetBobber(self.Bobber)
        self.Bobber.Owner = ply
        local plyMdl = ply:GetModel()
        local handBone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
        if ply.IsPony and ply:IsPony() then
            handBone = ply:LookupBone("Lrig_LEG_FL_FrontHoof")
        end
        if !handBone then handBone = 0 end
        self.Line = constraint.CreateKeyframeRope( self:GetPos(), 1, "cable/cable2", nil, ply, ply:WorldToLocal(ply:GetBonePosition(handBone)), handBone, self.Bobber, Vector(0,0,0), 0)
    end
end

--Slowly pull the line towards the player
function SWEP:PullLine()
    if !IsValid(self.Bobber) then self:RemoveBobber() return end
    local offset = self.BobberOffset
    offset:Normalize()

    self.Bobber:GetPhysicsObject():ApplyForceCenter(offset * 10 * self.BobberMass)
    local horizontalDist = math.abs(self.Bobber:GetPos().x - self.Owner:GetPos().x) + math.abs(self.Bobber:GetPos().y - self.Owner:GetPos().y)
    if horizontalDist < 100 then self:ReturnLine() return end
end

--Return the bobber entirely
function SWEP:ReturnLine()
    self.Owner:StopSound(self.ThrowSound)
    if self.LineStatus == "PullingIn" then return end
    self.Owner:EmitSound(self:SpoolSoundRandom())
	self:SendWeaponAnim( ACT_VM_HITCENTER )

    self.LineStatus = "PullingIn"
    if IsValid(self.Bobber) then 
        self.Bobber:SetPos(self.Bobber:GetPos() + Vector(0,0,20))
        self.Bobber:GetPhysicsObject():SetDragCoefficient(1)
        local heightpulloffset = self.BobberDist / (self.BobberDist/450) --Try and account for distance and strength
        self.Bobber:GetPhysicsObject():SetVelocity((self.BobberOffset + Vector(0,0,heightpulloffset)))
    end
    self.BobberPlaceTime = 0
    self.CastPlayerPosition = nil
    self.ChargeTime = 0
end

function SWEP:RemoveBobber()
    self:Debug(self.Bucket)
    self.Owner:StopSound(self.ThrowSound)
    if self.ItemHooked and self:GetBucket() then
        local ItemData = LAWLYFISH:GetRandomItem()
        self.Bucket:AddItem(ItemData)
        self.Owner:EmitSound("items/ammo_pickup.wav")
        self.ItemHooked = false
        net.Start("lawly_fishing_senditemnotif")
            net.WriteTable(ItemData)
        net.Send(self.Owner)
    else
        self.Owner:EmitSound("items/pickup_quiet_03.wav")
    end
    self.LineStatus = "In"
    if !IsValid(self.Bobber) then return end
    self.Bobber:Remove()
end


--How long after the bobber is pulled out of water it will return.
SWEP.BobberEscapeDelay = 3

function SWEP:Think()
    self:DoInput()

    --Check for when bobber lands in water
    if self.LineStatus == "ThrowingOut" then
        if self.Bobber.IsInWater then
            self:Debug("Line Out")
            self.LineStatus = "Out"
            self.Owner:StopSound(self.ThrowSound)
            self.Owner:EmitSound(self.TaughtSound)
            self:CalcNextRandTime()
        end
    end

    if self.LineStatus == "Out" then
        if self.Bobber.InWaterTime != 0 and self.Bobber.InWaterTime < CurTime() - self.BobberEscapeDelay then
            self:ReturnLine()
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

    //Bobber must be out to continue past this point.

    self.BobberDist = self:GetPos():Distance(self.Bobber:GetPos())
    self.BobberOffset = self.Owner:GetPos() - self.Bobber:GetPos()

    if self.CastPlayerPosition != nil then
        local plyMoveDist = self.Owner:GetPos():DistToSqr(self.CastPlayerPosition)
        if plyMoveDist > LAWLYFISH.MaxPlyMovement then self:RemoveBobber() end
    end

    if self.LineStatus == "PullingIn" then
        if !self.ReturnTimerStarted then
            timer.Simple(self.RemoveBobberTime, function()
                self.ReturnTimerStarted = false
                if self.LineStatus != "PullingIn" then return end
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

function SWEP:Holster()
    self:RemoveBobber()
    return true
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
    util.Effect( "gunshotsplash", effectdata, true, true )
end