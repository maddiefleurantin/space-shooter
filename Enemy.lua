Enemy = {
	image = love.graphics.newImage("images/shipn1.png"),
	width = 50, height = 50,
}
function Enemy:new (x, y)
	local obj = {x=x, y=y}
	setmetatable(obj, self)
	self.__index = self
	return obj
end
function Enemy:update (dt)
	self.y = self.y + 150 * dt
end
function Enemy:draw ()
	love.graphics.setColor(180, 90, 20)
	love.graphics.draw(self.image, self.x, self.y, math.rad(180), _, _, 25)
end

return Enemy
