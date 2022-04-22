local Bone = {}
Bone.__index = Bone
setmetatable(Bone, Pickup)

function Bone:create (x, y, map, spawner)
	local bone = {}
	setmetatable(bone, Bone)
	bone.sprite = ASSETS.bone
	bone.spawner = spawner
	bone:init_default_value(x, y, map)
	spawner.powerups_present = spawner.powerups_present + 1
	return bone
end

function Bone:pickup_action (player)
	self.to_remove = true
	player.dog.stress = math.max(0, player.dog.stress - 50)
	self.spawner.powerups_present = self.spawner.powerups_present - 1
end

return Bone

