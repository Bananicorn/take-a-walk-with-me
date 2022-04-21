local Dog = {}
Dog.__index = Dog
setmetatable(Dog, Mob)

function Dog:create (x, y, map)
	local dog = {
		x = x,
		y = y,
		size = 10,
		map = map,
	}
	setmetatable(dog, Dog)
	dog:init_physics()
	return dog
end

function Dog:update (dt)
end

function Dog:draw ()
	local x, y = self.map:tile_pos_to_screen(self.x, self.y)
	LG.setColor(0, 0, 1)
	LG.circle("fill", x, y - self.size, self.size)
end

return Dog
