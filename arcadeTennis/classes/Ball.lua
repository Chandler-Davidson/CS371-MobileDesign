local physics = require('physics')
physics.start( )
physics.setGravity( 0, 0 )

-- Default parameters
local Ball = { moveSpeedX = 100, moveSpeedY = 100 }

-- Default constructor
function Ball:new( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

-- Hand the collision
local function onCollision( event )
	local other = event.other
	local ball = event.target.parentObject

	-- Start of collision
	if ( event.phase == 'began' ) then

		-- Within the enemy's reach
		if ( other.tag == 'enemyRacket' and ball.isHittable ) then

			-- Swing regardless
			other.parentObject:swing( )

			-- Calculate hit based on difficulty
			if ( other.parentObject:isGoingToHit( ) ) then

				-- Continue
				ball:hit( )
			else
				-- Human won
				ball._scene:roundOver( true )
			end

		-- Ball went past human
		elseif ( other.tag == 'ballBounds' ) then

			-- Enemy won
			ball:remove( )
			ball._scene:roundOver( false )

		-- Set hit property
		elseif ( other.tag == 'hitBounds' ) then
			ball.isHittable = true
		end

	-- End of collision
	elseif ( event.phase == 'ended' ) then

		-- Set hit property
		if ( other.tag == 'hitBounds' ) then
			ball.isHittable = false
		end
	end
end

-- Create image and define properties
function Ball:spawn( scene, x, y )
	self.shape = display.newImage( "kenney_sportspack/PNG/Equipment/ball_tennis1.png", x, y)
	self.shape:scale( 1.5, 1.5 )

	physics.addBody( self.shape, 'dynamic' )
	self.shape.isFixedRotation = true 	-- shape is a square, that looks like a circle
	self.shape.parentObject = self	-- Used to acess the parent functions

	self.shape:addEventListener( 'collision', onCollision )

	-- Link to current scene
	self._scene = scene

	-- Ball is within hitBounds
	self.isHittable = false

	-- Start movement
	self:hit()
end

-- Check if ball is still in play
function Ball:inBounds(  )
	return self.shape.x < 320 and self.shape.x > 0
end

-- Get the current location
function Ball:getLocation(  )
	return self.shape.x
end

-- Change the direction and apply a random speed 
function Ball:hit( )
	local ballSound = audio.loadSound( 'sounds/kenney_uiaudio/Audio/rollover2.ogg' )
	audio.play( ballSound )


	local dx, dy = self.shape:getLinearVelocity( )

	-- Start of the round
	if dy == 0 then
		-- Assign a random speed for serve, eliminates patterning
		dx = math.random(-100, self.moveSpeedX)
		dy = self.moveSpeedY

	-- Hit by a player
	else
		-- Hit the ball in a random direction
		dx = math.random(0, 1) 
		if dx == 0 then
			dx = self.moveSpeedX * -1
		else
			dx = self.moveSpeedX
		end

		-- Hit the ball in the opposite direction
		dy = dy * -1
	end

	print('    Ball Velocity: '.. dx .. ', ' .. dy )
	self.shape:setLinearVelocity( dx, dy )
end

function Ball:pause(  )
	self.shape.alpha = 0.5

	self.oldDX, self.oldDY = self.shape:getLinearVelocity( )

	self.shape:setLinearVelocity( 0, 0 )
end

function Ball:play(  )
	self.shape.alpha = 1

	self.shape:setLinearVelocity( self.oldDX, self.oldDY )
	self.oldDX, self.oldDY = nil
end

-- Destructor
function Ball:remove( )
	self.shape:removeSelf( )
	self.shape = nil
	self = nil
end

return Ball