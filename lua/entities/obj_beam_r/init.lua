
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	//print("INITIALIZE")
	self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	local StartPos = self:GetPos()

	if self:GetWidth() == 0 then self:SetWidth(20) end
	if string.len(self:GetNWString("color")) == 0 then self:SetBeamColor(255,255,255,255) end
end

function ENT:SetWidth(flWidth)
	self:SetNWFloat("width", flWidth)
end

function ENT:GetWidth()
	return self:GetNWFloat("width")
end

function ENT:SetStart(tStart, iAtt, entowner) -- kingpin calls
	if type(tStart) == "Vector" then
		--print("type(tStart) == Vector")
		self:SetNWEntity("entStart", entowner)
		self:SetNWVector("vecStart", tStart)
		if iAtt then self:SetNWInt("attachmentStart", iAtt) end
	else
		self:SetNWEntity("entStart", entowner)
		--print("entStart: ", tStart) -- 1, 2
		if iAtt then self:SetNWInt("attachmentStart", iAtt) end
		self:SetNWVector("vecStart", Vector(0,0,0))
	end
end

function ENT:GetStart()
	print("Get Start !!!")
	local ent = self:GetNWEntity("start") -- "start" no sale en ningun otro lado
	if ent != NULL then return ent, self:GetNWInt("attachmentStart") end
	return self:GetNWVector("start") -- borrar
end

function ENT:SetEnd(tEnd, iAtt) -- kingpin calls
	//print("SET END!")
	if type(tEnd) == "Vector" then
		self:SetNWEntity("entEnd", NULL)
		self:SetNWVector("vecEnd", tEnd)
	else
		self:SetNWEntity("entEnd", tEnd)
		if iAtt then self:SetNWInt("attachmentEnd", iAtt) end -- to do if you wanna connect the beam at certain pos
		//print(iAtt)
		self:SetNWVector("vecEnd", Vector(0,0,0))
	end
end

function ENT:GetEnd()
	local ent = self:GetNWEntity("end")
	if ent != NULL then return ent, self:GetNWInt("attachmentEnd") end
	return self:GetNWVector("end")
end

function ENT:SetTexture(sText)
	self:SetNWString("texture", sText)
end

function ENT:GetTexture()
	return self:GetNWString("texture")
end

function ENT:SetAmplitude(flAmp)
	self:SetNWFloat("amplitude", math.Clamp(flAmp,0,25))
end

function ENT:GetAmplitude()
	return self:GetNWFloat("amplitude")
end

function ENT:SetUpdateRate(flRate)
	self:SetNWFloat("update", flRate)
end

function ENT:GetUpdateRate()
	return self:GetNWFloat("update")
end

function ENT:SetRandom(bRandom)
	self:SetNWBool("random", bRandom)
end

function ENT:GetRandom()
	return self:GetNWBool("random")
end

function ENT:SetDistance(iDist)
	self:SetNWInt("distance", iDist)
end

function ENT:GetDistance()
	return self:GetNWInt("distance")
end

function ENT:SetDelay(flDelay)
	self:SetNWFloat("delay", flDelay)
end

function ENT:GetDelay()
	return self:GetNWFloat("delay")
end

function ENT:SetBeamColor(r,g,b,a)
	local color = r .. "," .. g .. "," .. b
	if a then color = color .. "," .. a end
	self:SetNWString("color", color)
end

function ENT:GetBeamColor()
	local _color = self:GetNWString("color")
	_color = string.Explode(",", _color)
	local color = Color(_color[1],_color[2],_color[3],_color[4])
	return color
end

function ENT:SetLifeTime(flTime) -- not included, breaks kingpin own beam duration code
	self.flLifeTime = CurTime() +flTime
end

function ENT:GetLifeTime()
	return self.flLifeTime || -1
end

function ENT:OnRemove()
end

function ENT:Think()
	//print("server Think")
	local flLife = self:GetLifeTime()
	if flLife == -1 || CurTime() < flLife then return end
	self:Remove()
end

function ENT:TurnOn()
	//print("TURNON!!")
	self:SetNWBool("active", true) -- returns true on ENT.Draw
end

function ENT:TurnOff()
		//print("TURNOff!!")
	self:SetNWBool("active", false)
end
