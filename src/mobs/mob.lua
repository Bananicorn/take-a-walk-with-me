local Mob = {}
Mob.__index = Mob

function Mob:create (x, y, map)
	local mob = {
		x = x,
		y = y,
		size = 10,
		map = map,
	}
	setmetatable(mob, Mob)
	mob:init_physics()
	return mob
end

function Mob:update (dt)
end

function Mob:init_physics ()
end

function Mob:draw ()
	local x, y = self.map:tile_pos_to_screen(self.x, self.y)
	LG.setColor(1, 0, 0)
	LG.circle("fill", x, y, 10)
end

return Mob
