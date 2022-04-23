local Dog = {}
Dog.__index = Dog
setmetatable(Dog, Mob)

function Dog:create (x, y, map, target_pool, tint_color)
	local dog = {}
	local target_memory_size = 10
	setmetatable(dog, Dog)
	dog.sprite = ASSETS.dog
	dog:init_default_value(x, y, map)
	dog.speed = .1
	dog.smell_stress_reduction = 5
	dog.tint_color = tint_color or dog:get_random_color()
	dog.target_pool = target_pool or {}
	dog.smell_range = .5 --how close do we need to be to smell? (in tiles)
	dog.min_smell_time = .2 --seconds
	dog.max_smell_time = 3 --seconds
	dog.smell_countdown = 0
	dog.target = nil
	dog.last_targets = {}
	dog.is_target = true
	dog.targeting_range = 15
	dog.stress = 0
	dog.stress_potential = 25
	dog.priority = 5
	for i = 1, target_memory_size do
		dog.last_targets[i] = false
	end
	return dog
end

function Dog:get_random_color (target)
	local r, g, b = math.random(0, 4), math.random(0, 2), 1
	return {r / 10, g / 10, b / 10}
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
			self.stress = self.stress - self.smell_stress_reduction
			self:push_last_target(self.target)
			self.target = nil
		end
		local possible_targets = {}
		for i = 1, #self.target_pool do
			local target = self.target_pool[i]
			if not target.is_target or target == self then
				goto continue
			end

			for j = 1, #self.last_targets do
				if self.last_targets[j] == target then
					goto continue
				end
			end

			local is_in_range = (self.pos - target.pos).length <= target.targeting_range
			if not is_in_range then
				goto continue
			end

			local random_skip = math.random(0, 10) > 5
			if random_skip then
				goto continue
			end

			self.smell_countdown = self.min_smell_time + math.random(0, (self.max_smell_time - self.min_smell_time))
			possible_targets[#possible_targets + 1] = target

			::continue::
		end

		--now choose targets according to priority!
		if #possible_targets > 0 then
			local target_index = 1
			local highest_priority = 1
			for i = 1, #possible_targets do
				local target = possible_targets[i]
				if target.priority > highest_priority then
					highest_priority = target.priority
					target_index = i
				end
			end
			self.target = possible_targets[target_index]
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
