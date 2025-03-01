AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/devilsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 140
ENT.BloodColor = "Oil" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.RangeAttackEntityToSpawn = "obj_firesphere_r" -- The entity that is spawned when range attacking
ENT.NextRangeAttackTime = 0.6 -- How much time until it can use a range attack?

ENT.NextMeleeAttackTime = 0.7
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?

ENT.FlameParticle = "flame_gargantua"
ENT.Immune_AcidPoisonRadiation = false
--ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.CustomBlood_Particle = {nil} -- Particles to spawn when it's damaged
ENT.BloodPoolSize = "Small" -- What's the size of the blood pool? | Sizes: "Normal" || "Small" || "Tiny"
ENT.AllowIgnition = false -- Can this SNPC be set on fire?
ENT.Immune_Fire = true -- Immune to fire-type damages
//ENT.CanUseFlame = true
ENT.FlameDamageType = DMG_BURN
ENT.FlameDmgRadius = 280
ENT.FlameConeDmgDegree = 30
ENT.DamageScales = {
	[DMG_BURN] = 0.1,
	[DMG_DIRECT] = 0.1
}

ENT.FlinchChance = 10
ENT.FlameSd = "npc/bullsquid/flame_run_lp.wav"
ENT.GeneralSoundPitch1 = 60
ENT.GeneralSoundPitch2 = 78
ENT.FootStepTimeWalk = 0.82 -- Next foot step sound when it is walking
ENT.FootStepPitch = VJ_Set(false, false)
ENT.BreathSoundPitch = VJ_Set(false, false)

function ENT:CustomOnThink()

end