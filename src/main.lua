require("base.love_shortcuts")
IS_MOBILE = love.system.getOS() == "Android" or love.system.getOS() == "iOS"

if IS_MOBILE then
	TOUCH_CLASSES = require("base.touch_classes")
	TOUCH_OBJECTS = require("touch_objects")
	TOUCH_CONTROLS = require("base.touch_controls")
end

--Classes
Dimetric_Map = require("dimetric")

UTF8 = require("utf8")
INSPECT = require("external.inspect")
LOVESIZE = require("external.lovesize")
UTIL = require("util")
INPUT = require("input")
ASSETS = require("assets")
CREDITS = require("base.credits")
LEVEL = require("level")

MENU_INPUT = require("menu_input")
MC = require("base.menu_classes")
MENU = require("base.menu")
INTRO = require("intro")

GAME = require("game")

function love.load ()
	if IS_MOBILE then
		love.window.setFullscreen(true)
	end
	LK.setKeyRepeat(true)
	INTRO.init(MENU.init)
end

function love.mousereleased (x, y, key)
end

function love.keyreleased (key)
end

function love.update (dt)
end

love.draw = MENU.draw
love.resize = MENU.resize
