local options = {
	data = nil
}
options.__index = options

function options:save ()
	JUPITER.save(self.data)
end

function options:default_data (filename)
	return {
		_fileName = filename,
		screen_resolution = [800, 600],
		background_effects = true,
	}
end

function options:load ()
	local filename = "options.sav"
	self.data = JUPITER.load(filename)
	if not self.data then
		self.data = self:default_data(filename)
		self:save()
	end
end

function options:set_option (name, value)
end

function options:init ()
	self:load()
	self:set_initial_volume()
end

return options
