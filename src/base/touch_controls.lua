local dpi_scale = love.window.getDPIScale()
local tc = {
	joystick_active = false,
	size = LG.getHeight() / 100,
	font = love.graphics.newFont(32 * dpi_scale),
	sticks = {},
	buttons = {},
	objects = TOUCH_OBJECTS
}

tc.init = function ()
	love.touchpressed = tc.touchpressed
	love.touchreleased = tc.touchreleased
	love.touchmoved = tc.touchmoved

	--more for debugging and testing purposes than anything else
	love.mousepressed = function (x, y)
		tc.touchpressed(1, x, y)
	end
	love.mousereleased = function (x, y)
		tc.touchreleased(1, x, y)
	end
	love.mousemoved = function (x, y)
		tc.touchmoved(1, x, y)
	end

	tc.resize(LG.getWidth(), LG.getHeight())
	for i = 1, #tc.objects do
		if tc.objects[i].type == "joy" then
			tc.sticks[#tc.sticks + 1] = tc.objects[i]
		elseif tc.objects[i].type == "btn" then
			tc.buttons[#tc.buttons + 1] = tc.objects[i]
		end
	end
end

tc.init_objects = function (w, h)
	for i = 1, #tc.objects do
		tc.objects[i]:init(w, h)
	end
end

tc.get_dist = function (x, y, x2, y2)
	local dist_x = x - x2
	local dist_y = y - y2
	local dist = math.sqrt(dist_x^2 + dist_y^2)

	return dist
end

tc.touchpressed = function (id, x, y)
	for i = 1, #tc.objects do
		local obj = tc.objects[i]
		local dist = tc.get_dist(x, y, obj.actual_x, obj.actual_y)
		if dist < obj.actual_size then
			obj.touch_id = id
			return
		end
	end
end

tc.touchreleased = function (id, x, y)
	for i = 1, #tc.objects do
		local obj = tc.objects[i]
		if id == obj.touch_id then
			obj:touchreleased(id, x, y)
			return
		end
	end
end

tc.touchmoved = function (id, x, y, dx, dy)
	for i = 1, #tc.objects do
		local obj = tc.objects[i]
		if obj.type == "btn" and obj.swipeover then
			local dist = tc.get_dist(obj.actual_x, obj.actual_y, x, y)
			if id == obj.touch_id and dist > obj.actual_size then
				obj.touch_id = nil
				break
			elseif dist < obj.actual_size then
				obj.touch_id = id
				break
			end
		elseif id == obj.touch_id and obj.type == "joy" then
			local dist = tc.get_dist(obj.actual_x, obj.actual_y, x, y)
			obj.dir_x = (x - obj.actual_x) / dist
			obj.dir_y = (y - obj.actual_y) / dist
			obj.offset_x = obj.dir_x * math.min(dist, obj.actual_size)
			obj.offset_y = obj.dir_y * math.min(dist, obj.actual_size)
			obj.axis_x = obj.dir_x
			obj.axis_y = obj.dir_y
			break
		end
	end
end

tc.resize = function (w, h)
	tc.size = math.min(w, h) / 100
	tc.init_objects(w, h)
end

tc.draw = function ()
	local prev_font = LG.getFont()
	LG.setFont(tc.font)
	for i = 1, #tc.objects do
		local obj = tc.objects[i]
		local x, y = obj.actual_x, obj.actual_y
		local size = obj.actual_size
		obj:draw()
	end
	LG.setFont(prev_font)
end

--functions for compatibility with the löve API
function tc:getAxis (index)
	--I know joypad axes also include analog bumpers and whatnot,
	--but I'm not sure how practical that is on a touchscreen
	local stick = tc.sticks[math.floor(index / 2)]
	local axis = "axis_x"
	if index % 2 ~= 0 then
		axis = "axis_y"
	end
	return stick[axis]
end

function tc:getGamepadAxis (axis_name)
	local stick = nil
	local stick_position = axis_name:gsub("[xy]", "")
	local stick_axis = axis_name:gsub("left", ""):gsub("right", "")
	for i = 1, #tc.sticks do
		if stick_position == tc.sticks[i].position_on_gamepad then
			stick = tc.sticks[i]
			return stick["axis_" .. stick_axis]
		end
	end
	return 0
end

function tc:isDown (index)
	local button = tc.buttons[index]
	if button then
		return button.touch_id ~= nil
	end
	return false
end

--TODO: make it work with multiple buttons
function tc:isGamepadDown(button_name)
	for i = 1, #tc.buttons do
		if button_name == tc.buttons[i].button_name then
			return tc.buttons[i].touch_id ~= nil
		end
	end
	return false
end

return tc
