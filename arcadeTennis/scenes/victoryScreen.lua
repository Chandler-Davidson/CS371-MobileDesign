local Player = require('classes.Player')
local widget = require('widget')
local composer = require( "composer" )
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
	local sceneGroup = self.view

	-- Commonly used coordinates
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

	-- BACKGROUND --
		-- Scene Background --
		local background = display.newRect(sceneGroup, 0, 0, 570, 600)
		background.fill = {
			type = 'gradient',
			color1 = { 8/255, 158/255, 0/255 },
			color2 = { 104/255, 183/255, 95/255 } }

		background.x = _W / 2
		background.y = _H / 2

	-- TITLE --
	local title = display.newText( { 
		parent = sceneGroup,
		x = _CX, y = 50,
		text = "Victory!", 
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		align = 'center'} )

	-- List students' names
	local creditText = display.newText( {
		parent = titleGroup,
		parent = sceneGroup,  
		text = "Jake Clough\nMartin Richards\nChandler Davidson\nAssets: Kenney.nl",
		x = 95, y = _H, 
		font = "kenvector_future_thin.ttf", 
		fontSize = 15 } )

	-- PLAY BUTTON --
	-- Start the game, using a smooth transition
	self.playButton = widget.newButton( {
		parent = sceneGroup,
		defaultFile = 'uipack_fixed/PNG/blue_button04.png',
		overFile = 'uipack_fixed/PNG/blue_button02.png',
		width = 120, height = 60,
		x = _CX, y = _CY,
		label = ' Again!', labelAlign = 'center',
		font = 'kenvector_future_thin.ttf', fontSize = 20,
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = function ( )
			audio.play( clickSound )
			composer.gotoScene( 'scenes.game', {time = 200, effect = 'slideRight', params = {currentLevel = 1}} )
		end } )
	sceneGroup:insert( self.playButton )


	-- OPTIONS BUTTON
	-- Change settings, using a smooth transition
	self.optionsButton = widget.newButton( {
		parent = sceneGroup,
		defaultFile = 'uipack_fixed/PNG/blue_button04.png',
		overFile = 'uipack_fixed/PNG/blue_button02.png',
		width = 130, height = 60,
		x = _CX, y = _CY + 100,
		label = ' Menu', labelAlign = 'center',
		font = 'kenvector_future_thin.ttf', fontSize = 20,
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = function ( )
			audio.play( clickSound )
			composer.gotoScene( 'scenes.menu', {time = 500, effect = 'slideUp', params = {} })
		end } )
	sceneGroup:insert( self.optionsButton )
 
	player = Player:new()
	player:spawn( _CX, _H - 20 )

	-- Bar to control player's movement
		self.controlBar = display.newRect( sceneGroup, _CX, _H - 20, _W, 100 )
		self.controlBar:setFillColor( 1, 1, 1, 0.5 )
		transition.to( self.controlBar, { time = 1000, alpha = 0.01 } )

end
 
 
-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	-- Move the player's position
	local function move( event )

	-- Add dramatic movement towards outside
		if player.playerShape then
			if event.phase == "began" then		
				player.markX = player.playerShape.x
			elseif event.phase == "moved" then	 	
				local x = (event.x - event.xStart) + player.markX	 	

				if (x <= 20 + player.playerShape.width/2) then
					player.playerShape.x = 20+player.playerShape.width/2;
					player.racketShape.x = 50+player.racketShape.width/2

				elseif (x >= display.contentWidth-20-player.playerShape.width/2) then
					player.playerShape.x = display.contentWidth-20-player.playerShape.width/2;
					player.racketShape.x = display.contentWidth+10-player.racketShape.width/2;

				else
					player.playerShape.x = x;	
					player.racketShape.x = x + 30	
				end
			end
		end
	end

	self.controlBar:addEventListener( 'touch', move )
 
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		Runtime:addEventListener( 'tap', function (  )
			player:swing()
		end )
	end
end
 
 
-- hide()
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
 
		player:remove()

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end
 
 
-- destroy()
function scene:destroy( event )
 
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene