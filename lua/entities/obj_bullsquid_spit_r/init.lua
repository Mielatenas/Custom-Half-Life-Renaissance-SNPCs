
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Model = {"models/icesphere_small.mdl"} -- "models/icesphere_large.mdl","models/icesphere_medium.mdl"
ENT.RemoveOnHit = true
ENT.PaintDecalOnCollide = true -- Should it paint decals when it collides with something? | Use this only when using a projectile that doesn't get removed when it collides with something
ENT.DecalTbl_OnCollideDecals = {"HLR_Splat_Toxic"}
ENT.CollideCodeWithoutRemoving = false
ENT.NextCollideWithoutRemove = VJ_Set(1, 1)
--ENT.MoveCollideType = MOVECOLLIDE_DEFAULT
ENT.MoveCollideType = nil
ENT.CollisionGroupType = nil
ENT.SolidType = SOLID_VPHYSICS

ENT.DecalTbl_DeathDecals = {"HLR_Splat_Toxic"}
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 60
ENT.RadiusDamage = 4
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_ACID
ENT.RadiusDamageForce = 2 -- Put the force amount it should apply | false = Don't apply any force
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 3

ENT.ToxicDeathSoundPitch = VJ_Set(50, 180)
--ENT.SoundWater_Tbl = {"waterphysics/watermove1.ogg", "waterphysics/watermove3.ogg", "waterphysics/watersplash1.ogg"}

ENT.SoundTbl_Idle = {"waterphysics/watermove1.ogg", "waterphysics/watermove3.ogg", "waterphysics/watersplash1.ogg"}
ENT.IdleSoundChance = 12
ENT.IdleSoundLevel = 30
ENT.IdleSoundPitch = VJ_Set(240, 250)
--Do not change bellow !!!
ENT.CustomModelScale = VJ_Set(1.5, 5)
ENT.nextToxicDmgT = 0
local CustomHLRmaxTmines = 70

local function CustomHLRCountAndLimitToxmines()
    local curTmines = ents.FindByClass("obj_bullsquid_spit_r")
    local entityCount = 0
    for _, ent in ipairs(curTmines) do
        entityCount = entityCount + 1
    end
    -- Check if the maximum number of entities has been reached
    if entityCount >= CustomHLRmaxTmines then
        return false
    else
        return true -- Return true to indicate that new entities can be created
    end
end
function ENT:CustomOnPreInitialize()
	local hlrcustomToxicminesMax = GetConVar("hlrcustom_toxic_mines_max"):GetInt()
	CustomHLRmaxTmines = hlrcustomToxicminesMax
    self.BullOwner = self:GetOwner()
    self.VJ_OwnerClassTbl = self.BullOwner.VJ_NPC_Class
end

function ENT:CustomOnInitialize()
	self:SetModelScale( math.Rand(self.CustomModelScale.a, self.CustomModelScale.b),4) -- to make it get a buried-looking inside walls! deltatime solves crazy origin!
	--self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(self.SolidType)
	--self:SetMoveType(MOVETYPE_VPHYSICS)
	--self:SetSolid(SOLID_CUSTOM) -- vj base uses SOLID_VPHYSICS
	self:SetCollisionBounds(Vector(0.5, 0.5 , 0.5), Vector(-0.5, -0.5, 0))
	self:DrawShadow(false)
    self:SetRenderFX( 18)
	
	self:SetMaterial("particle/particle_ext4unlit_toxhyb")
	local Gcolor = Color( 70, 100, 15, 245 )
	self:SetColor(Gcolor) --Not available for "UnlitGeneric"
	local light = ents.Create("env_sprite")
	self.light = light
	self.light:SetKeyValue( "model", "sprites/light_glow01.spr" )
	self.light:SetKeyValue( "scale", 0.5 )
	self.light:SetKeyValue("rendermode", 3 )
	self.light:SetKeyValue("renderfx", 1)
	self.light:SetKeyValue("renderamt",120)
	self.light:SetKeyValue("rendercolor", "150 250 90")
	self.light:SetPos(self:GetPos())
	self.light:Spawn()
	self.light:SetAttachment(self, -1)

	local phys = self:GetPhysicsObject() -- the PhysObj isn't created in client! 
	if IsValid(phys) then
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:SetBuoyancyRatio(3)
	    self.phys = phys
	end	
	local customtoxicMines = GetConVar("hlrcustom_toxic_mines"):GetInt()
	local hlrMultidmg = GetConVar("hlrcustom_multidmg"):GetFloat()
	self.RadiusDamage = self.RadiusDamage*hlrMultidmg
	self.DirectDamage = self.DirectDamage*hlrMultidmg

	self.delayRemove = CurTime() +17

	if self.BullOwner.ToxicBull==true and customtoxicMines>=1 and CustomHLRCountAndLimitToxmines() then
		self.entHit = nil
		self.closestBoneIndex = nil
	    self.hitPos = nil
	    self.UnderWater = nil
		--self.myNewPos = nil -- 
		--self.myCoolBone = nil 
	    self.RemoveOnHit = false
        self.PaintDecalOnCollide = true -- Should it paint decals when it collides with something? | Use this only when using a projectile that doesn't get removed when it collides with something
        self.CollideCodeWithoutRemoving = true
        self.NextCollideWithoutRemove = VJ_Set(1, 2)

        self.RadiusDamageRadius = 30
    end
end
/*
function ENT:SetEntityOwner(ent) -- unused
	self:SetOwner(ent)
	self.entOwner = ent
end
*/

function ENT:CustomOnThink()
	local curTime = CurTime()
	self.ModelScale = self:GetModelScale()
	/*util.AddNetworkString( "UpdateToxBomb_CustomHLR" )
	net.Receive( "UpdateToxBomb_CustomHLR", function( len, ply )
		-- We read in the same order as we written
		self.entHit = net.ReadEntity()
		self.myNewPos = net.ReadVector()
		self.myCoolBone = net.ReadUInt(8)
		--idk why the three variables are readed by all like they were globals, they keep changing their pos
	end )*/
    if IsValid(self.entHit) and self.closestBoneIndex then
        self:SetAngles(self:GetAngles())
        local RightBpos, _ = self.entHit:GetBonePosition(self.closestBoneIndex) -- this gets the proper position, can't be used to attach a particle effect         
        if RightBpos == self.entHit:GetPos() then
            local MtxBone = self.entHit:GetBoneMatrix(self.closestBoneIndex)
            if MtxBone then
                RightBpos = MtxBone:GetTranslation()
            end
        end
        self:SetPos(RightBpos, false) --false to teleport
        if IsValid(self.phys) then
		   --self.phys:ApplyTorqueCenter( Vector(4.5,14,41) )
           -- self.phys:SetPos(RightBpos, false) --false to teleport
        end 
        /*--print("COMON BLUE")
        util.AddNetworkString( "UpdateToxBomb_CustomHLR" )
        net.Start("UpdateToxBomb_CustomHLR")
        net.WriteEntity(self.entHit) 
        net.WriteVector(RightBpos)
        net.WriteUInt(self.closestBoneIndex,8)
        net.Broadcast()
        */
        if !self.UpdateToxBomb_CustomHLR then
            self.UpdateToxBomb_CustomHLR = true
        end
    end
    if IsValid(self.entHit) then
    	if !self.entHit:Alive() and (self.entHit:IsPlayer()) then
    	    if self.data then
	        self:CustomHlrToxicGasDeath(self.data, phys, dmgorigin)-- destroy itself if player died
	        else
	        self:Remove()
	        end
        end
    end
    /*if IsValid(self.entHit) and self.RemoveOnHit==false then
    	--print("aaa")
        if IsValid(self.phys) then
		   --self.phys:ApplyTorqueCenter( Vector(4.5,14,41) )
        end 
    	if !self.alreadyparented then
    		--self:SetPos(self.myNewPos, true)
    		--print("parentedalready")
		    --self:SetParent(self.entHit,self.myCoolBone)
            --self.entHit:SetParentPhysNum(self.myCoolBone) -- won't do anything serverside
            --self:AddEffects(EF_FOLLOWBONE)
            self.alreadyparented = true
        end
    end */
	if curTime > self.nextToxicDmgT then -- the rest DID need a timer fix
		self.nextToxicDmgT = curTime +self.ModelScale
		self:SetModelScale(math.Rand(self.CustomModelScale.a, self.CustomModelScale.b),3)
		self:RemoveAllDecals()
		local dmgorigin = self:GetPos()
		if !self.phys:IsMotionEnabled() then
			local tr = util.TraceLine({start = dmgorigin, endpos = dmgorigin+self.wHitNormal*10, filter =self, mask=MASK_NPCWORLDSTATIC})
			if !tr.Hit or tr.HitSky then -- or tr.HitNoDraw 			
			    self.phys:EnableMotion(true)
			    self.phys:Wake()
			    self.phys:ApplyForceCenter( Vector(0,0,-1) )
			end
        end
		local TFilter1
	    if !IsValid(self.BullOwner) then
        	if IsValid(self.entHit) then
        	    self.BullOwner = self.entHit
        	else
        	    self.BullOwner = self
        	end
        end
        if IsValid(self.BullOwner) then --and IsValid(self.entHit)
        	TFilter1 = true --(!self.entHit:IsNPC() || self.BullOwner:Disposition(self.entHit) <= 2)--true if is no NPC or true if enemy
            self.TFilter1 = TFilter1
        end
        local entHit = self.entHit
		local tblEnts = util.CustomHlrBlastDmg(self, self.BullOwner, dmgorigin, self.RadiusDamageRadius, self.RadiusDamage/8,
		function(entHit) -- have to test if works for nextbot
			return self.TFilter1 && (!entHit:IsPlayer() || !tobool(GetConVarNumber("ai_ignoreplayers"))) --true if no player or true if ai_ignoreplayers is 0
		end, self.RadiusDamageType, false, self.VJ_OwnerClassTbl)
		/*if table.Count(tblEnts) > 0 then
		end*/
		/*self:DeathEffects()
		self:DoDamageCode(data, phys)
		--Can't use VJ_SphereDamage when called on a projectile since harms ents allies, may be VJ base version
	        local CheckIfPlayer = false
		    if IsValid(self) then
			   CheckIfPlayer = !self:IsPlayer()
		    end 
		    util.VJ_SphereDamage(self.BullOwner, nil, dmgorigin, self.RadiusDamageRadius, 0.5, self.RadiusDamageType, true, true, {Force=1, UpForce=0,UseConeDegree=30,UseConeDirection=self:GetForward()})
    */
    end
    if self:WaterLevel() == 3 and self.UnderWater==nil then 
		VJ_EmitSound(self, self.SoundTbl_Idle, 75, 100)
		self.UnderWater=true
	end
	if curTime > self.delayRemove then
		if self.data then
	    self:CustomHlrToxicGasDeath(self.data, phys, dmgorigin)
	    else
	    self:Remove()
	    end
	end
end 
/*function ENT:DeathEffects()
	self:DoDamageCode()
	self:SetDeathVariablesTrue(nil, nil, false)
end */
function ENT:CustomOnPhysicsCollide(data, phys)
	self:SetNWBool("active", true)
	self.data = data
	local entHit = data.HitEntity 
    local dmgorigin = self:GetPos()
    local IsTanknoBone = entHit:LookupBone("static_prop")==0
    self.wHitNormal = data.HitNormal
    self.hitPos = data.HitPos

	if IsValid(self.phys) then
        self.phys:EnableDrag(true)
        self.phys:SetDragCoefficient(55)
        if IsValid(entHit) and (IsTanknoBone or VJ_IsProp(entHit) or entHit:GetClass():sub(1, 5) == "prop_" ) and (!entHit:IsRagdoll() or !entHit:GetClass() == "prop_ragdoll") then
            self:SetPos(self.hitPos)
            self:SetParent(entHit)
	    end
        if !self.phys:IsMotionEnabled() then self:CustomHlrToxicGasDeath(data, phys, dmgorigin) end
        if entHit:IsWorld() then --data.HitNormal
            local tr = util.TraceLine({start = dmgorigin, endpos = dmgorigin+self.wHitNormal*20, filter =self, mask=MASK_ALL})
			if !tr.HitSky then --or !tr.HitNoDraw
            self.phys:EnableMotion(false)
            end 
        end
    end
	if IsValid(entHit) and (!VJ_IsProp(entHit) and IsTanknoBone==false) && (self.BullOwner.ToxicBull==true) and (entHit:IsPlayer() || entHit:IsNPC() || entHit:IsNextBot() || (entHit:IsRagdoll() or entHit:GetClass() == "prop_ragdoll")) then
          --print(entHit:GetBoneCount())
		    --self:SetNWEntity("entStart", entHit) -- deactivated
		if self.closestBoneIndex==nil and self.BullOwner:Disposition(entHit) <= 2 then --and self.BullOwner:Disposition(entHit) <= 2
			self:CollisionRulesChanged() -- test
			self:SetMoveType(MOVETYPE_NONE) --WARNING: Changing collision rules within a callback is likely to cause crashes!
	        --self:SetSolid(SOLID_NONE)     
        	local closestBones = {} -- Initialize the table
        	if IsValid(entHit) /*BoneIndex!=nil and*/ then
            	local closestBoneIndex = nil
            	local closestDistanceSqr = math.huge
            	for i = 0, entHit:GetBoneCount() - 1 do -- Iterate through all bones of the hit entity
                	local bonePos, _ = entHit:GetBonePosition(i)
            		-- Ensure bonePos is valid
                	if bonePos == entHit:GetPos() then
                    	local MtxBone = entHit:GetBoneMatrix(i)
                    	if MtxBone then
                        	bonePos = MtxBone:GetTranslation()
                    	end
                	end
                	local distanceSqr = (bonePos - self.hitPos):LengthSqr() -- Check if this bone is the closest to the hit position
                	if distanceSqr < closestDistanceSqr then
                    	closestDistanceSqr = distanceSqr
                    	closestBones = {i}
                	elseif distanceSqr == closestDistanceSqr then
                    	table.insert(closestBones, i) -- Add to the list of closest bones
                	end
            	end
        	end
        	if #closestBones > 0 then  
            	self.closestBoneIndex = closestBones[1] -- You can change this to select a different bone if needed 
            	if IsValid(entHit) then
            	self.entHit = entHit  
                --timer.Simple(0.1, function() if IsValid(self) and IsValid(self.entHit) then
                self:SetPos(self.hitPos, false) --true to teleport
                self:SetParent(self.entHit,self.closestBoneIndex)
                --entHit:SetParentPhysNum(self.closestBoneIndex) -- won't do anything serverside
                self:AddEffects(EF_FOLLOWBONE)
                self:SetOwner(self.entHit)
                ----self:AddEffects(EF_BONEMERGE)
                --end end)
                end
        	end
    	end      
                /*
                --self:SetNWInt("attachmentStart", closestBoneIndex) -- unused
                util.AddNetworkString("SendPosition")
                net.Start("SendPosition")
                net.WriteVector(hitPos)
                net.Broadcast()
               	--self.phys:SetPos(RightBpos)
				--self:SetPos(RightBpos)
                 */
-- we have to make the server get data from client, the mines attach to the bone after 3-6 secs
--seems like server needs to get updated position values from the client continuosly, that explains why some don't attach to the bones due to unsync
	    if entHit:GetClass() != "npc_turret_floor" then
            local tblEnts = util.CustomHlrBlastDmg(self, self.BullOwner, dmgorigin, self.RadiusDamageRadius, self.RadiusDamage,
		    function(entHit) -- have to test if works for nextbot
			    return self.TFilter1 && (!entHit:IsPlayer() || !tobool(GetConVarNumber("ai_ignoreplayers"))) --true if no player or true if ai_ignoreplayers is 0
		    end, self.RadiusDamageType, false, self.VJ_OwnerClassTbl)
		/*if table.Count(tblEnts) > 0 then
		end*/
		    --util.VJ_SphereDamage(self, self, dmgorigin, self.RadiusDamageRadius, self.RadiusDamage, self.RadiusDamageType, true, true, {Force=3, UpForce=0})
			if entHit:IsPlayer() then
			    entHit:ScreenFade(SCREENFADE.IN,Color(10,40,0,200), 0.3, 0)
			end
		elseif !entHit.bSelfDestruct then
			entHit:GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *10000)
			entHit:Fire("selfdestruct", "", 0)
			entHit.bSelfDestruct = true
		end
    else
    	if self.BullOwner.ToxicBull==true then
		    --    self.phys:SetBuoyancyRatio(1)
			--ParticleEffectAttach("toxicsquid_gas_toxic01", PATTACH_POINT_FOLLOW, self,0)
			/*
            if self.CreateParticleEffect then
            print("CreateParticleEffect method is available.") 
            else
            print("CreateParticleEffect method is not available for this entity.") 
            end
		    local particleEffect = self:CreateParticleEffect("toxicsquid_gas_toxic01", 1, options)
	        */
	    end
	end
	if self.RemoveOnHit==true then
	    self:EmitSound("npc/bullsquid/splat" .. math.random(1,2) .. ".wav", 75, 100)
	    --local effectdata = EffectData()
	    --effectdata:SetOrigin(self:GetPos())
	    --util.Effect("impact_splat", effectdata)
	    ParticleEffect("spore_splash", self:GetPos(), self:GetAngles(), self.entOwner)
	end
    timer.Simple(self.delayRemove, function() if IsValid(self) then
    self:CustomHlrToxicGasDeath(data, phys, dmgorigin)
        end 
    end) 
	return true
end
function ENT:CustomHlrToxicGasDeath(data, phys, dmgorigin)
	dmgorigin = dmgorigin or self:GetPos()
    --self.RemoveOnHit=true
		--self.StopAndDestroyParticles()
	    --local effectdata = EffectData()
	    --effectdata:SetOrigin(self:GetPos())
	    --util.Effect("impact_splat", effectdata)
	    --util.Decal("HLR_Splat_Toxic", data.HitPos +data.HitNormal, data.HitPos -data.HitNormal)
	ParticleEffect("spore_splash_02", self:GetPos(), self:GetAngles(), self.entOwner)
	    --self:DoDamageCode(data, phys)
	local CheckIfPlayer = false
		if IsValid(self) then
			CheckIfPlayer = !self:IsPlayer()
		end
    local tblEnts = util.CustomHlrBlastDmg(self, self.BullOwner, dmgorigin, self.RadiusDamageRadius, self.RadiusDamage,
		function(entHit) -- have to test if works for nextbot
			return self.TFilter1 && (!entHit:IsPlayer() || !tobool(GetConVarNumber("ai_ignoreplayers"))) --true if no player or true if ai_ignoreplayers is 0
		end, self.RadiusDamageType, false, self.VJ_OwnerClassTbl)
		/*if table.Count(tblEnts) > 0 then
		end*/
	--util.VJ_SphereDamage(self, self, dmgorigin, self.RadiusDamageRadius, self.RadiusDamage, self.RadiusDamageType, true, true, {Force=3, UpForce=0})
	self:EmitSound("npc/bullsquid/splat" .. math.random(1,2) .. ".wav", 40, math.random(self.ToxicDeathSoundPitch.a, self.ToxicDeathSoundPitch.b))
	SafeRemoveEntityDelayed( self, 0.1 )
 end
function ENT:CustomOnRemove()
self:CustomHlrToxicGasDeath(self.data, phys, dmgorigin)
end

