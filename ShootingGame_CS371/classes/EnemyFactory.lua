local timer = require('timer')

local TriangleEnemy = require('classes.TriangleEnemy')
local PentagonEnemy = require('classes.PentagonEnemy')

-- Default properties
	-- enemies = # of enemies to spawn
	-- gameTime = total length of game to survive in seconds
EnemyFactory = { pentagonChance = 15, triangleChance = 15, gameTime = 180 }

-- Constructor
function EnemyFactory:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Initializes the factory
function EnemyFactory:spawn( scene, player )
	self.playing = true
	self._enemies = {}
	self._player = player
	self._scene = scene

	self.timeElapsed = 0

	-- Main enemy loop --
	timer.performWithDelay( 1000, function (  )
		if ( self.playing ) then
			self.timeElapsed = self.timeElapsed + 1

			if (self.timeElapsed >= self.gameTime) then
				self.playing = false
				self:remove()
				scene:endGame()
				-- End the game
			end

			-- Random percent to determine if enemy should spawn
			local randPercT = math.random( 0, 100 )
			local randPercP = math.random( 0, 100 )

			-- Random position for enemy's spawn
			local randPos = math.random( 0, display.contentWidth )

			if (randPercP < self.pentagonChance) then
				local enemy = PentagonEnemy:new()
				enemy:spawn( randPos )
				table.insert( self._enemies, enemy )
				enemy:move()
			end

			if (randPercT < self.triangleChance) then
				local enemy = TriangleEnemy:new()
				enemy:spawn( self._player, randPos )
				table.insert( self._enemies, enemy )

				if (self._player.playerSprite) then
					local location = { x = self._player.playerSprite.x, y = self._player.playerSprite.y }
					enemy:move( location )
				end
			end
		end

	end, -1 )

	timer.performWithDelay( 100, function (  )
		-- shoot bullets from here
	end)

	-- If updating movement continuously
-- 	timer.performWithDelay( 1000, function (  )
-- 		print('1')
-- 		for i=1, #self._enemies do
-- 			print('2')
-- 			if self._enemies[i].enemySprite.tag == 'enemy' then
-- 				print('3')
-- 				self._enemies[i]:move(self._player)
-- 			end
-- 		end
-- 	end, -1)
end

function EnemyFactory:pause(  )
	self.playing = false
end

function EnemyFactory:play(  )
	self.playing = true
end

function EnemyFactory:remove(  )
	for i=1, #self._enemies do
		-- self._enemies[i]:remove()
		print("Removing enemy["..i.."]")
	end


	print('removed')

	self = nil
end

return EnemyFactory
