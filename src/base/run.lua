--changed up the regular main loop from https://love2d.org/wiki/love.run
--and implemented this: https://www.fabiensanglard.net/timer_and_framerate/index.php

GLOBAL_TIMESTEP = 1/60
local simulation_time = love.timer.getTime()

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Call update until we're caught up with real time
		local frame_start_time = love.timer.getTime()
		local i = 0
		while simulation_time < frame_start_time do
			love.update(GLOBAL_TIMESTEP)
			simulation_time = simulation_time + GLOBAL_TIMESTEP
			i = i + 1
		end

		if LG.isActive() then
			LG.origin()
			LG.clear(LG.getBackgroundColor())

			if love.draw then love.draw() end

			LG.present()
		end
	end
end

