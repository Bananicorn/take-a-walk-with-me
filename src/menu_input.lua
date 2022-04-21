local baton = require("external.baton")

local menu_controls = baton.new {
	controls = {
		up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
		down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
		action = {'key:return', 'key:space', 'button:a', 'mouse:1'},
		mouse_action = {'mouse:1'}, --only used for a special case
		back = {"key:escape", "button:start"}
	},
	joystick = love.joystick.getJoysticks()[1]
}

return menu_controls
