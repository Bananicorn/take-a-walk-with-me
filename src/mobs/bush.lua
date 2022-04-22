local Bush = {}
Bush.__index = Bush
setmetatable(Bush, Dog_Target)

function Bush:create (x, y, map)
	local target = {}
	setmetatable(target, Bush)
	target.sprite = ASSETS.bush
	target:init_default_value(x, y, map)
	target:init_target_value(1, 5)
	return target
end

return Bush

