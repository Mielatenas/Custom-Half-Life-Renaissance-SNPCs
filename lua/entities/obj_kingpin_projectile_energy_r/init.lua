
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.PhysicsInitType = SOLID_VPHYSICS

ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.CollideCodeWithoutRemoving = true -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
ENT.NextCollideWithoutRemove = VJ_Set(0.5, 1) -- Time until it can run the code again

ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 80 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamage = 3 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageType = DMG_GENERIC -- Damage type
ENT.RadiusDamageForce = 7 -- Put the force amount it should apply | false = Don't apply any force
ENT.RadiusDamageForce_Up = false -- How much up force should it have? | false = Let the base automatically decide the force using RadiusDamageForce value
ENT.RadiusDamageDisableVisibilityCheck = false -- Should it disable the visibility check? | true = Disables the visibility check
	-- ====== Direct Damage Variables ====== --
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 1 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_GENERIC -- Damage type

function ENT:CustomOnInitialize()
	self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self:SetMaterial("invis")
	self:SetMoveCollide(3)
	self:DrawShadow(false)
	self:SetMoveType(MOVETYPE_FLY)
	self:SetSolid(SOLID_CUSTOM)
	self:PhysicsInit(self.PhysicsInitType)
	self:SetHealth(1)
	//self:AddFlags(FL_OBJECT)

    ParticleEffectAttach("kingpin_sphere_rope", PATTACH_POINT_FOLLOW, self, 0)
	local hlrMultidmg = GetConVar("hlrcustom_multidmg"):GetFloat()
	self.RadiusDamage = self.RadiusDamage*hlrMultidmg
	self.DirectDamage = self.DirectDamage*hlrMultidmg
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(1)
		phys:EnableGravity(false)
		phys:EnableDrag(true)
		phys:SetBuoyancyRatio(0)
	end
	
	self.delayRemove = CurTime() +6
    if self.OrbTarget then
    	self.delayRemove = self.delayRemove +5
    end
	self.nextRandDir = CurTime() +math.Rand(0,0.4)
	if self:GetScale() > 1 then self.deploy = CurTime() +4.0 end
end

function ENT:SetScale(nScale)
	self:SetNWInt("scale", nScale)
end

function ENT:GetScale()
	return self:GetNWInt("scale")
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)

	self.entOwner = ent
end
function ENT:SetOrbTarget(target)
	self.OrbTarget = target
end
function ENT:CustomOnThink()
	local phys = self:GetPhysicsObject()
	local dir = self:GetVelocity():GetNormalized()
		if IsValid(phys) then
			if CurTime() >= self.nextRandDir then
		    self.nextRandDir = CurTime() +math.Rand(0,0.4)
			--print("dir: ", dir)
			dir = (dir:Angle() +Angle(math.Rand(-2,2), math.Rand(-4,4),0)):Forward()
			phys:ApplyForceCenter(dir *((2 /self:GetScale()) *1))
           -- dir:Zero() -- sets to zero but angular velocity keeps going crazy
            self:SetLocalAngularVelocity(dir:Angle())
            --phys:SetAngleVelocityInstantaneous( Vector(1,1,1) ) -- won't change angular velocity no matter what here
            end
			if IsValid(self.OrbTarget) then
				orbpos = self:GetPos()
				//local direction = self:GetConstrictedDirection(orbpos, 10, 1, self.OrbTarget:WorldSpaceCenter() +self.OrbTarget:GetVelocity() *0.85) -- the direction changes when angles are modified, can't be used here after obj collides and wasn't able to reach target. 
				local normal = (self.OrbTarget:WorldSpaceCenter() -orbpos):GetNormalized()
				local dist = self.OrbTarget:NearestPoint(orbpos):Distance(orbpos) -- have not figured how to use
				local speed = math.Clamp((dist /30) *20, 20, 30)
				local posTgt = orbpos +normal *speed
				local tr = util.TraceLine({start = orbpos, endpos = posTgt, filter = self, ignoreworld=true})
				--PrintTable(tr)
			    local impuls1 = tr.Normal * 150

	            phys:ApplyForceOffset(impuls1, tr.HitPos) -- apply force toward enemy
	            phys:AddVelocity((normal)/5)
	            phys:SetAngleVelocityInstantaneous( (dir)+posTgt*speed ) -- regulates angular velocity so it won't remove the entity on crazy velocities
	            self:SetLocalAngularVelocity(dir:Angle())
			    --phys:ApplyForceCenter(dir *((8 /self:GetScale()) *12)) -- doesn't provide the wanted goal
				--print("dist: ", dist)
			else
			phys:ApplyForceCenter(dir *((8 /self:GetScale()) *100 +5))
		    end
		end
	if self.deploy && CurTime() >= self.deploy then
		if IsValid(self.entOwner) then
			local pos = self:GetPos()
			for _, ent in pairs(ents.FindInSphere(pos, 100)) do
				if ent:IsNPC() || ent:IsPlayer() || ent:IsNextBot() then
					local disp = self.entOwner:Disposition(ent)
					if disp == D_HT || disp == D_FR then
						self.deploy = nil -- set to nil so it splits just one time
						local angles = {Angle(0,-1,0),Angle(1,0,0),Angle(0,1,0)}
						for _, ang in pairs(angles) do -- for each value of the table
							local entProjectile = ents.Create("obj_kingpin_projectile_energy_r")
							self.RadiusDamageRadius = self.RadiusDamageRadius/3 
							self.RadiusDamage = self.RadiusDamage/3
							--print(self.RadiusDamage)
						    self.RadiusDamageForce = self.RadiusDamageForce/3
							entProjectile:SetEntityOwner(self.entOwner)
							entProjectile:SetPos(self:GetPos())
							entProjectile:SetAngles(self:GetAngles())
							--entProjectile:NoCollide(self)
							entProjectile:SetScale(self:GetScale() *0.4)
							entProjectile:Spawn()
							entProjectile:Activate()
							local phys = entProjectile:GetPhysicsObject()
							if IsValid(phys) then
								local dir = (self:GetVelocity():Angle() +ang):Forward()
								local angDir = dir:Angle()
								local ang = (ent:WorldSpaceCenter() -self:GetPos()):Angle() -angDir
								ang.p = math.Clamp(math.NormalizeAngle(ang.p), -10, 10)
								ang.y = math.Clamp(math.NormalizeAngle(ang.y), -10, 10)
								ang = angDir +ang
								dir = ang:Forward()
								phys:ApplyForceCenter(dir *((4 /entProjectile:GetScale()) *50 +1))
							end
						end
						--self:Remove()
						break
					end
				end
			end
		end
	end
	if CurTime() < self.delayRemove then return end
	self:Remove()
end

function ENT:CustomOnCollideWithoutRemove(data, physobj)
	local ent = data.HitEntity
	if IsValid(ent) && (ent:IsPlayer() || ent:IsNPC()) then
		if !IsValid(self.entOwner) || self.entOwner:Disposition(ent) <= 2 then
			if ent:GetClass() != "npc_turret_floor" then
			elseif !ent.bSelfDestruct then
				ent:GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *10000)
				ent:Fire("selfdestruct", "", 0)
				ent.bSelfDestruct = true
			end
		end
	end
	self.delayRemove = self.delayRemove -1
	ParticleEffect("kingpin_object_charge_bits", data.HitPos, Angle(0,0,0), self)
	self:EmitSound("npc/controller/electro4.wav", 75, 100)
	self:DoDamageCode(data, phys)
	self.RadiusDamage = self.RadiusDamage/1.2
	//self:Remove()
	return true
end

