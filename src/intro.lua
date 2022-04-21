local i = {
	start_timestamp = love.timer.getTime(),
	display_duration = 2, --seconds
	font = LG.newFont(16 * love.window.getDPIScale()),
	big_font = LG.newFont(64 * love.window.getDPIScale()),
	padding = 16
}

i.init = function (callback)
	i.callback = callback
	love.draw = i.render_splash_screen
	love.update = i.inputs
end

i.inputs = function ()
	local time_over = love.timer.getTime() - i.start_timestamp > i.display_duration
	MENU_INPUT:update()
	if time_over or MENU_INPUT:pressed("action") or MENU_INPUT:pressed("back") then

		local bg_canvas = LG.newCanvas(LG:getWidth(), LG:getHeight())
		LG.setCanvas(bg_canvas)
		i.render_splash_screen()
		LG.setCanvas()
		i.callback()

	end
end

i.render_splash_screen = function ()
	local ww = LG.getWidth()
	local wh = LG.getHeight()
	local text_height = i.font:getHeight()

	i.draw_logo()
	i.draw_love_logo()
end

i.draw_logo = function ()
	local lw, lh = ASSETS.bananicorn_logo:getDimensions()
	local text_height = i.big_font:getHeight()
	local name = "Bananicorn Studios"
	local logo_scale_factor = .5

	LG.setFont(i.big_font)
	lw = lw * logo_scale_factor
	lh = lh * logo_scale_factor
	lx = LG.getWidth() / 2 - lw / 2
	ly = LG.getHeight() / 2 - lh / 2 - text_height / 2

	LG.setColor(1,1,1,1)
	LG.draw(ASSETS.bananicorn_logo, lx, ly, 0, logo_scale_factor, logo_scale_factor)
	LG.printf(name, 0, ly + lh, LG.getWidth(), "center")
end

i.draw_love_logo = function ()
	local ww = LG.getWidth()
	local wh = LG.getHeight()
	local lw, lh = ASSETS.love_logo:getDimensions()
	local text_height = i.font:getHeight()
	local logo_scale_factor = .125
	local text_height = i.font:getHeight()

	lw = lw * logo_scale_factor
	lh = lh * logo_scale_factor
	lx = i.padding
	ly = wh - lh - i.padding

	LG.draw(ASSETS.love_logo, lx, ly, 0, logo_scale_factor, logo_scale_factor)

	lx = lx + i.padding / 2 + lw
	ly = ly + (lw / 2) - (text_height / 2)
	LG.setFont(i.font)
	LG.printf("made with Löve", lx, ly, LG.getWidth(), "left")
end
return i
