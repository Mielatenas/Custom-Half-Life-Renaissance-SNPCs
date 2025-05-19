function EFFECT:Init(data)
	local pos = data:GetStart()
	local posStart = self:GetTracerShootPos(pos,data:GetEntity(),data:GetAttachment())
	local ang = data:GetNormal()
	
	local emitter = ParticleEmitter(posStart)
			local particle = emitter:Add("sprites/crystal_beam2",posStart)
			
			particle:SetVelocity(ang)
			particle:SetDieTime(1.2)
			particle:SetStartAlpha(math.random(50,252))
			particle:SetStartSize(0)
			particle:SetEndSize(40)
			particle:SetRoll(math.random(0,360))
			particle:SetRollDelta(math.random(-1.00,1.00))
			particle:SetColor(225,190,222)
			particle:SetCollide(true)
			particle:SetCollideCallback(function(part,pos,ang) if (math.random(0,4) == 4) then util.Decal("FireExt",pos + ang,pos - ang) end part:SetDieTime(0) end)
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end