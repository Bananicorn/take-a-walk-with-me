local Pickup = {}
Pickup.__index = Pickup
setmetatable(Pickup, Mob)

function Pickup:pickup_action (player)
end

function Pickup:update (dt)
	local player = GAME.player
	local pickup_dist = .3
	local dist = (self.pos - player.pos).length
	if dist <= pickup_dist then
		self:pickup_action(player)
	end
end

return Pickup
