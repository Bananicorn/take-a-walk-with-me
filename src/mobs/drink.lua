local Drink = {}
Drink.__index = Drink
setmetatable(Drink, Pickup)

function Drink:create (x, y, map, spawner)
	local drink = {}
	setmetatable(drink, Drink)
	drink.spawner = spawner
	drink.sprite = ASSETS.drink
	drink:init_default_value(x, y, map)
	spawner.powerups_present = spawner.powerups_present + 1
	return drink
end

function Drink:pickup_action (player)
	self.to_remove = true
	player.stress = math.max(0, player.stress - 50)
	self.spawner.powerups_present = self.spawner.powerups_present - 1
end

return Drink


