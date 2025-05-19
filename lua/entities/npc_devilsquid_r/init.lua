AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/devilsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 140
ENT.BloodColor = "Oil" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.RangeAttackProjectiles = "obj_firesphere_r" -- The entity that is spawned when range attacking
ENT.NextRangeAttackTime = 0.6 -- How much time until it can use a range attack?

ENT.NextMeleeAttackTime = 0.7
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?

ENT.FlameParticle = "flame_gargantua"
ENT.Immune_AcidPoisonRadiation = false
--ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.HasBloodParticle = false
ENT.HasBloodDecal = false -- Should it spawn a decal when damaged?
ENT.BloodParticle = {nil}
ENT.BloodPoolSize = "Small" -- What's the size of the blood pool? | Sizes: "Normal" || "Small" || "Tiny"
ENT.AllowIgnition = false -- Can this SNPC be set on fire?
ENT.Immune_Fire = true -- Immune to fire-type damages
//ENT.CanUseFlame = true
ENT.FlameDamageType = DMG_BURN

ENT.FlinchChance = 10
ENT.FlameSd = "npc/bullsquid/flame_run_lp.wav"
ENT.MainSoundPitch = VJ.SET(60, 78) -- Can be a number or VJ.SET
ENT.FootStepTimeWalk = 0.82 -- Next foot step sound when it is walking
ENT.FootstepSoundPitch = VJ.SET(60, 78)
--Do not change--
ENT.fRangeDistanceFlame = 190
ENT.FlameDmgRadius = 280
ENT.FlameConeDmgDegree = 30
ENT.DamageScales = {
	[DMG_BURN] = 0.1,
	[DMG_DIRECT] = 0.1
}
function ENT:OnBleed(dmginfo, hitgroup)
		local effect = EffectData()
		effect:SetEntity(self)
		effect:SetMagnitude(2)
	    effect:SetStart(self:GetPos())
	    effect:SetScale(1)
	    effect:SetRadius(5)
		effect:SetOrigin(dmginfo:GetDamagePosition())
		util.Effect("hotglow1",effect)

	local fireextinguisher = EffectData()
	fireextinguisher:SetEntity(self)
    fireextinguisher:SetMagnitude(2)
	fireextinguisher:SetStart(dmginfo:GetDamagePosition())
	fireextinguisher:SetScale(1)
	fireextinguisher:SetRadius(5)
	fireextinguisher:SetOrigin(dmginfo:GetDamagePosition())
	util.Effect("effect_fireextinguisher",fireextinguisher)
end