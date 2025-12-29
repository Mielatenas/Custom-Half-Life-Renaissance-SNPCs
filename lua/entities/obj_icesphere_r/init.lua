//AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = {"models/icesphere_small.mdl","models/icesphere_medium.mdl", "models/icesphere_large.mdl"}
--ENT.PhysicsInitType = SOLID_VPHYSICS
--ENT.SolidType = SOLID_VPHYSICS

ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 30
ENT.RadiusDamage = 2
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_DIRECT
ENT.RadiusDamageForce = 4 -- Put the force amount it should apply | false = Don't apply any force
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 1 -- How much damage should it do when it hits something
--ENT.CollisionDecal = {"HLR_Splat_Poison"}

ENT.DecalTbl_DeathDecals = {"HLR_Splat_Ice"}
ENT.SoundTbl_Idle = {"npc/bullsquid/flame_run_lp.wav"}
ENT.IdleSoundPitch = VJ_Set(130, 200)
ENT.SoundTbl_OnCollide = {"npc/bullsquid/flame_start1.wav", "npc/bullsquid/flame_start2.wav"}
ENT.OnCollideSoundPitch = VJ_Set(130, 310)
ENT.OnCollideSoundLevel = 70

ENT.NextSoundTime_Idle = VJ_Set(1, 4)
ENT.HasStartupSounds = false

function ENT:Init()
	timer.Simple(8,function() if IsValid(self) then self:Remove() end end)
	self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:SetMaterial("models/gibs/ice/ice")
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
	self.light:SetKeyValue("rendercolor", "150 250 250")
	self.light:SetPos(self:GetPos())
	self.light:Spawn()
	self.light:SetAttachment(self, -1)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:SetBuoyancyRatio(1)
		phys:Wake()
		self.phys = phys
	end	
	ParticleEffectAttach("icesphere_trail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	timer.Simple(0.6,function() if IsValid(self) then ParticleEffectAttach("icesphere_trail", PATTACH_ABSORIGIN_FOLLOW, self, 0) end end)

end
function ENT:OnThink()
	if self.HasStartupSounds==false then
        local pos = self:GetPos()
        local trace = util.TraceLine({
        start = pos,
        endpos = pos + Vector(0, 0, -4),
        mask = MASK_WATER
        })
        if trace.Hit then
	  --local mypos = self.phys:GetPos()+ self:GetUp()*55
		--print(util.PointContents( mypos ))
	--if util.PointContents( mypos ) == CONTENTS_WATER then -- some maps unavailable
	--if self:WaterLevel() >= 1 then -- only for players
			self.SoundTbl_Idle = {"waterphysics/watermove1.ogg", "waterphysics/watermove3.ogg", "waterphysics/watersplash1.ogg"}
			self.phys:EnableDrag(true)
			self.phys:SetDragCoefficient(1)
		    self.phys:SetDamping( -1,5 )
		    SafeRemoveEntityDelayed( self, 6 )
		    self.HasStartupSounds = true
		    --VJ_EmitSound(self, self.SoundTbl_Idle, 75, 100)
		end
	end
end

function ENT:SetSize(iSize)
		print(iSize)
	local mdl
	if iSize == 1 then mdl = "models/icesphere_small.mdl"
	elseif iSize == 2 then mdl = "models/icesphere_medium.mdl"
	else mdl = "models/icesphere_large.mdl" end
	//self:SetModel(mdl)
	self.iSize = iSize
	return iSize
end
/*
function ENT:SetEntityOwner(ent) -- unused
	self:SetOwner(ent)
	self.entOwner = ent
end
*/
function ENT:OnDealDamage(data, phys, hitEnts)
	if not FreezeModule or not FreezeModule.FreezeEnemies then return end
	if hitEnts then
       -- FreezeModule.HLRCustomApplyFreeze(data.HitEntity, 10, 2)
        for _, ent in ipairs(hitEnts) do -- entities that can be frozen
            if IsValid(ent) then
                FreezeModule.HLRCustomApplyFreeze(ent, 5, 2)
            end
        end  
    end
end
function ENT:Splash(data, physobj)
    self:DealDamage(data, phys)	//print(iSize)
	self.bCollided = true
		local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetStart(self:GetPos())
	effectdata:SetScale(1)
	util.Effect("env_iceglove", effectdata)
		local effectdata1 = EffectData()
	effectdata1:SetOrigin(self:GetPos())
	effectdata1:SetStart(self:GetPos())
	effectdata1:SetScale(0.4)
	util.Effect("impact_splat_ice", effectdata1)
	local pos = self:GetPos()
	ParticleEffect("icesphere_splash_02", pos, Angle(0,0,0), self) -- test
	local iFreeze
	if self.iSize == 1 then iFreeze = 20
	elseif self.iSize == 2 then iFreeze = 35
	else iFreeze = 50 end
	for k, v in pairs(ents.FindInSphere(pos, 250)) do
		if (v:IsNPC() || v:IsPlayer()) && v != self.entOwner then
			local posDmg = v:NearestPoint(pos)
			local iFreeze = math.Clamp((250 -pos:Distance(posDmg)) /250 *iFreeze, 1, iFreeze)
		end
	end
	timer.Simple(0.1, function() if IsValid(self) then self:Remove() end end)
end
function ENT:OnCollision(data, phys) -- Return true to override the base code
	if !data.HitEntity || self.bCollided then return true end

	self:Splash(data, phys)
	return false
end
function ENT:Touch(ent)

end
