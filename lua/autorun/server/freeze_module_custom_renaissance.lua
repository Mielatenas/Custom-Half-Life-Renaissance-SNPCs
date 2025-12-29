    FreezeModule = FreezeModule or {} -- Initializes module table
if SERVER then
    AddCSLuaFile() -- Send this file to clients
    FreezeModule.FrozenEntities = FreezeModule.FrozenEntities or {}

    timer.Create("HLR_FreezeProcessTimer", 1.2, 0, function() -- this was 0.2 before initially, 1.2 just testing, change can have noticeable gameplay and sync consequences
        if FreezeModule and FreezeModule.ProcessAll then
            FreezeModule.ProcessAll()
        end
    end)
    util.AddNetworkString("HLRC_FreezeSync")
----------------------------cvars to enable/disable module--------------------------------------------
    local cvarEnemy = GetConVar("hlrcustom_freeze_enemy")
    local cvarEnabled = GetConVar("hlrcustom_freeze_enabled")
    local cvarResistance = GetConVar("hlrcustom_freeze_resistance")
    local enemyValue = cvarEnemy and cvarEnemy:GetBool() or false
    local enabledValue = cvarEnabled and cvarEnabled:GetBool() or false
    FreezeModule.FreezeEnemies = enemyValue or enabledValue
    --print("[HLRC] FreezeEnemies =", FreezeModule.FreezeEnemies)
    --- updates hlrcustom_freeze_resistance cvar only when the player changes the value, not every frame.
    local HP_resistance = math.max(cvarResistance and cvarResistance:GetInt() or 10000, 101) -- HP_resistance only usable in this SERVER block
    cvars.AddChangeCallback("hlrcustom_freeze_resistance", function(_, _, newValue)
        HP_resistance = math.max(tonumber(newValue) or 100000, 101)
    end, "HP_resistance_freeze")
----------------------------------------------------------------------------------------------
    function FreezeModule.ProcessAll()
        for ent, data in pairs(FreezeModule.FrozenEntities) do
            if not IsValid(ent) then
                FreezeModule.FrozenEntities[ent] = nil
                continue
            end
               -- Throttle movement, weapon usage, etc.
            FreezeModule.ApplyThrottle(ent, data)
            if ent.FreezeLevel ~= data.FreezeLevel then
                ent.FreezeLevel = data.FreezeLevel
            end
        end
    end

    hook.Add("Think", "HLR_FreezeModuleThink", FreezeModule.ProcessAll)
    local function HLRC_GetResistance(hp)
        local HP_resistance = FreezeModule.HP_resistance or 10000
        if hp >= HP_resistance then return 1 end
        local base = math.log(HP_resistance / 100)
        if base == 0 then base = 1 end
        return math.Clamp(math.log(hp / 100) / base, 0, 1)
    end
 -----------------------------------------------------------------------------------------------------   
function FreezeModule.HLRCustomApplyFreeze(ent, amount, minDuration) -- called from Icesphere and frostquid flame attack
    --PrintTable(scripted_ents.GetList())
    if not IsValid(ent) then return end
    local class = ent:GetClass()
    local isScripted = scripted_ents.GetStored(class) ~= nil
    --local isVJSNPC = ent.IsVJBaseSNPC == true
    local isNPC = ent:IsNPC()
    local allowedClasses = { -- add what non-sripted ents you want to be frozen
        ["player"] = true,
        ["prop_physics"] = true,
        ["prop_ragdoll"] = true,
    }
    local isAllowedClass = allowedClasses[class]
    if not (isScripted or isNPC or isAllowedClass) then --or isVJSNPC -- skip func_door, non-scripted entities, etc.
    --print("[FreezeModule] Rejected:", class)
        return
    end
    --print("[FreezeModule] Allowed:", ent:GetClass(), "→", allowedClasses[class] and "✓" or "✗")
    --if not isScripted and not isNPC and not allowedClasses[class] then return end -- skip func_door, non-scripted entities, etc.
    if scripted_ents.IsBasedOn(class, "base_anim") or scripted_ents.IsBasedOn(class, "base_projectile") or scripted_ents.GetType(class) == "anim" then return end -- filtering out scripted projectiles common bases
    if ent:GetMoveType() == MOVETYPE_NONE then return end
    if ent:GetCreationTime() and CurTime() - ent:GetCreationTime() < 2.5 then return end --acts as a grace period filter — filter short-lived entities like: Projectiles
    if ent:IsDormant() then return end
    local data = FreezeModule.FrozenEntities[ent] or {}
    local scaledAmount
    local duration = minDuration or 0
    local newUntil = CurTime() + duration
    data.untilFr = math.max(data.untilFr or 0, newUntil)
    if not data.untilFr or CurTime() < data.untilFr then
        local health = ent:Health() or 100
        local resistance = HLRC_GetResistance(health)
        scaledAmount = amount * (1 - resistance)
        data.FreezeLevel = data.FreezeLevel or 0
        data.FreezeLevel = math.Clamp(data.FreezeLevel + scaledAmount, 0, 100)
    end
    FreezeModule.FrozenEntities[ent] = data

    for ent, data in pairs(FreezeModule.FrozenEntities) do
        if not IsValid(ent) then 
            FreezeModule.FrozenEntities[ent] = nil
            data.FreezeLevel = nil
            data.NextWeaponFire = nil
            --net.Start("HLRC_FreezeSync") -- no longer needed as player is detected dead on PostDrawOpaqueRenderables
            --    net.WriteEntity(ent)
            --    net.WriteFloat(0)
             --   net.SendPVS(ent:GetPos())
            continue
        end
        --print("[FreezeModule] Tracking entity:", ent, "→ FreezeLevel:", data.FreezeLevel)
        -- Optional: reset weapon fire delay if you're throttling attacks
        FreezeModule.ApplyThrottle(ent, data)
        net.Start("HLRC_FreezeSync") -- send to client data for ice-effects
        net.WriteEntity(ent)
        net.WriteFloat(data.FreezeLevel or 0)
        net.SendPVS(ent:GetPos())
    end
end
function FreezeModule.ApplyThrottle(ent, data)
    if not data or not data.FreezeLevel or data.FreezeLevel <= 0 then return end
    -- Defensive defaults
    data.LastFreezeLevel = data.LastFreezeLevel or 0
    data.FreezeLevel = data.FreezeLevel or 0
    data.NextWeaponFire = data.NextWeaponFire or 0
    local seq = ent:GetSequence()
    local seqSpeed = data and data.SequenceSpeeds and data.SequenceSpeeds[seq]
    if not seqSpeed or seqSpeed <= 0 then
        seqSpeed = ent:GetSequenceGroundSpeed(seq)
        if seqSpeed > 0 then
            data.SequenceSpeeds = data.SequenceSpeeds or {}
            data.SequenceSpeeds[seq] = seqSpeed
        else
            if ent.BaseSpeed then
                seqSpeed = ent.BaseSpeed -- fallback to cached base speed
            end
        end
    end
    local function CanWeaponFire(wep)
        if not IsValid(wep) then return false end
        -- Accept Lua SWEPs with known fire functions
        if isfunction(wep.PrimaryAttack) or isfunction(wep.FireBullet) or isfunction(wep.ShootBullet) then
            return true
        end
    -- Accept base weapons by class name
        local class = wep:GetClass()
        return class:match("^weapon_") -- crude but effective
    end
   -- local function CanWeaponFire(wep)
    --    return IsValid(wep) and (isfunction(wep.PrimaryAttack) or isfunction(wep.FireBullet) or isfunction(wep.ShootBullet))
    --end

    local previousFreeze = data.LastFreezeLevel
    local freeze = data.FreezeLevel
    local Isnpc = ent:IsNPC()
    local Isnextbot = ent:IsNextBot()
    local isVJBase = ent.IsVJBaseSNPC
    local /*schedule,*/ scheduleName, hasValidSchedule -- read vj base schedules to avoid AI corruption when playbackrate is toyed with
    local health = ent:Health() 

    local fireDelay = Lerp(freeze / 100, 0.1, 1.5)      -- fire rate slows from 0.1s to 1.5s
    if not ent.BaseSpeed then
        ent.BaseSpeed = ent:GetSaveTable().m_flGroundSpeed or 200
    end 

    local thawing = previousFreeze >= 100 and freeze < 100
    if isVJBase then
        --schedule = ent.CurrentSchedule  -- reactivate if you see AI breaks in vj base Snpcs
        scheduleName = ent.CurrentScheduleName 
        hasValidSchedule = /*schedule and*/ scheduleName and scheduleName != "SCHED_NONE" and scheduleName != "" and scheduleName != "nil"
        if data.PendingThaw and hasValidSchedule then
            ent:SetPlaybackRate(1)
            data.PendingThaw = nil
            --print("[Thaw] Playback rate restored after schedule recovery:", ent:GetClass())
        end
    end
    if thawing then -- Thaw transition detection
        --MsgN("[Thaw] Entity:", ent, " transitioned from frozen to thawed.")
        if ent:IsNextBot() and ent.loco then
            ent.loco:SetDesiredSpeed(ent.BaseSpeed or 200)
            ent.Frozen = false
            ent.CanAttack = true
        end
        if Isnpc then
            --ent:ClearSchedule()
            if isVJBase then
                data.PendingThaw = true
                --ent:PlayAnim(ACT_IDLE, true, 0, false)
                --ent:SetState(VJ_STATE_NONE) -- breaks vj base npcs, was used to resume movement
                --if ent:GetEnemy() and not ent:IsMoving() then ent:SetIdealActivity(ACT_RUN) end -- help VJ Base SNPCs re-enter movement logic? tested it and is better off unused
                --timer.Simple(0.1, function()
                --    if IsValid(ent) and ent:GetState() == VJ_STATE_NONE then
                       -- ent:SelectSchedule()
                --    end
               -- end)
                --ent:VJ_TASK_CHASE_ENEMY() -- nothing
                --ent:SetCondition(0) -- the condition seems to not be the issue
                --ent.DisableChasingEnemy = false
                --ent.VJ_IsBeingControlled = false
            else
                ent:SetPlaybackRate(1)
                ent:SetNPCState(NPC_STATE_COMBAT) -- change this doesn't help
            end
            ent:SetSaveValue("m_flGroundSpeed", ent.BaseSpeed or 200) -- breaks vj base npcs IF 0 SPEED! due to schedule change, Once disabled, the AI assumes it's in a passive mode
        end
    end
    -- Fire rate throttle     -- Throttle parameters
    --if CurTime() < data.NextWeaponFire then
        if not data.originalRate then
            data.originalRate = ent:GetPlaybackRate()
        end
        local baseRate, scaledRate, shouldUpdate, rate
        baseRate = data.originalRate or 1.0

        if ent:IsPlayer() then
            local wep = ent:GetActiveWeapon()
            local now = CurTime()
            rate = HLRC_GetThrottleRate(health, freeze, 2.0) -- tweak curve for player feel
            if freeze >= 100 then
                rate = 0
                data.lastAppliedRate = rate
                wep:SetNextPrimaryFire(CurTime() + 4)
                wep:SetNextSecondaryFire(CurTime() + 4)
                return
            end
            scaledRate = math.max(0.05, baseRate * rate)
            data.lastAppliedRate = scaledRate
            if CanWeaponFire(wep) then
                --print(wep)
                shouldUpdate = math.abs(baseRate - scaledRate) > 0.05
                if shouldUpdate then  -- Only throttle if weapon is ready
                    local freezeFactor
                    if freeze < 50 then
                        freezeFactor = (freeze / 50) * 0.25
                    else
                        freezeFactor = 0.25 + ((freeze - 50) / 50) ^ 2 * 0.75
                    end
        
                    local baseDelay = wep.Primary and wep.Primary.Delay or 0.1
                    local extraDelay = baseDelay * freezeFactor * 2

                    local current = wep:GetNextPrimaryFire()
                    local target = current + extraDelay

                    -- Only apply if weapon is about to fire
                    if not data.NextWeaponFire or current >= data.NextWeaponFire then
                        wep:SetNextPrimaryFire(target)
                        wep:SetNextSecondaryFire(target)
                        --print(string.format("Applied freeze delay %.2f at freeze %d", extraDelay, freeze))
                        data.NextWeaponFire = target
                    end
                    ent:SetPlaybackRate(scaledRate)
                --print(string.format("[Throttle] Player %s: rate %.2f → fire delay %.2f (freeze: %.1f)", ent:Nick(), rate, fireDelay, data.FreezeLevel))   
                end
            end
        end

        if Isnpc then
            --print("[Schedule Debug]", ent:GetClass(), "Schedule:", scheduleName or "nil", "Raw:", tostring(schedule), "Valid:", hasValidSchedule)
            --local playbackRate = freeze >= 100 and 0 or math.max(0.2, 1 - (freeze / 100) ^ 2.0) -- reduce the 0.2 value for less anim speed
            local playbackRate = freeze >= 100 and 0 or math.max(0.1, baseRate * (1 - (freeze / 100) ^ 2.0)) -- reduce the 0.2 value for less anim speed
            local animSpeed = math.max(2, seqSpeed * playbackRate)
            rate = HLRC_GetThrottleRate(health, freeze, 3.0) 
            --print("[Throttle] FreezeLevel:", freeze, "PlaybackRate:", playbackRate, "Entity:", ent)
            if freeze < 100 and not thawing then
                --currentRate = ent:GetPlaybackRate()
                local moveDir = ent:GetForward()
                data.lastAppliedRate = data.lastAppliedRate or -1
                scaledRate = math.max(0.05, baseRate * rate)
                shouldUpdate = (baseRate > 1.1 or baseRate < 0.9) or (math.abs(baseRate - scaledRate) > 0.1)
                --local shouldUpdate = currentRate > playbackRate + 0.1 or math.abs(currentRate - 1.0) < 0.1 or math.abs(currentRate - scaledRate) > 0.1
                local rateDelta = math.abs(playbackRate - data.lastAppliedRate)
                local moveVec = moveDir * (seqSpeed * playbackRate)
                if isVJBase then
                    if hasValidSchedule then
                        if freeze >= 10 and shouldUpdate and rateDelta > 0.05 then -- Only apply playback if it changed meaningfully
                            ent:SetPlaybackRate(playbackRate)
                            --ent:SetSaveValue("m_flGroundSpeed", animSpeed)
                            --print(string.format("[Throttle] %s: base %.2f × rate %.2f → %.2f (freeze: %.1f)", ent:GetClass(), baseRate, rate, playbackRate, freeze))                       
                            data.lastAppliedRate = playbackRate
                        end
                        ent:SetMoveVelocity(moveVec)
                    end
                else
                    local moveX = ent:GetPoseParameter("move_x")
                    if shouldUpdate and rateDelta > 0.05 then -- Only apply playback rate if it changed meaningfully
                        ent:SetPlaybackRate(playbackRate)
                        data.lastAppliedRate = playbackRate
                        --print(string.format("[Throttle] %s: base %.2f × rate %.2f → %.2f (freeze: %.1f)", ent:GetClass(), baseRate, rate, playbackRate, freeze))                       
                    end
                    --ent:SetSaveValue("m_flGroundSpeed", seqSpeed * playbackRate) -- never 0 speed
                    ent:SetMoveVelocity(moveVec)   
                    if moveX then
                        ent:SetPoseParameter("move_x", moveX * rate) -- test vj combine beta poseparams that broke with this, vj hlr1 zombie breaks
                    end
                end
            end
            if freeze >= 90 and freeze < 100 then
                if not ent:IsCurrentSchedule(SCHED_IDLE_WALK) and not isVJBase then
                    --ent:SetSchedule(SCHED_IDLE_WALK) -- breaks vj base npcs due to schedule change
                    --ent:SetNPCState(NPC_STATE_ALERT) -- won't let vanilla npcs attack
                end
            end
            if freeze == 100 then
                --ent:SetMoveVelocity( Vector(0, 0, 0)) --seems to not be doing anything
                --ent:ResetSequence("idle")
                --ent:SetCycle(0) -- this forces it to restart anim which is an unpleasant view
                --ent:SetCondition(35) seems to not be doing anything on vanilla or vj base ones
                --ent:ClearSchedule() -- tested on vanilla zombie, combines, antlions, vj humans and creatures, nothing happens
                if isVJBase then
                    ent:SetMoveVelocity(Vector(1, 0, 0))   
                    --if ent:GetState() == VJ_STATE_NONE then
                        --ent:MaintainIdleBehavior(2) -- broke npc_vj_soldier_zombie
                        --ent.VJ_IsBeingControlled = true -- breaks, calls KeyDown(IN_ATTACK)
                        --ent:SetState(VJ_STATE_ONLY_ANIMATION_CONSTANT, -1) -- breaks vj base npcs, was used to make them stop
                        --ent.DisableChasingEnemy = true -- breaks vj base npcs due to schedule change, Once disabled, the AI assumes it's in a passive mode — even if VJ_STATE_FREEZE is cleared and NPC_STATE_COMBAT is restored
                    --end             
                else
                    ent:SetVelocity(Vector(0, 0, 0))
                    ent:SetNPCState(NPC_STATE_SCRIPT)-- tested on vanilla zombie, combines, antlions, vj humans and creatures, nothing happens
                    ent:SetPlaybackRate(0)
                    ent:SetSaveValue("m_flGroundSpeed", 0) -- 0 can break vj base npcs         
                end
                --ent:SetPoseParameter("move_x", 0)
                --ent:SetPoseParameter("move_y", 0)
            end
        end

        if ent:IsNextBot() and ent.loco then -- this block needs the function to be per tick, will have to port it to if I want the whole func to run casually
            if not ent.BaseSpeed then
                ent.BaseSpeed = ent.loco:GetDesiredSpeed() or 200
            end
            rate = HLRC_GetThrottleRate(health, data.FreezeLevel, 1.6)
            scaledRate = math.max(0.05, baseRate * rate)
            --if data.FreezeLevel < 99 then
                    -- DRG base nextbots hard-coded playbackrate to fluctuate every tick so needs to be applied per tick 
                    ent:SetPlaybackRate(scaledRate) -- DRG base nextbots melee anims will play at 1.0 if otherwise
                    ent.loco:SetDesiredSpeed(math.max(5, ent.BaseSpeed * rate))
                    --print(string.format("[Throttle] %s: %.2f → %.2f (raw rate: %.2f)", tostring(ent:GetClass()), baseRate, scaledRate, rate))
            --end

            if data.FreezeLevel >= 100 and not ent.Frozen then
               -- ent.loco:SetDesiredSpeed(0)
                --ent:SetVelocity(Vector(0, 0, 0))
                ent.Frozen = true
              --  ent:ResetSequence("idle")
              --  ent:SetCycle(0)
            --    ent:SetPlaybackRate(0)
            --    ent.CanAttack = false
            end
        end
    data.LastFreezeLevel = freeze -- Update freeze tracker
end
    function HLRC_GetThrottleRate(hp, freezeLevel, decayExponent)
        local resistance = HLRC_GetResistance(hp)
        if resistance >= 1 then return 1 end

        local freezeRatio = freezeLevel / 100
        local effectiveFreeze = freezeRatio * (1 - resistance)
        return math.pow(1 - effectiveFreeze, decayExponent)
    end
end

if CLIENT then
    function FreezeModule.DrawFrostOverlay(ent, alpha) -- tint client side, called on the hooks
        --print("[Overlay] Drawing on:", ent, "Alpha:", alpha)
        --local isViewmodel = ent:GetClass() == "class C_BaseViewModel"
        if not IsValid(ent) then return end
        if ent:GetPos():Distance(EyePos()) > 2000 then return end
        local isViewmodel = ent:IsWeapon() == false and ent:GetClass():lower():find("viewmodel")
        local mat = Material("models/gibs/ice/ice_unlit_layer")    
        --local mat = isViewmodel and Material("models/debug/debugwhite") or Material("models/gibs/ice/ice_unlit_layer")    
        if isViewmodel then
            --if not ent:GetOwner() or ent:GetOwner() ~= LocalPlayer() then return end
            render.MaterialOverride(mat)
            render.SetColorModulation(0.7, 0.9, 1) -- slightly softer tint
            render.SetBlend(alpha)
            --ent:DrawModel()

           -- render.SetBlend(1)
           -- render.SetColorModulation(1, 1, 1)
           -- render.MaterialOverride(nil)
        else
            render.MaterialOverride(mat)
            render.SetColorModulation(0.8, 0.9, 1)
            render.SetBlend(alpha)
            ent:DrawModel()

            render.MaterialOverride(mat)
            render.SetColorModulation(0.6, 0.9, 1)
            render.SetBlend(alpha)
            ent:DrawModel()

            render.SetBlend(1)
            render.SetColorModulation(1, 1, 1)
            render.MaterialOverride(nil)
        end
    end
    function FreezeModule.HLRC_SpawnIceGibs(ent)
        local boneCount = ent:GetBoneCount()
        local maxGibs = 8
        local spawned = 0
        local attempts = 0

        for i = 1, boneCount - 1 do
            if spawned >= maxGibs then break end
            if attempts >= boneCount then break end

            local boneName = ent:GetBoneName(i)
            local pos = ent:GetBonePosition(i)
            attempts = attempts + 1

            if boneName and boneName ~= "__INVALIDBONE__" and pos and pos:DistToSqr(ent:GetPos()) > 4 then
                --local gib = ClientsideModel("models/gibs/ice_shard0" .. math.random(1,6) .. ".mdl")
                local gib = ents.CreateClientProp("models/gibs/ice_shard0" .. math.random(1,6) .. ".mdl")
                if IsValid(gib) then
                    gib:SetPos(pos + VectorRand() * 2)
                    --gib:SetPos(pos + VectorRand() * 4 + Vector(0, 0, 8))
                    gib:SetAngles(AngleRand())
                    gib:SetHealth(0) -- disables damage sounds
                    --gib:SetSolid(SOLID_VPHYSICS)
                    gib:SetModelScale(2.4, 0.1)
                    gib:SetMaterial("models/gibs/ice/ice_unlit_layer")
                    gib:SetKeyValue("debris", "1")
                    --gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                    gib:DrawShadow(false)
                    --gib:SetNoDraw(false)
                    --gib:Spawn()
                    --gib:Activate()

                    local phys = gib:GetPhysicsObject()
                    if IsValid(phys) then
                        phys:SetMass(0.1)
                        phys:ApplyForceCenter(VectorRand() * math.Rand(20, 50))
                    end
                    --gib:SetNoDraw(false)
                    timer.Simple(math.Rand(2, 5), function()
                        if IsValid(gib) then gib:Remove() end
                    end)
                    spawned = spawned + 1
                end
            end
        end
    end
end

/*
function FreezeModule.BreakIceGibs(ent)
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
            local gib = ents.Create("prop_physics_multiplayer") -- for now obj_vj_gib to let them fade and remove 
            gib:SetModel("models/gibs/ice_shard0" .. math.random(1,6) .. ".mdl")
            gib:SetPos(bonepos)
            gib:SetAngles(boneang)
            gib:SetHealth(0) -- disables damage sounds
            gib:SetSolid(SOLID_VPHYSICS)
            gib:SetMaterial("models/gibs/ice/ice_unlit_layer")
            gib:SetKeyValue("debris", "1")
            gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            gib:DrawShadow(false)
            gib:SetModelScale(1.5, 0.1)
            gib:Spawn()
            gib:Activate()
            tblIceShards[i] = gib
            local phys = gib:GetPhysicsObject()
                if IsValid(phys) then
                phys:SetMass( 0.1 )
                phys:ApplyForceCenter(VectorRand() * math.Rand(20, 50))
                --phys:Sleep()
            end
            local lifetime = math.Rand(2, 5)
            timer.Simple(lifetime, function()
            if IsValid(gib) then gib:Remove() end
            end)
        end
        i = i + 1
        bonepos, boneang = ent:GetBonePosition(i)
    end

    if ent:IsPlayer() then
        local pos = ent:GetPos()
        ent:Spawn()
        ent:SetPos(pos)
        ent:KillSilent()
    else
        ent:Remove()
    end
end */