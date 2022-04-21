local Player = {}
Player.__index = Player
setmetatable(Player, Mob)

function Player:create (x, y, map, dog)
	local player = {}
	setmetatable(player, Player)
	player:init_default_value(x, y, map)
	player.dog = dog
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
	local force = 1 * dt --tiles per second
	local has_moved = false
	local dx, dy = 0, 0
	if INPUT:down("left") then
		has_moved = true
		dx = -1
	elseif INPUT:down("right") then
		has_moved = true
		dx = 1
	end

	if INPUT:down("up") then
		has_moved = true
		dy = -1
	elseif INPUT:down("down") then
		has_moved = true
		dy = 1
	end
	local dir = VECTOR(dx, dy)
	dir.length = force
	dir.angle = dir.angle - math.pi / 4
	if has_moved then
		self.vel = self.vel + dir
	end
	--self:apply_tether()
	self:physics()
	self:set_camera()
end

function Player:apply_tether ()
	local tether_length = 1.5 --length in tiles
	local dist = (self.pos - self.dog.pos).length
	if dist > tether_length then
		local orig_vel = self.vel.copy
		local orig_dog_vel = self.dog.vel.copy
		self.vel = orig_vel + (orig_dog_vel * .3)
		self.dog.vel = orig_vel + orig_dog_vel
	end
end

function Player:draw ()
	local x, y = self.map:tile_pos_to_screen(self.pos.x, self.pos.y)
	LG.setColor(1, 0, 0)
	LG.circle("fill", x, y - self.size, self.size)
end

return Player
