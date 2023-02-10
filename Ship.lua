Ship = {
	image = love.graphics.newImage("images/shipn1.png"),
	width = 50, height = 50, shoot_timer = 0,
	bullet_list = {}
}

function Ship:new ()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

Ship.x = 400
Ship.y = 600 - Ship.height

function Ship:move(x, y, dt)
	self.x = self.x + (x or 0) * dt
	self.y = self.y + (y or 0) * dt
end

function Ship:draw ()
	love.graphics.setColor(20, 180, 180)
	love.graphics.draw(self.image, self.x, self.y, _, _, _, 25)
end

return Ship
