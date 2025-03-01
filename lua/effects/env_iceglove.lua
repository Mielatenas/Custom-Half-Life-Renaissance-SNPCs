function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	self.Normal = data:GetNormal()
	
	local ang = self.Normal:Angle():Right():Angle()
	local emitter = ParticleEmitter(self.Position)

	for i=1,16 do
		local vec = (self.Normal + 1.2*VectorRand()):GetNormalized()
		local particle = emitter:Add("sprites/env_iceglove", self.Position + math.Rand(3,15)*vec)
		particle:SetVelocity(math.Rand(50,150)*vec)
		particle:SetDieTime(4.24)
		particle:SetStartAlpha(252)
		particle:SetStartSize(1)
		particle:SetEndSize(0)
		particle:SetStartLength(1)
		particle:SetEndLength(5)
		particle:SetColor(155,250,255)
		particle:SetGravity(Vector(0,0,-50))
		particle:SetAirResistance(100)
		particle:SetCollide(true)
		particle:SetBounce(1)
	end
	
	for i = 1,4 do
	for x = 1,2 do
	local particle = emitter:Add( "effects/blueflare1" , self.Position )
		particle:SetAirResistance(100)
		particle:SetGravity( Vector(0, 0, 0 ) )
		particle:SetDieTime( 0.14 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 2 )
		particle:SetEndSize( 21 )
		particle:SetRoll( math.Rand( 360, -360 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor(82,180,255,255)
end
end


	emitter:Finish()
	
	local dlight = DynamicLight(150)
	dlight.Pos = self.Position
	dlight.Size = 125
	dlight.DieTime = CurTime() + 0.71
	dlight.r = 82
	dlight.g = 210
	dlight.b = 210
	dlight.Brightness = 1
	dlight.Decay = 1
end


function EFFECT:Think()
end


function EFFECT:Render()
end
