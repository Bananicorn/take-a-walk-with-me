local Control = {}
Control.__index = Control
Control.create = function (attrs)
	local c = {}
	setmetatable(c, Control)
	c.x = attrs.x or 0
	c.y = attrs.y or 0
	c.size = attrs.size or 10
	c.anchor = attrs.anchor or  "bottom left"
	if attrs.draw then
		c.draw = attrs.draw
	end
	return c
end

function Control:init (w, h)
	local size = LG.getHeight() / 100
	local x, y = self.x * size, self.y * size

	if self.anchor:find("right") then
		x = w - x
	end
	if self.anchor:find("bottom") then
		y = h - y
	end

	self.actual_size = self.size * size
	self.actual_x = x
	self.actual_y = y
	self.touch_id = nil
end

function Control:touchreleased (id)
	self.touch_id = nil
end

local Stick = {}
Stick.__index = Stick
setmetatable(Stick, Control)
Stick.create = function (attrs)
	local j = Control.create(attrs)
	setmetatable(j, Stick)
	j.type = "joy"
	j.position_on_gamepad = attrs.position_on_gamepad or "left"
	j.offset_x = 0
	j.offset_y = 0
	j.dir_x = 0
	j.dir_y = 0
	j.axis_x = 0
	j.axis_y = 0
	return j
end

function Stick:draw ()
	local x, y = self.actual_x, self.actual_y
	local size = self.actual_size

	LG.setColor(1, 1, 1, .3)
	LG.circle("fill", x, y, size)
	if self.touch_id ~= nil then
		LG.setColor(1, 1, 1, 1)
	end
	LG.circle("fill", x + self.offset_x, y + self.offset_y, size / 2)
end

function Stick:touchreleased ()
	self.touch_id = nil
	self.offset_x = 0
	self.offset_y = 0
	self.dir_x = 0
	self.dir_y = 0
	self.axis_x = 0
	self.axis_y = 0
end

local Button = {}
Button.__index = Button
setmetatable(Button, Control)
Button.create = function (attrs)
	local b = Control.create(attrs)
	setmetatable(b, Button)
	b.type = "btn"
	b.label = attrs.label or "x"
	b.button_name = attrs.button_name or "a"
	b.swipeover = attrs.swipeover or false
	return b
end

function Button:draw ()
	local x, y = self.actual_x, self.actual_y
	local size = self.actual_size

	if self.touch_id ~= nil then
		LG.setColor(1, 1, 1, 1)
	else
		LG.setColor(1, 1, 1, .3)
	end
	LG.circle("fill", x, y, size)
	local font = LG.getFont()
	local label_w = font:getWidth(self.label)
	local label_h = font:getHeight()
	LG.setColor(0, 0, 0, 1)
	LG.print(self.label, x - label_w / 2, y - label_h / 2)
end

return {
	Control = Control,
	Stick = Stick,
	Button = Button
}
