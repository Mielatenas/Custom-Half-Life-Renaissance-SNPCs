include('shared.lua')

language.Add("obj_icesphere_r", "Ice Sphere")
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
	for i=1,2 do
	local particle = self.emitter:Add("slimesplat_ice", self:GetPos())
 	if particle then
 		particle:SetVelocity(VectorRand() *math.Rand(0, 200))
 		particle:SetLifeTime(0)
 		particle:SetDieTime(math.Rand(0.3, 0.7))
 		particle:SetStartAlpha(math.Rand(100, 255))
 		particle:SetEndAlpha(0)
 		particle:SetStartSize(12)
 		particle:SetEndSize(1)
 		particle:SetRoll(math.Rand(0, 360))
 		particle:SetAirResistance(400)
 		particle:SetGravity(Vector(0, 0, -200))
 	end
    end
end