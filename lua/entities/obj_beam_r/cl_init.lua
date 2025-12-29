include('shared.lua')
language.Add("obj_beam_r", "Kingpin Beam")

ENT.nextUpdate = 0
ENT.nextRandom = 0
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:Initialize()
//self:Draw()
local playerfov = LocalPlayer():GetFOV()
self.playerfov = playerfov
--self.renderaddvec = Vector(225,225,225)
self.minBounds = Vector(0,0,0)
self.maxBounds = Vector(0,0,0)
end

function ENT:GetStartPos(owner)
	//print("GetStartPos")
	local posStart
	local entStart = self:GetNWEntity("entStart") -- kingpin entity
	//print(entStart)
	if entStart != NULL then
		local iAtt = self:GetNWInt("attachmentStart")
		if iAtt > 0 then posStart = entStart:GetAttachment(iAtt).Pos
		else posStart = entStart:GetPos() end
	else 
	posStart = self:GetNWVector("vecStart")
	--print("posStart: ", posStart)
	end
	return posStart
end

function ENT:GetEndPos()
	--print("ENT:GetEndPos()")
	local posDest
	if self:GetNWBool("random") then -- to create a random pos when obj_target isn't visible, doesn't work
		if CurTime() >= self.nextRandom then
			self.posRandom = self:GetRandomPos()
			self.nextRandom = CurTime() +self:GetNWFloat("delay")
			//print(self.nextRandom)
		end
		if !self.posRandom then return end
		posDest = self.posRandom
	else
		local entEnd = self:GetNWEntity("entEnd")
		--print("entEnd: ", entEnd)
		if entEnd:IsValid() then
			local iAtt = self:GetNWInt("attachmentEnd")
					//print(iAtt)
			if iAtt > 0 then posDest = entEnd:GetAttachment(iAtt).Pos -- this is just if obj target has any attachment apparently, but it is not provided yet, have to do.
			else posDest = entEnd:GetPos() end -- THIS IS THE ACTUAL END RESULT
		else posDest = self:GetNWVector("vecEnd") end
	end
	//print(posDest)
	return posDest -- THE obj_pointed_tg_R entity
end
function ENT:Think()
    local posStart = self:GetStartPos()
    local posEnd   = self:GetEndPos()
    if not posStart or not posEnd then return end

    local padding = 32

    self.minBounds.x = math.min(posStart.x, posEnd.x) - padding
    self.minBounds.y = math.min(posStart.y, posEnd.y) - padding
    self.minBounds.z = math.min(posStart.z, posEnd.z) - padding

    self.maxBounds.x = math.max(posStart.x, posEnd.x) + padding
    self.maxBounds.y = math.max(posStart.y, posEnd.y) + padding
    self.maxBounds.z = math.max(posStart.z, posEnd.z) + padding

    self:SetRenderBoundsWS(self.minBounds, self.maxBounds) -- in common with how the beam renders, wrong render bounds cause the beam texture to dissapear, if big, can mess up map meshes and get darker a lot of it! - fixed 2025
end

/*
function ENT:Think()
--print("THINK")

	local owner = self:GetOwner()
	local posDest = self:GetPos() -- different of posDest on function ENT:GetEndPos()
		//print(posDest)

	if !posDest then return end
	self:SetRenderBoundsWS(posDest, self:GetEndPos(), self.renderaddvec*100) 
end */

function ENT:Draw()
//print("DRAW")
	local owner = self:GetOwner()
		//print(self:GetNWBool("active")) --returns false on client

	if !self:GetNWBool("active") then return end
	local mat = self:GetNWString("texture")
	//print(mat)
	if mat != self.sMaterial then
		self.sMaterial = mat
		self.texture = Material(mat)
	end
	local color = self:GetNWString("color")

	color = string.Explode(",", color)
	color = Color(color[1],color[2],color[3],color[4])
	local width = self:GetNWFloat("width")
	local updateRate = self:GetNWFloat("update")
	local posStart = self:GetStartPos(owner)
		//print(posStart)
	local posDest = self:GetEndPos()
	//print(posDest)
	if !posDest then return end
	local normal = (posDest -posStart):GetNormalized()
	local ang = normal:Angle()
	local pos = posStart
	local amplitude = self:GetNWFloat("amplitude")
	if amplitude != 0 && CurTime() >= self.nextUpdate then self:RefreshBeam(ang, pos, posDest); self.nextUpdate = CurTime() +updateRate end

	local eyeang = EyeAngles():Add( RenderAngles()) -- EyePos() and EyeAngles() are the current cam.3d ang and pos not the player's.
	--cam.Start3D(EyePos(), eyeang) -- the rest 7 arguments just messes view, from here below not the cause of the beam not drawing (fixed 2024)
		render.SetMaterial(self.texture)
		if amplitude == 0 then
			render.DrawBeam(posStart, posDest, width, 1, 1, color)
		else
			render.StartBeam(table.Count(self.positions))
			for k, v in pairs(self.positions) do
				render.AddBeam(v,width,CurTime(),color)
			end
			render.EndBeam()
		end
	--cam.End3D()
			--print("End part of Draw")
end

function ENT:GetRandomPos()  -- have to test if this creates a random pos
	local iDist = self:GetNWInt("distance")
	local pos = self:GetPos()
	local posDest
	for i = 0, 10 do
		posDest = pos +VectorRand() *iDist
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = posDest
		tracedata.mask = MASK_SOLID_BRUSHONLY
		local tr = util.TraceLine(tracedata)
		if tr.Hit then return tr.HitPos end
		//print("GetRandomPos")
	end
	return
end

function ENT:RefreshBeam(ang,pos,posDest)
	local amplitude = self:GetNWFloat("amplitude")
	local fDist = pos:Distance(posDest)
	local iSegments = math.Clamp(math.Round(fDist *0.05), 0, 100)
	local fDistEach = math.Round(fDist /iSegments)
	self.positions = {}
	table.insert(self.positions, pos)
	local _pos = pos
	for i = 1, iSegments -1 do
		if i < iSegments -1 then
			pos = _pos +ang:Forward() *fDistEach *i +ang:Up() *math.Rand(-amplitude, amplitude) +ang:Right() *math.Rand(-amplitude, amplitude)
		else pos = posDest end
		table.insert(self.positions, pos)
	end
end