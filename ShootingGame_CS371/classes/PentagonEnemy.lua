local Enemy = require('classes.Enemy')
local physics = require('physics')
physics.start( )

-- PentagonEnemy extends Enemy, altering default parameters
local PentagonEnemy = Enemy:new( { hitPoints = 3, moveSpeed = .3, fireInterval = 2000 } )

local function onCollision( event )
	if event.other.tag == 'enemyBounds' then
		event.target.po:remove( )
	end
end

-- Initializes the display object
function PentagonEnemy:spawn( x )
	x = x or 0
	y = 0

	self.enemySprite = display.newPolygon( x, y, {0,15, 15,8, 10,-15, -10,-15, -15, 8} )
	self.enemySprite:setFillColor( 1, 1, 0 )
	physics.addBody( self.enemySprite, 'dynamic', { isSensor = true, shape = {0,15, 15,8, 10,-15, -10,-15, -15, 8} } )
	self.enemySprite:addEventListener( 'collision', onCollision )

	-- Connects the displayObject to the parentObject
	self.enemySprite.po = self
	self.enemySprite.tag = 'enemy'

	self._timer = timer.performWithDelay( self.fireInterval, function (  )
		if self.enemySprite then
			self:fire()
		end
	end, -1 )
end

-- Initialze a bullet and fire downwards
function PentagonEnemy:fire( )
	local bullet = Bullet:new()
	bullet:spawn( self.enemySprite.x, self.enemySprite.y + 25 )
	bullet:shootDown()
end

-- Move the enemy at a constant speed, passed as a table
function PentagonEnemy:move( )
	transition.to( self.enemySprite, { y = 600, time = 50000 } )
end

-- Deconstructor
function Enemy:remove(  )
	self.enemySprite:removeSelf()
	self.enemySprite = nil
	self = nil
end


return PentagonEnemy