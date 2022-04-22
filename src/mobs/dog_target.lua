local Dog_Target = {}
Dog_Target.__index = Dog_Target
setmetatable(Dog_Target, Mob)

function Dog_Target:create (x, y, map)
	local target = {}
	setmetatable(target, Dog_Target)
	target:init_default_value(x, y, map)
	target:init_target_value()
	return target
end

function Dog_Target:init_target_value(priority, range)
	self.is_target = true
	self.last_visited = 0
	self.priority = priority or 1
	self.range = range or 1
end

return Dog_Target
