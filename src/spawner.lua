local spawner = {
	game = nil,
	last_spawn_timestamp = 0,
	spawn_interval = 1, --seconds
	powerups_present = 0,
	max_powerups = 10,
	powerups = {
		Bone,
		Drink,
	},
}

function spawner.init(game)
	spawner.game = game
end

function spawner.spawn_powerup()
	if spawner.powerups_present < spawner.max_powerups then
		local Chosen_Powerup = spawner.powerups[math.random(1, #spawner.powerups)]
		local g = spawner.game
		local min_x, min_y = 2, 2
		local max_x, max_y = g.map.width - 1, g.map.height - 1
		local x = math.random(min_x, max_x)
		local y = math.random(min_y, max_y)
		g.mobs[#g.mobs + 1] = Chosen_Powerup:create(x, y, g.map, spawner)
	end
end

function spawner:update()
	if spawner.last_spawn_timestamp + spawner.spawn_interval < love.timer.getTime() then
		spawner.last_spawn_timestamp = love.timer.getTime()
		spawner.spawn_powerup()
	end
end
return spawner
