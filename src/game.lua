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
	g.mobs[#g.mobs + 1] = Player:create(5, 1, g.map)
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
	for i = 1, #g.mobs do
		g.mobs[i]:update(dt)
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
	for i = 1, #g.mobs do
		g.map:draw_object(g.mobs[i])
	end
	g.map:draw(0, 0, w, h)

	LG.setColor(0, 0, 0)
	LG.print(love.timer.getFPS(), 10, 10)

	LOVESIZE.finish()
	LG.setColor(1, 1, 1, 1)
	if IS_MOBILE then
		TOUCH_CONTROLS.draw()
	end
end

return g
