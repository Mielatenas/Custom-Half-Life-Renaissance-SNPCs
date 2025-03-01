include('shared.lua')

language.Add("obj_bullsquid_spit_r", "Toxicmine")
function ENT:Draw()
    self:DrawModel()
    self:DrawShadow(false)
    self:SetRenderFX( 18)

    if !self:GetNWBool("active") or self.ActiveParticleEffect==true then return end
    	--self:SetCollisionGroup(COLLISION_GROUP_WORLD) -- we have to make the entity collide so it does vj base dmg
		self.ActiveParticleEffect = true
		self.DrawLuaEffectToxic = false
        ParticleEffectAttach("toxicsquid_gas_toxic01", PATTACH_POINT_FOLLOW, self,0)
end

function ENT:Initialize()
   -- self:SetMaterial("gmod_silent")
       --local phys = self:GetPhysicsObject() -- the PhysObj isn't present in client! 
	self.closestBoneIndex = nil
	self.hitPos = nil
	self.emitter = ParticleEmitter(self:GetPos())
    self.DrawLuaEffectToxic = true
end
 
function ENT:OnRemove()
	self.emitter:Finish()
	self:StopParticles()
end

function ENT:Think() -- moved code to Think from Draw and now they grasp more frequent?
    local entHit = self:GetNWEntity("entStart")
    --local BoneIndex = self:GetNWInt("attachmentStart") taken out to save slot space 
    /*net.Receive("SendPosition", function() 
        self.hitPos = net.ReadVector() -- data.HitPos info
    end)*/ 
    /*
    if self.closestBoneIndex==nil and isvector(self.hitPos) then
        local closestBones = {} -- Initialize the table
        if IsValid(entHit) then
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
        end
    end 
    */     
    net.Receive("UpdateToxBomb_CustomHLR", function() 
        self.entHit = net.ReadEntity()
        self.UpdatePos = net.ReadVector()
        self.closestBoneIndex = net.ReadUInt(8)
    end)
    /*if IsValid(self.entHit) and isvector(self.UpdatePos) then
        self:SetAngles(self:GetAngles())
        local RightBpos = entHit:GetBonePosition(self.closestBoneIndex) -- this gets the proper position, can't be used to attach a particle effect         
        if !self.UpdateToxBomb_CustomHLR then
            net.Start("UpdateToxBomb_CustomHLR")
            net.WriteEntity(entHit)
            net.WriteVector(RightBpos)
            --net.WriteEntity(self) 
            net.WriteUInt(self.closestBoneIndex,8)
            net.SendToServer()
            */
            /*self.UpdateToxBomb_CustomHLR = true
        end
        self:SetPos(self.UpdatePos, true)
        self:SetParent(self.entHit) --not supported?
        self.entHit:SetParentPhysNum(self.closestBoneIndex) -- parent the bone
        self:AddEffects(EF_FOLLOWBONE)
        self.DrawLuaEffectToxic = false
    else
    end*/
	if self.DrawLuaEffectToxic==true then
		for i=1,4 do
			local particle = self.emitter:Add("slimesplat_toxic", self:GetPos())
 			if particle then
 				particle:SetVelocity(VectorRand(-200, 200) )
 				particle:SetLifeTime(0)
 				particle:SetDieTime(1)
 				particle:SetStartAlpha(math.Rand(100, 255))
 				particle:SetEndAlpha(0)
 				particle:SetStartSize(10)
 				particle:SetEndSize(2)
 				particle:SetRoll(math.Rand(0, 360))
                if self:WaterLevel() == 3 then 
                    particle:SetGravity(Vector(0, 0, -50))
                    particle:SetAirResistance(3000)
                else 
                    particle:SetAirResistance(400)
                    particle:SetGravity(Vector(0, 0, -500))
                end
 		    end
 		end
    end
end