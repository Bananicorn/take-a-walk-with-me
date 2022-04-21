local Dog = {}
Dog.__index = Dog
setmetatable(Dog, Mob)

function Dog:create (x, y, map)
	local dog = {}
	setmetatable(dog, Dog)
	dog:init_default_value(x, y, map)
	return dog
end

function Dog:update (dt)
	self:physics()
end

function Dog:draw ()
	local x, y = self.map:tile_pos_to_screen(self.pos.x, self.pos.y)
	LG.setColor(0, 0, 1)
	LG.circle("fill", x, y - self.size, self.size)
end

return Dog
