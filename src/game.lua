local g = {
	dog = nil,
	player = nil,
	mobs = {},
	map = Dimetric_Map:create(LEVEL),
	start_time = 0,
}
function g.init ()
	UTIL.unset_love_hooks()
	if IS_MOBILE then
		TOUCH_CONTROLS.init()
	end
	LOVESIZE:set(800, 600)
	g.start_time = love.timer.getTime()
	g.font = LG.newFont(16)
	LG.setFont(g.font)
	g.mobs = {}
	g.dog = Dog:create(6, 1, g.map, g.mobs)
	g.player = Player:create(5, 1, g.map, g.dog)
	g.mobs[#g.mobs + 1] = g.dog
	g.mobs[#g.mobs + 1] = g.player
	g.mobs[#g.mobs + 1] = Fire_Hydrant:create(2, 2, g.map)
	g.mobs[#g.mobs + 1] = Fire_Hydrant:create(2, 4, g.map)
	g.mobs[#g.mobs + 1] = Fire_Hydrant:create(7, 6, g.map)
	g.mobs[#g.mobs + 1] = Fire_Hydrant:create(10, 10, g.map)
	g.mobs[#g.mobs + 1] = Fire_Hydrant:create(12, 10, g.map)
	g.mobs[#g.mobs + 1] = Bush:create(11, 10, g.map)

	g.mobs[#g.mobs + 1] = Dog:create(6, 6, g.map, g.mobs)
	g.mobs[#g.mobs + 1] = Dog:create(7, 6, g.map, g.mobs)
	g.mobs[#g.mobs + 1] = Dog:create(8, 6, g.map, g.mobs)

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
	if INPUT:pressed("back") or g.player:win_condition() then
		g.exit()
	end
end


function g.draw_bar (x, y, width, height, percentage, color)
	local fill_width = width / 100 * math.max(math.min(percentage, 100), 0)
	LG.setColor(color)
	LG.rectangle("fill", x, y, fill_width, height)
	LG.setColor(0, 0, 0)
	LG.rectangle("line", x, y, width, height)
end

function g.draw_ui ()
	local w, h = LG.getWidth(), LG.getHeight()
	local bar_width = w / 5
	local bar_height = w / 50
	local font_height = g.font:getHeight()
	local padding = w / 100
	local x, y = w - bar_width - padding, padding

	LG.setColor(0, 0, 0)
	LG.print("Autonomy", x, y)
	y = y + font_height
	g.draw_bar(x, y, bar_width, bar_height, g.player.autonomy * 100, {0, 1, 0})
	y = y + font_height + bar_height + padding
	LG.print("Stress", x, y)
	y = y + font_height
	g.draw_bar(x, y, bar_width, bar_height, g.player.dog.stress, {0, 0, 1})
end

function g.draw ()
	LG.clear(0, 0, 0)
	LOVESIZE.begin()
	local w, h = LG.getWidth(), LG.getHeight()

	for i = 1, #g.mobs do
		g.map:draw_object(g.mobs[i])
	end
	g.map:draw(0, 0, w, h)

	g.draw_ui()

	LOVESIZE.finish()
	LG.setColor(1, 1, 1, 1)
	if IS_MOBILE then
		TOUCH_CONTROLS.draw()
	end
end

return g
