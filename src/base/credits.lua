local credits = {
	offset_y = 0,
	lines = {},
	fonts = {
		love.graphics.newFont(16),
		love.graphics.newFont(36),
		love.graphics.newFont(24)
	}
}

credits.init = function ()
	src_text = love.filesystem.read("string", "credits.txt")
	if not src_text then
		file = assert(io.open(love.filesystem.getSourceBaseDirectory() .. "/" .. "credits.txt", "rb"))
		src_text = file:read("*all")
		file.close()
	end
	credits.offset_y = 0
	credits.lines = {}
	credits.fonts = {
		love.graphics.newFont(16),
		love.graphics.newFont(36),
		love.graphics.newFont(24)
	}
	for line in string.gmatch(src_text, "[^\n]-.-\n") do
		credits.lines[#credits.lines + 1] = {
			content = line:gsub("#", ""):gsub("\n", ""),
			type = #line - #line:gsub("#", "") + 1
		}
	end
	UTIL.unset_love_hooks()
	love.update = function () end
	love.draw = credits.draw
	love.keypressed = credits.exit
	love.touchpressed = credits.exit
	love.mousepressed = credits.exit
end

credits.exit = function ()
	MENU.init()
end

credits.draw = function ()

	local padding = LG.getHeight() / 100
	local y = padding * 2 + credits.offset_y

	love.graphics.setBackgroundColor(0, 0, 0, 1)
	local lines = credits.lines
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	for i = 1, #lines do
		local line = lines[i]
		local font_index = line.type or 3
		local font = credits.fonts[font_index]
		if line.content then
			love.graphics.setFont(font)
			love.graphics.printf(line.content, 0, y, w, "center")
		end
		y = y + font:getHeight() + padding
	end

	if y > h - padding then
		credits.offset_y = credits.offset_y - .3
	end
end

return credits
