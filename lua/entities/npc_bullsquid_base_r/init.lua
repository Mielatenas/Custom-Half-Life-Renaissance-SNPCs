AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/half-life/bullsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 80
ENT.HullType = HULL_WIDE_SHORT
ENT.SightDistance = 8000 -- How far it can see | Remember to call "self:SetSightDistance(dist)" if you want to set a new value after initialize!
ENT.SightAngle = 180 

ENT.ControllerParams = {
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "Bip01 Neck",
	FirstP_Offset = Vector(0, 0, 15),
	FirstP_ShrinkBone = false,
}
-- use !self.VJ_IsBeingControlled, self.VJ_TheController:KeyDown(IN_ATTACK)
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Immune_AcidPoisonRadiation = true -- Makes the SNPC not get damage from Acid, poison, radiation
--ENT.AnimTbl_IdleStand = {ACT_IDLE, ACT_SQUID_DETECT_SCENT, ACT_TURN_LEFT} -- The idle animation table when AI is enabled | DEFAULT: {ACT_IDLE}
ENT.CanEat = true -- Can it search and eat organic stuff?
ENT.EatCooldown = 45 -- How much time until it can eat again after devouring something?
ENT.ForceDamageFromBosses = true

ENT.AnimTbl_MeleeAttack = {"vjseq_whip","vjseq_bite"} 
ENT.MeleeAttackExtraTimers = nil -- Extra melee attack timers, EX: {1, 1.4} | it will run the damage code after the given amount of seconds
ENT.TimeUntilMeleeAttackDamage = false

ENT.NextMeleeAttackTime = 0.8 -- How much time until it can use a melee attack?
ENT.MeleeAttackAnimationFaceEnemy = false -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.MeleeAttackDistance = 55 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackDamageDistance = 100 -- How far does the damage go?
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy

ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1} -- Range Attack Animations
ENT.RangeAttackProjectiles = "obj_bullsquid_spit_r" -- The entity that is spawned when range attacking
ENT.TimeUntilRangeAttackProjectileRelease = false

ENT.NextRangeAttackTime = 1.0 -- How much time until it can use a range attack?
ENT.RangeAttackMinDistance = 45 -- Min range attack distance
ENT.RangeAttackMaxDistance = 4000 -- Max range attack distance
ENT.RangeUseAttachmentForPos = false -- Should the projectile spawn on a attachment?

ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = false -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = true -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemy_MinDistance = 2500 -- How close does it have to be until it starts to face the enemy?

ENT.LimitChaseDistance = "OnlyRange" -- Should it limit chasing when between certain distances? | true = Always limit | "OnlyRange" = Only limit if it's able to range attack
ENT.LimitChaseDistance_Min = "UseRangeDistance" -- Min distance from the enemy to limit its chasing | "UseRangeDistance" = Use range attack's min distance
ENT.LimitChaseDistance_Max = "UseRangeDistance" -- Max distance from the enemy to limit its chasing | "UseRangeDistance" = Use range attack's max distance
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEFORWARD} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse

ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 4 -- Chance of flinching from 1 to x | 1 = Always flinch
ENT.FlinchCooldown = 5 -- How much time until it can flinch again? | false = Base auto calculates the duration
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH, ACT_BIG_FLINCH} -- If it uses normal based animation, use this
ENT.FlinchHitGroupMap = false -- EXAMPLE: {{HitGroup = HITGROUP_HEAD, Animation = ACT_FLINCH_HEAD}, {HitGroup = HITGROUP_LEFTARM, Animation = ACT_FLINCH_LEFTARM}, {HitGroup = HITGROUP_RIGHTARM, Animation = ACT_FLINCH_RIGHTARM}, {HitGroup = HITGROUP_LEFTLEG, Animation = ACT_FLINCH_LEFTLEG}, {HitGroup = HITGROUP_RIGHTLEG, Animation = ACT_FLINCH_RIGHTLEG}}
ENT.FlinchHitGroupPlayDefault = true -- Should it play "self.AnimTbl_Flinch" when none of the mapped hit groups hit?	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/pl_step1.wav","vj_hlr/gsrc/pl_step2.wav","vj_hlr/gsrc/pl_step3.wav","vj_hlr/gsrc/pl_step4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/bullchicken/bc_idle1.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle2.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle2.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle3.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle4.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/bullchicken/bc_idle1.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle2.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle3.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle4.wav","vj_hlr/gsrc/npc/bullchicken/bc_idle5.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/bullsquid/attackgrowl3.wav", "npc/bullsquid/attackgrowl2.wav", "npc/bullsquid/attackgrowl3.wav", "vj_hlr/gsrc/npc/bullchicken/bc_attackgrowl.wav","vj_hlr/gsrc/npc/bullchicken/bc_attackgrowl2.wav","vj_hlr/gsrc/npc/bullchicken/bc_attackgrowl3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/gsrc/npc/bullchicken/bc_bite1.wav","vj_hlr/gsrc/npc/bullchicken/bc_bite2.wav","vj_hlr/gsrc/npc/bullchicken/bc_bite3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/gsrc/npc/zombie/claw_miss1.wav","vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_RangeAttack = {"npc/bullsquid/attack1.wav", "npc/bullsquid/attack2.wav", "npc/bullsquid/attack3.wav", "npc/bullsquid/bc_attack1.wav"}
ENT.SoundTbl_Pain = {"npc/bullsquid/pain1.wav", "npc/bullsquid/pain2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_pain1.wav","vj_hlr/gsrc/npc/bullchicken/bc_pain2.wav","vj_hlr/gsrc/npc/bullchicken/bc_pain3.wav","vj_hlr/gsrc/npc/bullchicken/bc_pain4.wav"}
ENT.SoundTbl_Death = {"npc/bullsquid/die3.wav", "npc/bullsquid/die1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_die1.wav","vj_hlr/gsrc/npc/bullchicken/bc_die2.wav","vj_hlr/gsrc/npc/bullchicken/bc_die3.wav"}
ENT.FootStepTimeRun = 0.2 -- Next foot step sound when it is running
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events

-- Custom
ENT.FlameAttackDmg = 10
ENT.fRangeDistanceFlame = 230
ENT.SpitReps = 5
ENT.SoundWater_Tbl = {"waterphysics/watermove1.ogg", "waterphysics/watermove3.ogg", "waterphysics/watersplash1.ogg"}

---DO NOT CHANGE BELOW!---
ENT.CanUseFlame = false
ENT.FlameDuration = 0
ENT.nextBlink = 0
ENT.nextBsAttack = 0
ENT.HasMeleeAttack = true
ENT.HasRangeAttack = true -- troublesome with NPC controller if set on and off in think!   
ENT.TexecuteRangeSpit = 0.17
--ENT.RangeToMeleeDistance = 1 -- breaks the Rangeattackcode when number is reached !!!!!!!
ENT.NextMoveAfterFlinchTime = 1 -- if this is set lower than 1 sec breaks the whole range code for some reason-- after a time breaks when there's too much flinch? if they stay long distances they are fine. Prob have to update it when the new Vj Base Revamp is released.
//ENT.SoundTbl_BeforeRangeAttack = {"npc/bullsquid/flame_run_lp.wav"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	if !self.IsHybrid then
	self.BloodParticle = {"vj_hlr_blood_yellow"} end
	self:SetCollisionBounds(Vector(20, 20 , 35), Vector(-20, -20, 0))
	self.iSpitCount = 5
	self.nextSpit = 0
	self.nextBsSpitAttack = 0
    local hlrMultidmg = GetConVar("hlrcustom_multidmg"):GetFloat()
	self.FlameAttackDmg = self.FlameAttackDmg*hlrMultidmg
	self.MeleeAttackDamage = self.MeleeAttackDamage*hlrMultidmg
	self.MultidmgWhip = 25*hlrMultidmg
    self.MultidmgBite = 15*hlrMultidmg
	if self.FlameSd then
	    self.loopsd = CreateSound(self,self.FlameSd)
	    self.loopsd:SetSoundLevel(70)
	end
	--self:CapabilitiesRemove(bit.bor(CAP_ANIMATEDFACE)) -- does it fix anything??!!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data) -- no key received on flinch, idle, run, walk and some unused animations
	--print(key)
	if self.IsPoisonBs then
		if key == "event_play AttackRange" or key == "event_rattack spit" or key == "event_play AttackSpit" or key == "event_play AttackBite" or key == "event_mattack bite" then
			self.CanUseSpit = true -- use the boolean to disable spits attacks and fix anim issues, since PoisonSquid uses the spits on every attack
		else
			self.CanUseSpit = false
		end
	    if key == "event_play AttackBite" or key == "event_mattack bite" then
	    	self.SpecialEvAnim = true
	    	self.MeleeAttackMissSoundLevel = 22
	    else
	    	self.SpecialEvAnim = false
	    	self.MeleeAttackMissSoundLevel = 75
        end
    end
	--if key == "step" then
		--self:FootStepSoundCode()
	if key == "event_play AttackWhip" then 

	end	
	if key == "event_mattack whip" then -- or  key == "event_play AttackWhip"
		/*	--------------------- used to control TIMERS when VJ_ACT_PLAYACTIVITY was used, cannot change it if using events, vj melee timer set the timer even before 
		if self.Immune_Fire then self.TimeUntilMeleeAttackDamage = 0.6 
		elseif (self.IsFrostBs == true or self.ToxicBull == true) then self.TimeUntilMeleeAttackDamage = 1.2
		else self.TimeUntilMeleeAttackDamage = 1.0 
		end */
		self.MeleeAttackDamageAngleRadius = 180
		self.MeleeAttackAngleRadius = 180 -- had to 180º all around since 150 was breaking his AI when on his back 
		--self:PlayAnim("vjseq_whip", false, 0, false, 0)
		self.MeleeAttackDamage = self.MultidmgWhip
		self:MeleeAttackCode()
	end
    if key == "event_mattack bite" then -- or key == "event_play AttackBite"
		--self.NextMeleeAttackTime = 0.8 
		self.MeleeAttackAnimationFaceEnemy = true
		self.MeleeAttackDamageAngleRadius = 80
		self.MeleeAttackAngleRadius = 80
		--self:PlayAnim("vjseq_bite", false, 0, false, 0)
		//self:PlayAnim(ACT_MELEE_ATTACK2, false, false, true, 0)
		self.MeleeAttackDamage = self.MultidmgBite
		self:MeleeAttackCode()
		self.MeleeAttackAnimationFaceEnemy = false
    end
	if key == "event_dropdead" then
	end
	if key == "event_emit FlameStart" or key == "event_rattack flamestart" then -- boolean on validation if the key is == specialrangeattack which is the flame
        self.SpecialEvAnim = true
    else
        if !self.IsPoisonBs then
        self.SpecialEvAnim = false end
    end
	--if key == "event_play AttackBite" or key == "event_mattack bite" then
		    --self:MeleeAttackCode()
	--end
	if key == "event_play AttackRange" or key == "event_rattack spit" or key == "event_play AttackSpit" then
        self.CanUseSpit = true
        if key == "event_rattack spit" and self.iSpitCount > 0 then
       		timer.Simple(self.TexecuteRangeSpit, function() 
	            if self.Dead or self.Flinching == true then return end
		        if IsValid(self) and IsValid(self.BsValidCurEnemy) then self:ExecuteRangeAttack()
		        end
		    end) 	
        end
	else
	    if !self.IsPoisonBs then
        self.CanUseSpit = false
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if CurTime() >= self.nextBlink then
		local iDelay = 0.1
		self.nextBlink = CurTime() +math.Rand(iDelay,5)
		self:SetSkin(1)
		for i = 1, 0, -1 do
			timer.Simple(iDelay, function()
				if IsValid(self) then
					self:SetSkin(i)
				end
			end)
			iDelay = iDelay +0.1
		end
	end
	if self:WaterLevel() > 2 then 
		self.CanUseFlame = false
    end
	if self:WaterLevel() <= 2 and (self.ToxicBull==true or self.IsPoisonBs==true or self.Immune_Fire==true or self.IsFrostBs==true) and !self.IsHybrid and self.CanUseFlame == false then
	    self.CanUseFlame = true
	end
	local bValid = self.BsValidCurEnemy -- vj base internal enemy ent, the table self.EnemyData has if visible but prefered to not use it
	if !IsValid(bValid) then
		bValid = self:GetEnemy()-- is a quicker way to update enemy but gives nil sometimes
	end
	--if IsValid(bValid) then
    	--self.BsValidCurEnemy = bValid -- update enemy only if GetEnemy() got an enemy
    --end
	if bValid then dist = VJ.GetNearestDistance(self, bValid) end
	if dist then
		-- Ai control 
		self.DistoEnemy = dist	
		if self.iSpitCount <= 0 && CurTime() >= self.nextSpit then -- give back normal anim and timers
		    self.iSpitCount = 6
		    self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
		    self.NextRangeAttackTime = 1 
		    self.NextAnyAttackTime_Range = false
		end
	    if self.bInSchedule==true and !self.VJ_IsBeingControlled then -- let player run without limits
	        self.LimitChaseDistance="OnlyRange"
	        self.HasRangeAttackSound = false
	        --self.HasMeleeAttack = false
	        --if self.iSpitCount > 0 and CurTime() >= self.nextBsSpitAttack then -- wrong use, have to fix 
	            --self.HasRangeAttack = true
	        --end
	    end	
	    if (self.bInSchedule==true and self.FlameOn == true) or self.CanUseSpit==false then --
	    	--print(self.SpitReps)
	    	--self.DisableDefaultRangeAttackCode = true 
	    	--self.TimeUntilRangeAttackProjectileRelease = false
	        elseif self.CanUseSpit==true then -- if is playing animation let spits go out
	    	--self.DisableDefaultRangeAttackCode = false
	    	--self.TimeUntilRangeAttackProjectileRelease = 0.55 
	    end

	    if self.iSpitCount > 0 and CurTime() >= self.nextBsSpitAttack then -- outside bInSchedule good
	        --self.HasRangeAttack = true
	        if self.IsPoisonBs and !self.SpecialEvAnim then
                self.SpitReps = 5
            end	
        end
	    if dist >= self.MeleeAttackDistance then 
	        --self.HasMeleeAttack = false
        else 
            --self.HasMeleeAttack = true
            --self.HasRangeAttack = false
        end
        if dist > self.fRangeDistanceFlame and CurTime() >= self.FlameDuration and !self.bInSchedule and self.CanUseSpit==true then
    	self.HasRangeAttackSound = true -- turn on range attack sounds 
        end
    end
    -- enter here if iSpitCount > 0, self.nextBsSpitAttack is here to let a chase period when iSpitCount is depleted 
    if (self.FlameOn == true and CurTime() >= self.FlameDuration and CurTime() >= self.nextBsSpitAttack) then /*|| self.BsValidCurEnemy:GetPos().z -self:GetPos().z > 65 */ /* */
    	--print("flame ON INTERRUPT")
    	self.bInSchedule = false	
	    self.FlameOn = false
	    self.NextRangeAttackTime = 1
		//if isnumber(self.NextAnyAttackTime_Range) then self.NextRangeAttackTime = 1 + (self.NextAnyAttackTime_Range) end
		if self.IsPoisonBs then 
		    --self.TimeUntilRangeAttackProjectileRelease = 0.55
		else
			if !self.IsHybrid then
		    self.SpitReps = 5
		    end
		end
		--self.DisableDefaultRangeAttackCode = false
	    --self.TimeUntilRangeAttackProjectileRelease = 0.55 
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
		self:StopParticles()
		if self.FlameSd then self.loopsd:Stop() end 
	end
end
function ENT:OnThinkAttack(isAttacking, enemy)

end

function ENT:CustomOnFootStepSound()
	if self:WaterLevel() ==1 then 
		VJ_EmitSound(self, self.SoundWater_Tbl, 75, 100)
   	elseif self:WaterLevel() ==2 then
   		VJ_EmitSound(self, self.SoundWater_Tbl, 75, 100)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------

function ENT:TranslateActivity(act) -- 
    -- if eatingData.AnimStatus== "Eating" then
	if (self:GetNPCState() == NPC_STATE_ALERT or self:GetNPCState() == NPC_STATE_COMBAT and self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK) then
        if (self.IsPoisonBs or self.ToxicBull==true or self.IsHybrid) then
           -- return ACT_IDLE --ACT_SQUID_EAT --"eat"
     	else
     		--if not VJ.IsCurrentAnim(self, "eat") then -- check to not repeat PlayAnim every tick ACT_SQUID_DETECT_SCENT, sniff
     	    --self:PlayAnim("vjseq_eat", false, 2, false, 0)
     	    --return ACT_SQUID_DETECT_SCENT --"eat" --ACT_SQUID_EAT
     	    --end
     	end
        --return act
    end
    return baseclass.Get("npc_vj_creature_base").TranslateActivity(self, act)
end

local vecZ50 = Vector(0, 0, -50)
function ENT:OnEat(status, statusData)
	--self.EatingData.NextCheck = curTime + 15 to add extra seconds to find next food
	if status == "CheckFood" then
		return true
	elseif status == "BeginEating" then
		if (self.IsPoisonBs or self.ToxicBull==true or self.IsHybrid) then
			self.AnimationTranslations[ACT_IDLE] = ACT_COVER_LOW -- Eating animation
		    return select(2, self:PlayAnim(ACT_COVER_LOW, true, false))
		else
			--self:PlayAnim("vjseq_inspectdown", true, 2)
			self.AnimationTranslations[ACT_IDLE] = VJ.SequenceToActivity(self, "eat") --{ACT_IDLE, "vjges_eat"}
			return select(2, self:PlayAnim("vjseq_eat", true, false))
		end
	elseif status == "Eat" then
		--if (self.Immune_Fire==true or self.IsFrostBs or self.CanUseFlame==false) then
		    --self.AnimationTranslations[ACT_IDLE] = VJ.SequenceToActivity(self, "eat")
		    --self:PlayAnim("vjseq_eat", true, 1.5,false,0) end
		--end
		VJ.EmitSound(self, "npc/bullsquid/eat_munch" .. math.random(1, 2) .. ".ogg", 55)
		-- Health changes
		local food = self.EatingData.Target
		local damage = 4 -- How much damage food will receive
		local foodHP = food:Health() -- Food's health
		local myHP = self:Health() -- NPC's current health
		self:SetHealth(math.Clamp(myHP + ((damage > foodHP and foodHP) or damage), myHP, self:GetMaxHealth() < myHP and myHP or self:GetMaxHealth())) -- Give health to the NPC
		food:SetHealth(foodHP - damage) -- Decrease corpse health
		-- Blood effects
		local bloodData = food.BloodData
		if bloodData then
			local bloodPos = food:GetPos() + food:OBBCenter()
			local bloodParticle = VJ.PICK(bloodData.Particle)
			if bloodParticle then
				ParticleEffect(bloodParticle, bloodPos, self:GetAngles())
			end
			local bloodDecal = VJ.PICK(bloodData.Decal)
			if bloodDecal then
				local tr = util.TraceLine({start = bloodPos, endpos = bloodPos + vecZ50, filter = {food, self}})
				util.Decal(bloodDecal, tr.HitPos + tr.HitNormal + Vector(math.random(-45, 45), math.random(-45, 45), 0), tr.HitPos - tr.HitNormal, food)
			end
		end
		return 1 -- Eat every this seconds
	elseif status == "StopEating" then
		if statusData != "Dead" && self.EatingData.AnimStatus != "None" then -- Do NOT play anim while dead or has NOT prepared to eat
			if statusData == "Injured" or statusData == "Enemy" then
		        return select(2, self:PlayAnim(ACT_HOP, true, 0.5,false,0,{PlayBackRate=1}))
	        else
			    return select(2, self:PlayAnim(ACT_SIGNAL1, true, 1.5,false,0,{PlayBackRate=1}))
		    end
		end
	end
	return 0
end
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)

end
function ENT:CustomOnAlert(ent)
	if math.random(1, 3) == 1 then
		if ent.VJ_ID_Headcrab or ent:GetClass() == "npc_headcrab" or ent:GetClass() == "npc_headcrab_black" or ent:GetClass() == "npc_headcrab_fast" then
			self:PlayAnim("seecrab", true, false, true)
		else
			self:PlayAnim(ACT_HOP, true, false, true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	-- Use curve if the projectile has physics, otherwise use a simple line
	local phys = projectile:GetPhysicsObject()
	if IsValid(phys) && phys:IsGravityEnabled() then
		return VJ.CalculateTrajectory(self, self:GetEnemy(), "CurveAntlion", projectile:GetPos(), 1, self.DistoEnemy*1.1,{ApplyDist=false}) -- Increment it by distance
	end
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 0.7, 1500)
end
/*
function ENT:RangeAttackCode_GetShootPos(projectile)
	if self.Bullsquid_BullSquidding == true then
		return self:CalculateProjectile("Line", projectile:GetPos(), self.BsValidCurEnemy:GetPos() + self.BsValidCurEnemy:OBBCenter(), 250000)
	else
		if self.IsPoisonBs then
		return self:CalculateProjectile("Curve", projectile:GetPos(), self.BsValidCurEnemy:GetPos() + self.BsValidCurEnemy:OBBCenter(), self.DistoEnemy+150)
        end
		return self:CalculateProjectile("Curve", projectile:GetPos(), self.BsValidCurEnemy:GetPos() + self.BsValidCurEnemy:OBBCenter(), self.DistoEnemy*2) -- Increment it by distance
	end
end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward()*55 + self:GetUp()*255
end
---------------------------------------------------------------------------------------------------------------------------------------------

function ENT:CustomAttack(ene, eneVisible) 
self.BsValidCurEnemy = ene
end
function ENT:RangeAttackProjPos(projectile) --
	if self.Immune_Fire==true then 
    end
	// return self:GetAttachment(self:LookupAttachment("muzzle")).Pos -- Attachment example
	return self:GetPos() + self:GetUp() * 25 +self:GetForward()*35
end
function ENT:OnRangeAttack(status, enemy) -- old function ENT:MultipleRangeAttacks() hasn't all the validations
	--print("OnRangeAttack")
	--print(self.EnemyData.Visible) -- Mlaes the game CRASH!!!
	if IsValid(self.BsValidCurEnemy) then
	    local bValid = self:GetEnemy()
		// when the Flame stops
		if (self.FlameOn == false and CurTime() >= self.FlameDuration and CurTime() >= self.nextBsSpitAttack) or /*(self.DistoEnemy > self.fRangeDistanceFlame || self.DistoEnemy <= self.MeleeAttackDistance ||*/ (self.BsValidCurEnemy:Health() <= 0 or !self.BsValidCurEnemy) then /*|| self.BsValidCurEnemy:GetPos().z -self:GetPos().z > 65 */
		   -- print("flame stop on range attack")
			self.FlameOn = false
			self.bInSchedule = false
			--self.DisableDefaultRangeAttackCode = false
			--self.TimeUntilRangeAttackProjectileRelease = 0.55 
			self.nextBsSpitAttack = CurTime()+0.4
			if self.IsPoisonBs then 
				self.NextRangeAttackTime = 1.0 
			    --self.TimeUntilRangeAttackProjectileRelease = 0.55 
			    self.NextAnyAttackTime_Range = false
            end
			self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
			self:PlayAnim(ACT_SPECIAL_ATTACK2, true, 0.4, false)
			self:StopParticles()
			if self.FlameSd then self.loopsd:Stop() end

		end
		    // Flame is on, Set an extra validation if enemy is visible, they do the flame even if the enemy is behind a wall--add traceline
		if isnumber(self.DistoEnemy) and self.Flinching==false then 
		    if self.CanUseFlame == true and !self.IsHybrid  then /*and self.DistoEnemy < self.fRangeDistanceFlame and VJ_FindInCone(self:GetPos(), self:GetForward() or self.BsValidCurEnemy:GetForward(), 600, self.FlameConeDmgDegree or 90, {AllEntities=true})*/
	           --print("Flameeee check")
	            local size = 60+ self.fRangeDistanceFlame
	            local dir = self:GetForward()
	            local angle = 0.780
	            local startPos = self:GetPos()
	            local entities = ents.FindInCone(startPos, dir, size, angle)
			for id, ent in ipairs( entities ) do
			        if (ent == nil) or (ent:IsWorld()) then
			        break end
				local DispEne = self:Disposition(ent)
 				if (self:Visible(ent) or ent:OnGround()) and ent:IsValid() and (ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer()) and DispEne <= 2 then 
                    --print("FLAMEEEE")
                    --self.DisableDefaultRangeAttackCode = true
                    --self.TimeUntilRangeAttackProjectileRelease = false 
		    		self.nextBsSpitAttack = CurTime() +0.5 -- issue?
		        	if !self.IsPoisonBs then
		    		    if self.SpecialEvAnim then
		    		        --print("aooohohohoh")
		    	    	    if !self.FlameOn then
		    	    	    ParticleEffectAttach(self.FlameParticle, PATTACH_POINT_FOLLOW, self, 1)
				    	    --print("myparticle")
				    	    end
				    	    self.FlameOn = true
				    	else
				    	    if !self.FlameOn then 
				    	    	self:PlayAnim("vjseq_flame_start", false, false, true)
		    		            self.AnimTbl_RangeAttack = {"vjseq_flame_run"}
		    		        end
				    	end
		    		else --poison code!
		    		--self.TimeUntilRangeAttackProjectileRelease = 0.1
		    		--self.NextRangeAttackTime = VJ.SET(0.3, 1)
		    		self.NextAnyAttackTime_Range = VJ.SET(0.3, 1)
                    self.FlameOn = true
		    		self.AnimTbl_RangeAttack = {"vjseq_bite"} 
		    		--self:PlayAnim("vjseq_bite", false, 1, "Visible",0,{PlayBackRate=1.5,PlayBackRateCalculated=false})
		       		end
		       	    --self.FlameOn = true
		       	    self.NextRangeAttackTime = 0.1
		       	    self.bInSchedule = true
		    	    self.HasRangeAttackSound = false
		    	    if self.SpecialEvAnim then
                        if self.FlameSd then
                        self.loopsd:PlayEx(1,100)
                        	if self.ToxicBull ==true then
	                         self.loopsd:ChangePitch( 55+(self.iSpitCount*2), 0 )
	                        end
                       //self:PlaySoundSystem("BeforeRangeAttack")
                        end
				    end
				    if CurTime() >= self.FlameDuration then 
 		    	        self.FlameDuration = CurTime() +0.5
				        if self.FlameOn == true	then
				        self:DoFlameDamage(ent) end
				    end
			    if not self.IsPoisonBs and self.DistoEnemy < self.fRangeDistanceFlame then return end -- don't let pass next except poison
			    end
		    end 
		    end
	    --if self.TimeUntilRangeAttackProjectileRelease==false and !self.IsPoisonBs then return end
		if self.bInSchedule==true and !self.IsPoisonBs then return end
	    local eyePos = self.BsValidCurEnemy:EyePos() + self.BsValidCurEnemy:GetRight() * -5
	    local eyeDir = self.BsValidCurEnemy:GetAimVector()
	    local tr = util.TraceLine( {
		start = eyePos,
		endpos = eyePos + eyeDir * 10000,
		filter = self.BsValidCurEnemy
	    } )
		local bRange = (self.DistoEnemy <= self.RangeAttackMaxDistance && self.DistoEnemy >= self.MeleeAttackDistance && self.iSpitCount > 0) //&& (!IsValid(tr.Entity)) || tr.HitPos == self)
		if bRange then // Range Attack Code
			--print("Spits Attack Code")
		    if self.IsPoisonBs then 
		    	-- print("POISON!")
		    	if CurTime() > self.RT then -- fixes majority of vj base range attack timer breaks bc we turn on/off self.HasRangeAttack constantly and ENT.RangeToMeleeDistance is set to 1	 		
		    	    self.RT = CurTime() +0.4
		    	    timer.Simple(0.4, function()
		    	    	if self.Dead or self.Flinching == true then return end
		                if IsValid(self) and IsValid(self.BsValidCurEnemy) then self:AttackSpit(self.BsValidCurEnemy)
		                end
		            end)
		    	end
		    else
		    	if CurTime() > self.nextBsAttack and CurTime() > self.FlameDuration then -- the rest DID need a timer fix
		    	    self.nextBsAttack = CurTime() +self.NextRangeAttackTime
	                timer.Simple(0.55, function() 
	            	    if self.Dead or self.Flinching == true or self.AttackType == VJ_ATTACK_MELEE then return end
		                if IsValid(self) and IsValid(self.BsValidCurEnemy) then self:AttackSpit(self.BsValidCurEnemy)

		                end
		            end)
		        end
		    end
	    end
	    end
	end
end
function ENT:OnRangeAttackExecute(status, enemy, projectile) 
	--print(status)
   -- if status == "Init" and self.DistoEnemy >= 1000 then print("NOPROJ") return true end
end
function ENT:DoFlameDamage(ent)
	local dist = self.fRangeDistanceFlame
	local dmg = self.FlameAttackDmg
	//local posDmg = self.MeleeAttackDamageDistance
	local dmgorigen = self:GetPos()+self:GetForward()*50 + self:GetUp()*20
	//local conewidth = 
	--for k, ent in pairs(ents.FindInSphere(dmgorigen, dist)) do
		if self.Immune_Fire==true then 
		    if IsValid(ent) then
				local posEnemy = ent:GetPos()
				local angToEnemy = self:CustomHLRenaissanceGetAngleToPos(posEnemy).y
				if (angToEnemy <= 70 && angToEnemy >= 0) || (angToEnemy <= 360 && angToEnemy >= 290) then
					if ent:IsPlayer() then 
						ent:EmitSound("player/pl_burnpain" ..math.random(1,3).. ".wav", 75, 100) 
					end
					if (ent:IsNPC() || ent:IsPlayer()) then 
						ent:Ignite(math.Rand(3, 4), 0)
						if ent:GetClass() == "npc_turret_floor" && !ent.SelfDestruct then
					        ent:Fire("selfdestruct", 1, 2, self)
					        ent:GetPhysicsObject():ApplyForceCenter(self:GetUp() *1) 
					        ent.SelfDestruct = true
				        end
					else
						ent:Ignite(math.Rand(1, 3), 0)
					end
				end
			end
		end	
	--end
		local CheckIfPlayer = false
		if IsValid(self) then
			CheckIfPlayer = !self:IsPlayer()
		end
		util.VJ_SphereDamage(self, self, dmgorigen, self.FlameDmgRadius, self.FlameAttackDmg, self.FlameDamageType, CheckIfPlayer, true, {Force=1, UpForce=0, DamageAttacker=self:IsPlayer(),UseConeDegree=self.FlameConeDmgDegree,UseConeDirection=self:GetForward()})
end
function ENT:AttackSpit(BsValidCurEnemy)
    pos = self:GetProjectilePosition(BsValidCurEnemy) 
    local stpo = self:RangeAttackProjPos(projectile)
    local target1 = BsValidCurEnemy:GetPos() + BsValidCurEnemy:OBBCenter()
    	if self.IsPoisonBs and self.bInSchedule == true then
        self.SpitReps = 0
        stpo = stpo + self:GetForward()*15 + self:GetUp()*23
        elseif !self.bInSchedule and self.IsPoisonBs then 
            stpo = stpo
        end
			for i = 0, self.SpitReps do
				local Bullsphere = ents.Create(self.RangeAttackProjectiles)
                Bullsphere:SetPos(stpo)
				Bullsphere:SetOwner(self)
				Bullsphere:SetParent(self, 1)
				Bullsphere:Spawn()
				local phys = Bullsphere:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(pos +VectorRand() *80)
				end
				if !IsValid(Bullsphere) then return end -- in case it was destroyed
					Bullsphere:SetParent(nil)
					if !self.IsPoisonBs then
					Bullsphere:GetPhysicsObject():SetVelocity((target1+(BsValidCurEnemy:GetRight()*(math.Rand(-75, 75)))-stpo) * math.Rand(1, 2) + Vector(0,0,215/*self.DistoEnemy/5*/)) 	-- self.DistoEnemy/(self.DistoEnemy-1)	print(self.DistoEnemy/(self.DistoEnemy-1)) 

				    else
				    Bullsphere:GetPhysicsObject():SetVelocity((target1+(BsValidCurEnemy:GetRight()*(math.Rand(-75, 75)))-stpo) * math.Rand(0.9, 1.2) + Vector(0,0,257))
                    end
			end
		self.iSpitCount = self.iSpitCount -1
		if self.iSpitCount <= 0 then
			--print("iSpitCount 0")
	        self.NextRangeAttackTime = 15
		    --self.HasRangeAttack = false
		    self.LimitChaseDistance = false -- chase enemy when no spits
		    self.AnimTbl_RangeAttack = {nil} -- unconventional way to fix the last range attack anim when iSpitCount = 0
			if !self.IsPoisonBs then
			self.nextSpit = CurTime() +math.Rand(3,8)
		    else
		    self.nextSpit = CurTime()
		    //print(self.nextSpit)
		    end
		    if self.IsHybrid then
			self.nextSpit = CurTime() +math.Rand(5,13) end
		self.nextBsSpitAttack = self.nextSpit
		end
	if self.IsHybrid then
	self.SpitReps = 5+self.iSpitCount
	end
end
function ENT:GetProjectilePosition(BsValidCurEnemy)
          local pos
			if IsValid(BsValidCurEnemy) then
				local posSelf = self:GetPos()
				local posEnemy
				posEnemy = BsValidCurEnemy:OBBCenter()

				local fDistZ = posEnemy.z -posSelf.z
				posSelf.z = 0
				posEnemy.z = 0
				local fDist = posSelf:Distance(posEnemy)
				local fDistZMax = math.Clamp((fDist /450) *500, 0, 500)
				fDistZ = math.Clamp(fDistZ, -fDistZMax, fDistZMax)
				fDist = math.Clamp(fDist, 100, 1250)
				pos = self:GetForward() *fDist +self:GetUp() *fDistZ
			else
				pos = self:GetForward() *500 +Vector(0,0,10)
			end
			pos = pos:GetNormalized() *1200 +Vector(0,0,300 *(pos:Length() /1200))
	return pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() 
	if self.FlameSd then
self.loopsd:Stop() end
end
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse) 
	corpse:SetSkin(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
	local posSpr = self:GetPos() + self:OBBCenter()
		local effectBlood = EffectData()
		effectBlood:SetOrigin(posSpr+ self:GetUp()*15)
		effectBlood:SetColor(VJ_Color2Byte(Color(255,221,85)))
		effectBlood:SetScale(120)
		util.Effect("VJ_Blood1",effectBlood)
		if self.IsFrostBs==true then
	    	local effectBlood2 = EffectData()
	    	effectBlood2:SetOrigin(posSpr+ self:GetUp()*18)
	        effectBlood2:SetColor(VJ_Color2Byte(Color(170,230,200)))
		    effectBlood2:SetScale(90)
			util.Effect("VJ_Blood1",effectBlood2) 
	    elseif self.Immune_Fire then
	    effectBlood:SetColor(VJ_Color2Byte(Color(255,160,55)))
		effectBlood:SetScale(160)
		util.Effect("VJ_Blood1",effectBlood)
		elseif self.IsPoisonBs then
	    effectBlood:SetColor(VJ_Color2Byte(Color(210,70,240)))
		effectBlood:SetScale(130)
		util.Effect("VJ_Blood1",effectBlood)
		elseif self.IsHybrid then
	    effectBlood:SetColor(VJ_Color2Byte(Color(110,110,110)))
	    effectBlood:SetScale(190)
		util.Effect("VJ_Blood1",effectBlood)
		elseif self.ToxicBull then 
		effectBlood:SetOrigin(posSpr+ self:GetUp()*29)
		effectBlood:SetColor(VJ_Color2Byte(Color(150,150,60)))
		effectBlood:SetMagnitude(1)
		util.Effect("VJ_Blood1",effectBlood)
	    end
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(1)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
	    if !self.Immune_Fire then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() + self:OBBCenter())
		effectdata:SetScale(1)
		util.Effect("StriderBlood",effectdata)
		util.Effect("StriderBlood",effectdata)
	    end
	end
	for i=1,2 do
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
    end
	return true -- Return to true if it gibbed!
end
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	--VJ_EmitSound(self, "vj_base/gib/splat.wav", 90, 100)
	--return false
end
