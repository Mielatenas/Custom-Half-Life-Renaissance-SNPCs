AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/half-life/poissquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 120
ENT.BloodColor = "Purple" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.RangeAttackEntityToSpawn = "obj_poisonsquid_spit_r" -- The entity that is spawned when range attacking
ENT.FlameParticle = "poisonsquid_sphere_trail"
ENT.FlameDamageType = DMG_POISON

ENT.MeleeAttackDistance = 74 -- How close does it have to be until it attacks?
ENT.NextMeleeAttackTime = 0.7 --can't get it lower than the animation duration
ENT.NextMeleeAttackTime_DoRand = 1.15
--ENT.TimeUntilMeleeAttackDamage = 1 -- This counted in seconds | This calculates the time until it hits something
//ENT.NextRangeAttackTime = 0.1 -- How much time until it can use a range attack? -- do not change here, breaks the code base
//ENT.NextAnyAttackTime_Range = 0.4 -- How much time until it can use any attack again? | Counted in Seconds
//ENT.NextAnyAttackTime_Range_DoRand = -0.3 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
//ENT.RangeAttackExtraTimers = {0.4, 0.8, 1.2}
ENT.RangeAttackPos_Forward = 30 -- Forward/Backward spawning position for range attack
ENT.RangeAttackPos_Up = 25 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Right = 0 -- Right/Left spawning position for range attack

ENT.CustomBlood_Decal = {"HLR_Splat_Poison"}
ENT.CustomBlood_Particle = {"poisonsquid_splash1"} 
ENT.BloodPoolSize = "Small"

ENT.FlameAttackDmg = 1
ENT.FlameDmgRadius = 300
ENT.FlameConeDmgDegree = 30
ENT.fRangeDistanceFlame = 230
//ENT.FlameSd = "npc/hlrr/fire1.wav"

ENT.GeneralSoundPitch1 = 75
ENT.GeneralSoundPitch2 = 110
ENT.FootStepTimeWalk = 0.8 -- Next foot step sound when it is walking
ENT.FootStepTimeRun = 0.2 -- Next foot step sound when it is running
ENT.FootStepPitch = VJ_Set(false, false)
ENT.BreathSoundPitch = VJ_Set(false, false)

ENT.bIgnitable = false
ENT.bFreezable = false
----DO NOT CHANGE BELOW!----
ENT.CanUseFlame = true
ENT.IsPoisonBs = true
ENT.RT = 0

function ENT:CustomOnThink()
	if self.IsSparying == true && CurTime() > self.NextSprayT then
		-- local att = self:GetAttachment(1)
		-- local effect = EffectData()
		-- effect:SetStart(att.Pos)
		-- effect:SetNormal(att.Ang:Forward())
		-- effect:SetEntity(self)
		-- effect:SetAttachment(1)
		-- effect:SetSize(0.4)
		-- util.Effect("effect_geneworm_poison",effect)
		self.NextSprayT = CurTime() +0.1
	end
	if !self.bInSchedule then return end
	    if self.SpecialEvAnim then
		local att = self:GetAttachment(1)
		local effect = EffectData()
		effect:SetStart(att.Pos + self:GetForward()*40 -self:GetUp()*20)
		effect:SetNormal(att.Ang:Forward())
		effect:SetEntity(self)
		effect:SetAttachment(1)
		-- effect:SetSize(0.4)
		util.Effect("effect_poisonsquid_poison",effect)
	    end
end

function ENT:DealPoisonDamage(dist,dmg,attacker)
	local dist = dist || self.fRangeDistance
	local dmg = dmg || GetConVarNumber("sk_" .. self.skName .. "_dmg_flame")
	local posDmg = self:GetPos() +(self:GetForward() *self:OBBMaxs().y)
	for _, ent in pairs(ents.FindInSphere(posDmg,dist)) do
		if (ent:IsValid() || ent:CustomHLRenaissanceIsPhysicsEntity()) && self:Visible(ent) then
			local posEnt = ent:GetPos()
			local yaw = self:CustomHLRenaissanceGetAngleToPos(posEnt,self:GetAimAngles()).y
			if((yaw <= 70 && yaw >= 0) || (yaw <= 360 && yaw >= 290)) then
				local dmginfo = DamageInfo()
				dmginfo:SetDamageType(DMG_POISON)
				dmginfo:SetDamage(dmg)
				dmginfo:SetAttacker(attacker || self)
				dmginfo:SetInflictor(self)
				ent:TakeDamageInfo(dmginfo)
			end
		end
	end
end

function ENT:FlameAttack() self:DealPoisonDamage(self.fRangeDistanceFlame) end
