local MC = {}
MC.label = {}
MC.label.__index = MC.label

function MC.label:create (label)
	local label_entry = {}
	setmetatable(label_entry, MC.label)
	label_entry.label = label
	label_entry.event = function () end
	return label_entry
end

function MC.label:draw (x, y, w, h, padding, active)
	LG.setColor(MENU.color)
	LG.printf(self.label, x, y, w, "center")
end

function MC.label:on_activate (label, event)
	local dir = 1
	if MENU.current_index < MENU.prev_index then
		dir = -1
	end
	MENU.current_index = MENU.current_index + dir
end

MC.entry = {}
MC.entry.__index = MC.entry
function MC.entry:create (label, event)
	local entry = {}
	setmetatable(entry, MC.entry)
	entry.label = label
	entry.event = event
	return entry
end

function MC.entry:draw (x, y, w, h, padding, active)
	LG.setColor(MENU.color)
	if active then
		LG.rectangle("fill", x, y - padding, w, h)
		LG.setColor(MENU.active_color)
		LG.printf(self.label, x, y, w, "center")
	else
		LG.rectangle("line", x, y - padding, w, h)
		LG.printf(self.label, x, y, w, "center")
	end
end

MC.link = {}
MC.link.__index = MC.link
setmetatable(MC.link, MC.entry)

function MC.link:create (label, menu)
	local link = {}
	setmetatable(link, MC.link)
	link.label = label
	link.event = function ()
		MENU.change_menu(menu)
	end
	return link
end

MC.back = {}
MC.back.__index = MC.back
setmetatable(MC.back, MC.entry)

function MC.back:create (label)
	local back = {}
	setmetatable(back, MC.back)
	back.label = label
	back.event = function ()
		MENU:back()
	end
	return back
end

MC.textinput = {}
MC.textinput.__index = MC.textinput
setmetatable(MC.textinput, MC.entry)

--unicode characters can add more than one to the lenght of the string
function MC.textinput:create (label, max_len)
	local textinput = {}
	setmetatable(textinput, MC.textinput)

	textinput.label = label
	textinput.content = ""
	textinput.max_len = max_len or 0
	textinput.writable = false
	textinput.prev_keypressed = nil
	textinput.prev_mousepressed = nil

	textinput.event = function ()
		textinput.writable = true

		textinput.prev_keypressed = love.keypressed
		love.keypressed = function (key)
			textinput:keypressed(key)
		end

		textinput.prev_mousepressed = love.mousepressed
		love.mousepressed = function (key)
			textinput:mousepressed(key)
		end

		love.textinput = function (text)
			textinput:textinput(text)
		end

		if IS_MOBILE then
			love.keyboard.setTextInput(true) --open the soft keyboard
		end
	end

	return textinput
end

function MC.textinput:deactivate ()
	love.keypressed = self.prev_keypressed
	love.mousepressed = self.prev_mousepressed
	self.prev_keypressed = nil
	self.prev_mousepressed = nil
	love.textinput = nil
	if IS_MOBILE then
		love.keyboard.setTextInput(false)
	end
	self.writable = false
end

function MC.textinput:mousepressed (key)
	self:deactivate()
end

function MC.textinput:keypressed (key)
	if key == "backspace" then
		local byteoffset = UTF8.offset(self.content, -1)
		if byteoffset then
			self.content = string.sub(self.content, 1, byteoffset - 1)
		end
	end
	if key == "escape" or key == "return" then --return actually re-activates it right after, ugh.
		self:deactivate()
	end
end

function MC.textinput:textinput (text)
	if self.max_len > 0 and self.content:len() < self.max_len then
		self.content = self.content .. text
	end
end

function MC.textinput:draw (x, y, w, h, padding, active)
	LG.setColor(MENU.color)
	if active then
		LG.rectangle("fill", x, y - padding, w, h)
		LG.setColor(MENU.active_color)
	else
		LG.rectangle("line", x, y - padding, w, h)
	end
	if self.writable then
		LG.rectangle("fill", x + padding + MENU.font:getWidth(self.content), y, padding / 3, h - padding * 2)
	end
	if self.content ~= "" or self.writable then
		LG.printf(self.content, x + padding, y, w, "left")
	else
		local r, g, b, a = LG:getColor()
		a = .5
		LG.setColor(r, g, b, a)
		LG.printf(self.label, x, y, w, "center")
	end
end

return MC
