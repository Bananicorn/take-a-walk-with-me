local Player = {}
Player.__index = Player
setmetatable(Player, Mob)

function Player:create (x, y, map)
	local player = {
		x = x,
		y = y,
		size = 10,
		map = map,
	}
	setmetatable(player, Player)
	player:init_physics()
	return player
end

function Player:update (dt)
	local force = 3 * dt --tiles per second
	if INPUT:down("left") then
		self.x = self.x - force
	elseif INPUT:down("right") then
		self.x = self.x + force
	end

	if INPUT:down("up") then
		self.y = self.y - force
	elseif INPUT:down("down") then
		self.y = self.y + force
	end
end

function Player:draw ()
	local x, y = self.map:tile_pos_to_screen(self.x, self.y)
	LG.setColor(1, 0, 0)
	LG.circle("fill", x, y - self.size, self.size)
end

return Player
