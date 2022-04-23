local w, h = LG.getWidth(), LG.getHeight()
ASSETS.deco_bone:setWrap("repeat", "repeat")
quad = love.graphics.newQuad(0, 0, w + 128, h + 128, 64, 64)

return function ()
	w, h = LG.getWidth(), LG.getHeight()
	local x, y = (love.timer.getTime() * 100 % 64) - 64, (love.timer.getTime() * 100 % 64) - 64
	LG.setColor(0, 0, 0)
	LG.rectangle("fill", 0, 0, w, h)
	LG.setColor(1, 1, 1)
	love.graphics.draw(ASSETS.deco_bone, quad, x, y, 0, 1,1)
end

