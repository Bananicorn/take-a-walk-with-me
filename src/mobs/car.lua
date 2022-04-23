local Car = {}
Car.__index = Car
setmetatable(Car, Mob)

function Car:create (x, y, map, targets, vel, game)
	local car = {}
	setmetatable(car, Car)
	car.sprite = ASSETS.car_front
	if vel.y < 0 then
		car.sprite = ASSETS.car_back
	end
	car:init_default_value(x, y, map)
	car.initial_vel = vel
	car.targets = targets
	car.vel = vel
	car.width = .5
	car.height = .5
	car.game = game
	return car
end

function Car:collision_action (target)
	self.game.game_over_text = "Don't get run over!"
	target.stress = 100
end

function Car:collision ()
	for i = 1, #self.targets do
		local target = self.targets[i]
		local dist = (self.pos - target.pos).length
		local tx, ty = target.pos.x, target.pos.y
		local sx, sy = self.pos.x, self.pos.y
		if
			tx > sx and tx < sx + self.width and
			ty > sy and ty < sy + self.height
		then
			self:collision_action(target)
		end
	end
end

function Car:update (dt)
	self:physics(dt)
	self.vel = self.initial_vel
	if self.pos.y < 1.5 then
		self.pos.y = self.map.height - 1.5
	elseif self.pos.y > self.map.height - 1.5 then
		self.pos.y = 2
	end
	self:collision()
end
return Car
