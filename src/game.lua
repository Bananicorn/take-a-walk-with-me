local g = {
	dog = nil,
	player = nil,
	mobs = {},
	map = nil,
	spawner = nil,
	start_time = 0,
}
function g.init (level, spawner)
	UTIL.unset_love_hooks()
	if IS_MOBILE then
		TOUCH_CONTROLS.init()
	end
	g.map = Dimetric_Map:create(level)
	g.spawner = spawner
	g.start_time = love.timer.getTime()
	g.score = 0
	g.score_multiplier = 100
	g.font = LG.newFont(16)
	g.big_font = LG.newFont(32)
	g.game_over_text = "Too much stress!"
	LG.setFont(g.font)
	g.mobs = {}
	g.dog = Dog:create(6, 2, g.map, g.mobs, {.4, .1, .1})
	g.player = Player:create(5, 2, g.map, g.dog)
	g.mobs[#g.mobs + 1] = g.dog
	g.mobs[#g.mobs + 1] = g.player
	level.init(g)
	spawner.init(g)

	love.draw = g.draw
	love.update = g.update
	love.resize = function (w, h)
		if IS_MOBILE then
			TOUCH_CONTROLS.resize(w, h)
		end
	end
end

function g.exit ()
	MENU.init()
end

function g.update_end_screen (dt)
	INPUT:update()
	if INPUT:pressed("back") or INPUT:pressed("action") then
		g.exit()
	end
end

function g.update (dt)
	INPUT:update()
	g.spawner:update()
	for i = 1, #g.mobs do
		g.mobs[i]:update(dt)
	end
	if g.player:end_condition() then
		love.draw = g.draw_end_screen
		love.update = g.update_end_screen
	end
	if INPUT:pressed("back") then
		g.exit()
	end
	local i = 1
	while i <= #g.mobs do
		if g.mobs[i].to_remove then
			table.remove(g.mobs, i)
		end
		i = i + 1
	end
	g.score = g.score + dt
end

function g.draw_end_screen ()
	MENU.draw_bg()
	local title_text = g.game_over_text
	local w, h = LG.getWidth(), LG.getHeight()
	local title_height = g.big_font:getHeight()
	local title_width = g.big_font:getWidth(title_text)
	LG.setFont(g.big_font)
	LG.print(title_text, w / 2 - title_width / 2, h / 2 - title_height / 2)

	local score_text = "Score: " .. math.floor(g.score * g.score_multiplier)
	local score_height = g.big_font:getHeight()
	local score_width = g.big_font:getWidth(score_text)
	LG.print(score_text, w / 2 - score_width / 2, h / 2 + title_height - score_height / 2)
	LG.setFont(g.font)
	LG.print("Press space or escape to continue", score_height * .75, h - score_height)
end

function g.draw_combined_bar (x, y, width, height, percentage, color, percentage2, color2)
	local fill_width = width / 100 * math.max(math.min(percentage, 100), 0)
	local fill_width2 = width / 100 * math.max(math.min(percentage2, 100), 0)
	LG.setColor(color)
	LG.rectangle("fill", x, y, fill_width, height)
	LG.setColor(color2)
	LG.rectangle("fill", x + fill_width, y, fill_width2, height)
	LG.setColor(0, 0, 0)
	LG.rectangle("line", x, y, width, height)
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
	LG.print("Score: " .. math.floor(g.score * g.score_multiplier), padding, y)
	LG.print("Autonomy", x, y)
	y = y + font_height
	g.draw_bar(x, y, bar_width, bar_height, g.player.autonomy * 100, {0, 1, 0})
	y = y + font_height + bar_height + padding
	LG.print("Stress", x, y)
	y = y + font_height
	g.draw_combined_bar(
		x, y,
		bar_width, bar_height,
		g.player.dog.stress, {.4, .2, .2},
		g.player.stress, {0, 0, 1}
	)
end

function g.draw ()
	LG.clear(0, 0, 0)
	local w, h = LG.getWidth(), LG.getHeight()

	for i = 1, #g.mobs do
		g.map:draw_object(g.mobs[i])
	end
	g.map:draw(0, 0, w, h)

	g.draw_ui()

	LG.setColor(1, 1, 1, 1)
	if IS_MOBILE then
		TOUCH_CONTROLS.draw()
	end
end

return g
