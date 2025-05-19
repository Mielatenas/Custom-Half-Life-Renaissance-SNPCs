AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Model = {"models/half-life/blacsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 140
ENT.BloodColor = "White" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.RangeAttackEntityToSpawn = "obj_hybridsquid_spit_r" -- The entity that is spawned when range attacking
--ENT.FlameParticle = "stukabat_acid_trail"
ENT.FlameDamageType = DMG_POISON

--ENT.MeleeAttackAnimationFaceEnemy = true
ENT.MeleeAttackDistance = 65
--ENT.NextMeleeAttackTime = 0.55 --can't get it lower than the animation duration
ENT.TimeUntilMeleeAttackDamage = false

ENT.LimitChaseDistance_Max = 200 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
//ENT.NextRangeAttackTime = 0.1 -- How much time until it can use a range attack?
--ENT.NextAnyAttackTime_Range = 0.3 -- How much time until it can use any attack again? | Counted in Seconds
//ENT.RangeAttackExtraTimers = {0.4, 0.8, 1.2}
ENT.RangeAttackMaxDistance = 4500 -- This is how far away it can shoot

--ENT.CustomBlood_Decal = {"HLR_Splat_Hybrid"} -- Decals to spawn when it's damaged
ENT.HasBloodDecal = false -- Should it spawn a decal when damaged?
ENT.BloodParticle = {}
ENT.BloodPoolSize = "Small" -- What's the size of the blood pool? | Sizes: "Normal" || "Small" || "Tiny"
--ENT.FlameAttackDmg = 2
--ENT.FlameDmgRadius = 300
--ENT.FlameConeDmgDegree = 30
--ENT.fRangeDistanceFlame = 230
//ENT.FlameSd = "npc/hlrr/fire1.wav"110
ENT.MainSoundPitch = VJ.SET(75, 110) -- Can be a number or VJ.SET

ENT.FootStepTimeWalk = 0.8 -- Next foot step sound when it is walking
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.SpitReps = 6

---DO NOT CHANGE BELOW---
ENT.CanUseFlame = false
ENT.IsHybrid = true
ENT.bIgnitable = false
ENT.bFreezable = false
ENT.nextBlink = 0
function ENT:PreInit()
end
function ENT:OnBleed(dmginfo, hitgroup)
		local effect = EffectData()
		--effect:SetStart(dmginfo:GetDamagePosition())
		--effect:SetNormal(self:GetForward())
		effect:SetEntity(self)
		effect:SetMagnitude(0)
		effect:SetScale(40)
		--effect:SetHitBox(1)
		effect:SetOrigin(dmginfo:GetDamagePosition())
		util.Effect("impact_splat_hybrid",effect)
end

/*function ENT:DamageHandle(dmginfo)
	if self.Eating == true then
		self.Eating = false
		self.nextSequence = 0
		self.nextBloodEffect = 0
		self.nextSound = 0
		self.nextSoundIdle = 0
		self.EatingSound:Stop()
	end
	if ValidEntity(self.entEnemy) || self:IsMoving() || self.bInSchedule || math.random(1,3) != 1 then return end
	local dmgPos = dmginfo:GetDamagePosition()
	local ang = self:CustomHLRenaissanceGetAngleToPos(dmgPos)
	local bCanSee = ang.y > 90 && ang.y < 270
	if bCanSee then
		self:SetLastPosition(dmgPos)
		local schdHop = ai_schedule.New("Surprised Hop")
		schdHop:EngTask("TASK_STOP_MOVING", 0)
		schdHop:EngTask("TASK_STOP_MOVING", 0)
		schdHop:EngTask("TASK_PLAY_SEQUENCE", ACT_HOP)
		schdHop:EngTask("TASK_FACE_LASTPOSITION")
		self:StartSchedule(schdHop)
	end
end */