local special_entries = {
	ip_address = MC.textinput:create(
		"127.0.0.1",
		15
	)
}

local menu_entries = {
	special_entries = special_entries,
	main = {
		MC.label:create("Take a walk with me"),
		MC.entry:create(
			"Start",
			function ()
				GAME.init()
			end
		),
		MC.link:create(
			"Options",
			"options"
		),
		MC.entry:create(
			"Credits",
			function ()
				CREDITS.init()
			end
		),
		MC.entry:create(
			"Exit",
			function ()
				love.event.quit()
			end
		),
	},
	options = {
		MC.back:create("Back")
	}
}

return menu_entries
