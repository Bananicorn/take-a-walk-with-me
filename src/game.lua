local x, y = 0, 0
local g = {
	mobs = {},
	map = Dimetric_Map:create(LEVEL)
}
function g.init ()
	UTIL.unset_love_hooks()
	if IS_MOBILE then
		TOUCH_CONTROLS.init()
	end
	LOVESIZE:set(800, 600)
	LG.setFont(LG.newFont(32))
	love.draw = g.draw
	love.update = g.update
	love.resize = function (w, h)
		if IS_MOBILE then
			TOUCH_CONTROLS.resize(w, h)
		end
		LOVESIZE:resize(w, h)
	end
end

function g.exit ()
	MENU.init()
end

function g.update (dt)
	INPUT:update()
	if INPUT:down("left") then
		x = x - 1
	elseif INPUT:down("right")then
		x = x + 1
	end
	if INPUT:down("up") then
		y = y - 1
	elseif INPUT:down("down")then
		y = y + 1
	end
	if INPUT:down("action")then
		x = 200
		y = 200
	end
	if INPUT:pressed("back") then
		g.exit()
	end
end

function g.draw ()
	LG.clear(0, 0, 0)
	LOVESIZE.begin()
	local w, h = LG.getWidth(), LG.getHeight()

	LG.print(love.timer.getFPS(), 10, 10)
	g.map:draw(0, 0, w, h)

	LOVESIZE.finish()
	LG.setColor(1, 1, 1, 1)
	if IS_MOBILE then
		TOUCH_CONTROLS.draw()
	end
end

return g
