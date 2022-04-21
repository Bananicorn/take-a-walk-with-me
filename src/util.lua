local socket = require "socket"

local util = {
	unset_love_hooks = function ()
		love.mousereleased = nil
		love.mousepressed = nil
		love.mousemoved = nil
		love.touchpressed = nil
		love.touchreleased = nil
		love.touchmoved = nil
		love.keyreleased = nil
		love.keypressed = nil
		love.update = nil
		love.draw = nil
		love.resize = nil
		love.focus = nil
		love.textinput = nil
	end,
	get_ip_address = function ()
		local s = socket.udp()
		s:setpeername("8.8.8.8", 80)
		local ip, _ = s:getsockname()
		return ip
	end
}
return util
