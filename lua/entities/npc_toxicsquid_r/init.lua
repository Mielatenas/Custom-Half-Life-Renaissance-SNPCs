AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Model = {"models/toxicsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 90
ENT.BloodColor = "Green" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.RangeAttackEntityToSpawn = "obj_bullsquid_spit_r" -- The entity that is spawned when range attacking
ENT.FlameParticle = "spore_trail"
ENT.FlameDamageType = DMG_ACID

ENT.MeleeAttackDistance = 74 -- How close does it have to be until it attacks?
--ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.RangeDistance = 1000 -- This is how far away it can shoot
ENT.LimitChaseDistance_Max = 490 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.LimitChaseDistance_Min = 65 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
//ENT.RangeAttackPos_Up = 180 -- Up/Down spawning position for range attack

--ENT.bFreezable = false
ENT.CustomBlood_Particle = {"spore_splash_02", "spore_splash_player"}
ENT.BloodPoolSize = "Small" 
ENT.CanUseFlame = true
ENT.FlameAttackDmg = 8
ENT.FlameDmgRadius = 450
ENT.FlameConeDmgDegree = 45
ENT.fRangeDistanceFlame = 300
ENT.FlameSd = "NPC/hlrr/fire1.wav"
ENT.MainSoundPitch = VJ.SET(75, 110) -- Can be a number or VJ.SET

ENT.FootStepTimeWalk = 1.25 -- Next foot step sound when it is walking
ENT.FootStepTimeRun = 0.45 -- Next foot step sound when it is running

---DO NOT CHANGE BELOW---
ENT.ToxicBull = true
ENT.NextMoveAfterFlinchTime = 1.2

function ENT:CustomOnThink()
	if self.bInSchedule and self.FlameOn then
	local effect = EffectData()
	effect:SetStart(self:GetAttachment(1).Pos)
	effect:SetNormal(self:GetForward())
	effect:SetEntity(self)
	effect:SetAttachment(1)
	util.Effect("effect_toxic_spray",effect)
    end
end

/*function ENT:EventHandle(sEvent)
	if string.find(sEvent,"mattack") then
		local fDist = self.fMeleeDistance
		local bWhip = tobool(string.find(sEvent,"whip"))
		local bBite = !bWhip
		if bWhip then
			local iDmg = GetConVarNumber("sk_toxicsquid_dmg_whip")
			local angViewPunch = Angle(-7,-36,4)
			self:DoMeleeDamage(fDist,iDmg,angViewPunch,nil,nil,true)
			return
		end
		local iDmg = GetConVarNumber("sk_toxicsquid_dmg_bite")
		local angViewPunch = Angle(-14,0,0)
		
		self:DoMeleeDamage(fDist,iDmg,angViewPunch,nil,function(ent)
			ent:SetVelocity((self:GetForward() *100) +Vector(0, 0, 300))
		end,nil,"")

		if !self.bPossessed && self.entEnemy:IsPlayer() then 
			self.entEnemy:FadeScreen(Color(0,130,0,255), math.random(8,14), math.random(1,3))
		return
		end
	end
	if string.find(sEvent,"rattack") then
		local fDist
		local bValid = ValidEntity(self.entEnemy)
		if bValid then fDist = self:OBBDistance(self.entEnemy) end
		if !self.bPossessed && (!bValid || fDist >= self.fRangeDistance || fDist <= self.fMeleeDistance || self.entEnemy:Health() <= 0 || self.bDead || self.entEnemy:GetPos().z -self:GetPos().z > 65) then
			self:PlayActivity(ACT_SPECIAL_ATTACK2, true)
			self.bInSchedule = false
			self:StopParticles()
			self.cspFlame:Stop()
		else
			self:PlayActivity(ACT_RANGE_ATTACK2, !self.bPossessed)
			if string.find(sEvent,"flamestart") then
				self.cspFlame:Play()
				dmgtoxic = GetConVarNumber("sk_toxicsquid_dmg_toxic")
							local dmg = DamageInfo()
							dmg:SetDamage(dmgtoxic)
							dmg:SetDamageType(DMG_ACID)
							dmg:SetAttacker(self)
						    dmg:SetInflictor(self)
							self.entEnemy:TakeDamageInfo(dmg)
							self.entEnemy:EmitSound("npc/bullsquid/acid1.wav", 75, 100)
							if self.entEnemy:IsPlayer() then
								self.entEnemy:FadeScreen(Color(0,130,0,math.random(100,250)), math.random(1,2), 0.5)
							end
			else
				local posSelf = self:GetPos()
				for k, v in pairs(ents.FindInSphere(self:GetAttachment(1).Pos,self.fRangeDistance)) do
					local bIsNPC = v:IsNPC()
					local bIsPlayer = v:IsPlayer()
					dmgtoxic = GetConVarNumber("sk_toxicsquid_dmg_toxic")
					if ValidEntity(v) && (bIsNPC || bIsPlayer) && v != self && (self:IsEnemy(v) || v:CustomHLRenaissanceIsPhysicsEntity()) && v:GetPos().z -self:GetPos().z <= 65 then
						local posEnemy = v:GetPos()
						local angToEnemy = self:GetAngles().y -(posEnemy -posSelf):Angle().y
						if angToEnemy < 0 then angToEnemy = angToEnemy +360 end
						if ((angToEnemy <= 70 && angToEnemy >= 0) || (angToEnemy <= 360 && angToEnemy >= 290)) then
						  local dmg = DamageInfo()
							dmg:SetDamage(dmgtoxic)
							dmg:SetDamageType(DMG_ACID)
							dmg:SetAttacker(self)
						        dmg:SetInflictor(self)
							v:TakeDamageInfo(dmg)
							v:EmitSound("npc/bullsquid/acid1.wav", 75, 100)
							if v:IsPlayer() then
								v:FadeScreen(Color(0,130,0,math.random(100,250)), math.random(1,2), 0.5)
							end
						end
					end
				end
			end
		end
	end
end */