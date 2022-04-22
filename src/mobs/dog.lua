local Dog = {}
Dog.__index = Dog
setmetatable(Dog, Mob)

function Dog:create (x, y, map, target_pool)
	local dog = {}
	local target_memory_size = 10
	setmetatable(dog, Dog)
	dog.sprite = ASSETS.dog
	dog:init_default_value(x, y, map)
	dog.speed = .05
	dog.tint_color = {.3, .2, .1}
	dog.target_pool = target_pool or {}
	dog.smell_range = .5 --how close do we need to be to smell? (in tiles)
	dog.min_smell_time = .5
	dog.max_smell_time = 10
	dog.smell_countdown = 0
	dog.target = nil
	dog.last_targets = {}
	dog.is_target = true
	dog.targeting_range = 5
	for i = 1, target_memory_size do
		dog.last_targets[i] = false
	end
	return dog
end

function Dog:push_last_target (target)
	for i = 1, #self.last_targets - 1 do
		self.last_targets[i] = self.last_targets[i + 1]
	end
	self.last_targets[#self.last_targets] = target
end

function Dog:choose_target ()
	if not self.target or self.smell_countdown < 0 then
		if self.target then
			self:push_last_target(self.target)
			self.target = nil
		end
		for i = 1, #self.target_pool do
			local target = self.target_pool[i]
			if not target.is_target or target == self then
				goto continue
			end

			local is_in_last_targets = false
			for j = 1, #self.last_targets do
				if self.last_targets[j] == target then
					is_in_last_targets = true
					break
				end
			end
			if is_in_last_targets then
				goto continue
			end

			local is_in_range = (self.pos - target.pos).length <= target.targeting_range
			if not is_in_range then
				goto continue
			end

			self.smell_countdown = self.min_smell_time + math.random(0, (self.max_smell_time - self.min_smell_time))
			self.target = target

			::continue::
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
	else
		self.smell_countdown = self.smell_countdown - dt
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
