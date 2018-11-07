local Player = {}

function Player:new ( obj )
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

function Player:spawn( x, y )
	-- Constructor
	x = x or display.contentCenterX
	y = y or display.contentHeight - 20

	self.playerShape = display.newImage( "kenney_sportspack/PNG/Green/characterGreen (1).png", x, y )
	self.racketShape = display.newImage( "kenney_sportspack/PNG/Equipment/racket_metal.png", x + 30, y - 15 )

	self.playerShape:scale( 1.5, 1.5 )
	self.playerShape:rotate( 270 )
end

function Player:move( x )
	-- Legacy code from old play style
	self.playerShape.x = x - 30
	self.racketShape.x = x
end

function Player:swing( )
	-- Animate player's racket
	transition.to( self.racketShape, {time = 100, rotation = -45} )
	transition.to( self.racketShape, {time = 200, delay = 100, rotation = 0} )
end

function Player:setAlpha( alpha )
	-- Adjust the alpha of both sprites
	self.playerShape.alpha = alpha
	self.racketShape.alpha = alpha
end

function Player:remove(  )
	-- Common destructor
	self.playerShape:removeSelf( )
	self.playerShape = nil

	self.racketShape:removeSelf( )
	self.racketShape = nil
	
	self = nil
end

return Player