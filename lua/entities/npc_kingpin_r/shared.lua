ENT.Base = "npc_vj_custom_hlr_base"
ENT.Type = "ai"
ENT.PrintName 		= "Kingpin R"
ENT.Author 			= "Mielatenas"
ENT.Purpose 		= ""
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life NPCs"

if (CLIENT) then
	language.Add("npc_kingpin_r", "Kingpin")
	usermessage.Hook("Kingpin_SetShieldScale", function(um)
		local ent = um:ReadEntity()
		local scale = um:ReadShort()
		if !IsValid(ent) || !scale then return end
		scale = scale /100
		ent.scale = Vector(scale, scale, scale)
		ent.BuildBonePositions = ent.BuildBonePositions || function(self, NumBones, NumPhysBones)
			local scale = self.scale
			if scale then
				local iBone = self:LookupBone("Bip01")
				local boneMat = self:GetBoneMatrix(iBone)
				boneMat:Scale(scale)
				self:SetBoneMatrix(iBone, boneMat)
			end
		end
	end)
end
