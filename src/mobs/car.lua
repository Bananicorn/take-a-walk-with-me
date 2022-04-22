local Car = {}
Car.__index = Car
setmetatable(Car, Mob)

function Car:create (x, y, map)
	local car = {}
	setmetatable(car, Car)
	car.sprite = ASSETS.car_front
	car:init_default_value(x, y, map)
	return car
end

function Car:update (dt)
	--if 0 then
		--car.sprite = ASSETS.car_front
	--else
		--car.sprite = ASSETS.car_back
	--end
end

return Car

