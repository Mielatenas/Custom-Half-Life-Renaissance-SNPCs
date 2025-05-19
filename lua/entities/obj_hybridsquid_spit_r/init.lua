AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Model = {"models/weapons/w_bugbait.mdl","models/icesphere_medium.mdl","models/icesphere_large.mdl"}
ENT.SolidType = SOLID_CUSTOM

ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 60
ENT.RadiusDamage = 6
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_RADIATION
ENT.RadiusDamageForce = 5 -- Put the force amount it should apply | false = Don't apply any force

ENT.DecalTbl_DeathDecals = {"HLR_Splat_Hybrid"}
ENT.SoundTbl_Idle = {"npc/bullsquid/flame_run_lp.wav"}
ENT.IdleSoundPitch = VJ_Set(30, 50)
ENT.SoundTbl_OnCollide = {"npc/bullsquid/splat1.wav", "npc/bullsquid/splat2.wav"}
ENT.OnCollideSoundPitch = VJ_Set(45, 77)
ENT.OnCollideSoundLevel = 60
ENT.SoundWater_Tbl = {"waterphysics/watermove1.ogg", "waterphysics/watermove3.ogg", "waterphysics/watersplash1.ogg"}
	ENT.delayRemove = CurTime() +12

function ENT:CustomOnInitialize()
	self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:SetMaterial("particle/particle_ext4unlit_toxhyb")
	local Wcolor = Color( 200, 200, 200, 160 )
	self:SetColor(Wcolor)
	local hlrMultidmg = GetConVar("hlrcustom_multidmg"):GetFloat()
	self.RadiusDamage = self.RadiusDamage*hlrMultidmg
	self.DirectDamage = self.DirectDamage*hlrMultidmg
	
	local light = ents.Create("env_sprite")
	self.light = light
	self.light:SetKeyValue( "model", "sprites/light_glow01.spr" )
	self.light:SetKeyValue( "scale", 0.6 )
	self.light:SetKeyValue("rendermode", 3 )
	self.light:SetKeyValue("renderfx", 0)
	self.light:SetKeyValue("renderamt",150)
	self.light:SetKeyValue("rendercolor", "200 200 200")
	self.light:SetPos(self:GetPos())
	self.light:Spawn()
	self.light:SetAttachment(self, -1)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:SetBuoyancyRatio(0)
	end
	
	self.delayRemove = CurTime() +12
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

function ENT:CustomOnThink()
	if self:WaterLevel() == 3 then 
		VJ_EmitSound(self, self.SoundWater_Tbl, 75, 100)
		//self:Remove()
	end
	if CurTime() < self.delayRemove then return end
	self:Remove()
end

function ENT:CustomOnPhysicsCollide(data, phys)
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
	//effectdata:SetStart(self:GetPos())
	effectdata:SetScale(100)
    effectdata:GetMagnitude(40)
	util.Effect("impact_splat_hybrid", effectdata)
	local ent = data.HitEntity
	if IsValid(ent) && (ent:IsPlayer() || ent:IsNPC()) then
		if !IsValid(self.entOwner) || self.entOwner:Disposition(ent) <= 2 then
			if ent:GetClass() != "npc_turret_floor" then
				if ent:WaterLevel() == 3 then
                    self.RadiusDamage = 1
				end
				if ent:IsPlayer() then
					ent:ScreenFade(SCREENFADE.IN,Color(200,200,200,200), 0.5, 0.2)
				end
			elseif !ent.bSelfDestruct then
				ent:GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *10000)
				ent:Fire("selfdestruct", "", 0)
				ent.bSelfDestruct = true
			end
		end
	end
	self:DealDamage(data, phys)
	self:Remove()
	return true
end

