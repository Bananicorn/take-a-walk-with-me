local Bone = {}
Bone.__index = Bone
setmetatable(Bone, Pickup)

function Bone:create (x, y, map, dog)
	local bone = {}
	setmetatable(bone, Bone)
	bone.sprite = ASSETS.bone
	bone:init_default_value(x, y, map)
	return bone
end

function Bone:pickup_action (player)
	self.to_remove = true
	player.dog.stress = math.max(0, player.dog.stress - 50)
end

return Bone

