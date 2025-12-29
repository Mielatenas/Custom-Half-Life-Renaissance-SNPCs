AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.Model = {"models/frostsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 80
ENT.BloodColor = "Blue" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.RangeAttackEntityToSpawn = "obj_icesphere_r" -- The entity that is spawned when range attacking
ENT.FlameParticle = "icesphere_trail"
ENT.Immune_AcidPoisonRadiation = false -- Makes the SNPC not get damage from Acid, poison, radiation
--ENT.MeleeAttackDistance = 44 -- How close does it have to be until it attacks?
--ENT.TimeUntilMeleeAttackDamage = 1.2 -- This counted in seconds | This calculates the time until it hits something

//	"icesphere_splash","icesphere_trail",
ENT.bFreezable = false
ENT.CustomBlood_Particle = {"blood_impact_blue_01"} -- Particles to spawn when it's damaged
ENT.BloodPoolSize = "Small" -- What's the size of the blood pool? | Sizes: "Normal" || "Small" || "Tiny"
ENT.AllowIgnition = false -- Can this SNPC be set on fire?
ENT.CanUseFlame = true
ENT.FlameDamageType = DMG_GENERIC
ENT.IsFrostBs = true
ENT.FlameAttackDmg = 0.4

ENT.DamageScales = {
	[DMG_BURN] = 2,
	[DMG_DIRECT] = 2
}

ENT.NextMoveAfterFlinchTime = 1.2
ENT.FlameSd = "npc/hlrr/fire1.wav"
ENT.FootStepTimeWalk = 1.25 -- Next foot step sound when it is walking
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
--ENT.MainSoundPitchStatic = false

ENT.MainSoundPitch = VJ.SET(95, 130) -- Can be a number or VJ.SET
ENT.FootstepSoundPitch = VJ.SET(95, 160)

ENT.FootStepTimeWalk = 0.82 -- Next foot step sound when it is walking
// DO NOT CHANGE THIS VAIRABLE
ENT.FlameDmgRadius = 400
ENT.FlameConeDmgDegree = 40

--function ENT:ShouldUseFlame() end //return GetEnemy:PercentageFrozen() < 90 end

--function ENT:ShouldUseSpit() end //return self.entEnemy:PercentageFrozen() < 90 end

function ENT:CustomAttackCheck_MeleeAttack()
 return true
 end -- Not returning true will not let the melee attack code run!

function ENT:FlameAttack() 
	local dist = self.fRangeDistanceFlame
	local posSelf = self:GetPos()
	local posDmg = self:GetAttachment(self:LookupAttachment("attach_mouth"))
	for _, ent in pairs(ents.FindInSphere(posDmg.Pos,dist)) do
		if(ent:IsValid() && (ent:IsNPC() || ent:IsPlayer()) && ent != self && self:IsEnemy(ent) && self:Visible(ent) && ent:GetPos().z -posSelf.z <= 65) then
			local posEnt = ent:GetPos()
			local yaw = self:CustomHLRenaissanceGetAngleToPos(posEnt,self:GetAimAngles()).y
			if((yaw <= 70 && yaw >= 0) || (yaw <= 360 && yaw >= 290)) then
				--ent:SetFrozen(16)
			end
		end
	end
end

function ENT:OnThink()
	//self:UpdateLastEnemyPositions()
	if self.bInSchedule and self.FlameOn then
		local effect = EffectData()
		effect:SetStart(self:GetAttachment(1).Pos)
		effect:SetNormal(self:GetForward())
		effect:SetEntity(self)
		effect:SetAttachment(1)
		util.Effect("effect_ice_spray",effect)
    end
end