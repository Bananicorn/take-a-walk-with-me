local Player = {}
Player.__index = Player
setmetatable(Player, Mob)

function Player:create (x, y, map, dog)
	local player = {}
	setmetatable(player, Player)
	player.sprite = ASSETS.player
	player:init_default_value(x, y, map)
	player.dog = dog
	player.autonomy = .01
	player.speed = .5 --tiles per second
	player.tether_length = 1.5 --length in tiles
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

function Player:end_condition ()
	return self.dog.stress > 100
end

function Player:update (dt)
	local speed = self.speed * dt --tiles per second
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
	dir.length = speed
	dir.angle = dir.angle - math.pi / 4
	if has_moved then
		self.vel = self.vel + dir
	end
	self:physics(dt)
	self:apply_tether(dt)
	self:set_camera()
end

function Player:apply_tether (dt)
	local dist = (self.pos - self.dog.pos).length
	if dist > self.tether_length then
		local orig_dog_vel = self.dog.vel.copy
		local a = self.pos - self.dog.pos
		a.length = self.autonomy
		self.dog.vel = self.dog.vel + a
		a.length = self.autonomy
		self.vel = self.vel - a
		self.dog.stress = self.dog.stress + (dt * self.dog.stress_potential)
	end
end

function Player:draw ()
	local x, y = self.map:tile_pos_to_screen(self.pos.x, self.pos.y)
	local dx, dy = self.map:tile_pos_to_screen(self.dog.pos.x, self.dog.pos.y)
	LG.setColor(0, 0, 1)
	LG.draw(self.sprite, x - self.sprite_width / 2, y - self.sprite_height)
	LG.line(x - self.sprite_width / 2, y - self.sprite_height / 2, dx + self.dog.sprite_width * .75, dy - self.dog.sprite_height * .35)
end

return Player
