AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Model = {"models/toxicsquid.mdl"}
ENT.StartHealth = 90
ENT.BloodColor = "Green"
ENT.RangeAttackEntityToSpawn = "obj_bullsquid_spit_r" 
ENT.FlameParticle = "spore_trail"
ENT.FlameDamageType = DMG_ACID

ENT.MeleeAttackDistance = 74 
--ENT.TimeUntilMeleeAttackDamage = false
ENT.RangeAttackMaxDistance = 1000
ENT.LimitChaseDistance_Max = 490 
ENT.LimitChaseDistance_Min = 65
//ENT.RangeAttackPos_Up = 180 -- Up/Down spawning position for range attack

--ENT.bFreezable = false
ENT.CustomBlood_Particle = {"spore_splash_02", "spore_splash_player"}
ENT.BloodPoolSize = "Small" 
ENT.CanUseFlame = true
ENT.FlameAttackDmg = 8
ENT.FlameDmgRadius = 450
ENT.FlameConeDmgDegree = 45
ENT.fRangeDistanceFlame = 300
ENT.FlameSd = "NPC/hlrr/fire1.wav"
ENT.MainSoundPitch = VJ.SET(75, 110) -- Can be a number or VJ.SET

ENT.FootStepTimeWalk = 1.25 -- Next foot step sound when it is walking
ENT.FootStepTimeRun = 0.45 -- Next foot step sound when it is running

---DO NOT CHANGE BELOW---
ENT.ToxicBull = true
ENT.NextMoveAfterFlinchTime = 1.2

function ENT:OnThink()
	if self.bInSchedule and self.FlameOn then
	local effect = EffectData()
	effect:SetStart(self:GetAttachment(1).Pos)
	effect:SetNormal(self:GetForward())
	effect:SetEntity(self)
	effect:SetAttachment(1)
	util.Effect("effect_toxic_spray",effect)
    end
end