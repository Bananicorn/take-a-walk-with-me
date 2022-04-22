local Mob = {}
Mob.__index = Mob

function Mob:create (x, y, map)
	local mob = {
		pos = VECTOR(x, y),
		vel = VECTOR(0, 0),
		size = 10,
		map = map,
	}
	setmetatable(mob, Mob)
	return mob
end

function Mob:init_default_value (x, y, map)
	self.pos = VECTOR(x, y)
	self.vel = VECTOR(0, 0)
	self.size = 10
	self.map = map
	if self.sprite then
		self.sprite_width = ASSETS.player:getWidth()
		self.sprite_height = ASSETS.player:getHeight()
	end
end

function Mob:update (dt)
end

function Mob:check_collision (x, y)
	local x, y = math.floor(x), math.floor(y)
	return self.map:get_elevation(x, y) > 0
end

function Mob:physics (dt)
	self:momentum(dt)
end

function Mob:momentum (dt)
	local x = self.pos.x + self.vel.x
	local y = self.pos.y + self.vel.y
	local damping = .95
	if not self:check_collision(x, y) then
		self.pos.x = x
		self.pos.y = y
	end
	self.vel = self.vel * damping
end

function Mob:draw ()
	local x, y = self.map:tile_pos_to_screen(self.pos.x, self.pos.y)
	if self.tint_color then
		LG.setColor(self.tint_color)
	else
		LG.setColor(1, 1, 1)
	end
	if self.sprite then
		LG.draw(self.sprite, x - self.sprite_width / 2, y - self.sprite_height / 2)
	else
		LG.circle("fill", x, y, 10)
	end
end

return Mob
