AddCSLuaFile( "shared.lua" )
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2024-2025 by Mielatenas, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

function ENT:DrawTraceLine(tr)
    -- Draw a red line from start to hit position
    debugoverlay.Line(tr.StartPos, tr.HitPos, 5, Color(255, 0, 0), true)
    -- Draw a green box at the hit position
    debugoverlay.Box(tr.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(0, 255, 0), true)
end
function util.CustomHlrBlastDmg(inflictor, attacker, pos, radius, dmg, TFilter, dmgType, bReduce, vjnpcClasses)
	TFilter = TFilter && ((type(TFilter) == "function" || type(TFilter) == "table") && TFilter || {TFilter})
	--if TFilter is true damages properly enemies but damage allies aswell, 
	--if false won't dmg anything  
	local allynpcclass = false
	if type(vjnpcClasses) == "table" then
        allynpcclass = 2
    end
	dmgType = dmgType || DMG_GENERIC
	local tblEntsHit = {}
	for k, v in ipairs(ents.FindInSphere(pos, radius)) do
		if v==inflictor then return end
		if allynpcclass ==2 and istable(v.VJ_NPC_Class) then
		    for i = 1, #vjnpcClasses do
                local class = vjnpcClasses[i]
                if VJ_HasValue(v.VJ_NPC_Class,class) then
                	allynpcclass = true
                	--print("NPC Class:", class)
                	break
                end
            end
    	    /*for _, class in ipairs(vjnpcClasses) do
                for _, vclass in ipairs(v.VJ_NPC_Class) do
                    --print("NPC Class:", vclass)
                    if vclass == class or VJ_HasValue(v.VJ_NPC_Class,class) then
                	    allynpcclass = true
                	break end         
                end
                if allynpcclass==true then
                break end
            end */
        end
		if allynpcclass ==true then continue end
		    --print("Iteration:", v)
		if (!TFilter || (type(TFilter) == "table" && !table.HasValue(TFilter, v)) || type(TFilter) != "table" && TFilter(v)) && !util.TraceLine({start = pos, endpos = v:GetPos() +v:OBBCenter(), mask = MASK_NPCWORLDSTATIC}).Hit || v:IsNextBot() then -- && (!v:IsPlayer()) frozen Nextbots not compatible 
			local posDmg = v:NearestPoint(pos)
			tblEntsHit[v] = pos:Distance(posDmg)
			--print(tblEntsHit[v])
			local dmg = dmg
			if bReduce then dmg = math.Clamp(((radius -pos:Distance(posDmg)) +100) /radius *dmg, 1, dmg) end
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamage(dmg)
			if !attacker then
			dmgInfo:SetAttacker(attacker) 
            else dmgInfo:SetAttacker(inflictor)
		    end
			dmgInfo:SetInflictor(inflictor)
			dmgInfo:SetDamageType(dmgType)
			dmgInfo:SetDamagePosition(posDmg)
			v:TakeDamageInfo(dmgInfo)
			if (v:IsNPC() || v:IsPlayer()) && dmgType == DMG_ENERGYBEAM && v:Health() <= 0 then
			    v:Dissolve(attacker, inflictor, 0)
			end
		end
	end
	return tblEntsHit
end

function table.refresh(tbl)
	table.MakeSequential(tbl)
end

function table.MakeSequential(tbl)
	local i = 1
	for ind, _ in pairs(tbl) do
		if ind > i then tbl[i] = tbl[ind]; tbl[ind] = nil end
		i = i +1
	end
end