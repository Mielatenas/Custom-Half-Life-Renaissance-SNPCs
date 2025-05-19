AddCSLuaFile( "shared.lua" )
include('shared.lua')

--ENT.bFreezable = false
ENT.Model = {"models/half-life/kingpin.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want

ENT.StartHealth = 700
ENT.HullType = HULL_MEDIUM_TALL //HULL_MEDIUM_TALL HULL_LARGE
ENT.SightDistance = 12000 -- How far it can see | Remember to call "self:SetSightDistance(dist)" if you want to set a new value after initialize!
ENT.SightAngle = 200 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians

ENT.ControllerParams = {
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "MDLDEC_Bone23",
	FirstP_Offset = Vector(15, 0, 2),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = true -- Does it have a blood pool?
ENT.Immune_Electricity = true -- Immune to electrical-type damages | Example: shock or laser
ENT.Immune_Dissolve = true -- Immune to dissolving | Example: Combine Ball
ENT.ForceDamageFromBosses = true -- Should it receive damage by bosses regardless of its immunities? | Bosses are attackers tagged with "VJ_ID_Boss"

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- "vjseq_attack1","vjseq_attack2"
ENT.MeleeAttackDistance = 100 -- How close does it have to be until it attacks?
ENT.NextMeleeAttackTime = 0.5

ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = 100 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
--ENT.MeleeAttackAnimationDecreaseLengthAmount = 0.5 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
//ENT.MeleeAttackDamageDistance = 200 -- How far does the damage go?
ENT.HasMeleeAttackKnockBack = false -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackDSP = 32 -- Should it apply a DSP effect to players? | false = Disable applying DSP effect | number = DSP effect ID
ENT.MeleeAttackDSPLimit = 5 -- Should it only apply if the damage surpasses the given number? | false = Always apply | number = Only apply when damage is greater than or equal to this number

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_kingpin_projectile_energy_r" -- The entity that is spawned when range attacking
--ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1 -- Range Attack Animations
ENT.NextAnyAttackTime_Range = false -- How much time until it can do any attack again? | false = Base auto calculates the duration | number = Specific time | VJ.SET = Randomized between the 2 numbers
--ENT.RangeUseAttachmentForPos = false -- Should the projectile spawn on a attachment?
--ENT.RangeAttackPos_Up = 65
--ENT.RangeAttackPos_Forward = 65
ENT.NextRangeAttackTime = 0.9 -- How much time until it can use a range attack?
//ENT.NextRangeAttackTime_DoRand = 6 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.CallForHelp = true -- Can it request allies for help while in combat?
ENT.CallForHelpDistance = 2000 -- Max distance its request for help travels
ENT.CallForHelpCooldown = 9 -- Time until it calls for help again
ENT.AnimTbl_CallForHelp = ACT_RANGE_ATTACK2
ENT.CallForHelpAnimFaceEnemy = false -- Should it face the enemy while playing the animation?
ENT.CallForHelpAnimCooldown = 30 -- How much time until it can play an animation again?

ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
--ENT.ConstantlyFaceEnemy_IfAttacking = true -- Should it face the enemy when attacking?
ENT.NoChaseAfterCertainRange = false -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.DeathDelayTime = 0.6 -- Time until it spawns the corpse, removes itself, etc.
ENT.AnimTbl_Death = {"vjseq_diesimple", "vjseq_diebackward"} -- Death Animations
ENT.DeathAnimationTime = 0.6 
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse

ENT.FlinchChance = 4 -- Chance of flinching from 1 to x | 1 = Always flinch
	-- To let the base automatically detect the animation duration, set this to false:
ENT.FlinchCooldown = 5
ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_SIGNAL_HALT 
	-- ====== Sound File Paths ====== --
ENT.HasExtraMeleeAttackSounds = true -- Can it play extra melee attack sound effects?
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"npc/kingpin/kingpin_breath01.mp3","npc/kingpin/kingpin_breath02.mp3"}
ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/npc/kingpin/kingpin_move.wav", "vj_hlr/gsrc/npc/kingpin/kingpin_moveslow.wav"}
ENT.SoundTbl_IdleDialogue = {"npc/kingpin/kingpin_mindlinkloop.ogg"}
ENT.SoundTbl_Alert = {"npc/kingpin/kingpin_alert.mp3"}
ENT.SoundTbl_OnReceiveOrder = {"npc/kingpin/kingpin_leechgrab.wav","npc/kingpin/kingpin_mindlinkbegin.mp3","npc/kingpin/kingpin_mindlinkinterruption.mp3"}
ENT.SoundTbl_MeleeAttack = {"npc/kingpin/kingpin_melee.wav","vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/gsrc/npc/zombie/claw_miss1.wav","vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"npc/kingpin/kingpin_injured02.mp3","npc/kingpin/kingpin_injured03.mp3"}
ENT.SoundTbl_Death = {"npc/kingpin/kingpin_death02.mp3"}

ENT.FootStepTimeRun = 2-- Next foot step sound when it is running
ENT.FootStepTimeWalk = 2 -- Next foot step sound when it is walking
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.NextSoundTime_Breath = VJ.SET(3, 5)
ENT.PainSoundChance = 2
ENT.IdleDialogueDistance = 900
ENT.IdleDialogueSoundLevel = 82

ENT.MainSoundPitch = VJ.SET(80, 110) -- Can be a number or VJ.SET
ENT.MeleeAttackSoundPitch = VJ.SET(75, 110)

---Custom.---
ENT.BeamloopAnims = {ACT_SIGNAL3, ACT_RANGE_ATTACK2}
ENT.PickBeamAnim = VJ.PICK(ENT.BeamloopAnims)
ENT.BeamLoopSnd = "npc/kingpin/kingpin_leechpullloop.wav"
ENT.BeamDmg = 4

-------DO NO CHANGE!------
ENT.CanDoSummon = false
ENT.KSCooldownDelay = 0
ENT.thelast = nil
ENT.TimeUntilRangeAttackProjectileRelease = false -- Breaks Kingpin if number as is intended to be range event-based
ENT.RangeAttackMinDistance = 20 -- Min range attack distance
ENT.RangeAttackMaxDistance = 10000 -- -- beam and energy orbs ignore this
ENT.RangeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of it | 180 = All around it
//ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee? // breaks the Rangeattackcode when number is reached !!!!!!!
--ENT.RangeToMeleeDistance = math.huge // breaks Rangeattackcode when number IS reached and melee code activates !!!!!!!

//ENT.DisableDefaultMeleeAttackCode = false -- When set to true, it will completely disable the melee attack code

function ENT:Init()
	//self:SetHullSizeNormal()
	self:SetCollisionBounds(Vector(22, 22, 95), Vector(-22, -22, 0))

	--self.nextPsychicAttack = 0
	--self.nextThrow = 0
	--self.throwDelay = 0
	--self.nextPlayerThrow = 0
	--self.nextPlayerHealthDrain = 0
	--self.entCurThrow = NULL
	--self.tblPhysEnts = {}
	self.KingPinCanDoNextAttack = true
	self.KingPinNextRangeAttackTime = 0
	self.energy = 80
	self.MeleeAttackDuration = 0.78
	self.LastAllyPosSlot = nil
	self.boneposfollow = self:GetPos()
	local hlrMultidmg = GetConVar("hlrcustom_multidmg"):GetFloat()
	self.MeleeKingpinDamage1 = 15*hlrMultidmg
	self.MeleeKingpinDamage2 = 25*hlrMultidmg
	local shield = ents.Create("prop_dynamic_override")
	shield:SetModel("models/half-life/kingpin_sphereshield.mdl")
	shield:SetPos(self:GetPos())
	shield:SetParent(self)
	shield:DrawShadow(false)
	shield:Spawn()
	--shield:Activate()
	self.bShieldActive = true
	self.entShield = shield
	--self:SetShieldPower(100)
	--self:ActivateShield()
	--self:SetSoundLevel(95)
	self.tblSummonedAllies = {}
	--local entBeam = util.ParticleEffectTracer("kingpin_beam_charge2", self:GetAttachment(self:LookupAttachment("clawright")).Pos, {{ent = self, att = "clawleft"}}, self:GetAngles(), self, "clawright", false)
	--timer.Simple(5, function() print("BEAM: ", entBeam) end)
	--self:DeleteOnDeath(entBeam)
	local ForKingpinbool = true
	for i = 1, 2 do
	-- follow ear bone entity
        local bonFollowEnt = ents.Create("obj_vj_pointed_tg_r") --VJ_CreateBoneFollower(self, self:GetModel()), can't use global cause it sets its position back to ent:GetPos() -- also obj_vj_bonefollower internal code damages kingpin
	    bonFollowEnt:SetNoDraw( true )
    	bonFollowEnt:SetAngles(self:GetAngles())
    	bonFollowEnt:SetParent(self) -- don't make it parented
    	bonFollowEnt:AddEffects(EF_FOLLOWBONE)
    	bonFollowEnt:Spawn()
    	bonFollowEnt:SetOwner(self)
    	self:DeleteOnRemove(bonFollowEnt)
    		if ForKingpinbool==nil then
    		self.REarBoneFollower = bonFollowEnt 
       	    else
       	    self.LEarBoneFollower = bonFollowEnt
    		end
    	ForKingpinbool=nil
    end 
end
/*
function ENT:ScaleDamage(dmginfo, hitgroup) --unused, check in vj base
	if hitgroup == HITBOX_HEAD then
		dmginfo:ScaleDamage(2)
	elseif hitgroup == HITBOX_GEAR then dmginfo:SetDamage(0)
	elseif hitgroup == HITBOX_LEFTARM || hitgroup == HITBOX_RIGHTARM || hitgroup == HITBOX_LEFTLEG || hitgroup == HITBOX_RIGHTLEG || hitgroup == HITBOX_ADDLIMB then
		dmginfo:ScaleDamage(0.25)
	end
	if !self:ShieldActive() then return end
	local inflictor = dmginfo:GetInflictor()
	if !IsValid(inflictor) then return end
	local scale = self.shieldPower /100
	local r = 225.6525 *scale
	local dist = self:OBBCenter():Distance(inflictor:GetPos() +inflictor:OBBCenter())
	if dist >= r then dmginfo:ScaleDamage(0.05) end
end
*/
function ENT:DisableShield()
	if IsValid(self.entShield) then self.entShield:SetNoDraw(true); self.bShieldActive = false end
end

function ENT:EnableShield()
	if IsValid(self.entShield) then self.entShield:SetNoDraw(false); self.bShieldActive = true end
end

function ENT:SetShieldPower(nPower)
	if !IsValid(self.entShield) then return end
	self.shieldPower = math.Clamp(nPower, 0, 100)
	if self.shieldPower == 0 then self.entShield:Remove(); self.entShield = nil; self.bShieldActive = false; return end
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("Kingpin_SetShieldScale", rp)
		umsg.Entity(self.entShield)
		umsg.Short(nPower)
	umsg.End()
end
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Init" then
	    dmg = dmginfo:GetDamage()
	    if dmg > 40 then
	        self.FlinchChance = 2
            self.FlinchCooldown = 0.5
        end
    end
end

function ENT:OnFlinch(dmginfo, hitgroup, status)
	--print("FLINCHHHH")
	if status == "Execute" then
		if hitgroup != 109 then
			if hitgroup != 101 then -- no other way to play diesimple, so I had to force it
	        self:PlayAnim(ACT_DIESIMPLE, true, 1, false,0,{AlwaysUseSequence=true,PlayBackRate=1.4,PlayBackRateCalculated=true})
            self.KingPinNextRangeAttackTime = CurTime() + 1
	        end
	    end
	    self:KingpinRenaissanceInterruptBeam(false)
	    self.FlinchChance = 4
        self.FlinchCooldown = 5
	--self:StopAttack()
	--self.nextPlayerThrow = CurTime() +math.Rand(8,12)
    end
end
/*
function ENT:StopAttack()
	if self.bThrowPlayer && IsValid(self.entEnemy) && self.entEnemy:IsPlayer() then
		self.entEnemy:SetGravity(1)
	end
	self.throwDelay = 0
	self.nextThrow = 0
	self:StopAttackEffects()
	self.bWaitForThrow = false
	self.entParticle = nil
	self.bInSchedule = false
	self:UpdatePhysicsEnts()
	for k, v in pairs(self.tblPhysEnts) do
		v:GetPhysicsObject():EnableGravity(true)
	end
	self.bThrowPlayer = false
end

function ENT:ActivateShield()
	//self:SetInvincible(true)
	ParticleEffectAttach("kingpin_psychic_shield_idle", PATTACH_ABSORIGIN_FOLLOW, self, 0 )
end

function ENT:DeactivateShield()
	//self:SetInvincible(false)
	self:StopParticles()
end
*/
/*
local velMax = {rpg_missile = 1500, obj_rpg = 1200, npc_grenade_frag = 1024, prop_combine_ball = 1000}
function ENT:CustomOnThink_AIEnabled()
	if true then return end
	if !self.bInSchedule && IsValid(self.entCurThrow) && !IsValid(self.entEnemy) then
		self.entCurThrow:GetPhysicsObject():EnableGravity(true)
		self.entCurThrow = NULL
	end
	print("Main Think")
	if self.bDead then return end
	self:UpdateLastEnemyPositions()
	for _, ent in pairs(ents.GetAll()) do
		local class = ent:GetClass()
		if velMax[class] && self:CustomHLRenaissanceOBBDistance(ent) <= 800 then
			local velMax = velMax[class]
			local pos = ent:GetPos()
			local vel = ent:GetVelocity()
			local normal = vel:GetNormal()
			local normalDest = (pos -self:GetPos()):GetNormal()
			normal = Vector(math.Approach(normal.x, normalDest.x, 0.1), math.Approach(normal.y, normalDest.y, 0.1), math.Approach(normal.z, normalDest.z, 0.1))
			vel = normal *math.min(vel:Length() *1.5, velMax)
			if class == "rpg_missile" then ent:SetLocalVelocity(vel)
			else
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then phys:SetVelocity(vel) end
			end
		end
	end
	self:NextThink(CurTime())
	if !self.bInSchedule then return true end
	if self.bThrowPlayer then
		if !IsValid(self.entEnemy) || self.entEnemy:Health() <= 0 || self.entEnemy:CustomHLRenaissanceDistance(self) > self.RangeDistance || !self:Visible(self.entEnemy) then
			self:StopAttack()
			self:SLVPlayActivity(ACT_SIGNAL_HALT, true)
			return true
		end
		local vel = self.entEnemy:GetVelocity()
		vel.x = vel.x *0.8
		vel.y = vel.y *0.8
		vel.z = 100 -(self.entEnemy:GetPos().z -self:GetPos().z)
		if self.entEnemy:OnGround() then
			vel.z = vel.z +200
		end

		local fDist = self:OBBCenter():Distance(self.entEnemy:GetPos())
			
		vel = vel +((self:GetPos() +self:OBBMaxs()) -self.entEnemy:GetPos()):GetNormal() *math.Clamp(fDist -100, 0, 20)
		// +SIN/COS
		self.entEnemy:SetLocalVelocity(vel)
		self.entEnemy:SetGravity(0.000001)
		// ONLY GET PLAYER IF SELF HEALTH IS SMALLER THAN 3/4 OF MAX HEALTH
		if fDist <= 200 && CurTime() >= self.nextPlayerHealthDrain then
			self.nextPlayerHealthDrain = CurTime() +0.5
			self.entEnemy:TakeDamage(1, self, self)
			local iHealth = self:Health()
			local iHealthMax = self:GetMaxHealth()
			// DONT LET PLAYER MOVE AWAY FROM FORCE!!!
			// BIGGER SPHERE FOR PLAYER!!
			/*if iHealth >= iHealthMax then
				self:StopAttack()
				self:SLVPlayActivity(ACT_RANGE_ATTACK2_LOW, true)
				//THROW PLAYER
				return
			else*/
/*		        self:slvSetHealth(iHealth +1)
			//end
			//IF DAMAGED THEN THROW PLAYER
		end
		if CurTime() >= self.nextThrow then
			self:StopAttackEffects()
			self.nextThrow = 0
			self.nextPlayerThrow = CurTime() +math.Rand(8,12)
			self.bThrowPlayer = false
			self:SLVPlayActivity(ACT_RANGE_ATTACK2_LOW, true)
			self.entEnemy:SetGravity(1)
			self.entEnemy:SetLocalVelocity((self.entEnemy:OBBCenter() -self:OBBCenter()):GetNormal() *2000)
			self.entEnemy:TakeDamage(GetConVarNumber("sk_kingpin_dmg_psychic"), self, self)
			self:DeactivateShield()
		end
		return true
	end
	self:UpdatePhysicsEnts()
	if #self.tblPhysEnts == 0 || !IsValid(self.entEnemy) || self.entEnemy:Health() <= 0 || self.entEnemy:CustomHLRenaissanceDistance(self) > self.RangeDistance || !self:Visible(self.entEnemy) then
		self:StopAttack()
		self:SLVPlayActivity(ACT_SIGNAL_HALT, true)
		return true
	end
	for k, v in pairs(self.tblPhysEnts) do
		if self.entCurThrow != v || self.bWaitForThrow then
			local phys = v:GetPhysicsObject()
			if IsValid(phys) then
				local vel = phys:GetVelocity()
				vel.x = vel.x *0.8
				vel.y = vel.y *0.8
				vel.z = 600 -(v:GetPos().z -self:GetPos().z)
				phys:SetVelocity(vel)
				phys:AddAngleVelocity(phys:GetAngleVelocity() *-0.2)
			end
		end
	end

	if self.bWaitForThrow then
		if !IsValid(self.entCurThrow) then
			self:StopAttack()
			self:PlayAnim(ACT_SIGNAL_HALT, true)
			return true
		end
		if CurTime() >= self.throwDelay then
			local yaw = self:CustomHLRenaissanceGetAngleToPos(self.entCurThrow:GetPos()).y
			if (yaw <= 180 && yaw > 75) || (yaw > 180 && yaw < 285) then
				self.throwDelay = CurTime() +1
				return true
			end
			self:SLVPlayActivity(ACT_RANGE_ATTACK2_LOW, true)
			self.throwDelay = 0
			self.bWaitForThrow = false
			self.nextThrow = CurTime() +math.Rand(1,2)
			self:StopAttackEffects()
			self.entParticle = nil
			self.entCurThrow:EmitSound(self.sSoundDir .. "kingpin_teletoss0" .. math.random(1,2) .. ".mp3", 80, 100)
			local phys = self.entCurThrow:GetPhysicsObject()
			phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
			phys:SetVelocity((self.entEnemy:CustomHLRenaissanceGetHeadPos() -self.entCurThrow:GetPos()):GetNormal() *1800)
			self:UpdatePhysicsEnts()
			for k, v in pairs(self.tblPhysEnts) do
				if v != self.entCurThrow then
					v:GetPhysicsObject():EnableGravity(true)
				end
			end
			self.bInSchedule = false
			self:DeactivateShield()
		else
			local fDist = self:OBBCenter()():Distance(self.entCurThrow:GetPos()) -100
			local vel = math.Clamp(fDist, 0, 450)
			
			local pos = ((self:GetPos() +(self:OBBMaxs() *1.3)) -self.entCurThrow:GetPos()):GetNormal() *vel
			pos.z = 100 -(self.entCurThrow:GetPos().z -self:GetPos().z)
			local yaw = self:CustomHLRenaissanceGetAngleToPos(self.entCurThrow:GetPos()).y
			local mSin = math.sin(CurTime() +1) *100
			local mCos = math.cos(CurTime() +1) *100
			if yaw <= 180 && yaw > 60 then
				pos.x = pos.x +mCos
				pos.y = pos.y +mSin
			elseif yaw > 180 && yaw < 300 then
				pos.x = pos.x +mSin
				pos.y = pos.y +mCos
			end
			
			local phys = self.entCurThrow:GetPhysicsObject()
			phys:SetVelocity(pos)
		end
	elseif CurTime() >= self.nextThrow then
		self.throwDelay = CurTime() +2
		self.bWaitForThrow = true
		local mass = 0
		for _, ent in pairs(self.tblPhysEnts) do
			local phys = ent:GetPhysicsObject()
			local _mass = phys:GetMass()
			if IsValid(phys) && _mass > mass then
				mass = _mass
				self.entCurThrow = ent
			end
		end
		self.entCurThrow:EmitSound(self.sSoundDir .. "kingpin_telepickup0" .. math.random(1,2) .. ".mp3", 80, 100)
		ParticleEffectAttach("kingpin_object_charge", PATTACH_ABSORIGIN_FOLLOW, self.entCurThrow, 0)
		
		local _sName = self.entCurThrow:GetName()
		local sName = _sName
		if string.len(sName) == 0 then
			sName = "KingPin" .. self:EntIndex() .. "_entThrow"
			self.entCurThrow:SetName(sName)
		end
		local entParticle = ents.Create("info_particle_system")
		entParticle:SetPos(self:OBBCenter())
		entParticle:SetParent(self)
		entParticle:SetKeyValue("effect_name", "kingpin_psychic_beam")
		entParticle:SetKeyValue("start_active", "1")
		entParticle:SetKeyValue("cpoint1", sName)
		entParticle:Spawn()
		entParticle:Activate()
		self.entCurThrow:SetName(_sName)
		
		self.entParticle = entParticle
	end
end
*/
function ENT:OnThink()
	--print(self.energy)
	if self.Dead then return end
	local GetaTarget = self.entEnemy -- vj base internal enemy ent
	local curTime = CurTime()
	--print(self.HasRangeAttack)
	if !IsValid(GetaTarget) then
		GetaTarget = self:GetEnemy()-- is a quicker way to update enemy but gives nil sometimes
	end
	if GetaTarget then distToEne = VJ.GetNearestDistance(self, GetaTarget) end
	    if distToEne and IsValid(self.entEnemy) then 
	        --print(self.nextThrow)
	        self.energy = self.energy -1
	        if distToEne >= self.MeleeAttackDistance then 
	        --self.HasMeleeAttack = false
	       -- self.HasRangeAttack = true
            self.HasRangeAttackSound = false
            end
            if distToEne <= self.MeleeAttackDistance and !self.bInSchedule then
            //self.DisableDefaultMeleeAttackCode = false
            --self.HasRangeAttack = false
            --self.HasMeleeAttack = true
            //self.HasRangeAttack = false
            //print(self.HasRangeAttack)
                --if curTime > self.nextThrow and self.KingPinCanDoNextAttack==true then
                --self:ExecuteMeleeAttack()
                --end
            end
            if distToEne > self.RangeAttackMaxDistance then
             //print("self.HasSoundAttack")
    	    self.HasRangeAttackSound = true
            end
        end
        /*if !self.entEnemy and !self.bInSchedule then
        	--print(self.HasMeleeAttack)
            --self.HasMeleeAttack = false
        end*/
	if self.bInSchedule && self.tblBeams then -- Have to fix why tracelines cut the beam direction and speed on high height cliffs 
		if IsValid(self.entEnemy) then
			GetaTarget = self.entEnemy
			local posSelf = self:GetPos() -- not used on Beam
		//print("posSelf: ", posSelf)		
		--local Newenemypos = enemypos:Add(Vector(10000,0,0)) --enemypos+enemypos.y*1000
			local normal = (self.posEnemyLast || self.entEnemy:WorldSpaceCenter() -self.posBeam):GetNormalized()
			local dist = self.entEnemy:NearestPoint(self.posBeam):Distance(self.posBeam)
						--print("dist: ", dist)		
			local speed = math.Clamp((dist /20) *20, 20, 350)
				//print("speed: ", speed)		
			local posTgt = self.posBeam +normal *speed
						//print("posTgt: ", posTgt)		
			local attA = self:GetAttachment(self:LookupAttachment("clawleft"))
			local attB = self:GetAttachment(self:LookupAttachment("clawright")) -- Ang, Bone and Pos table
			self.attA = attA 
			self.attB = attB 
				--PrintTable(self.attA)
			self.attAPos = attA.Pos
		--print(self.attAPos)
			self.attBPos = attB.Pos
			local pos = (self.attAPos +self.attBPos) *0.5
			//print("pos: ", pos)		
			local tr = util.TraceLine({start = pos, endpos = posTgt, filter = self})
	    	local newposTgt = tr.Normal *speed
	    	tr = util.TraceLine({start = pos, endpos = posTgt+newposTgt, filter = self})
			--self:DrawTraceLine(tr)	
				--PrintTable(tr)	

			if dist > 5 then
				if !tr.Hit then
				--print("NO HIT")
				tr = util.TraceLine({start = tr.HitPos +Vector(0,0,0), endpos = tr.HitPos -Vector(0,0,0), mask = MASK_NPCWORLDSTATIC})
				else -- traceline hit pos
				--tr.HitPos = tr.HitPos +Vector(0,0,1) *speed 
				--print("HIT")
            	end
			end
			local tblEnts = util.CustomHlrBlastDmg(self, self, tr.HitPos, 25, self.BeamDmg,
			function(GetaTarget) -- have to test if works for nextbot
				return (!GetaTarget:IsNPC() || self:Disposition(GetaTarget) <= 2) && (!GetaTarget:IsPlayer() || !tobool(GetConVarNumber("ai_ignoreplayers")))
			end, DMG_DISSOLVE, false)
			if istable(tblEnts) and table.Count(tblEnts) > 0 then
				if !self.bHit then
					self.cspBeamHit:Play()
					self.bHit = true
				end
			elseif self.bHit then
				self.cspBeamHit:Stop()
				self.bHit = false
			end
	    	//print("self.posBeam, tr.HitPos: ", self.posBeam, tr.HitPos)
			self.posBeam = tr.HitPos
			self.entTarget:SetPos(self.posBeam)
			--self.entBeam:SetPos(self.posBeam) -- allows Draw function to run on client since it spawns inside world, This wasn't here, draws blue beam to obj_target but is not the right way, it mess one of the attachments pos
			--self.entBeam:SetStart(self.attAPos) -- the right position but server updates too slow, have to convert it on client
        end  
	    if (!IsValid(self.entEnemy) or !self.eneVisible) then -- interrupt beam if no enemy or no visible, to change if will update the beam traceline 
	        timer.Simple(2, function()
		    if IsValid(self) then
		    self:KingpinRenaissanceInterruptBeam(false) 
            end end)
	    end
	end
	if self:LookupBone("MDLDEC_Bone28") then -- move to client
		LeftBpos = self:GetBonePosition(self:LookupBone("MDLDEC_Bone28"))+self.LEarBoneFollower:GetRight()*-10-- this gets the proper position, can't be used to attach a particle effect 
		--print("LeftBpos: ", LeftBpos)
		self.LeftBpos = LeftBpos
		self.LEarBoneFollower:SetPos(LeftBpos)
			/*self:UpdateBoneFollowers()
	    if IsValid(phys_bone_follower) then -- wasn't able to read the bone follower entity 
	    self.boneposFollower = phys_bone_follower:GetPos()
        end */
    end
    	if self:LookupBone("MDLDEC_Bone26") then -- move to client
    		RightBpos = self:GetBonePosition(self:LookupBone("MDLDEC_Bone26"))+self.REarBoneFollower:GetRight()*10-- this gets the proper position, can't be used to attach a particle effect 
		    --print("RightBpos: ", RightBpos)
		    self.RightBpos = RightBpos
		    self.REarBoneFollower:SetPos(RightBpos)
    	end 
	self:NextThink(curTime +0.02)
	self:SelectScheduleHandle(distToEne)
	return true
end

function ENT:StopAttackEffects()
	if IsValid(self.entParticle) then
		self.entParticle:Fire("Stop", "", 0)
		self.entParticle:Remove()
	end
	if self.bThrowPlayer && IsValid(self.entEnemy) && self.entEnemy:IsPlayer() then
		self.entEnemy:StopParticles()
	end
	--if IsValid(self.entCurThrow) then self.entCurThrow:StopParticles() end
end

function ENT:CustomOnRemove()
	self:KingpinRenaissanceInterruptBeam(true)
	--self:UpdatePhysicsEnts()
	/*
	for k, v in pairs(self.tblPhysEnts) do
		local phys = v:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableGravity(true)
		end
	end
	if self.bThrowPlayer && IsValid(self.entEnemy) && self.entEnemy:IsPlayer() then
		self.entEnemy:SetGravity(1)
	end*/
	self:StopAttackEffects()
end
	/*
function ENT:UpdatePhysicsEnts()
	for k, v in pairs(self.tblPhysEnts) do
		if !IsValid(v) then self.tblPhysEnts[k] = nil; if v == self.entCurThrow then self:StopAttackEffects() end
		elseif IsValid(v) and v:GetPos():Distance(self:GetPos()) > self.RangeDistance then
			--print(v)
			v:GetPhysicsObject():EnableGravity(true)
			self.tblPhysEnts[k] = nil
			if v == self.entCurThrow then self:StopAttackEffects() end
		end
	end
	table.refresh(self.tblPhysEnts)
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(), self.RangeDistance)) do
		if v:CustomHLRenaissanceIsPhysicsEntity() && !table.HasValue(self.tblPhysEnts,v) then
			local phys = v:GetPhysicsObject()
			local mass = phys:GetMass()
			if mass <= 10000 && mass >= 25 then
				phys:EnableGravity(false)
				table.insert(self.tblPhysEnts,v)
			end
		end
	end
end
*/
function ENT:OnInput(key, activator, caller, data)
	--print(key)
	    if key == "event_mattack left" or key == "event_mattack right" then
        self.KingPinNextRangeAttackTime = CurTime() + 1
		self.MeleeAttackDamage = self.MeleeKingpinDamage1
        --self:ExecuteMeleeAttack()
	    elseif key == "event_mattack strike" then
        self.KingPinNextRangeAttackTime = CurTime() + 1
		self.MeleeAttackDamage = self.MeleeKingpinDamage2
		--self:ExecuteMeleeAttack()
	    elseif key == "rattack distance" or key == "event_rattack distance" then
		--self:ExecuteRangeAttack()
	    end
	if key == "event_rattack beamstart" or key == "event_rattack beamloop" then -- loop

	end
	if key == "event_rattack beamanim" then
	   	self.AnimTbl_RangeAttack = self.PickBeamAnim -- ACT_RANGE_ATTACK2 --ACT_SIGNAL3, ACT_SIGNAL2 , vjseq_attack_beam_loop, vjseq_attack_beam_start2
    end
	if key == "event_rattack psychic_loop" then
    	-- TURNON MIND LINK 
    	self.MindLinkLoopAnim = true
    else
    	-- TURNOFF MIND LINK
    	self.MindLinkLoopAnim = false
    end
end
function ENT:OnMeleeAttack(status, enemy)
	--print(status)
	/*
	if math.random(1, 2) == 1 then 
		else self.TimeUntilMeleeAttackDamage = 1.0 end
		self:VJ_ACT_PLAYACTIVITY("vjges_attack1", true, self.MeleeAttackDuration, true, 0,{SequenceDuration=1.5, SequenceInterruptible=false,PlayBackRate=1,PlayBackRateCalculated=true})
		// case1
	else
		self.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
		self:VJ_ACT_PLAYACTIVITY("vjges_attack2", true, self.MeleeAttackDuration, true, 0,{SequenceDuration=1.5, SequenceInterruptible=false})
		// case2
    end*/
    --self.nextThrow = CurTime()+self.MeleeAttackDuration
end
function ENT:OnMeleeAttackExecute(status, ent, isProp)
	--print(status)
end

function ENT:CustomAttack(ene, eneVisible) 
    self.entEnemy = ene
    self.eneVisible = eneVisible
end

function ENT:OnIdleDialogue(ent, status, statusData)
--print("DIALOGUE") 
	self:PlayAnim("vjseq_psychic_start", true, 0.8, false, false)
	timer.Simple(0.55, function()
		if IsValid(self) then
		self:PlayAnim(ACT_RANGE_ATTACK2, true, 4.8, false, false,{OnFinish=function(interrupted, anim)
			self.energy = 150
			if self.bShieldActive==true then
			    self:DisableShield()
			else
                self:EnableShield()
			end end, SequenceDuration=4.8,PlayBackRateCalculated=true})
    --self.AnimTbl_IdleStand = {ACT_RANGE_ATTACK2}
        end
    end)
end
function ENT:ResetSummonTraceBools()
    self.Tr1Hit=false
    self.Tr2Hit=false 
    self.Tr3Hit=false
end

function ENT:TranslateActivity(act)
    if act == ACT_IDLE then --if self.MovementType==VJ_MOVETYPE_STATIONARY then 
        --act = ACT_SIGNAL1
        if self.bInSchedule==true && self.tblBeams then -- make beamloop animation
            act = self.PickBeamAnim
        end
        return act
    end
    return baseclass.Get("npc_vj_creature_base").TranslateActivity(self, act)
end

function ENT:OnRangeAttack(status, enemy) --function ENT:MultipleRangeAttacks()	// CustomAttack
	--print("OnRangeAttack")
--if self.HasMeleeAttack == true then return end -- safa check to not let melee break AI!
if self.energy <= -100 then
    self.SpwPartEfc = "tor_shockwave_blue"
else
    self.SpwPartEfc = "tor_shockwave"
end
    if self.energy > 0 then
    	// multiple energy orbs validation
    	self.DoMultipleEnergyOrbs = true
    else
        self.DoMultipleEnergyOrbs = false end
    if (IsValid(self.entEnemy) && CurTime() >= self.KingPinNextRangeAttackTime && self.KingPinCanDoNextAttack == true) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_ATTACK)) then /*!self:IsBusy()*/
    	self.KingPinCanDoNextAttack = false
    	--print(VJ.IsCurrentAnim(self, ACT_SIGNAL_FORWARD))
    	if self.CanDoSummon == true and self.DoMultipleEnergyOrbs == false and self.Flinching == false then
    		local hlrFloatHealth = GetConVar("hlrcustom_multihealth"):GetFloat()
    		--print("Custom_01")
    		self.AnimTbl_RangeAttack = ACT_SIGNAL_FORWARD
    		--self:PlayAnim("vjseq_attack_summon", true, 1, false, false)
	        self.KingPinNextRangeAttackTime = CurTime() + 0.8
           -- --ParticleEffectA( "tor_projectile", self.LeftBpos,Angle(0,0,0), self) -- won't follow the bone
           	if !self.BoneFollowerOn then
          	    ParticleEffectAttach("tor_projectile_d", PATTACH_ABSORIGIN_FOLLOW, self.LEarBoneFollower, 0)
                ParticleEffectAttach("tor_projectile_d", PATTACH_ABSORIGIN_FOLLOW, self.REarBoneFollower, 0)
                --ParticleEffectAttach("tor_projectile_b", PATTACH_POINT_FOLLOW, self, 1)
           	    self.BoneFollowerOn = true
           	/*else
           		if table.Count(self.tblSummonedAllies) > 1 then
			    ParticleEffectAttach("tor_projectile_b", PATTACH_POINT_FOLLOW, self, 2)
			    end*/
           	end
           	----ParticleEffectAttach("kingpin_psychic_shield_idle", PATTACH_ABSORIGIN_FOLLOW, self, 1)
	        timer.Simple(0.75, function()
		    if IsValid(self) then
	
            local lottery = math.random(1,18)
		    local positions = math.random(1,3)
		    pos1 = self:LocalToWorld(Vector(30,55,10))
		    pos2 = self:LocalToWorld(Vector(40,-55,10))
            pos3 = self:LocalToWorld(Vector(130,0,10))
            local vecStartpos1 = Vector(0,0,0)
            local vecEndPos1 = Vector(0,0,40)
            local vecStartpos2 = Vector(0,35,0)
            local vecEndPos2 = Vector(0,-35,0)
            local vecStartpos3 = Vector(35,0,0)
            local vecEndPos3 = Vector(-35,0,0) 
            local vecStartpos4 = Vector(25,25,0)
            local vecEndPos4 = Vector(-25,-25,20)
		    tr1 = util.TraceLine({start = pos1 +vecStartpos1, endpos = pos1 +vecEndPos1, mask = MASK_NPCSOLID})
			--self:DrawTraceLine(tr1)
			--PrintTable(tr1)		
			if tr1.Hit or tr1.StartSolid then
				self.Tr1Hit=true
				--print("tr1.HitTexture: ", tr1.HitTexture,"tr1.Contents: ", tr1.Contents, "tr1.HitWorld: ", tr1.HitWorld, "tr1.StartSolid:", tr1.StartSolid)
			else
				tr1 = util.TraceLine({start = pos1 +vecStartpos2, endpos = pos1 +vecEndPos2, mask = MASK_NPCSOLID})
				--self:DrawTraceLine(tr1)	
			    if (tr1.Hit or tr1.StartSolid) and tr1.Entity!=self then
				    self.Tr1Hit=true
				else
				     tr1 = util.TraceLine({start = pos1 +vecStartpos3, endpos = pos1 +vecEndPos3, mask = MASK_NPCSOLID})
					--self:DrawTraceLine(tr1)
			    	if (tr1.Hit or tr1.StartSolid) and tr1.Entity!=self then
						self.Tr1Hit=true
				    else
				    	tr1 = util.TraceLine({start = pos1 +vecStartpos4, endpos = pos1 +vecEndPos4, mask = MASK_NPCSOLID})
					    --self:DrawTraceLine(tr1)
			    	    if (tr1.Hit or tr1.StartSolid) and tr1.Entity!=self then
						self.Tr1Hit=true
                        else
                            tr1 = util.TraceLine({start = pos1 +(vecStartpos2+vecEndPos3), endpos = pos1 +(vecEndPos2+vecStartpos3), mask = MASK_NPCSOLID})
					        --self:DrawTraceLine(tr1)
			    	    if (tr1.Hit or tr1.StartSolid) and tr1.Entity!=self then
						    self.Tr1Hit=true
                            else
                        	self.Tr1Hit=false
                            end
					    end
			        end
			    end
			end
			if !self.Tr1Hit then
				pos = pos1
				--print("!Tr1Hit", "tr1.StartSolid:", tr1.StartSolid)
            else
            	-- create a loop for
            	for i = 1, 5 do
			    tr2 = util.TraceLine({start = pos2 +vecStartpos1, endpos = pos2 +vecEndPos1, mask = MASK_NPCSOLID})
			    	--self:DrawTraceLine(tr2)
			    	if (tr2.Hit or tr2.StartSolid) and tr2.Entity!=self then -- make kingpin an exception bc we spawn allies too close
			    		--print("tr2.HitTexture: ", tr2.HitTexture,"tr2.Contents: ", tr2.Contents, "tr2.HitWorld: ", tr2.HitWorld, "tr2.StartSolid: ", tr2.StartSolid)
					    self.Tr2Hit=true
					    break -- deactivate this if debugging
					end	
						if vecStartpos1==vecStartpos3 then -- 3th roll
                     	   -- print("third roll on loop2")
	                        vecStartpos1=vecStartpos4
	                        vecEndPos1=vecEndPos4
						continue end
						if vecStartpos1==vecStartpos4 then -- 4th roll
                     	    --print("fourth roll on loop2")
	                        vecStartpos1=vecStartpos2+vecEndPos3 -- =(35,-35,0)
	                        vecEndPos1=vecEndPos2+vecStartpos3 -- =(-35,35,0)
						continue end
					if vecStartpos1!=vecStartpos2 then -- 1st roll, 5th roll falls here, if wanna add a 6th then compare 5th and add/subtract them together vecStartpos1.z > 25 ...
						--print("first roll on loop2")
					    vecStartpos1=vecStartpos2
					    vecEndPos1=vecEndPos2 -- set added vector for the second roll of loop, resets on next think
				    else -- 2nd roll
				        if vecStartpos1!=vecStartpos3 then
				       -- print("second roll on loop2")
				        vecStartpos1=vecStartpos3
					    vecEndPos1=vecEndPos3
					    end
				    end
                end
                if !self.Tr2Hit then
				pos = pos2
				--print("!Tr2Hit", "tr2.StartSolid:", tr2.StartSolid)
			    else
			    	for i = 1, 5 do
			        tr3 = util.TraceLine({start = pos3 +vecStartpos1, endpos = pos3 +vecEndPos1, mask = MASK_NPCSOLID})
			    			--self:DrawTraceLine(tr3)
			    	    if (tr3.Hit or tr3.StartSolid) and tr3.Entity!=self then
			    			--print("tr3.HitTexture: ", tr3.HitTexture,"tr3.Contents: ", tr3.Contents, "tr3.HitWorld: ", tr3.HitWorld, "tr3.StartSolid: ", tr3.StartSolid)
					        self.Tr3Hit=true
					        break
					    end	
							if vecStartpos1==vecStartpos3 then
	                        	vecStartpos1=vecStartpos4
	                        	vecEndPos1=vecEndPos4
					        continue end
							if vecStartpos1==vecStartpos4 then
	                        	vecStartpos1=vecStartpos2+vecEndPos3
	                        	vecEndPos1=vecEndPos2+vecStartpos3
							continue end
						if vecStartpos1!=vecStartpos2 then
					    	vecStartpos1=vecStartpos2
					    	vecEndPos1=vecEndPos2
				   		else
				        	if vecStartpos1!=vecStartpos3 then
				        	vecStartpos1=vecStartpos3
					    	vecEndPos1=vecEndPos3
					    	end
				    	end
                    end
                    if !self.Tr3Hit then
				    pos = pos3	
				    --print("!Tr3Hit", "tr3.HitTexture: ", tr3.HitTexture,"tr3.Contents: ", tr3.Contents, "tr3.HitWorld: ", tr3.HitWorld, "tr3.StartSolid: ", tr3.StartSolid)

				    else 
				    	self.KSCooldownDelay = CurTime() +1
                        self.CanDoSummon = false
                        self:StopParticles()
                        self:ResetSummonTraceBools() -- reset bools for next think
                        --print("return no space")
				        return -- no space available so cancel and delay summon
				    end
			    end
			end
			self:ResetSummonTraceBools() -- reset bools outside the return for next think, both cases

			--if tr
		       /* if positions==1 and self.LastAllyPosSlot !=1 then -- spawn on 1 out of 3 spots and block it for next summon
		        self.LastAllyPosSlot = 1
			    pos = self:LocalToWorld(Vector(30,45,10))
		        elseif positions==2 and self.LastAllyPosSlot !=2 then
		        self.LastAllyPosSlot = 2
			    pos = self:LocalToWorld(Vector(40,-45,10))
			    else
			    self.LastAllyPosSlot = 3
			    pos = self:LocalToWorld(Vector(130,0,10))
		        end	*/
                if lottery == 1 || lottery == 7 || lottery == 11 || lottery == 15 then
                    --ParticleEffectAttach("tor_projectile", PATTACH_POINT_FOLLOW, self, 1)
                    local bullchicken = ents.Create("npc_bullsquid_base_r")
					bullchicken:SetPos(pos)
					bullchicken:SetAngles(self:GetAngles())
					bullchicken:Spawn()
					bullchicken:Activate()
					bullchicken.entEnemy = self.entEnemy
					table.insert(self.tblSummonedAllies, bullchicken)
					
					bullchicken:EmitSound("vj_hlr/gsrc/fx/beamstart" .. math.random(1,2) .. ".wav",85,100)
					
					ParticleEffect(self.SpwPartEfc, pos +Vector(0,0,40), Angle(0,0,0), ally)
					ParticleEffect("tor_projectile_vanish", pos +Vector(0,0,40), Angle(0,0,0), ally)
					self:StopParticles()
			        self.thelast = 1
			    end

                    if lottery == 3 then
                        if self.thelast != 3 then
                        --ParticleEffectAttach("tor_projectile", PATTACH_POINT_FOLLOW, self, 1)
                        local frostsquid = ents.Create("npc_frostsquid_r")
			frostsquid:SetPos(pos)
			frostsquid:SetAngles(self:GetAngles())
			frostsquid:Spawn()
			frostsquid:Activate()
			frostsquid.entEnemy = self.entEnemy
			table.insert(self.tblSummonedAllies, frostsquid)
			
			frostsquid:EmitSound("vj_hlr/gsrc/fx/beamstart" .. math.random(1,2) .. ".wav",85,100)
			
			ParticleEffect(self.SpwPartEfc, pos +Vector(0,0,40), Angle(0,0,0), ally)
			ParticleEffect("tor_projectile_vanish", pos +Vector(0,0,40), Angle(0,0,0), ally)
			self:StopParticles()
			self.thelast = 3
                        end
			        end
                        
                    if lottery == 5 then
			            if self.thelast != 5 then
                        --ParticleEffectAttach("tor_projectile", PATTACH_POINT_FOLLOW, self, 1)
                        local devilsquid = ents.Create("npc_devilsquid_r")
			devilsquid:SetPos(pos)
			devilsquid:SetAngles(self:GetAngles())
			devilsquid:Spawn()
			devilsquid:Activate()
			devilsquid.entEnemy = self.entEnemy
			table.insert(self.tblSummonedAllies, devilsquid)
			
			devilsquid:EmitSound("vj_hlr/gsrc/fx/beamstart" .. math.random(1,2) .. ".wav",85,100)
			
			ParticleEffect(self.SpwPartEfc, pos +Vector(0,0,40), Angle(0,0,0), ally)
			ParticleEffect("tor_projectile_vanish", pos +Vector(0,0,40), Angle(0,0,0), ally)
			self:StopParticles()
			self.thelast = 5
                        end			      
			        end
                            
			    if lottery == 9 then
			        if self.thelast != 9 then
                        --ParticleEffectAttach("tor_projectile", PATTACH_POINT_FOLLOW, self, 1)
                    local poisonsquid = ents.Create("npc_poisonsquid_r")
					poisonsquid:SetPos(pos)
					poisonsquid:SetAngles(self:GetAngles())
					poisonsquid:Spawn()
					poisonsquid:Activate()
					poisonsquid.entEnemy = self.entEnemy
					table.insert(self.tblSummonedAllies, poisonsquid)
			
					poisonsquid:EmitSound("vj_hlr/gsrc/fx/beamstart" .. math.random(1,2) .. ".wav",85,100)
			
					ParticleEffect(self.SpwPartEfc, pos +Vector(0,0,40), Angle(0,0,0), ally)
					ParticleEffect("tor_projectile_vanish", pos +Vector(0,0,40), Angle(0,0,0), ally)
					self:StopParticles()
					self.thelast = 9
                    end
			    end
         
					if lottery == 13 then
						if self.thelast != 13 then
                        --ParticleEffectAttach("tor_projectile", PATTACH_POINT_FOLLOW, self, 1)
                        local toxicsquid = ents.Create("npc_toxicsquid_r")
						toxicsquid:SetPos(pos)
						toxicsquid:SetAngles(self:GetAngles())
					    toxicsquid:Spawn()
					    toxicsquid:Activate()
					    toxicsquid.entEnemy = self.entEnemy
					    table.insert(self.tblSummonedAllies, toxicsquid)
			
					toxicsquid:EmitSound("vj_hlr/gsrc/fx/beamstart" .. math.random(1,2) .. ".wav",85,100)
			
					ParticleEffect(self.SpwPartEfc, pos +Vector(0,0,40), Angle(0,0,0), ally)
					ParticleEffect("tor_projectile_vanish", pos +Vector(0,0,40), Angle(0,0,0), ally)
					self:StopParticles()
					self.thelast = 13
                        end
					end

					if lottery == 17 then
						if self.thelast != 17 then
                       -- ParticleEffectAttach("tor_projectile", PATTACH_POINT_FOLLOW, self, 1)
                        local hybridsquid = ents.Create("npc_hybridsquid_r")
					hybridsquid:SetPos(pos)
					hybridsquid:SetAngles(self:GetAngles())
					hybridsquid:Spawn()
					hybridsquid:Activate()
					hybridsquid.entEnemy = self.entEnemy
					table.insert(self.tblSummonedAllies, hybridsquid)
			
					hybridsquid:EmitSound("vj_hlr/gsrc/fx/beamstart" .. math.random(1,2) .. ".wav",85,100)
			
					ParticleEffect(self.SpwPartEfc, pos +Vector(0,0,40), Angle(0,0,0), ally)
					ParticleEffect("tor_projectile_vanish", pos +Vector(0,0,40), Angle(0,0,0), ally)
					self:StopParticles()
					self.thelast = 17
                        end
					end
                        if lottery == 12 || lottery == 14 || lottery == 16 || lottery == 18 then
                        self.houndally = "npc_vj_hlr1a_houndeye"
                        end                 
                        if lottery == 2 || lottery == 4 || lottery == 6 || lottery == 8 || lottery == 10 then
                        self.houndally = "npc_vj_hlr1_houndeye"
                        end
                        if lottery == 2 || lottery == 4 || lottery == 6 || lottery == 8 || lottery == 10 || lottery == 12 || lottery == 14 || lottery == 16 || lottery == 18 then
                        local houndeye = ents.Create(self.houndally)// npc_vj_hlr1a_houndeye
                        --ParticleEffectAttach("tor_projectile", PATTACH_POINT_FOLLOW, self, 1)
						houndeye:SetPos(pos)
						houndeye:SetAngles(self:GetAngles())
						houndeye:Spawn()
						houndeye:Activate()
						houndeye:SetHealth(houndeye:GetMaxHealth()*hlrFloatHealth)
						houndeye.entEnemy = self.entEnemy
						table.insert(self.tblSummonedAllies, houndeye)
			
						houndeye:EmitSound("vj_hlr/gsrc/fx/beamstart" .. math.random(1,2) .. ".wav",85,100)
			
						ParticleEffect(self.SpwPartEfc, pos +Vector(0,0,40), Angle(0,0,0), ally)
						ParticleEffect("tor_projectile_vanish", pos +Vector(0,0,40), Angle(0,0,0), ally)
						self:StopParticles()
					    self.thelast = 2
                        end
            end end) 
            self.KingPinCanDoNextAttack = true
		elseif self.DoMultipleEnergyOrbs == true and self.bInSchedule != true and self.Flinching == false then
			self.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1 -- Range Attack Animations
			--self:PlayAnim("vjges_distanceattack", true, 1)
			self.KingPinNextRangeAttackTime = CurTime() + 0.5
			local OrbT = 0.2 -- timer delay
			local entscale
			if self.energy < 20 then
				entscale = 4
				if self.energy < 10 then
					entscale = 2
				end
            else
            	entscale = 8
			end
		    for i = 1, 3 do
			timer.Simple(OrbT, function()
		        if IsValid(self) then
		        if !IsValid(self.entEnemy) or self.energy <= 0 then return end
			    --print("Custom_02")
			    local attA = self:GetAttachment(self:LookupAttachment("clawleft"))
			    local attB = self:GetAttachment(self:LookupAttachment("clawright"))
				pos = (attA.Pos +attB.Pos) *0.5
				local dir = self:GetConstrictedDirection(pos, 10, 1, self.entEnemy:WorldSpaceCenter() +self.entEnemy:GetVelocity() *0.85)
				local ent = ents.Create("obj_kingpin_projectile_energy_r")
				ent:SetEntityOwner(self)
				ent:SetOrbTarget(self.entEnemy)
				ent:SetPos(pos)
				ent:SetAngles(dir:Angle())
				ent:SetScale(entscale)
				entscale = entscale-2
				/*if !self.PO then 
					ParticleEffect("kingpin_sphere_headglow", pos, Angle(0,0,0), self)
					timer.Simple(OrbT-0.9, function()
		       	       if IsValid(self) then
		        		self:StopParticles() end end) 
					self.PO = true 
				end */
		    	ParticleEffectAttach("kingpin_object_charge_bits", PATTACH_POINT_FOLLOW, ent, 1)
				ent:Spawn()
				ent:Activate()
				self.EntOrb = ent
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:ApplyForceCenter(dir *2)
		        end
		        self.KingPinCanDoNextAttack = true
				self.energy = self.energy -10
				self.thelast = 4
		    end end) 
		    OrbT = OrbT +0.2
		    end
		    //self.PO = false
        end
	    if IsValid(self.entEnemy) and self:Visible(self.entEnemy) and self.CanDoSummon==false and self.DoMultipleEnergyOrbs == false then -- self.MovementType != VJ_MOVETYPE_STATIONARY -- used to check if it had entered 1 time in beam, but broke it!
	    	--print("Custom_03")
		// beamstart
			self.AnimTbl_RangeAttack = ACT_SIGNAL1
		    self.IsGuard = true
		    self.MovementType = VJ_MOVETYPE_STATIONARY
		    --self:PlayAnim("vjseq_attack_beam_start1", true, 1.5, true, 0,{PlayBackRateCalculated=true}) -- ACT_SIGNAL1 attack_beam_start1, playbackrate can't be changed here otherwise changes all animations playbackrate though it can be set to normal on think with self.AnimationPlaybackRate
		    timer.Simple(1.4, function()
		    if IsValid(self) and (IsValid(self.entEnemy) && CurTime() >= self.KingPinNextRangeAttackTime && self.KingPinCanDoNextAttack == true) and self.DoMultipleEnergyOrbs==false then
		    --self:PlayAnim(ACT_SIGNAL_ADVANCE, false, 1, true) -- ACT_SIGNAL_ADVANCE
		    self.bInSchedule = true
		    self.AnimTbl_RangeAttack = self.PickBeamAnim
		    self.KingPinNextRangeAttackTime = CurTime() + 15
		    local hlrMultidmg = GetConVar("hlrcustom_multidmg"):GetFloat()
	        self.BeamDmg = self.BeamDmg*hlrMultidmg
		    //self.NextAnyAttackTime_Range = 2 -- How much time until it can use any attack again? | Counted in Seconds
		    //self.NextRangeAttackTime = 10 
		    //self.HasRangeAttack = false -- Should the SNPC have a range attack?
			local pos = self:GetPos()
			//if (!self.posEnemyLast && !IsValid(self.entEnemy) ) then return end
            local normal = ((self.posEnemyLast || self.entEnemy:GetPos()) -pos):GetNormalized()
			local posTgt = pos +normal *250
			local tr = util.TraceLine({start = posTgt +Vector(0,0,100), endpos = posTgt -Vector(0,0,100), mask = MASK_NPCWORLDSTATIC})
			posTgt = tr.HitPos
			self.posBeam = posTgt
			local entTarget = ents.Create("obj_vj_pointed_tg_r")
			entTarget:SetPos(self.posBeam)
			entTarget:SetOwner(self)
			entTarget:Spawn()
			entTarget:Activate()

			self:DeleteOnRemove(entTarget)
			self.entTarget = entTarget
			ParticleEffectAttach("vortigaunt_hand_glow", PATTACH_POINT_FOLLOW, self.entTarget, 0)
	        self.BeamLoopSd = CreateSound(self, self.BeamLoopSnd)
            self.BeamLoopSd:SetSoundLevel(85)
    	    self.BeamLoopSd:PlayEx(1,100)
			self.tblBeams = {}
			self.tblSprites = {}
			for i = 1, 2 do
			local csp = CreateSound(self, "npc/stalker/laser_burn.wav")
			csp:Play()
				local att = i == 1 && "clawleft" || "clawright"
				local entBeam = ents.Create("obj_beam_r")
				--local entBeam2 = util.ParticleTracer("kingpin_beam_charge2", self:GetAttachment(self:LookupAttachment("clawright")).Pos, self:GetAttachment(self:LookupAttachment("clawleft")).Pos, false)
	--timer.Simple(5, function() print("BEAM: ", entBeam2) end)
	            --self:DeleteOnRemove(entBeam2)
				--entBeam:SetLifeTime(2) -- system unused  
				entBeam:SetOwner(self)
				entBeam:SetStart(self.attAPos, self:LookupAttachment(att), self)
				entBeam:SetPos(self.entTarget:GetPos()) -- allows Draw function to run on client since it spawns inside world
				entBeam:SetEnd(self.entTarget)
				--entBeam:SetParent(self)
				--entBeam:Fire("SetParentAttachment", att, 0) --breaks beam render

				entBeam:SetDelay(1.11)
				entBeam:SetTexture("effects/kingpin_beam.vmt")
				--entBeam:SetRandom(true) -- to do when obj target reaches places that beam isn't able or to create random pos when there's no enemy
				entBeam:SetDistance(2)
				entBeam:SetBeamColor(10, 255, 222, 100)
				entBeam:SetAmplitude(2)
				entBeam:SetUpdateRate(0.025)--0.25)
				entBeam:Spawn()
				entBeam:Activate()
				entBeam:TurnOn()
				table.insert(self.tblBeams, entBeam)
				self:DeleteOnRemove(entBeam)
				self.entBeam = entBeam


				local entSprite = ents.Create("env_sprite")
				entSprite:SetKeyValue("model", "sprites/kingpin_glow01.vmt")
				entSprite:SetKeyValue("rendermode", "5") 
				entSprite:SetKeyValue("rendercolor", "0 225 225") 
				entSprite:SetKeyValue("scale", "0.2") 
				entSprite:SetKeyValue("spawnflags", "1") 
				entSprite:SetParent(self)
				entSprite:Fire("SetParentAttachment", att, 0)
				entSprite:Spawn()
				entSprite:Activate()
				table.insert(self.tblSprites, entSprite)
				self:DeleteOnRemove(entSprite)

			self.cspBeam = csp
			csp:Stop()
			end
			local entSprite = ents.Create("env_sprite")
			entSprite:SetPos(self.entTarget:GetPos())
			entSprite:SetKeyValue("model", "sprites/kingpin_glow01.vmt")
			entSprite:SetKeyValue("rendermode", "5") 
			entSprite:SetKeyValue("rendercolor", "0 225 225") 
			entSprite:SetKeyValue("scale", "0.4") 
			entSprite:SetKeyValue("spawnflags", "1") 
			entSprite:SetParent(self.entTarget)
			entSprite:Spawn()
			entSprite:Activate()
			table.insert(self.tblSprites, entSprite)
			self.entTarget:DeleteOnRemove(entSprite)

			self.energy = math.random(60,190)
			self.AddEnergy = self.energy /2

			csp = CreateSound(self.entTarget, "npc/stalker/laser_flesh.wav")
			self.cspBeamHit = csp
			csp:Stop()
			//self.thelast = 17
			ParticleEffectAttach("kingpin_psychic_shield_idle_middle", PATTACH_POINT_FOLLOW, self, 0)
	        ParticleEffectAttach("kingpin_psychic_shield_idle_ring", PATTACH_POINT_FOLLOW, self, 0)
	        end end)
		end
	else
		// beamstop
		/*	if !IsValid(self.entEnemy) or self.entEnemy:Health() <= 0 || !self:Visible(self.entEnemy) || self:GetPathDistanceToGoal() > self.RangeAttackMaxDistance then
			 	print("Custom_Stop")
				self:EnableShield()
		        if self.tblBeams != nil then
				    for _, beam in pairs(self.tblBeams) do beam:Remove() end
				    for _, sprite in pairs(self.tblSprites) do sprite:Remove() end 
                    self.tblSprites = nil
	        	    self.tblBeams = nil
				    self.cspBeam:Stop()
				    self.cspBeam = nil
				    self.cspBeamHit:Stop()
				    self.cspBeamHit = nil
				    self.entTarget:Remove()
				    self.entTarget = nil
				    self.BeamLoopSd:Stop()
				    self.BeamLoopSd = nil
				    self.KingPinNextRangeAttackTime = CurTime() -1
			    end
            else*/
		--if self.bShieldActive == true and !self.VJ_IsBeingControlled then self:DisableShield() end
	end
end
function ENT:OnRangeAttackExecute(status, enemy, projectile)
    if status == "Init" then return true
    end
end
function ENT:KingpinRenaissanceInterruptBeam(Forced) -- Called on flinch, no target or removed
	-- BeamInterruptCode
	--print("KingpinRenaissanceInterruptBeam")
	if self.bInSchedule then
		if self.tblBeams then for _, beam in pairs(self.tblBeams) do beam:Remove() end; self.tblBeams = nil end
		if self.tblSprites then for _, sprite in pairs(self.tblSprites) do sprite:Remove() end; self.tblSprites = nil end
		self.bInSchedule = false
		if VJ.IsCurrentAnim(self, "attack_beam_loop") then -- check for flinch anim before
		    self:PlayAnim(ACT_SIGNAL_ADVANCE, true, 0.5, true)
		end 
		if VJ.IsCurrentAnim(self, "psychic_loop") then
			self:PlayAnim(ACT_SIGNAL_HALT, true, 0.4, true) -- attack_beam_end 
		end
		--self:EnableShield()
		if self.cspBeam then
			self.cspBeam:Stop()
			self.cspBeam = nil
		end
		if self.cspBeamHit then
			self.cspBeamHit:Stop()
			self.cspBeamHit = nil
		end
		if self.BeamLoopSd then
			self.BeamLoopSd:Stop()
			self.BeamLoopSd = nil
		end
		if IsValid(self.entTarget) then
			self.entTarget:Remove()
			self.entTarget = nil
		end
	    self.IsGuard = false
	    self.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
	    self.PickBeamAnim = VJ.PICK(self.BeamloopAnims)
        self.KingPinNextRangeAttackTime = CurTime() -1
        if Forced == false then
        	self.energy = self.AddEnergy -- give more energy if the beam completed normally
        else 
        	self.energy = self.energy/3
        end
        self.FlinchChance = 4
        self.FlinchCooldown = 5
        self:PlaySoundSystem("OnReceiveOrder")
        self:StopParticles()
	end
	self.KingPinCanDoNextAttack = true
end
function ENT:SelectScheduleHandle(distToEne)
if self.energy < 0 then
    self:KingpinRenaissanceInterruptBeam(false)
end	
	if IsValid(self.entEnemy) then
	    if self:CanSee(self.entEnemy) then
			local InRange = distToEne <= self.RangeAttackMaxDistance
			--local bPlayerThrow = CurTime() >= self.nextPlayerThrow && self.entEnemy:IsPlayer()
			if InRange then
				for _, ent in pairs(self.tblSummonedAllies) do if !IsValid(ent) then self.tblSummonedAllies[_] = nil end end
				if table.Count(self.tblSummonedAllies) < 3 and CurTime() > self.KSCooldownDelay then
					self.CanDoSummon = true
					return
				else
				// more than 2 allies
					self.bHit = false
				// can not do summon
				    self.CanDoSummon = false
				    if self.BoneFollowerOn==true then
				        self.LEarBoneFollower:StopParticles()
				        self.REarBoneFollower:StopParticles()
				        self.BoneFollowerOn=false
				    end
				return end
				--[[/*self:UpdatePhysicsEnts()
				if #self.tblPhysEnts > 0 || bPlayerThrow then
					if bPlayerThrow && (#self.tblPhysEnts == 0 || math.random(1,3) == 1) then
						self.bThrowPlayer = true
						ParticleEffectAttach("kingpin_object_charge_large", PATTACH_ABSORIGIN_FOLLOW, self.entEnemy, 0)
						local _sName = self.entEnemy:GetName()
						local sName = _sName
						if sName == self.entEnemy:Name() then
							sName = "KingPin" .. self:EntIndex() .. "_entThrow"
							self.entEnemy:SetName(sName)
						end
						local entParticle = ents.Create("info_particle_system")
						entParticle:SetPos(self:OBBCenter())
						entParticle:SetParent(self)
						entParticle:SetKeyValue("effect_name", "kingpin_psychic_beam")
						entParticle:SetKeyValue("start_active", "1")
						entParticle:SetKeyValue("cpoint1", sName)
						entParticle:Spawn()
						entParticle:Activate()
						self.entEnemy:SetName(_sName)
						self.entParticle = entParticle
					end
					self.nextThrow = CurTime() +math.Rand(3,4)
					self:SLVPlayActivity(ACT_RANGE_ATTACK1_LOW, true)
					self.bInSchedule = true
					return
				end*/]]--
			else
			    self.CanDoSummon = false
			end
        end
	end
end
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("RELOAD: Turn On/Off shield, SPACE: Emergency Beam cancel")
	function controlEnt:OnKeyPressed(key)
		--print(key)
		if key == KEY_SPACE and self.VJCE_NPC.bInSchedule==true then
		    self.VJCE_NPC:KingpinRenaissanceInterruptBeam(true)
			ply:ChatPrint("Beam has been canceled, kingpin R energy dropped bellow half!")
		end
	end
	function controlEnt:OnKeyBindPressed(key)
		if key == IN_RELOAD and !self.VJCE_NPC:IsBusy(false) then
			self.VJCE_NPC:OnIdleDialogue(self.entShield)
        end
    end
end