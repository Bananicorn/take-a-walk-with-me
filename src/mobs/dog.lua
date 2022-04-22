local Dog = {}
Dog.__index = Dog
setmetatable(Dog, Mob)

function Dog:create (x, y, map)
	local dog = {}
	setmetatable(dog, Dog)
	dog.sprite = ASSETS.dog
	dog:init_default_value(x, y, map)
	dog.mass = .01
	dog.tint_color = {.3, .2, .1}
	return dog
end

function Dog:update (dt)
	local dir = {"up", "down", "left", "right"}
	local a = VECTOR.dir(dir[math.random(1, 4)]) * .01
	self.vel = self.vel + a
	self:physics()
end

return Dog
