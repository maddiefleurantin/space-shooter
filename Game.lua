local Ship = require "Ship"
local Enemy = require "Enemy"
local Bullet = require "Bullet"


Game = {}
-- the game logic will be there in the future.
function Game:load (args)
	ship = Ship:new()
	friendly_bullet = Bullet:new()

	enemy_bullet = Bullet:new()
	function enemy_bullet:update (dt)
		self.y = self.y - 600 * dt
	end
	function enemy_bullet:draw ()
		love.graphics.setColor(255, 55, 55)
		love.graphics.draw(self.image, self.x, self.y, _, _, _, 5, 10)
	end

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

function Game:update (dt)
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
			table.insert(enemy_list,Enemy:new(love.math.random(25, 775), -100))
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

function Game:draw ()
	for i,v in ipairs(enemy_list) do
		v:draw()
	end

	for i,v in ipairs(ship.bullet_list) do
		v:draw()
	end
	ship:draw()
end

return Game
