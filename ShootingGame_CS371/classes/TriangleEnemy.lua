local Enemy = require('classes.Enemy')
local physics = require('physics')
local timer = require('timer')
physics.start( )
physics.setGravity( 0, 0 )

-- TriangleEnemy extends Enemy, altering default parameters
local TriangleEnemy = Enemy:new( { hitPoints = 1, moveSpeed = .07, fireInterval = 1000 } )

local function onCollision( event )
	if event.other.tag == 'enemyBounds' then
		event.target.po:remove()
	end
end

-- Initializes the display object
function TriangleEnemy:spawn( player, x )
	x = x or 0
	y = 0

	self.enemySprite = display.newPolygon( x, y, {-15,-15,15,-15,0,15} )
	self.enemySprite:setFillColor( 0, 0, 1 )
	physics.addBody( self.enemySprite, 'dynamic', { isSensor = true, shape = {-15,-15,15,-15,0,15} } )
	self.enemySprite:addEventListener( 'collision', onCollision )

	-- Connects the displayObject to the parentObject
	self.enemySprite.po = self
	self.enemySprite.tag = 'enemy'

	self._timer = timer.performWithDelay( self.fireInterval, function (  )
		if self.enemySprite then
			self:fire( player )
		end
	end, -1 )
end

-- Initialze a bullet and fire it at the player 
function TriangleEnemy:fire( player )
	local bullet = Bullet:new()
	bullet:spawn( self.enemySprite.x, self.enemySprite.y + 25 )
	bullet:shootDown( )
end

-- Move the enemy at a constant speed, passed as a table
function TriangleEnemy:move( o )
	if ( o == nil ) then
		print('Enemy:move() must be passed a table of:\n1. xDestination\n2. yDestination\n3. deltaRoation')
	else	
		o.x = o.x or self.enemySprite.x
		o.y = o.y  + 200 or self.enemySprite.y

	-- 	-- Triangle movement isn't calculated right, needs update.
		local function distanceBetween( pos1, pos2 )
			local factor = { x = pos2.x - pos1.x, y = pos2.y - pos1.y }
			return math.sqrt( ( factor.x * factor.x ) + ( factor.y * factor.y ) )
		end

		local totDist = distanceBetween(self.enemySprite, o)
		local travTime = totDist / self.moveSpeed

		o.time = travTime

		-- local o = {
		-- y = 600,
		-- time = 10000 }

		-- transition.to( self.enemySprite, o )
		
		self.enemySprite.transition = transition.to( self.enemySprite, o )
	end
end

-- Deconstructor
function Enemy:remove(  )
	self.enemySprite:removeSelf()
	self.enemySprite = nil
	self = nil
end

return TriangleEnemy