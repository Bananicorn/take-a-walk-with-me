local Drink = {}
Drink.__index = Drink
setmetatable(Drink, Pickup)

function Drink:create (x, y, map, dog)
	local drink = {}
	setmetatable(drink, Drink)
	drink.sprite = ASSETS.drink
	drink:init_default_value(x, y, map)
	return drink
end

function Drink:pickup_action (player)
	self.to_remove = true
	player.stress = math.max(0, player.dog.stress - 50)
end

return Drink


