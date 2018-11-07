local physics = require('physics')
local Player = require('classes.Player')

local Enemy = Player:new( { difficulty = 7 } )

local colors = { 'Blue', 'Red', 'White' }

-- Constructs a new enemy object
function Enemy:spawn( x, y, level )
	-- Define sprites
	self.playerShape = display.newImage( "kenney_sportspack/PNG/" .. colors[level] .. "/character" .. colors[level] .. " (1).png", x, y )
	self.racketShape = display.newImage( "kenney_sportspack/PNG/Equipment/racket_metal.png", x - 30, y + 15 )

	-- Adjust body sprite
	self.playerShape:scale( 1.5, 1.5 )
	self.playerShape:rotate( 90 )
	self.playerShape.tag = 'enemy'

	-- Adjust racket sprite
	self.racketShape:rotate( 180 )
	self.racketShape.tag = 'enemyRacket'

	-- Attach physics used for collision
	physics.addBody( self.racketShape, "static", { isSensor=true } )
	self.racketShape.parentObject = self
end

-- Swing animation
function Enemy:swing ( )
	transition.to( racketShape, {time = 100, rotation = 135} )
	transition.to( racketShape, {time = 200, delay = 100, rotation = 180} )
end

function Enemy:move( x )
	self.playerShape.x = x + 30
	self.racketShape.x = x
end

function Enemy:isGoingToHit(  )
	rand = math.random( 0, 10 )

	local attempt = self.difficulty > rand

	print( 'Hit Number: ' .. rand .. ", Difficulty: " .. self.difficulty )

	return attempt
end

return Enemy