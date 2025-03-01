include('shared.lua')

language.Add("obj_poisonsquid_spit_r", "Poisonsquid")
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
	local particle = self.emitter:Add("slimesplat_poison", self:GetPos())
 	if particle then
 		particle:SetVelocity(VectorRand() *math.Rand(0, 200))
 		particle:SetLifeTime(0)
 		particle:SetDieTime(math.Rand(0.3, 1.5))
 		particle:SetStartAlpha(math.Rand(100, 255))
 		particle:SetEndAlpha(0)
 		particle:SetStartSize(15)
 		particle:SetEndSize(3)
 		particle:SetRoll(math.Rand(0, 360))
 		if self:WaterLevel() == 3 then 
            particle:SetGravity(Vector(0, 0, -50))
            particle:SetAirResistance(3000)
        else 
 		    particle:SetAirResistance(200)
 		    particle:SetGravity(Vector(0, 0, -300))		
 	    end
 	end
 end