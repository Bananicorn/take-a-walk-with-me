local LG = love.graphics
local Dimetric_Map = {}
local error_prefix = "Dimetric Map Error: "
local fallback_tilesize = 64
local fallback_elevation_unit = 20
Dimetric_Map.__index = Dimetric_Map

function Dimetric_Map:create(level, elevation_unit)
	self:check_level_integrity(level)
	local map = {
		tilesize = level.tilesize or fallback_tilesize,
		elevation_unit = level.elevation_unit or fallback_elevation_unit,
		width = level.width or 1,
		height = level.height or 1,
		offset_x = 0,
		offset_y = 0,
		elevation_map = level.elevation_map,
		tile_map = level.tile_map,
		sprites = Dimetric_Map:get_sprites_from_level(level),
		objects = {},
	}
	setmetatable(map, Dimetric_Map)
	return map
end

function Dimetric_Map:get_sprites_from_level(level)
	local sprites = {}
	local spritesheet = level.spritesheet
	local size = level.tilesize or fallback_tilesize
	local tiles_x = math.floor(spritesheet:getWidth() / size)
	local tiles_y = math.floor(spritesheet:getHeight() / (size * .75))
	local size_normalized_x = 1 / tiles_x
	local size_normalized_y = 1 / tiles_y
	for y = 0, tiles_y - 1 do
		local offset_y = y * size_normalized_y
		for x = 0, tiles_x - 1 do
			local offset_x = x * size_normalized_x
			local mesh = {
				top = LG.newMesh(
					{
						{--top center
							size / 2, 0,
							offset_x + size_normalized_x / 2, offset_y
						},
						{--left
							0, size / 4,
							offset_x, size_normalized_y / 3 + offset_y
						},
						{--bottom center
							size / 2, size / 2,
							offset_x + size_normalized_x / 2, size_normalized_y / 1.5 + offset_y
						},
						{--right
							size, size / 4,
							offset_x + size_normalized_x, size_normalized_y / 3 + offset_y
						},
					},
					"fan",
					"static"
				),
				left = LG.newMesh(
					{
						{--top left
							0, size / 4,
							offset_x, size_normalized_y / 3 + offset_y
						},
						{--bottom left
							0, size / 2,
							offset_x, size_normalized_y / 1.5 + offset_y
						},
						{--bottom right
							size / 2, size / 1.33333,
							offset_x + size_normalized_x / 2, size_normalized_y + offset_y
						},
						{--top right
							size / 2, size / 2,
							offset_x + size_normalized_x / 2, size_normalized_y / 1.5 + offset_y
						},
					},
					"fan",
					"static"
				),
				right = LG.newMesh(
					{
						{--top right
							size, size / 4,
							offset_x + size_normalized_x, size_normalized_y / 3 + offset_y
						},
						{--bottom right
							size, size / 2,
							offset_x + size_normalized_x, size_normalized_y / 1.5 + offset_y
						},
						{--bottom left
							size / 2, size / 1.33333,
							offset_x + size_normalized_x / 2, size_normalized_y + offset_y
						},
						{--top left
							size / 2, size / 2,
							offset_x + size_normalized_x / 2, size_normalized_y / 1.5 + offset_y
						},
					},
					"fan",
					"static"
				)
			}
			mesh.top:setTexture(spritesheet)
			mesh.left:setTexture(spritesheet)
			mesh.right:setTexture(spritesheet)
			sprites[#sprites + 1] = mesh
		end
	end
	return sprites
end

function Dimetric_Map:check_level_integrity(level)
	if (not level) then
		error(error_prefix .. "No level provided")
	end
	if (#level.elevation_map ~= level.width * level.height) then
		error(error_prefix .. "Level elevation map does not match width and height")
	end
	if (#level.tile_map ~= level.width * level.height) then
		error(error_prefix .. "Level tile_map does not match width and height")
	end
end

function Dimetric_Map:get_screen_width()
	return self.tilesize * self.width
end

function Dimetric_Map:get_screen_height()
	return self.tilesize * self.height / 2
end

function Dimetric_Map:get_sprite_index(x, y)
	local x = x + 1
	return y * self.width + x
end

function Dimetric_Map:get_elevation(x, y)
	return self.elevation_map[self:get_sprite_index(x, y)]
end

function Dimetric_Map:get_sprite_type(x, y)
	return self.tile_map[self:get_sprite_index(x, y)]
end

function Dimetric_Map:is_tile_in_view(width, height, tile_x, tile_y, elevation)
	local x, y = self:tile_pos_to_screen(tile_x, tile_y)
	local tilesize = self.tilesize
	return
		x > -self.tilesize / 2 and
		y > -self.tilesize / 2 and
		x < width + self.tilesize / 2 and
		y < height + self.tilesize / 2 + elevation * self.elevation_unit
end

function Dimetric_Map:screen_to_tile_pos(x, y)
	local ox, oy = self.offset_x, self.offset_y
	x = x - ox
	y = y - oy
	local size = self.tilesize
	local dx = (y * 2 + x) / size
	local dy = (y * 2 - x) / size
	return dx, dy
end

function Dimetric_Map:tile_pos_to_screen(x, y)
	local ox, oy = self.offset_x, self.offset_y
	local size = self.tilesize
	local dx = (x / 2 - y / 2) * size
	local dy = (y / 4 + x / 4) * size
	dx = dx + ox
	dy = dy + oy
	return dx, dy
end

function Dimetric_Map:draw_tile(tile_x, tile_y, elevation, draw_offset_x, draw_offset_y, sprite_type)
	local x, y = self:tile_pos_to_screen(tile_x, tile_y)
	local ox = draw_offset_x or 0
	local oy = draw_offset_y or 0
	x = x + ox
	y = y + oy
	local size = self.tilesize
	local elevation = self.elevation_unit * elevation

	if sprite_type == 0 then
		local outline_top = {
			x, y - elevation,
			x - size / 2, y + size / 4 - elevation,
			x, y + size / 2 - elevation,
			x + size / 2, y + size / 4 - elevation
		}
		LG.setColor(.6, .6, .6)
		LG.polygon("fill", outline_top)
	else
		LG.setColor(1, 1, 1)
		LG.draw(self.sprites[sprite_type].top, x - size / 2, y - elevation)
	end

	if elevation > 0 then
		if sprite_type == 0 then
			local outline_left = {
				x, y + size / 2 - elevation,
				x - size / 2, y + size / 4 - elevation,
				x - size / 2, y + size / 4,
				x, y + size / 2,
			}
			local outline_right = {
				x, y + size / 2 - elevation,
				x + size / 2, y + size / 4 - elevation,
				x + size / 2, y + size / 4,
				x, y + size / 2,
			}
			LG.setColor(.5, .5, .5)
			LG.polygon("fill", outline_left)
			LG.setColor(.7, .7, .7)
			LG.polygon("fill", outline_right)
		else
			LG.setColor(1, 1, 1)
			local block_height = 16
			for i = 0, math.floor(elevation / block_height) do
				LG.draw(self.sprites[sprite_type].left, x - size / 2, y - (elevation - block_height * i))
				LG.draw(self.sprites[sprite_type].right, x - size / 2, y - (elevation - block_height * i))
			end
		end
	end
end

function Dimetric_Map:draw_object(object)
	--as long as we only have a handful of moving objects, that's fine...
	self.objects[math.ceil(object.x) .. '_' .. math.ceil(object.y)] = object
end

function Dimetric_Map:draw(x, y, width, height)
	LG.setColor(1, 1, 1)
	LG.rectangle("fill", x, y, width, height)
	LG.setScissor(x, y, width, height)
	for tx = 0, self.width - 1 do
		for ty = 0, self.height - 1 do
			local elevation = self:get_elevation(tx, ty)
			local object_key = tx .. "_" ..  ty
			if self:is_tile_in_view(width, height, tx, ty, elevation) then
				local sprite_type = self:get_sprite_type(tx, ty)
				self:draw_tile(tx, ty, elevation, x, y, sprite_type)
			end
			if self.objects[object_key] then
				self.objects[object_key]:draw()
				self.objects[object_key] = nil
			end
		end
	end
	LG.setScissor()
end

return Dimetric_Map
