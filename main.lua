function love.load()
	ship = {
		image = love.graphics.newImage("images/shipn1.png"),
		width = 50, height = 50, shoot_timer = 0,
		bullet_list = {}
	}
	ship.x = 400
	ship.y = 600 - ship.height

	function ship:move(x, y, dt)
		self.x = self.x + (x or 0) * dt
		self.y = self.y + (y or 0) * dt
	end

	function ship:draw ()
		love.graphics.setColor(20, 180, 180)
		love.graphics.draw(self.image, self.x, self.y, _, _, _, 25)
	end
	--==================================================

	enemy = {
		image = love.graphics.newImage("images/shipn1.png"),
		width = 50, height = 50,
	}
	function enemy:new (x, y)
		local obj = {x=x, y=y}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end
	function enemy:update (dt)
		self.y = self.y + 150 * dt
	end
	function enemy:draw ()
		love.graphics.setColor(180, 90, 20)
		love.graphics.draw(self.image, self.x, self.y, math.rad(180), _, _, 25)
	end
	--====================================================

	friendly_bullet = {}
	function friendly_bullet:new (x, y)
		local obj = {
			x=x, y=y,
			image = love.graphics.newImage("images/bulletn1.png"),
			width = 10, height = 10
		}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end
	function friendly_bullet:update (dt)
		self.y = self.y - 600 * dt
	end
	function friendly_bullet:draw ()
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.image, self.x, self.y, _, _, _, 5)
	end
	--===================================================

	enemy_bullet = friendly_bullet:new()
	function enemy_bullet:update (dt)
		self.y = self.y - 600 * dt
	end
	function enemy_bullet:draw ()
		love.graphics.setColor(255, 55, 55)
		love.graphics.draw(self.image, self.x, self.y, _, _, _, 5, 10)
	end
	--====================================================

	function friendlyBulletAndEnemyCollision (friendly_bullet, enemy)
		return friendly_bullet.x - friendly_bullet.width / 2 < enemy.x - enemy.width / 2 + enemy.width
		and friendly_bullet.x - friendly_bullet.width / 2 + friendly_bullet.width > enemy.x - enemy.width / 2
		and friendly_bullet.y < enemy.y
		and friendly_bullet.y + friendly_bullet.height > enemy.y - enemy.height
	end

	enemy_list = {}
	spawn_timer = 0
	spawn_ratio = 0.4
end

function love.update(dt)
	if love.keyboard.isDown("w") then
		ship:move(_, -250, dt)
	end
	if love.keyboard.isDown("s") then
		ship:move(_, 250, dt)
	end
	if love.keyboard.isDown("a") then
		ship:move(-400, _, dt)
	end
	if love.keyboard.isDown("d") then
		ship:move(400, _, dt)
	end

	if ship.x < 25 then
		ship.x = 25
	elseif ship.x > 775 then
		ship.x = 775
	end
	if ship.y < 350 then
		ship.y = 350
	elseif ship.y > 550 then
		ship.y = 550
	end

	spawn_timer = spawn_timer + dt
	if spawn_timer > 0.5 then
		dice = love.math.random(10)
		if dice <= spawn_ratio * 10 then
			table.insert(enemy_list,enemy:new(love.math.random(25, 775), -100))
		end
		spawn_timer = 0
	end
	for i,v in ipairs(enemy_list) do
		v:update(dt)
		if v.y > 650 then
			table.remove(enemy_list, i)
		end
	end

	ship.shoot_timer = ship.shoot_timer + dt
	if ship.shoot_timer > 0.49 then
		table.insert(ship.bullet_list,friendly_bullet:new(ship.x, ship.y))
		ship.shoot_timer = 0
	end
	for i,v in ipairs(ship.bullet_list) do
		v:update(dt)
		for ii,vv in ipairs(enemy_list) do
			if friendlyBulletAndEnemyCollision(v, vv) then
				table.remove(enemy_list, ii)
				table.remove(ship.bullet_list, i)
			end
		end
		if v.y < -10 then
			table.remove(ship.bullet_list, i)
		end
	end
end

function love.draw()
	for i,v in ipairs(enemy_list) do
		v:draw()
	end

	for i,v in ipairs(ship.bullet_list) do
		v:draw()
	end
	ship:draw()
end
