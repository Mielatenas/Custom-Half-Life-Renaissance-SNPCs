if SERVER then
    AddCSLuaFile("autorun/server/freeze_module_custom_renaissance.lua")
    include("autorun/server/freeze_module_custom_renaissance.lua")
else
    include("autorun/server/freeze_module_custom_renaissance.lua")
end
if SERVER then
    local HLRCFreezeSyncT = 0
hook.Add("Think", "HLRC_FreezeDecay", function()
    if not FreezeModule or not FreezeModule.FrozenEntities then return end
    local now = CurTime()
    local doSync = now >= HLRCFreezeSyncT
    if doSync then HLRCFreezeSyncT = now + 1.5 end

    for ent, data in pairs(FreezeModule.FrozenEntities) do
        local isPlayer = ent:IsPlayer()
        local PLyisAlive = isPlayer and ent:Alive()
        if not IsValid(ent) or (isPlayer and not PLyisAlive) then
            if data.FreezeLevel and data.FreezeLevel > 0 then
            data.FreezeLevel = 0 ; data.lastAppliedRate=nil end
            FreezeModule.FrozenEntities[ent] = nil
            continue
        end
        -- Skip decay if still in freeze window
        if data.untilFr and CurTime() < data.untilFr then continue end
        -- Apply decay to internal data
        local interval = 0.3
        local baseDecay = 0.1 -- points per second
        local freezeRatio = data.FreezeLevel / 100
        local decayFactor = Lerp(freezeRatio ^ 0.3, baseDecay * 0.2, baseDecay * 0.8)    
        local decayRate = decayFactor * interval
        data.FreezeLevel = math.max(data.FreezeLevel - decayRate, 0)
        --print("[Decay] Entity:", ent, "FreezeLevel:", data.FreezeLevel, "DecayRate:", decayRate)   
        ent.FreezeLevel = data.FreezeLevel -- Sync entity field for compatibility

        -- Cleanup if thawed
        if data.FreezeLevel <= 0 then
            if data.originalRate then
                ent:SetPlaybackRate(data.originalRate) -- restore to entity org playrate
                --print(string.format("[Thaw] %s restored to %.2f", ent:GetClass(), data.originalRate or 1.0))
            end
            FreezeModule.FrozenEntities[ent] = nil
        elseif doSync then  -- Sync to client every x secs
            net.Start("HLRC_FreezeSync")
                net.WriteEntity(ent)
                net.WriteFloat(data.FreezeLevel or 0)
                net.WriteFloat(data.lastAppliedRate or 1.0)
            net.SendPVS(ent:GetPos())
        end
    end
end)

hook.Add("SetupMove", "HLRC_FreezePlayerSlowdown", function(ply, mv, cmd)
    if not FreezeModule then return end
    if not IsValid(ply) or not ply.FreezeLevel then return end
    local data = FreezeModule.FrozenEntities[ply]
    local rate = (data and data.lastAppliedRate) or 1.0
    local speedMultiplier = math.Clamp(rate, 0.3, 1.0)
    mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * speedMultiplier)
end)
/*
hook.Add("OnNPCKilled", "HLRC_BreakFrozen_NPC", function(npc, entKiller, entWeapon) -- a frozen npc dies
       --print(npc) 
    if not FreezeModule or not FreezeModule.FrozenEntities then return end
    if npc:IsNPC() then
        local data = FreezeModule.FrozenEntities[npc]
        if data and data.FreezeLevel >= 80 then
            FreezeModule.BreakIceGibs(npc)
        end
    end
end)
*/
hook.Add("PlayerSwitchWeapon", "HLRC_FreezePlayerSwitchWeapon", function(ply, oldWep, newWep)
    if not FreezeModule then return end
    local data = FreezeModule.FrozenEntities[ply]
    if data and data.NextWeaponFire and IsValid(newWep) then
        newWep:SetNextPrimaryFire(data.NextWeaponFire)
        newWep:SetNextSecondaryFire(data.NextWeaponFire)
    end
end)

hook.Add("PlayerDeath", "HLRC_BreakFrozen_Player", function(entVictim, entInflictor, entKiller)
    if not FreezeModule then return end
    if IsValid(entVictim) then
        --print("[HLRC] Clearing freeze for:", ply, IsValid(ply))
        FreezeModule.FrozenEntities[entVictim] = nil
        entVictim.FreezeLevel = nil
        entVictim.lastAppliedRate = nil
    end
end)
hook.Add("PlayerSpawn", "HLRC_ClearFreezeOnSpawn", function(ply)
    if IsValid(ply) then
        --print("[HLRC] Clearing freeze for:", ply, IsValid(ply))
        FreezeModule.FrozenEntities[ply] = nil
        ply.FreezeLevel = nil
        ply.lastAppliedRate = nil
    end
end)

hook.Add("EntityTakeDamage", "HLRC_FreezeScaleDamage", function(target, dmginfo) -- scales damage from FreezeLevel, so every melee DMG_SLASH type damage is reduced
    if not FreezeModule or not FreezeModule.FreezeEnemies then return end
    local attacker = dmginfo:GetAttacker()
    local inflictor = dmginfo:GetInflictor()
    local source = IsValid(attacker) and attacker or (IsValid(inflictor) and inflictor or nil)
    if not IsValid(source) then return end

    if source.FreezeLevel and source.FreezeLevel > 0 then
        local dmgType = dmginfo:GetDamageType()
        if bit.band(dmgType, DMG_SLASH) > 0 or bit.band(dmgType, DMG_CLUB) > 0 then
            local freezeFactor = math.Clamp(source.FreezeLevel / 100, 0, 1)
            local damageMultiplier = Lerp(freezeFactor, 1, 0.3)
            local scaledDamage = dmginfo:GetDamage() * damageMultiplier
            dmginfo:SetDamage(scaledDamage)
            --print("[Freeze] Damage scaled from", source:GetClass(), "FreezeLevel:", source.FreezeLevel, "Multiplier:", damageMultiplier)
        end
    end
end)
hook.Add("StartCommand", "HLRC_FreezeInputGate", function(ply, cmd)
    local data = FreezeModule.FrozenEntities and FreezeModule.FrozenEntities[ply]
    if not data then return end

    local nextFire = data.NextWeaponFire
    if nextFire and nextFire > CurTime() then
        -- Block only until the timestamp passes
        cmd:RemoveKey(IN_ATTACK)
        cmd:RemoveKey(IN_ATTACK2)
    end
end)

/*

hook.Add("EntityFireBullets", "HLRC_FreezeThrottleBullets", function(ent, data)
    if not FreezeModule or not FreezeModule.FrozenEntities[ent] then return end
    if ent:IsNextBot() and ent.FreezeLevel and ent.FreezeLevel > 70 then
        if not ent.CanAttack then return false end
    end

    local freezeData = FreezeModule.FrozenEntities[ent]
    local rate = freezeData.lastAppliedRate or 1.0
    local fireDelay = 0.2 * (1 - rate)
    local wep = ent:GetActiveWeapon()
    if IsValid(wep) then
        local now = CurTime()
        wep:SetNextPrimaryFire(now + fireDelay)
        wep:SetNextSecondaryFire(now + fireDelay)
        freezeData.NextWeaponFire = now + fireDelay
        print(string.format("[Throttle] Delayed fire for %s by %.2fs", ent:Nick(), fireDelay))
    end
end) */
hook.Add("EntityTakeDamage", "HLRC_BurnDamageUnFreeze", function(ent, dmginfo)
    if not FreezeModule then return end
	if IsValid(ent) && (ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot()) then -- set only if is DMG_BURN validation, happens too frequent
		--local iPercentFrozen = ent:FrozenPercentage()
		if ent.FreezeLevel and ent.FreezeLevel > 0 then
			if dmginfo:IsDamageType(DMG_DIRECT) || dmginfo:IsDamageType(DMG_BURN) then
				--ent:UnFreeze(math.Round(dmginfo:GetDamage() *0.5))
			end
		end
	end
end)
end
if CLIENT then
    ------------------client cvars that will have to port to freeze module--------------------
    ------------------every client can config their own freeze effects------------------------
    --FreezeModule = FreezeModule or {}
    FreezeModule.cvarmaxBones = 0
    FreezeModule.cvarMaxDrawnEnts = 0
    timer.Simple(0.1, function()
        local bonesCVar = GetConVar("hlrcustom_freeze_bones")
        local drawCVar = GetConVar("hlrcustom_freeze_maxdraw")
        if bonesCVar and drawCVar then
            FreezeModule.cvarmaxBones = math.max(bonesCVar:GetInt(), 0)
            FreezeModule.cvarMaxDrawnEnts = math.max(drawCVar:GetInt(), 20)
            local function FreezeEffectsClientCVars()
                local bones = math.max(bonesCVar:GetInt(), 0)
                local maxdraw = math.max(drawCVar:GetInt(), 20)
                if bones ~= FreezeModule.cvarmaxBones then
                    FreezeModule.cvarmaxBones = bones
                    print("[HLRC] freeze bones updated to", bones)
                end
                if maxdraw ~= FreezeModule.cvarMaxDrawnEnts then
                    FreezeModule.cvarMaxDrawnEnts = maxdraw
                    print("[HLRC] max drawn ents updated to", maxdraw)
                end
                timer.Simple(5, FreezeEffectsClientCVars)
            end
            FreezeEffectsClientCVars()
        end
    end)
    -----------------------------------------------------------------------------------------
    net.Receive("HLRC_FreezeSync", function()
        local ent = net.ReadEntity()
        local freezeLevel = net.ReadFloat()
        local rate = net.ReadFloat()
        --print("[ClientSync] Received FreezeLevel", freezeLevel, "for", ent)
        FreezeModule = FreezeModule or {}
        FreezeModule.FrozenEntities = FreezeModule.FrozenEntities or {}
        if not IsValid(ent) then 
            timer.Simple(0.5, function() -- safeguard to get ragdolls created late on client
                if not IsValid(ent) then return end
                FreezeModule.FrozenEntities[ent] = FreezeModule.FrozenEntities[ent] or {}
                if freezeLevel <= 0 then
                    FreezeModule.FrozenEntities[ent] = nil
                else
                    --FreezeModule.FrozenEntities[ent] = { FreezeLevel = freezeLevel }
                    FreezeModule.FrozenEntities[ent].FreezeLevel = freezeLevel
                    FreezeModule.FrozenEntities[ent].lastAppliedRate = rate
                end             
            end)
            return
        end
        FreezeModule.FrozenEntities[ent] = FreezeModule.FrozenEntities[ent] or {}
        if freezeLevel <= 0 then
            FreezeModule.FrozenEntities[ent] = nil
        else
            --FreezeModule.FrozenEntities[ent] = { FreezeLevel = freezeLevel }
            FreezeModule.FrozenEntities[ent].FreezeLevel = freezeLevel
            FreezeModule.FrozenEntities[ent].lastAppliedRate = rate
        end
    end)
    -- Client-side only
    hook.Add("PostDrawOpaqueRenderables", "HLRC_DrawFreezeOverlay", function() -- ice effect over any ents but viewmodels
        if not FreezeModule or not FreezeModule.FrozenEntities then return end
        local count = 0
        local maxDraw = FreezeModule.cvarMaxDrawnEnts -- max entities to draw per frame
        local maxDist = 2000 -- max distance from player
        local eyePos = EyePos()
        for ent, data in pairs(FreezeModule.FrozenEntities) do
            if count >= maxDraw then break end
            if not IsValid(ent) or not data.FreezeLevel or data.FreezeLevel <= 0 then continue end
            if ent:IsPlayer() then
                if not ent:Alive() then 
                    if data.FreezeLevel >= 50 then -- and not data._gibsSpawned
                        --data._gibsSpawned = true
                        data.FreezeLevel = 0
                        FreezeModule.HLRC_SpawnIceGibs(ent)
                    end
                    data.FreezeLevel = 0
                    data.lastAppliedRate = nil
                    if istable(ent.FreezeBoneParticles) then
                        for _, p in pairs(ent.FreezeBoneParticles) do
                            if IsValid(p) then p:StopEmission() end
                        end
                        ent.FreezeBoneParticles = nil
                    end
                    continue
                --else
                    --if data._gibsSpawned then data._gibsSpawned = nil end
                end
            end
            if ent:GetOwner() == LocalPlayer() then continue end
            if ent:GetPos():DistToSqr(eyePos) > maxDist * maxDist then continue end
            local alpha = math.Clamp((data.FreezeLevel / 100) ^ 2, 0.05, 1) 
            FreezeModule.DrawFrostOverlay(ent, alpha)
            --print("[Render] FreezeLevel for", ent, "=", data.FreezeLevel)
            local bonePositions = {}
            --print("[ClientFX] Entity:", ent, "FreezeLevel:", data.FreezeLevel)
            if data.FreezeLevel > 50 then
                if not istable(ent.FreezeBoneParticles) or table.IsEmpty(ent.FreezeBoneParticles) then
                    ent.FreezeBoneParticles = {}
                    local maxBones = FreezeModule.cvarmaxBones
                    local attached = 0 
                    local boneCount = ent:GetBoneCount()
                    if not istable(ent.FreezeBoneIndices) then
                        ent.FreezeBoneIndices = {}
                        for i = 1, boneCount - 1 do
                            ent.FreezeBoneIndices[#ent.FreezeBoneIndices + 1] = i
                        end
                        table.Shuffle(ent.FreezeBoneIndices)
                    end
                        --for i = 1, boneCount - 1 do
                    for i = 1, #ent.FreezeBoneIndices do
                        if attached >= maxBones then break end
                        local boneIndex = ent.FreezeBoneIndices[i]
                        local boneName = ent:GetBoneName(boneIndex)
                        local pos = ent:GetBonePosition(boneIndex)
                        bonePositions[boneIndex] = pos
                        if boneName and boneName ~= "__INVALIDBONE__" and pos and pos:DistToSqr(ent:GetPos()) > 4 then
                            local p = CreateParticleSystem(ent, "frostsquid_ice_mist", PATTACH_CUSTOMORIGIN)
                            if p then
                                p:SetControlPoint(0, pos)
                                ent.FreezeBoneParticles[boneIndex] = p
                                attached = attached + 1
                            end
                        end
                    end     
                    --ent.FreezeParticleAttached = true
                end
            else 
                if istable(ent.FreezeBoneParticles) then
                    for _, p in pairs(ent.FreezeBoneParticles) do
                        if IsValid(p) then p:StopEmission() --; print("[FreezeFX] Stopped mist for", ent:GetClass(), ent:EntIndex())
                        end
                    end
                    ent.FreezeBoneParticles = nil
                    --ent:StopParticleEmission()            
                end
            end
            if ent.FreezeBoneParticles then -- Update CP0 for each particle per bone
                ent._nextCPUpdate = ent._nextCPUpdate or 0
                if CurTime() >= ent._nextCPUpdate then -- Prevents buffer overflow from excessive updates
                    ent._nextCPUpdate = CurTime() + 0.1
                    for boneID, p in pairs(ent.FreezeBoneParticles) do
                        if IsValid(p) then
                            local pos = bonePositions[boneID] or ent:GetBonePosition(boneID)
                        --local lastPos = p._lastPos or vector_origin
                        --if pos:DistToSqr(lastPos) > 0.25 then
                            p:SetControlPoint(0, pos)
                               -- p._lastPos = pos
                            --end
                        end
                    end
                end
            end
            count = count + 1
        end
    end)
    hook.Add("EntityRemoved", "HLRC_ClientsideGibOnRemove", function(ent)
        if not IsValid(ent) or ent:IsPlayer() then return end
        local data = FreezeModule.FrozenEntities and FreezeModule.FrozenEntities[ent]
        if not data then return end
        if data and data.FreezeLevel >= 50 then
            FreezeModule.HLRC_SpawnIceGibs(ent)
        end
    end)
    hook.Add("PreDrawViewModel", "HLRC_SlowViewModelPlayback", function(vm, ply, weapon)
        if not IsValid(vm) or not IsValid(ply) then return end
        local data = (FreezeModule and FreezeModule.FrozenEntities) and FreezeModule.FrozenEntities[ply]
        if not data or not data.FreezeLevel or data.FreezeLevel <= 0 then return end
        local rate = (data and data.lastAppliedRate) or 1.0  

        --print(data.lastAppliedRate)
        local scaledRate = math.max(0.05, rate)
        vm:SetPlaybackRate(scaledRate)
        --local mat = Material("effects/ice_unlit_layer_vm")

        --local alpha = math.Clamp((data.FreezeLevel / 100) ^ 2, 0.1, 1)
        --render.SetMaterial(Material("effects/ice_unlit_layer_vm"))
        --render.MaterialOverride(mat)
        --render.SetColorModulation(0.57, 0.77, 1.3)
        --render.SetBlend(alpha)
    end)
    local lastWeaponClass = nil
    hook.Add("PostDrawViewModel", "HLR_FrostOverlayViewmodel", function(vm, ply, weapon)
        if not IsValid(vm) or ply ~= LocalPlayer() then return end
        local data = (FreezeModule and FreezeModule.FrozenEntities) and FreezeModule.FrozenEntities[ply]
        if not data or not data.FreezeLevel then return end -- data.FreezeLevel <= 0

        local currentClass = IsValid(weapon) and weapon:GetClass() or ""
        if currentClass ~= lastWeaponClass then
            if IsValid(overlayModel) then
                overlayModel:Remove()
                overlayModel = nil
            end
            lastWeaponClass = currentClass
        end
        --print(data.FreezeLevel)
        if not IsValid(overlayModel) and data.FreezeLevel > 1 then
            --print("overlayModel = ClientsideModel")
            overlayModel = ClientsideModel(vm:GetModel(), RENDERGROUP_VIEWMODEL)
            overlayModel:SetNoDraw(true)
            overlayModel:SetParent(vm)
            overlayModel:AddEffects(EF_BONEMERGE)
            overlayModel:SetMaterial("models/gibs/ice/ice_unlit_layer")
        end
        local alpha = math.Clamp((data.FreezeLevel / 100) ^ 2, 0, 1)
        if alpha < 0.01 then alpha = 0 end
        if IsValid(overlayModel) then
            overlayModel:SetRenderOrigin(vm:GetPos())
            overlayModel:SetRenderAngles(vm:GetAngles())
            render.SetBlend(alpha)
            render.SetLightingMode(2)
            render.SetColorModulation(0.57, 0.77, 1)
             overlayModel:DrawModel()
            render.SetBlend(1)
            render.SetLightingMode(0)
            render.SetColorModulation(1,1,1)
            local mat = overlayModel:GetMaterials()[1] and Material(overlayModel:GetMaterials()[1])
            if mat then
                --print(alpha)
                --mat:SetFloat("$alpha", alpha)
                --mat:SetFloat("$freezelevel", alpha)
                --mat:SetVector("$color2", Vector(0, 0, 0)) -- should render black
            end
        end
        if data.FreezeLevel < 1 and IsValid(overlayModel) then
            --print("removed overlayModel")
             overlayModel:Remove()
             overlayModel = nil
        end
    end)
end
-- Apply the health multiplier to newly spawned entities
hook.Add("OnEntityCreated", "HLRC_MultiplierIdentifiers", function(ent)
if SERVER then
	local CustomHLRentClasses = {
 ["npc_bullsquid_base_r"] =true,
 ["npc_kingpin_r"] =true, 
 ["npc_devilsquid_r"] =true,
  ["npc_frostsquid_r"] =true,
   ["npc_toxicsquid_r"] =true,
    ["npc_poisonsquid_r"] =true,
     ["npc_hybridsquid_r"] =true
 } 
    if CustomHLRentClasses[ent:GetClass()] then
    	--ent.IsCustomHLRSNPC = true -- make a global identifier that can be read only on HLRC
        local multiplier = GetConVar("hlrcustom_multihealth"):GetFloat() --CustomHLRLoadConfig()
        timer.Simple(0.1, function() -- let time the npc initializes 
			if IsValid(ent) then
                ent:SetMaxHealth(ent:GetMaxHealth() * multiplier)
                ent:SetHealth(ent:GetMaxHealth())
            end
        end)
    end
    /*local ToxicMinesCount = 0 
    local MaxCustomHLRToxicMines = 70
    for i, ent in ipairs(ents.FindByClass("obj_bullsquid_spit_r")) do
    	ToxicMinesCount = ToxicMinesCount + 1
    	print(i,ent)
    end
    if ToxicMinesCount > MaxCustomHLRToxicMines then
    	ent:Remove()
    else
    	ToxicMinesCount = ToxicMinesCount + 1
    end*/
end
end)
