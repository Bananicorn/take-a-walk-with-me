local Bone = {}
Bone.__index = Bone
setmetatable(Bone, Pickup)

function Bone:create (x, y, map, dog)
	local bone = {}
	setmetatable(bone, Bone)
	bone:init_default_value(x, y, map)
	--bone.sprite = ASSETS.bone
	return bone
end

function Bone:pickup_action (player)
end

return Bone

