local baton = require("external.baton")
local joystick = love.joystick.getJoysticks()[1]
local action = {"key:return", "key:space", "button:a", "mouse:1"}
if IS_MOBILE then
	joystick = TOUCH_CONTROLS
	action = {"key:return", "key:space", "button:a"}
end

local player_controls = baton.new {
	controls = {
		left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
		right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
		up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
		down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
		action = action,
		back = {"key:escape", "button:start"}
	},
	pairs = {
		move = {'left', 'right', 'up', 'down'}
	},
	joystick = joystick
}

return player_controls
