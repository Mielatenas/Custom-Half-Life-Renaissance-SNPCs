
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Model = {"models/icesphere_small.mdl","models/icesphere_medium.mdl", "models/icesphere_large.mdl"}
ENT.PhysicsInitType = SOLID_VPHYSICS
ENT.SolidType = SOLID_CUSTOM

ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 50
ENT.RadiusDamage = 5
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_DIRECT
ENT.RadiusDamageForce = 3 -- Put the force amount it should apply | false = Don't apply any force
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 1 -- How much damage should it do when it hits something

ENT.DecalTbl_DeathDecals = {"HLR_Splat_Poison"}
ENT.SoundTbl_OnCollide = {"npc/bullsquid/splat1.wav", "npc/bullsquid/splat2.wav"}
ENT.SoundTbl_Idle = {"waterphysics/watermove1.ogg", "waterphysics/watermove3.ogg", "waterphysics/watersplash1.ogg"}
ENT.HasIdleSounds = false
ENT.NextSoundTime_Idle = VJ_Set(3.5, 8.5)

function ENT:CustomOnInitialize()
	self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(self.PhysicsInitType)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:SetMaterial("models/stukabat_acid/stuk_acid") 
	local hlrMultidmg = GetConVar("hlrcustom_multidmg"):GetFloat()
	self.RadiusDamage = self.RadiusDamage*hlrMultidmg
	self.DirectDamage = self.DirectDamage*hlrMultidmg
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:SetBuoyancyRatio(0)
	    self.phys = phys
	end
	
	local light = ents.Create("env_sprite")
	self.light = light
	self.light:SetKeyValue( "model", "sprites/light_glow01.spr" )
	self.light:SetKeyValue( "scale", 0.6 )
	self.light:SetKeyValue("rendermode", 3 )
	self.light:SetKeyValue("renderfx", 0)
	self.light:SetKeyValue("renderamt",140)
	self.light:SetKeyValue("rendercolor", "230 100 230")
	self.light:SetPos(self:GetPos())
	self.light:Spawn()
	self.light:SetAttachment(self, -1)
	ParticleEffectAttach("poisonsquid_sphere_trail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

function ENT:CustomOnThink()
	if self:WaterLevel() >= 1 then 
		if !self.HasIdleSounds then
		    self.phys:SetDamping( 8,8 )
		    SafeRemoveEntityDelayed( self, 4 )
		end
		self.HasIdleSounds = true
		--VJ_EmitSound(self, self.SoundTbl_Idle, 75, 100)
	end
end

function ENT:CustomOnPhysicsCollide(data, phys) -- Return false to disable the base functions from running
	if !data.HitEntity || self.bCollided then return true end
    self:DealDamage(data, phys)
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.Effect("impact_splat_poison", effectdata)
	ParticleEffect("poisonsquid_spores1", data.HitPos, self:GetAngles())

	local owner = self:GetOwner()
	local ent = data.HitEntity
	if IsValid(ent) && (ent:IsPlayer() || ent:IsNPC()) then
		if !IsValid(owner) || owner:Disposition(ent) <= 2 then
			if ent:GetClass() != "npc_turret_floor" then
				local dmg = DamageInfo()
				local dmgvalue
				if ent:WaterLevel() == 3 then
					dmgvalue = 2
				elseif ent:WaterLevel() == 0 then
					dmgvalue = 5
				else
					dmgvalue = 1
				end
				dmg:SetDamage(dmgvalue)
				dmg:SetDamageType(DMG_ACID)
				if IsValid(owner) then
				dmg:SetAttacker(owner or self) end
				dmg:SetInflictor(self)
				dmg:SetDamagePosition(data.HitPos)
				ent:TakeDamageInfo(dmg)
				if ent:IsPlayer() then
					ent:ScreenFade(SCREENFADE.IN,Color(100,20,100,200), 0.4, 0.2)
				end
			elseif !ent.bSelfDestruct then
				ent:GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *10000)
				ent:Fire("selfdestruct", "", 0)
				ent.bSelfDestruct = true
			end
		end
	end
	self:Remove()
	return true
end

