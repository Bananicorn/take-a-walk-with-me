local dpi_scale = love.window.getDPIScale()
local menu = {
	font = love.graphics.newFont(32 * dpi_scale),
	current_index = 1,
	prev_index = 1,
	padding = 0,
	w = 0,
	h = 0,
	prev_menus = {},
	color = {1, 1, 1, 1},
	active_color = {0, 0, 0, 1},
	active_menu = "main",
	entries = require("menu_entries"),
	draw_bg = nil,
	after_init = nil
}

function menu.change_menu (sub_menu_name, going_back)
	local m = menu
	local entries = m.entries[sub_menu_name]
	if not going_back then
		m.prev_menus[#m.prev_menus + 1] = m.active_menu
	end
	m.active_menu = sub_menu_name
	m.set()
	m.current_index = 1
	if entries[m.current_index].on_activate then
		entries[m.current_index]:on_activate()
	end
end

function menu.back (sub_menu_name)
	local m = menu
	if #m.prev_menus > 0 then
		menu.change_menu(m.prev_menus[#m.prev_menus], true)
		m.prev_menus[#m.prev_menus] = nil
	end
end

function menu.init ()
	local m = menu
	local entries = m.entries[m.active_menu]
	UTIL.unset_love_hooks()
	love.update = m.update
	love.draw = m.draw
	love.mousemoved = m.mousemoved
	love.touchmoved = m.touchpressed
	love.touchpressed = m.touchpressed
	love.mousepressed = m.mousemoved
	love.resize = m.resize
	if m.after_init then
		m:after_init()
	end
	m.set()
	m.current_index = 1
	if entries[m.current_index].on_activate then
		entries[m.current_index]:on_activate()
	end
end

function menu.set ()
	local m = menu
	local entries = m.entries[m.active_menu]
	m.w = 0
	m.h = 0
	m.current_index = 0
	m.prev_index = 0
	m.padding = math.min(LG.getWidth(), LG.getHeight()) / 50

	for i = 1, #entries do
		m.w = math.max(m.w, m.font:getWidth(entries[i].label))
		m.h = m.h + m.padding * 3 + m.font:getHeight()
	end

	m.h = m.h - m.padding * 2
	m.w = m.w + m.padding * 2
end

function menu.resize (w, h)
	menu.set()
end

function menu.draw ()
	local m = menu
	local screen_w, screen_h = LG.getWidth(), LG.getHeight()
	local x = screen_w / 2 - m.w / 2
	local y = screen_h / 2 - m.h / 2
	local entries = m.entries[m.active_menu]
	local active = false
	local h = m.font:getHeight() + m.padding * 2

	if m.draw_bg then
		m.draw_bg()
	end

	LG.setFont(m.font)

	for i = 1, #entries do
		if i == m.current_index then
			active = true
		end
		if entries[i].draw then
			entries[i]:draw(x, y, m.w, h, m.padding, active)
		end
		active = false
		y = y + h + m.padding
	end
end

function menu.get_moused_item (mouse_x, mouse_y)
	local m = menu
	local screen_w, screen_h = LG.getWidth(), LG.getHeight()
	local entry_x = screen_w / 2 - m.w / 2
	local entry_y = screen_h / 2 - m.h / 2 - m.padding
	local h = m.font:getHeight() + m.padding * 2
	local entries = m.entries[m.active_menu]

	for i = 1, #entries do
		if
			(mouse_x > entry_x) and (mouse_x < entry_x + m.w) and
			(mouse_y > entry_y) and (mouse_y < entry_y + h)
		then
			return i
		end
		entry_y = entry_y + h + m.padding
	end
	return 0
end

function menu.update ()
	MENU_INPUT:update()
	local m = menu
	local entries = m.entries[m.active_menu]
	if not love.textinput then
		if MENU_INPUT:pressed("up") then
			m.current_index = m.current_index - 1
			m.current_index = math.max(1, m.current_index)
		elseif MENU_INPUT:pressed("down") then
			m.current_index = m.current_index + 1
			m.current_index = math.min(#entries, m.current_index)
		end
		if m.prev_index ~= m.current_index then
			if m.current_index > 0 and entries[m.current_index].on_activate then
				entries[m.current_index]:on_activate()
			end
			if m.prev_index > 0 and entries[m.prev_index].on_deactivate then
				entries[m.prev_index]:on_deactivate()
			end
			m.prev_index = m.current_index
		end
		if MENU_INPUT:pressed("action") then
			if MENU_INPUT:pressed("mouse_action") then
				m.mousemoved(love.mouse.getPosition())
			end
			if m.current_index > 0 then
				if entries[m.current_index].event then
					entries[m.current_index].event(entries[m.current_index])
				elseif entries[m.current_index].target_menu then
					m.change_menu(entries[m.current_index].target_menu)
				end
			end
		end
		if MENU_INPUT:pressed("back") and m.active_menu ~= "main" then
			m:back()
		end
	end
end

function menu.mousemoved (mouse_x, mouse_y)
	local m = menu
	local entries = m.entries[m.active_menu]
	m.current_index = m.get_moused_item(mouse_x, mouse_y)
	if m.current_index > 0 and entries[m.current_index].__index == MC.label then
		m.current_index = 0
	end
end
function menu.touchpressed (id, pos_x, pos_y)
	menu.mousemoved(pos_x, pos_y)
end

return menu
