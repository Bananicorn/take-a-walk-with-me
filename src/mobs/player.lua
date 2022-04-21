local Player = {}
Player.__index = Player
setmetatable(Player, Mob)

function Player:create (x, y, map)
	local player = {}
	setmetatable(player, Player)
	player:init_default_value(x, y, map)
	return player
end

function Player:set_camera ()
	local x, y = self.pos.x, self.pos.y
	local size = self.map.tilesize
	local dx = (x / 2 - y / 2) * size
	local dy = (y / 4 + x / 4) * size
	self.map.offset_x = -dx + LG.getWidth() / 2
	self.map.offset_y = -dy + LG.getHeight() / 2
end

function Player:update (dt)
	local force = 3 * dt --tiles per second
	local has_moved = false
	if INPUT:down("left") then
		self.vel.x = -force
		self.vel.y = 0
	elseif INPUT:down("right") then
		self.vel.x = force
		self.vel.y = 0
	end

	if INPUT:down("up") then
		self.vel.y = -force
		self.vel.x = 0
	elseif INPUT:down("down") then
		self.vel.y = force
		self.vel.x = 0
	end
	self:physics()
	self:set_camera()
end

function Player:draw ()
	local x, y = self.map:tile_pos_to_screen(self.pos.x, self.pos.y)
	LG.setColor(1, 0, 0)
	LG.circle("fill", x, y - self.size, self.size)
end

return Player
