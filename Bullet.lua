Bullet = {}
function Bullet:new (x, y)
	local obj = {
		x=x, y=y,
		image = love.graphics.newImage("images/bulletn1.png"),
		width = 10, height = 10
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end
function Bullet:update (dt)
	self.y = self.y - 600 * dt
end
function Bullet:draw ()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, self.x, self.y, _, _, _, 5)
end

return Bullet
