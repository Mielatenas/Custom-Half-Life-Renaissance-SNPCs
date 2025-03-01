include('shared.lua')

language.Add("obj_hybridsquid_spit_r", "Hybridsquid Spit")
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
	local particle = self.emitter:Add("slimesplat_white", self:GetPos())
 	if particle then
 		particle:SetVelocity(VectorRand() *math.Rand(0, 200))
 		particle:SetLifeTime(0)
 		particle:SetDieTime(math.Rand(0.5, 0.8))
 		particle:SetStartAlpha(math.Rand(100, 255))
 		particle:SetEndAlpha(0)
 		particle:SetStartSize(10)
 		particle:SetEndSize(5)
 		particle:SetRoll(math.Rand(0, 360))
 		particle:SetAirResistance(400)
 		particle:SetGravity(Vector(0, 0, -200))
 	end
    end
end