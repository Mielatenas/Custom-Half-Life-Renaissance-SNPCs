function EFFECT:Init(data)
	local pos = data:GetStart()
	local posStart = self:GetTracerShootPos(pos,data:GetEntity(),data:GetAttachment())
	local ang = data:GetNormal()
	
	local emitter = ParticleEmitter(posStart)
			local particle = emitter:Add("particle/particle_icespray",posStart)	
			particle:SetVelocityScale( true )
			particle:SetStartAlpha(100)
			particle:SetEndAlpha(1)
			particle:SetRoll(math.random(0,360))
			particle:SetVelocity(ang *200)
			particle:SetDieTime(math.random(1,1.8))
			particle:SetStartSize(1)
			particle:SetEndSize(math.random(100.0,160.0))
			particle:SetRollDelta(math.random(-2,2))
			particle:SetColor(170,212,55)
			particle:SetAirResistance(0.01)
			particle:SetCollide(true)
			particle:SetBounce( 0.5 )
			//particle:SetCollideCallback(function(part,pos,ang) if (math.random(0,4) == 4) then util.Decal("FireExt",pos + ang,pos - ang) end part:SetDieTime(0) end)
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end