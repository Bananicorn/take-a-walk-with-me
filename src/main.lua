require("base.love_shortcuts")
require("base.run")
IS_MOBILE = love.system.getOS() == "Android" or love.system.getOS() == "iOS"
SKIP_INTRO = true

if IS_MOBILE then
	TOUCH_CLASSES = require("base.touch_classes")
	TOUCH_OBJECTS = require("touch_objects")
	TOUCH_CONTROLS = require("base.touch_controls")
end

--Classes
Mob = require("mobs.mob")
Player = require("mobs.player")
Dog = require("mobs.dog")
Dog_Target = require("mobs.dog_target")
Fire_Hydrant = require("mobs.fire_hydrant")
Bush = require("mobs.bush")
Pickup = require("mobs.pickup")
Bone = require("mobs.bone")
Drink = require("mobs.drink")
Car = require("mobs.car")
Dimetric_Map = require("dimetric")

UTF8 = require("utf8")
INSPECT = require("external.inspect")
UTIL = require("util")
INPUT = require("input")
ASSETS = require("assets")
CREDITS = require("base.credits")
LEVEL = require("level")
VECTOR = require("external.brinevector")

MENU_INPUT = require("menu_input")
MC = require("base.menu_classes")
MENU = require("base.menu")
INTRO = require("intro")

SPAWNER = require("spawner")
GAME = require("game")

function love.load ()
	if IS_MOBILE then
		love.window.setFullscreen(true)
	end
	LK.setKeyRepeat(true)
	INTRO.init(MENU.init)
	MENU.draw_bg = require("menu_bg")
	math.randomseed(love.timer.getTime())
end

love.draw = MENU.draw
love.resize = MENU.resize
