function EFFECT:Init(data)
	
	self.Position = data:GetOrigin()
	self.Normal = data:GetNormal()
	
	local ang = self.Normal:Angle():Right():Angle()
	local emitter = ParticleEmitter(self.Position)

	for i=1,8 do
		local vec = (self.Normal + 1.2*VectorRand()):GetNormalized()
		local particle = emitter:Add("sprites/hotglowr", self.Position + math.Rand(3,15)*vec)
		particle:SetVelocity(math.Rand(100,200)*vec)
		particle:SetDieTime(3.24)
		particle:SetStartAlpha(0)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetStartLength(10)
		particle:SetEndLength(0)
		particle:SetColor(225,170,55)
		particle:SetGravity(Vector(0,0,-350))
		particle:SetAirResistance(1)
		particle:SetCollide(true)
		particle:SetBounce(0.75)
	end
	
	for i = 1,4 do
	for x = 1,2 do
	local particle = emitter:Add( "effects/blueflare1" , self.Position )
		particle:SetAirResistance(700)
		particle:SetGravity( Vector(0, 0, 0 ) )
		particle:SetDieTime( 0.14 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 2 )
		particle:SetEndSize( 21 )
		particle:SetRoll( math.Rand( 360, -360 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor(230,180,50,255)
end
end


	emitter:Finish()
	
	local dlight = DynamicLight(150)
	dlight.Pos = self.Position
	dlight.Size = 125
	dlight.DieTime = CurTime() + 0.21
	dlight.r = 210
	dlight.g = 160
	dlight.b = 40
	dlight.Brightness = 1
	dlight.Decay = 2
end


function EFFECT:Think()
end


function EFFECT:Render()
end
