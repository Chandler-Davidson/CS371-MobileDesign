local soundTable = require('soundTable')

-- Default properties
Bullet = { bulletSpeed = 0.8 }

-- Constructor
function Bullet:new ( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Bullet collision handler
local function onHit( event )
	-- Only handle collision once
	if (event.phase == 'began') then

		-- Remove the bullet
		event.target.po:remove( )

		if event.other.tag == 'enemy' then
			-- Hurt the character
			event.other.po:hit()

			-- 
			if event.target.po.attachedPlayer then
				event.target.po.attachedPlayer:addHit()
			end
		elseif event.other.tag == 'player' then
			event.other.po:hit()
		end
	end
end

-- Initializes the display object
function Bullet:spawn( x, y, player )
	self.bulletSprite = display.newCircle( x, y, 5 )
	self.bulletSprite:setFillColor( 0, 1, 0 )
	self.bulletSprite.po = self
	self.attachedPlayer = player

	physics.addBody( self.bulletSprite, 'dynamic' )
	physics.setGravity( 0, 0 )

	-- Bullet handles all collisions
	self.bulletSprite:addEventListener( 'collision', onHit )

	-- Play required sound
	audio.play( soundTable['shootSound'] )
end

function Bullet:shoot( o )
	if o == nil then
		-- If shot by player, go up
		self.bulletSprite:applyForce( 0, -self.bulletSpeed)
	else
		-- If shot by an enemy, draw line between enemy and player
		-- Draw a line between enemy and character, shooting the bullet in the direction
			-- New unit vector between two points
			-- Multiply by speed

		-- self.bulletSprite:setLinearVelocity( (self.bulletSprite.x - o.playerSprite.x) * self.bulletSpeed, (self.bulletSprite.y - o.playerSprite.x) * self.bulletSpeed)

		-- transition.to (self.bulletSprite, { x = 160, y = 600, time = 800 })
	end
end

function Bullet:shootDown(  )
	self.bulletSprite:applyForce( 0, self.bulletSpeed)
end

-- Deconstructor
function Bullet:remove(  )
	self.bulletSprite:removeSelf( )
	self.bulletSprite = nil
	self = nil
end

return Bullet