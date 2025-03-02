include('shared.lua')

language.Add("obj_firesphere_r", "Fire Sphere")
function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self.emitter = ParticleEmitter(self:GetPos())
end
 
function ENT:OnRemove()
	self.emitter:Finish()
end
 
function ENT:Think()
	for i=1,3 do
	local particle = self.emitter:Add("slimesplat_napalm", self:GetPos())
 	    if particle then
 		    particle:SetVelocity(VectorRand(-100, 100) ) --particle:SetVelocity(VectorRand() *math.Rand(0, 200))
 	    	particle:SetLifeTime(0)
 	    	particle:SetDieTime(0.5)
 	    	particle:SetStartAlpha(150)
 	    	particle:SetEndAlpha(0)
 	    	particle:SetStartSize(15)
 	    	particle:SetEndSize(7)
 	    	particle:SetRoll(math.Rand(0, 360))
 	    	particle:SetAirResistance(50)
 	    	particle:SetGravity(Vector(0, 0, -200))
        end	
 	end
end