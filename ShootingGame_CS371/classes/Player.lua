local soundTable = require('soundTable')
local Bullet = require('classes.Bullet')
local physics = require('physics')
physics.start( )
physics.setGravity(0,0)

-- Default properties
Player = {hitPoints = 5}

-- Constructer
function Player:new ( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

local function onCollision( event )
	if (event.phase == 'began') then
		if (event.other.tag == 'enemy') then
			event.target.po:hit()
			event.other.po:remove()
		end
	end
end

-- Initializes the display object
function Player:spawn( x, y, radius )
	x = x or 150
	y = y or 150
	radius = radius or 15

	self.playerSprite = display.newCircle( x, y, radius )

	-- Attach the parent object to the sprite, because collision is between display objects and not
	-- user tables. The sprite must have acess to it's parent object's functions
	self.playerSprite.po = self
	self.playerSprite.tag = 'player'
	self.hits = 0

	physics.addBody( self.playerSprite, 'dynamic', { isSensor = true } )
	self.playerSprite:addEventListener( 'collision', onCollision )
end

-- Mutator for the player's x position
function Player:move( x )
	self.playerSprite.x = x
end

-- Initialzes a bullet and fires it
function Player:fire( )
	local bullet = Bullet:new()
	bullet:spawn( self.playerSprite.x, self.playerSprite.y - self.playerSprite.path.radius - 10, self )
	bullet:shoot( )
end

-- On bullet collision, hurt the player
function Player:hit(  )
	self.hitPoints = self.hitPoints - 1
	
	if self.hitPoints == 0 then
		-- If dead, remove the player
		audio.play( soundTable['explodeSound'] )
		print('Death')
		self:remove()
	else
		audio.play( soundTable['hitSound'] )
		print('Ouch!')
	end
end

-- Increment the hits counter
function Player:addHit(  )
	self.hits = self.hits + 1
end

-- Accessor for the player's stats
function Player:getStats(  )
	return self.hitPoints, self.hits
end

-- Deconstructor
function Player:remove(  )
	if self.playerSprite ~= nil then
		self.playerSprite:removeSelf()
		self.playerSprite = nil
	end
	self = nil
end

return Player