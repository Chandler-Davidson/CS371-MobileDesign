local physics = require('physics')
local timer = require('timer')
local soundTable = require('soundTable')
local Bullet = require('classes.Bullet')

-- Enemy's default properties
local Enemy = {hitPoints = 3, moveSpeed = .5}

-- Constructor
function Enemy:new ( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- On bullet collision, hurt the enemy
function Enemy:hit( )
	self.hitPoints = self.hitPoints - 1
	audio.play( soundTable['hitSound'] )
	
	if self.hitPoints <= 0 then
		audio.play( soundTable['explodeSound'] )
		self:remove()
	end
end

return Enemy








