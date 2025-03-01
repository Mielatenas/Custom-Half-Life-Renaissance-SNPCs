/*
hook.Add("ScaleNPCDamage", "HLR_ScaleNPCDamage_HitGroupCheck", function(npc,hitgroup,dmg)
	if npc.bScripted then npc.lastHitGroupDamage = hitgroup end
end)

hook.Add("PhysgunPickup", "HLR_Physgunpickup", function(ply, ent)
	if ValidEntity(ent) && ent.OnPickedUp then
		ent:OnPickedUp(ply, 2)
	end
end)

hook.Add("GravGunOnPickedUp", "HLR_Gravgunpickup", function(ply, ent)
	if ValidEntity(ent) && ent.OnPickedUp then
		ent:OnPickedUp(ply, 1)
	end
end)

hook.Add("PhysgunDrop", "HLR_Physgundrop", function(ply, ent)
	if ValidEntity(ent) && ent.OnDropped then
		ent:OnDropped(ply, 2)
	end
end)

hook.Add("GravGunOnDropped", "HLR_Gravgundrop", function(ply, ent)
	if ValidEntity(ent) && ent.OnDropped then
		ent:OnDropped(ply, 1)
	end
end)
*/
hook.Add("EntityTakeDamage", "HLR_BurnDamageUnFreeze", function(ent, entInflictor, entAttacker, iAmount, dmginfo)
	if IsValid(ent) && (ent:IsPlayer() || ent:IsNPC()) /*|| ent:IsNextBot())*/ then -- set only if is DMG_BURN validation, happens too frequent
		local iPercentFrozen = ent:FrozenPercentage()
		if iPercentFrozen > 0 then
			if dmginfo:IsDamageType(DMG_DIRECT) || dmginfo:IsDamageType(DMG_BURN) then
				ent:UnFreeze(math.Round(dmginfo:GetDamage() *0.5))
			end
		end
	end
end)
-- Apply the health multiplier to newly spawned entities
hook.Add("OnEntityCreated", "CustomHLRMultiplierIdentifiers", function(ent)
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
    	--ent.IsCustomHLRSNPC = true -- make a global identifier that can be read only on CustomHLR
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
