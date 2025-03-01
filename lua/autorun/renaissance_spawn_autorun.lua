if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')
if(SERVER) then
	AddCSLuaFile("autorun/sh_meta_custom_renaissance.lua")
	include("autorun/sv_meta_custom_renaissance.lua")
	--include("hlrenaissance_custom_funcs.lua")
end
include("autorun/sh_meta_custom_renaissance.lua")


local spawnCategory = "HL Renaissance Custom"

VJ.AddNPC("Bullsquid","npc_bullsquid_base_r",spawnCategory)
VJ.AddNPC("Devilsquid","npc_devilsquid_r",spawnCategory)
VJ.AddNPC("Frostsquid","npc_frostsquid_r",spawnCategory)
VJ.AddNPC("Poisonsquid","npc_poisonsquid_r",spawnCategory)
VJ.AddNPC("Toxicsquid","npc_toxicsquid_r",spawnCategory)
VJ.AddNPC("Hybridsquid","npc_hybridsquid_r",spawnCategory)

VJ.AddNPC("Kingpin R","npc_kingpin_r",spawnCategory)
--VJ.AddNPC("Tor R","npc_tor_r",spawnCategory)

game.AddDecal("HLR_Splat_Napalm",{"decals/slime_splat_napalm","decals/slime_splat_napalm_02","decals/slime_splat_napalm_03","decals/slime_splat_napalm_04"})
game.AddDecal("HLR_Splat_Ice",{"decals/slime_splat_ice","decals/slime_splat_ice_02","decals/slime_splat_ice_03","decals/slime_splat_ice_04"})
game.AddDecal("HLR_Splat_Toxic",{"decals/slime_splat_toxic","decals/slime_splat_toxic_02","decals/slime_splat_toxic_03","decals/slime_splat_toxic_04"})
game.AddDecal("HLR_Splat_Poison",{"decals/slime_splat_poison","decals/slime_splat_poison_02","decals/slime_splat_poison_03","decals/slime_splat_poison_04"})
game.AddDecal("HLR_Splat_Hybrid",{"decals/slime_splat_white","decals/slime_splat_white_02","decals/slime_splat_white_03","decals/slime_splat_white_04"})

game.AddParticles("particles/blood_impact_blue.pcf")
game.AddParticles("particles/flame_gargantua.pcf")
game.AddParticles("particles/icesphere.pcf")
game.AddParticles("particles/magic_spells.pcf") -- Kingpin R beam impact
//game.AddParticles("particles/magic_spells02.pcf")
//game.AddParticles("particles/alien_slave.pcf") --deleted
game.AddParticles("particles/magic_spells02_toxi.pcf") --toxic ring
--game.AddParticles("particles/magic01.pcf") -- here unused toxic sticky mines, ice and fire effects
--game.AddParticles("particles/magic04.pcf") -- life drain beam, type trace -- for a new attack? "magic_spell_lifedrain_beam03"
--game.AddParticles("particles/mortarsynth.pcf") -- deleted 
--game.AddParticles("particles/mrfriendly.pcf") -- deleted "mrfriendly_vomit"
--game.AddParticles("particles/rpg_firetrail.pcf") -- deleted trace type "rpg_firetrail" on fire snark?
--game.AddParticles("particles/shocktrooper.pcf") -- has the headglow that the energy orbs used to have in blue color but has the proper size, maybe I can edit an orange color and include it. "shockroach_projectile_headglow", "shockroach_projectile_rope"- to add on tor blue orbs? 
game.AddParticles("particles/kingpin.pcf")
game.AddParticles("particles/kingpin2.pcf")
game.AddParticles("particles/kingpin_sphere.pcf")
game.AddParticles("particles/tor.pcf")
game.AddParticles("particles/tor_2.pcf")
game.AddParticles("particles/tor_3.pcf")
game.AddParticles("particles/tor_4.pcf")
game.AddParticles("particles/tor_5.pcf")
--game.AddParticles("particles/stukabat_acid.pcf")
game.AddParticles("particles/spore1.pcf")
game.AddParticles("particles/poisonsquid_01.pcf")

for k, v in pairs({
	    --"alien_slave_glow",
	    --"alien_slave_glow_b"
		"blood_impact_blue_01",
		"flame_gargantua",
		"hunter_flechette_glow_striderbuster",
		"hunter_projectile_explosion_1",
		"icesphere_splash",
		--"icesphere_splash_02" -- to use on frostsquid blood
		"icesphere_trail",
		"kingpin_object_charge_large",
		"kingpin_psychic_shield_idle", -- to add
		--"kingpin_psychic_shield_idle_beam"
		"kingpin_object_charge",
		--"kingpin_object_charge_glow"
		"kingpin_sphere_rope",
		"kingpin_sphere_headglow",
        /*--In magic01.pcf--
        "burning_gib_01_follower2"
        "fire_small_01"
		"fire_small_02"
		"fire_small_base"
		"magic_force_fire"
		"magic_force_ice",
		"magic_force_poison"
		"magic_spell_fireball"
		"magic_spell_fireball_hand_fp"
		"magic_spell_fireball_impact" */

        /*--In mortarsynth.pcf--
		"mortarsynth_beam_charge", -- trace type
		"mortarsynth_beam",
		"mortarsynth_beam_charge_b",
		"mortarsynth_beam_charge_glow_cp0", -- red beams
		"mortarsynth_glow_beam_cp1", -- orange beams */
          
		--"mrfriendly_vomit",
		--"rocket_smoke_trail",
		--"rpg_firetrail",
		--In spore1.pcf--
	    --"spore_splash", -- too congested for a blood effect -Toxicsquid
	    "spore_splash_02",
	    "spore_splash_player",
		"spore_trail",
		 --In stukabat_acid.pcf--
		--"stukabat_acid_splash", -- too big and congested, reduce size
		--"stukabat_acid_splash_02", -- new PoisonSquid blood
		--"stukabat_acid_splash_05", -- taken out of blood due to size
		--"stukabat_acid_trail",
		--In poisonsquid_acid.pcf--
		"poisonsquid_splash1",
		"poisonsquid_splash_04",
		"poisonsquid_splash_smoke1",
		"poisonsquid_sphere_trail", -- trace
		"poisonsquid_spores1",
        --magic_spells02_toxi.pcf-- 
        "mine_sigil_toxic01",
        "toxicsquid_gas_toxic01", -- Toxic mines
		"tor_beam_charge", -- not sure if this is tor drain attack or an unused one
		"tor_discharge", -- tor staff melee attack
		"tor_projectile", -- main projectile
		"tor_projectile_b", 
		"tor_projectile_d",
		"tor_projectile_blue", -- main blue projectile
		"tor_projectile_blue_b",
		"tor_projectile_blue_c",
		"tor_projectile_blue_d",
		"tor_projectile_vanish",
		"tor_projectile_vanish_blue", --only on tor, beautiful blue projectile collision
		"tor_shockwave",
		"tor_shockwave_blue",
		"tor_transform_wave", --decided only on tor
		"tor_transform_wave_debris", 
		"vortigaunt_beam",  -- to add on trace 
		"vortigaunt_beam_charge",
		"vortigaunt_hand_glow",
		"vortigaunt_hand_glow_b" -- kingpin hands on energy orbs?
	}) do
	PrecacheParticleSystem(v)
end

local CVars = {
	["hlrcustom_multihealth"] = 1,
	["hlrcustom_multidmg"] = 1,
    ["hlrcustom_toxic_mines"] = 1,
    ["hlrcustom_toxic_mines_max"] = 70
}
for k,v in pairs(CVars) do
	if !ConVarExists(k) then
		CreateConVar(k,v,FCVAR_ARCHIVE)
	end
end
if CLIENT then
	language.Add( "hlrcustom_multihealth", "Health value multiplier")
	language.Add( "hlrcustom_multidmg", "Multiply damage inflicted by")	
	language.Add( "hlrcustom_multihealth.help", "Multiply HLR Custom Snpc's health, Default: 1")
	language.Add( "hlrcustom_multidmg.help", "Adjust damage inflicted by HLR Custom Snpc's,some values will only apply to new-created SNPCs, Default: 1")

	--language.Add( "hlrcustom_freeze_enemy", "Frost enemies? Default: 1")
	--language.Add( "hlrcustom_freeze_enemy.help", "Allow Frostsquid breath and Frozen Snark get enemies frozen")
	language.Add( "hlrcustom_toxic_mines", "Toxicsquid sticky mines")
	language.Add( "hlrcustom_toxic_mines.help", "Enable/Disable mines that do damage overtime and stick to entities")
	language.Add( "hlrcustom_toxic_mines_max", "Toxicsquid max sticky mines")
	language.Add( "hlrcustom_toxic_mines_max.help", "max Toxic mines in world and server, warning: high numbers impact performance and past thousands will crash the game! Default:70")
end
local function HLR_Custom_Menu(TitleHp)
	local TitleHp = TitleHp:AddControl("ControlPanel", {Label = "Half-Life Renaissance SNPC's", Closed = false})
	TitleHp:AddControl("Slider", {
		Label = "#hlrcustom_multihealth", 
		Type = "Float",
		Min = "0.01",
		Max = "30",
		Command = "hlrcustom_multihealth",
		Help = true
	})
		TitleHp:AddControl("Slider", {
		Label = "#hlrcustom_multidmg", 
		Type = "Float",
		Min = "0.01",
		Max = "30",
		Command = "hlrcustom_multidmg",
		Help = true
	})
	local AIoptions = TitleHp:AddControl("ControlPanel", {Label = "AI settings", Closed = false})
/*

	AIoptions:AddControl("CheckBox", {
		Label = "#hlrcustom_freeze_enemy", 
		Command = "hlrcustom_freeze_enemy", 
	})
*/
	AIoptions:AddControl("CheckBox", {
		Label = "#hlrcustom_toxic_mines", 
		Command = "hlrcustom_toxic_mines",
		Help = true
	})
	AIoptions:AddControl("Slider", {
		Label = "#hlrcustom_toxic_mines_max", 
		Type = "Integer",
		Min = "1",
		Max = "1000",
		Command = "hlrcustom_toxic_mines_max",
		Help = true
	})
        local multiplier = GetConVar("hlrcustom_multihealth"):GetFloat()
        RunConsoleCommand("hlrcustom_multihealth", multiplier) -- test if runs once per map load
end
hook.Add("PopulateToolMenu", "AddConfigMenu", function()
    spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "HL Renaissance Custom", "HL Renaissance Custom", "", "", HLR_Custom_Menu, {})
end)

local function CustomHLRSaveConfig(multiplier)
    file.Write("CustomHLR.txt", tostring(multiplier))
end
local function CustomHLRLoadConfig()
    if file.Exists("CustomHLR.txt", "DATA") then
        return tonumber(file.Read("CustomHLR.txt", "DATA"))
    else
        return 1 -- Default value if the file doesn't exist
    end
end