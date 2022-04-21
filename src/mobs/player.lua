local Player = {}
Player.__index = Player
setmetatable(Player, Mob)

function Player:create (x, y, map)
	local player = {
		x = x,
		y = y,
		map = map,
	}
	setmetatable(player, Player)
	player:init_physics()
	return player
end

function Player:update ()
	self.x = 4 + math.sin(love.timer.getTime()) * 3
	self.y = 1 + math.cos(love.timer.getTime())
end

function Player:draw ()
	local x, y = self.map:tile_pos_to_screen(self.x, self.y)
	LG.setColor(1, 0, 0)
	LG.circle("fill", x, y, 10)
end

return Player
