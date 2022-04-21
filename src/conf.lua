function love.conf(t)
	t.version = "11.0"
	t.window.title = "autonomy" --no need to change this, it's set to the name of the folder by make/sed
	t.window.width = 800
	t.window.height = 600
	-- t.window.fullscreen = 0
	t.window.vsync = 0
	t.window.resizable = true
	t.window.msaa = 0
end
