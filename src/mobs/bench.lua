local Bench = {}
Bench.__index = Bench
setmetatable(Bench, Pickup)

function Bench:create (x, y, map)
	local bench = {}
	setmetatable(bench, Bench)
	bench.sprite = ASSETS.bench
	bench:init_default_value(x, y, map)
	bench:init_default_value(x, y, map)
	bench.effect_timestamp = 0
	bench.effect_cooldown = 1
	return bench
end

function Bench:pickup_action (player)
	if self.effect_timestamp + self.effect_cooldown < love.timer.getTime() then
		player.stress = math.max(0, player.stress - 5)
		self.effect_timestamp = love.timer.getTime()
	end
end

return Bench


