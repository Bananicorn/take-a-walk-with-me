local Fire_Hydrant = {}
Fire_Hydrant.__index = Fire_Hydrant
setmetatable(Fire_Hydrant, Dog_Target)

function Fire_Hydrant:create (x, y, map)
	local target = {}
	setmetatable(target, Fire_Hydrant)
	target.sprite = ASSETS.fire_hydrant
	target.tint_color = {1, 0, 0}
	target:init_default_value(x, y, map)
	target:init_target_value(1, 5)
	return target
end

return Fire_Hydrant
