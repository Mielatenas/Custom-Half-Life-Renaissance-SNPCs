AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Model = {"models/icesphere_small.mdl", "models/icesphere_medium.mdl", "models/icesphere_large.mdl"}
ENT.SolidType = SOLID_CUSTOM

ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 60
ENT.RadiusDamage = 10
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_BURN
ENT.RadiusDamageForce = 7 -- Put the force amount it should apply | false = Don't apply any force

ENT.DecalTbl_DeathDecals = {}
ENT.SoundTbl_Idle = {"npc/bullsquid/flame_run_lp.wav"}
ENT.SoundTbl_OnCollide = {"npc/bullsquid/flame_start1.wav", "npc/bullsquid/flame_start2.wav"}
ENT.SoundWater_Tbl = {"waterphysics/watermove1.ogg", "waterphysics/watermove3.ogg", "waterphysics/watersplash1.ogg"}

function ENT:CustomOnInitialize()
    self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetMaterial("models/Effects/splode1_sheet") --sourceengine mat
    
	local hlrMultidmg = GetConVar("hlrcustom_multidmg"):GetFloat()
	self.RadiusDamage = self.RadiusDamage*hlrMultidmg
	self.DirectDamage = self.DirectDamage*hlrMultidmg

    local light = ents.Create("env_sprite")
	self.light = light
	self.light:SetKeyValue( "model", "sprites/light_glow01.spr" )
	self.light:SetKeyValue( "scale", 0.7 )
	self.light:SetKeyValue("rendermode", 3 )
	self.light:SetKeyValue("renderfx", 0)
	self.light:SetKeyValue("renderamt",120)
	self.light:SetKeyValue("rendercolor", "250 210 50")
	self.light:SetPos(self:GetPos())
	self.light:Spawn()
	self.light:SetAttachment(self, -1)
	
        local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:SetBuoyancyRatio(0)
	end
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

function ENT:CustomOnThink()
	if IsValid(self.entOwner) && self:GetPos():Distance(self.entOwner:GetPos()) >= 4000 then self:Remove() end
	if self:WaterLevel() == 3 then 
		VJ_EmitSound(self, self.SoundWater_Tbl, 75, 100)
		self:Remove()
	end
end
function ENT:CustomOnPhysicsCollide(data, phys)
	if !data.HitEntity || self.bCollided then return true end
	//self:Splash()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetStart(self:GetPos())
	effectdata:SetMagnitude(8) -- number of particles
	effectdata:SetRadius(75) -- Bounce Value to be set
	effectdata:SetScale(1)
	util.Effect("hotglow1", effectdata)
	local effectdata1 = EffectData()
	effectdata1:SetOrigin(self:GetPos())
	effectdata1:SetStart(self:GetPos())
	effectdata1:SetScale(0.4)
	util.Effect("impact_splat_fire", effectdata1)

	util.Decal("HLR_Splat_Napalm", data.HitPos +data.HitNormal, data.HitPos -data.HitNormal)
	local ent = data.HitEntity
	if IsValid(ent) && (ent:IsPlayer() || ent:IsNPC() or ent:IsNextBot()) then
		if !IsValid(self.entOwner) || self.entOwner:Disposition(ent) <= 2 then
			if ent:GetClass() != "npc_turret_floor" then
				if ent:WaterLevel() == 3 then return end
				if ent:WaterLevel() == 0 then
				self:DealDamage(data, phys)
			    end
			/*	local dmg = DamageInfo()
				local dmgvalue
				if ent:WaterLevel() == 3 then
					dmgvalue = 0
				elseif ent:WaterLevel() == 0 then
					dmgvalue = 6
				else
					dmgvalue = 5
				end
				dmg:SetDamage(dmgvalue)
				dmg:SetDamageType(DMG_BURN)
				dmg:SetAttacker(IsValid(self.entOwner) && self.entOwner || self)
				dmg:SetInflictor(self)
				dmg:SetDamagePosition(data.HitPos)
				ent:TakeDamageInfo(dmg) */
			elseif !ent.bSelfDestruct then
				ent:GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *10000)
				ent:Fire("selfdestruct", "", 0)
				ent.bSelfDestruct = true
			end
		end
	elseif self:WaterLevel() == 0 then
		local lotteryflame = math.random(5,11)
		if lotteryflame <= 8 then
			self.flamepoint = ents.Create("env_fire")
			self.flamepoint:SetPos(self:GetPos())
			self.flamepoint:SetAngles(self:GetAngles())
			self.flamepoint:SetKeyValue("health",lotteryflame)
			local size = 20+lotteryflame
			self.flamepoint:SetKeyValue("firesize",size)
			self.flamepoint:SetKeyValue("fireattack","0")
			self.flamepoint:SetKeyValue("firetype","Normal")
			//self.flamepoint:SetKeyValue("damagescale",57)
			local flags = 0
			local smoke = math.random(1,2)
			if smoke == 1 then flags = flags + 2 end
			flags = flags + 4
			self.flamepoint:SetKeyValue("spawnflags",flags + 16 + 32 + 128)
			self.flamepoint:Spawn()
			self.flamepoint:Activate()
		end
	end
	self:Remove()
	return true
end
