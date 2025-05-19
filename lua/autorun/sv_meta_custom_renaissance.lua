local meta = FindMetaTable("Weapon")
local tblPlayerSpeed = {}
meta = FindMetaTable("Player")

function meta:FadeScreen(col, durFade, durHold)
	col = col || Color(0,0,0,255)
	durFade = durFade || 2
	durHold = durHold || 0
	umsg.Start("HLR_FadeScreen", self)
		umsg.String(col.r .. "," .. col.g .. "," .. col.b .. "," .. col.a)
		umsg.Float(durFade)
		umsg.Float(durHold)
	umsg.End()
end

/*
hook.Add("PlayerStepSoundTime", "PlayerStepSoundTime_Frozen", function(pl, iType, bWalking)
	if pl:CustomHLRIsFrozen() or pl:IsFrozen() then
		local iPercentFrozen = pl:FrozenPercentage()
		local fStepTime = 350
		local fMaxSpeed = pl:GetMaxSpeed()
		if iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT then
			if fMaxSpeed <= 100 then 
				fStepTime = 400
			elseif fMaxSpeed <= 300 then 
				fStepTime = 350
			else 
				fStepTime = 250 
			end
		elseif iType == STEPSOUNDTIME_ON_LADDER then
			fStepTime = 450 
		elseif iType == STEPSOUNDTIME_WATER_KNEE then
			fStepTime = 600 
		end
		if pl:Crouching() then
			fStepTime = fStepTime + 50
		end
		return fStepTime *math.Clamp(iPercentFrozen /50, 1, 2)
	end
end)
*/
function meta:SetPermanentlyFrozen(bPerm)
	if bPerm then
		self:SetFrozen(100)
		self.tblFrozen.permanent = true
		return
	end
	if !self.tblFrozen then return end
	self.tblFrozen.permanent = nil
end

function meta:SetFrozen(iPercent)
	if self:IsPossessing() then return end
	iPercent = iPercent || 100
	if iPercent > 0 && self:IsOnFire() then self:Extinguish() end
	local r,g,b,a = self:GetColor()
	if !self.tblFrozen then
		self.tblFrozen = {}
		self.tblFrozen.speedWalk = self:GetWalkSpeed()
		self.tblFrozen.speedRun = self:GetRunSpeed()
		self.tblFrozen.jumpPower = self:GetJumpPower()
		self.tblFrozen.duckSpeed = self:GetDuckSpeed()
		self.tblFrozen.unDuckSpeed = self:GetUnDuckSpeed()
		self.tblFrozen.iPercent = 0
		self.tblFrozen.nextUnfreeze = CurTime() +3
		--local wep = self:GetActiveWeapon()
		--self.tblFrozen.wepCur = wep
		--self.tblFrozen.nextPrimary = IsValid(wep) && wep:GetNextPrimaryFire() || 0
		--local delayMin = self.tblFrozen.nextPrimary -CurTime()
		--local delayMax = delayMin *10
		--local nextPrimary = ((delayMin /100) *(100 -iPercent) +(delayMax /100) *iPercent) +CurTime()
		--wep:SetNextPrimaryFire(nextPrimary)
		
		self.bFrozen = true
		
		local ang
		local entIndex = self:EntIndex()
		hook.Add("Think", "ThinkEntFrozen" .. entIndex, function()
			if !IsValid(self) then hook.Remove("Think", "ThinkEntFrozen" .. entIndex); return end
			if self:Health() <= 0 then
				self:UnFreeze()
				return
			end
			self:GetViewModel():SetPlaybackRate((100 -self.tblFrozen.iPercent) /100)
			local wep = self:GetActiveWeapon()
			if IsValid(wep) then
				if self.tblFrozen.iPercent == 100 then
					wep:SetNextPrimaryFire(CurTime() +0.2)
					wep:SetNextSecondaryFire(CurTime() +0.2)
				else
					local nextPrimary = wep:GetNextPrimaryFire()
					if !wep.nextPrimaryFire || nextPrimary != wep.nextPrimaryFire then
						local delayMin = nextPrimary -CurTime()
						local delayMax = delayMin *10
						wep.nextDefaultPrimaryFire = nextPrimary -CurTime()
						wep.primaryEnd = nextPrimary +CurTime()
						wep.nextPrimaryFire = ((delayMin /100) *(100 -self.tblFrozen.iPercent) +(delayMax /100) *self.tblFrozen.iPercent) +CurTime()
						wep:SetNextPrimaryFire(wep.nextPrimaryFire)
						wep.nextPrimaryFire = wep:GetNextPrimaryFire()
					end
					local nextSecondary = wep:GetNextSecondaryFire()
					if !wep.nextSecondaryFire || nextSecondary != wep.nextSecondaryFire then
						local delayMin = nextSecondary -CurTime()
						local delayMax = delayMin *10
						wep.nextDefaultSecondaryFire = nextSecondary -CurTime()
						wep.secondaryEnd = nextSecondary +CurTime()
						wep.nextSecondaryFire = ((delayMin /100) *(100 -self.tblFrozen.iPercent) +(delayMax /100) *self.tblFrozen.iPercent) +CurTime()
						wep:SetNextSecondaryFire(wep.nextSecondaryFire)
						wep.nextSecondaryFire = wep:GetNextSecondaryFire()
					end
				end
			end
			if self.tblFrozen.iPercent >= 80 then if !ang then ang = self:GetAngles() end; self:SetAngles(ang) end
			if !self.tblFrozen.permanent && CurTime() >= self.tblFrozen.nextUnfreeze then
				self.tblFrozen.nextUnfreeze = CurTime() +0.2
				self:UnFreeze(1)
			end
		end)
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		
		umsg.Start("ENT_FreezeEffect_Render", rp)
			umsg.Entity(self)
		umsg.End()
	elseif self.tblFrozen.iPercent >= 100 then self.tblFrozen.nextUnfreeze = CurTime() +3; return end
	if self.tblFrozen.iPercent +iPercent >= 100 then iPercent = 100 -self.tblFrozen.iPercent end
	self.tblFrozen.iPercent = self.tblFrozen.iPercent +iPercent
	
	local flScale = 100 -self.tblFrozen.iPercent
	self:SetWalkSpeed((self.tblFrozen.speedWalk /100) *flScale)
	self:SetRunSpeed((self.tblFrozen.speedRun /100) *flScale)
	self:SetJumpPower((self.tblFrozen.jumpPower /100) *flScale)
	
	local flDuckScale = math.Clamp(self.tblFrozen.iPercent /10, 1, 10)
	self:SetDuckSpeed(self.tblFrozen.duckSpeed *flDuckScale)
	self:SetUnDuckSpeed(self.tblFrozen.unDuckSpeed *flDuckScale)
	self:SetNetworkedFloat("FreezePercent", self.tblFrozen.iPercent)
	self.tblFrozen.nextUnfreeze = CurTime() +3
end

function meta:FrozenPercentage()
	return self.bFrozen && self.tblFrozen.iPercent || 0
end

local function BreakIceGibs(ent)
	local tblIceShards = {}
	local i = 0
	local bonepos, boneang = ent:GetBonePosition(i)
	while bonepos do
		local flDistMin = 999
		for k, v in pairs(tblIceShards) do
			if i != k then
				local flDist = bonepos:Distance(ent:GetBonePosition(k))
				if flDist < flDistMin then flDistMin = flDist end
			end
		end
		if flDistMin > 4 then
			local ent = ents.Create("obj_gib")
			ent:SetModel("models/gibs/ice_shard0" .. math.random(1,6) .. ".mdl")
			ent:SetPos(bonepos)
			ent:SetAngles(boneang)
			ent:Spawn()
			ent:Activate()
			tblIceShards[i] = ent
		end
		i = i +1
		bonepos, boneang = ent:GetBonePosition(i)
	end
	ent:EmitSound("physics/glass/glass_largesheet_break" .. math.random(1,3) .. ".wav", 75, 100)
	if ent:IsPlayer() then
		local pos = ent:GetPos()
		ent:Spawn()
		ent:SetPos(pos)
		ent:KillSilent()
	else ent:Remove() end
end

hook.Add("OnNPCKilled", "HLR_BreakFrozen_NPC", function(npc, entKiller, entWeapon) -- a frozen npc dies
	   --print(npc) 
	if npc:IsNPC() then
	    if npc:FrozenPercentage() >= 80 then
		    BreakIceGibs(npc)
	    end
	end
end)

hook.Add("PlayerDeath", "HLR_BreakFrozen_Player", function(entVictim, entInflictor, entKiller)
	if entVictim:FrozenPercentage() >= 80 then
		BreakIceGibs(entVictim)
	end
end)

function meta:UnFreeze(iPercent)
	iPercent = iPercent || 100
	if !self.bFrozen then return end
	if self.tblFrozen.iPercent -iPercent < 0 then iPercent = self.tblFrozen.iPercent end
	self.tblFrozen.iPercent = self.tblFrozen.iPercent -iPercent
	self:SetNetworkedFloat("FreezePercent", self.tblFrozen.iPercent)
	local iScale = 255 -((self.tblFrozen.iPercent /100) *155)
	
	local flScale = 100 -self.tblFrozen.iPercent
	self:SetWalkSpeed((self.tblFrozen.speedWalk /100) *flScale)
	self:SetRunSpeed((self.tblFrozen.speedRun /100) *flScale)
	self:SetJumpPower((self.tblFrozen.jumpPower /100) *flScale)
	
	local flDuckScale = math.Clamp(self.tblFrozen.iPercent /10, 1, 10)
	self:SetDuckSpeed(self.tblFrozen.duckSpeed *flDuckScale)
	self:SetUnDuckSpeed(self.tblFrozen.unDuckSpeed *flDuckScale)
	
	if self.tblFrozen.iPercent > 0 then return end
	hook.Remove("Think", "ThinkEntFrozen" .. self:EntIndex())
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("ENT_FreezeEffect_Render_End", rp)
		umsg.Entity(self)
	umsg.End()
	self:SetWalkSpeed(self.tblFrozen.speedWalk)
	self:SetRunSpeed(self.tblFrozen.speedRun)
	self:SetJumpPower(self.tblFrozen.jumpPower)
	self:SetDuckSpeed(self.tblFrozen.duckSpeed)
	self:SetUnDuckSpeed(self.tblFrozen.unDuckSpeed)
	self:SetPlaybackRate(1)
	self.bFrozen = false
	self.tblFrozen = nil
end

function meta:CustomHLRIsFrozen() -- overrided and broke the Prime SWEP addon and the gmod IsFrozen function and had to rename it!
	return self.bFrozen || IsFrozen(self)
end
meta = FindMetaTable("NPC")
/*
function meta:SetNoTarget(bNoTarget)
	if bNoTarget then
		if !table.HasValue(tblNoTargetNPCs, self) then
			tblNoTargetNPCs[self] = {}
			for k, ent in pairs(ents.GetNPCs()) do
				if !ent.bScripted && ent != self then
					tblNoTargetNPCs[self][ent] = ent:Disposition(self)
					AddEntityRelationship(ent, self, D_NU, 100)
				end
			end
		end
		return
	end
	if !tblNoTargetNPCs[self] then return end
	for ent, disp in pairs(tblNoTargetNPCs[self]) do
		if IsValid(ent) then
			AddEntityRelationship(ent, self, disp, 100)
		end
	end
	tblNoTargetNPCs[self] = nil
	for ent, rel in pairs(tblNoTargetNPCs) do
		if !IsValid(ent) then tblNoTargetNPCs[ent] = nil end
	end
end

*/
function meta:CanSee(ent, viewAng)
	local ang = self:CustomHLRenaissanceGetAngleToPos(ent:GetPos())
	local viewAng = self.fViewAngle || viewAng || 90
	if (ang.y <= viewAng || ang.y >= 360 -viewAng) && self:Visible(ent) then return true end
	return false
end

function meta:FrozenPercentage()
	return self.bFrozen && self.tblFrozen.iPercent || 0
end

function meta:SetPermanentlyFrozen(bPerm)
	if self:IsBoss() then return end
	if bPerm then
		self:SetFrozen(100)
		self.tblFrozen.permanent = true
		return
	end
	if !self.tblFrozen then return end
	self.tblFrozen.permanent = nil
end

function meta:SetFrozen(iPercent)
	if self.bScripted && !self.bFreezable then return end
	iPercent = iPercent || 100
	if iPercent > 0 && self:IsOnFire() then self:Extinguish() end
	local r,g,b,a = self:GetColor()
	if !self.tblFrozen then
		self.tblFrozen = {}
		self.tblFrozen.actMove = self:GetMovementActivity()
		self.tblFrozen.iPercent = 0
		self.tblFrozen.nextUnfreeze = CurTime() +3
		if self.bScripted then
			self.tblFrozen.iYawSpeed = self:GetMaxYawSpeed()
		end
		
		self.bFrozen = true
		
		local ang
		local entIndex = self:EntIndex()
		hook.Add("Think", "ThinkEntFrozen" .. entIndex, function()
			if !IsValid(self) then hook.Remove("Think", "ThinkEntFrozen" .. entIndex); return end
			if self:Health() <= 0 then
				self:UnFreeze()
				return
			end
			self:SetPlaybackRate((100 -self.tblFrozen.iPercent) /100)
			//self:SetLocalVelocity(Vector(0,0,0))
			if self.tblFrozen.iPercent >= 80 then if !ang then ang = self:GetAngles() end; self:SetAngles(ang) elseif ang then ang = nil end
			if !self.tblFrozen.permanent && CurTime() >= self.tblFrozen.nextUnfreeze then
				self.tblFrozen.nextUnfreeze = CurTime() +0.2
				self:UnFreeze(1)
			end
		end)
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		
		umsg.Start("ENT_FreezeEffect_Render", rp)
			umsg.Entity(self)
		umsg.End()
	elseif self.tblFrozen.iPercent >= 100 then self.tblFrozen.nextUnfreeze = CurTime() +3; return end
	if self.tblFrozen.iPercent +iPercent > 100 then iPercent = 100 -self.tblFrozen.iPercent end
	if self.tblFrozen.iPercent < 80 && self.tblFrozen.iPercent +iPercent >= 80 then self:SetMovementActivity(ACT_IDLE) end
	self.tblFrozen.iPercent = self.tblFrozen.iPercent +iPercent
	self:SetNetworkedFloat("FreezePercent", self.tblFrozen.iPercent)
	local iScale = 255 -((self.tblFrozen.iPercent /100) *155)
	if self.bScripted then
		local iMax = self.tblFrozen.iYawSpeed
		self:SetMaxYawSpeed((100 -(self.tblFrozen.iPercent /100)) *iMax)
	end
	self.tblFrozen.nextUnfreeze = CurTime() +3
end

function meta:UnFreeze(iPercent)
	iPercent = iPercent || 100
	if !self.bFrozen then return end
	if self.tblFrozen.iPercent -iPercent < 0 then iPercent = -self.tblFrozen.iPercent end
	self.tblFrozen.iPercent = self.tblFrozen.iPercent -iPercent
	self:SetNetworkedFloat("FreezePercent", self.tblFrozen.iPercent)
	local iScale = 255 -((self.tblFrozen.iPercent /100) *155)
	if self.bScripted then
		local iMax = self.tblFrozen.iYawSpeed
		self:SetMaxYawSpeed((100 -(self.tblFrozen.iPercent /100)) *iMax)
	end
	if self.tblFrozen.iPercent > 0 then return end
	hook.Remove("Think", "ThinkEntFrozen" .. self:EntIndex())
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("ENT_FreezeEffect_Render_End", rp)
		umsg.Entity(self)
	umsg.End()
	self:SetMovementActivity(self.tblFrozen.actMove)
	self:SetPlaybackRate(1)
	self.bFrozen = false
	self.tblFrozen = nil
end

function meta:CustomHLRIsFrozen()
	return self.bFrozen || IsFrozen(self)
end
meta = FindMetaTable("Entity")

local tblEntsIgnited = {}
/*
local Ignite = meta.Ignite
function meta:Ignite(...)
	local dur, radius = ...
	local bNPC = self:IsNPC()
	if bNPC || self:IsPlayer() then
		local iPercentFrozen = self:FrozenPercentage()
		if iPercentFrozen >= 20 then return end
		if bNPC && self.bScripted then
			if !self:Ignitable() then return end
			if tblEntsIgnited[self] then tblEntsIgnited[self].duration = CurTime() +dur; return end
                        local cspBurn = CreateSound(self, "General.BurningFlesh")
			cspBurn:Play()
			tblEntsIgnited[self] = {duration = CurTime() +dur, nextDmg = 0, cspBurn = cspBurn}
			self.tblFlameEffects = {}
			local i = 0
			local bonepos, boneang = self:GetBonePosition(i)
			while bonepos do
				local flDistMin = 999
				for k, v in pairs(self.tblFlameEffects) do
					if i != k then
						local flDist = bonepos:Distance(self:GetBonePosition(k))
						if flDist < flDistMin then flDistMin = flDist end
					end
				end
				if flDistMin > 12 then
					local ent = ents.Create("info_particle_system")
					ent:SetParent(self)
					ent:SetPos(bonepos)
					ent:SetKeyValue("effect_name", "burning_gib_01")
					ent:SetKeyValue("start_active", "1")
					ent:Spawn()
					ent:Activate()
					self.tblFlameEffects[i] = ent
				end
				i = i +1
				bonepos, boneang = self:GetBonePosition(i)
			end
			hook.Add("Think", "HLR_EntityIgniteThink", function()
				for ent, data in pairs(tblEntsIgnited) do
					if !IsValid(ent) || ent:Health() <= 0 || !ent.tblFlameEffects then
						data.cspBurn:Stop()
						tblEntsIgnited[ent] = nil
					elseif CurTime() >= data.duration || ent:WaterLevel() == 3 then
						ent:Extinguish()
					else
						for iBone, effect in pairs(ent.tblFlameEffects) do
							effect:SetPos(ent:GetBonePosition(iBone))
						end
						if CurTime() >= data.nextDmg then
							local attacker = IsValid(self) && self || ent
							data.nextDmg = CurTime() +0.4
							local dmg = DamageInfo()
							dmg:SetDamage(1)
							dmg:SetDamageType(DMG_DIRECT)
							dmg:SetAttacker(attacker)
							dmg:SetInflictor(attacker)
							ent:TakeDamageInfo(dmg)
							local r, g, b, a = ent:GetColor()
							r = math.Clamp(r -6, 45, 255)
							g = math.Clamp(g -6, 45, 255)
							b = math.Clamp(b -6, 45, 255)
							ent:SetColor(r,g,b,a)
						end
					end
				end
			end)
			self:CallOnRemove("IgniteStop", function()
				if !tblEntsIgnited[self] then return end
				tblEntsIgnited[self].cspBurn:Stop()
				tblEntsIgnited[self] = nil
			end)
		return end
	end
	Ignite(self, ...)
end

local Extinguish = meta.Extinguish
function meta:Extinguish()
	if !tblEntsIgnited[self] then Extinguish(self); return end
	tblEntsIgnited[self].cspBurn:Stop()
	if self.tblFlameEffects then
		for iBone, effect in pairs(self.tblFlameEffects) do
			effect:Remove()
		end
	end
	self.tblFlameEffects = nil
	tblEntsIgnited[self] = nil
end
*/
local IsOnFire = meta.IsOnFire
function meta:IsOnFire() -- overrides 
	return tblEntsIgnited[self] != nil || IsOnFire(self)
end

function meta:TurnDegree(iDeg, posAng, bPitch, iPitchMax)
	if posAng then
		local sType = type(posAng)
		local angTgt
		if sType == "Vector" then angTgt = (posAng -self:GetPos()):Angle()
		else angTgt = posAng end
		local ang = self:GetAngles()
		if !iDeg then ang.y = angTgt.y; if bPitch then ang.p = angTgt.p end
		else
			while angTgt.y < 0 do angTgt.y = angTgt.y +360 end
			while angTgt.y > 360 do angTgt.y = angTgt.y -360 end
			local _ang = ang -angTgt
			_ang.y = math.floor(_ang.y)
			while _ang.y < 0 do _ang.y = _ang.y +360 end
			while _ang.y > 360 do _ang.y = _ang.y -360 end
			local _iDeg = iDeg
			if _ang.y > 0 && _ang.y <= 180 then
				if _ang.y < _iDeg then _iDeg = _ang.y end
				ang.y = ang.y -_iDeg
			elseif _ang.y > 180 then
				if 360 -_ang.y < _iDeg then _iDeg = 360 -_ang.y end
				ang.y = ang.y +_iDeg
			end
			
			if bPitch then
				iPitchMax = iPitchMax || 360
				_ang.p = math.floor(_ang.p)
				while _ang.p < 0 do _ang.p = _ang.p +360 end
				while _ang.p > 360 do _ang.p = _ang.p -360 end
				if _ang.p > 0 then
					local _iDeg = iDeg
					if _ang.p < 180 then
						if ang.p > -iPitchMax then
							if _ang.p < _iDeg then _iDeg = _ang.p end
							ang.p = ang.p -_iDeg
						end
					else
						if ang.p < iPitchMax then
							if 360 -_ang.p < _iDeg then _iDeg = 360 -_ang.p end
							ang.p = ang.p +_iDeg
						end
					end
				end
			end
			self:SetAngles(ang)
		end
		return
	end
	local ang = self:GetAngles()
	ang.y = ang.y +iDeg
	self:SetAngles(ang)
end

function meta:DoExplode(dmg, radius, owner, bDontRemove)
	radius = radius || 260
	dmg = dmg || 85
	if !IsValid(owner) then owner = self end
	
	local pos = self:GetPos()
	local ang = Angle(0,0,0)
	local entParticle = ents.Create("info_particle_system")
	entParticle:SetKeyValue("start_active", "1")
	entParticle:SetKeyValue("effect_name", "svl_explosion")
	entParticle:SetPos(pos)
	entParticle:SetAngles(ang)
	entParticle:Spawn()
	entParticle:Activate()
	timer.Simple(1, function() if IsValid(entParticle) then entParticle:Remove() end end)

	WorldSound("weapons/explode" .. math.random(7,9) .. ".wav", pos, 110, 100)
	util.BlastDamage(self, owner, pos, radius, dmg)
	util.ScreenShake(pos, 5, dmg, math.Clamp(dmg /100, 0.1, 2), radius *2)

	for dir,ent in pairs(ents.FindInSphere(self:GetPos(),500)) do
		if ent:IsNPC() && ent:GetClass() == "monster_tentacle" then
			ent.posEnemyLastMem = self:GetPos()
			ent.forceFacePos = true
			ent.nextStrike = 0
		end
	end
	
	local iDistMin = 26
	local tr
	for i = 1, 6 do
		local posEnd = pos
		if i == 1 then posEnd = posEnd +Vector(0,0,25)
		elseif i == 2 then posEnd = posEnd -Vector(0,0,25)
		elseif i == 3 then posEnd = posEnd +Vector(0,25,0)
		elseif i == 4 then posEnd = posEnd -Vector(0,25,0)
		elseif i == 5 then posEnd = posEnd +Vector(25,0,0)
		elseif i == 6 then posEnd = posEnd -Vector(25,0,0) end
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = posEnd
		tracedata.filter = self
		local trace = util.TraceLine(tracedata)
		local iDist = pos:Distance(trace.HitPos)
		if trace.HitWorld && iDist < iDistMin then
			iDistMin = iDist
			tr = trace
		end
	end
	if tr then
		util.Decal("Scorch",tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)  
	end
	if !bDontRemove then self:Remove() end
end

meta = FindMetaTable("Player")
tblNoTargetPlayers = {}
local SetNoTarget = meta.SetNoTarget
function meta:SetNoTarget(...)
	local bNoTarget = ...
	if bNoTarget then
		if !table.HasValue(tblNoTargetPlayers, self) then
			table.insert(tblNoTargetPlayers, self)
		end
	else
		for k, pl in pairs(tblNoTargetPlayers) do
			if pl == self then table.remove(tblNoTargetPlayers, k); break end
		end
	end
	return SetNoTarget(self, ...)
end

function meta:GetNoTarget()
	return table.HasValue(tblNoTargetPlayers, self)
end

meta = FindMetaTable("PhysObj")
function meta:SetAngleVelocity(ang)
	self:AddAngleVelocity(self:GetAngleVelocity() *-1 +ang)
end