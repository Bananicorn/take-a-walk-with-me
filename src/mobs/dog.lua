local Dog = {}
Dog.__index = Dog
setmetatable(Dog, Mob)

function Dog:create (x, y, map, target_pool)
	local dog = {}
	setmetatable(dog, Dog)
	dog.sprite = ASSETS.dog
	dog:init_default_value(x, y, map)
	dog.mass = .01
	dog.speed = .05
	dog.tint_color = {.3, .2, .1}
	dog.target_pool = target_pool or {}
	dog.smell_range = .5 --how close do we need to be to smell? (in tiles)
	dog.target = nil
	return dog
end

function Dog:choose_target ()
	if not self.target then
		for i = 1, #self.target_pool do
			local target = self.target_pool[i]
			if target.is_target then
				self.target = target
				return
			end
		end
	end
end

function Dog:random_movement (dt)
	local dirs = {"up", "down", "left", "right"}
	local speed = self.speed * dt
	local dir = VECTOR.dir(dirs[math.random(1, 4)]) * speed
	self.vel = self.vel + dir
end

function Dog:chase_target (dt)
	local speed = self.speed * dt
	local target_dist = self.target.pos - self.pos
	local target_dir = target_dist.normalized
	if target_dist.length > self.smell_range then
		self.vel = self.vel + target_dir * speed
	end
end

function Dog:update (dt)
	self:choose_target()
	if self.target then
		self:chase_target(dt)
	else
		self:random_movement(dt)
	end
	self:physics(dt)
end

return Dog
