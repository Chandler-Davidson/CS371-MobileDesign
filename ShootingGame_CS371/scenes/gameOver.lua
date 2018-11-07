local composer= require('composer')
local widget = require('widget')

local scene = composer.newScene()
 
function scene:create( event )
	local sceneGroup = self.view

	-- Commonly used coordinates
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

	-- BACGROUND --
		local background = display.newRect(sceneGroup, 0, 0, 570, 600)
		background.x = _W / 2
		background.y = _H / 2
		background.alpha = 0
		background.isHitTestable = true

		-- Disable any touch events outside of buttons
		background:addEventListener("touch", function() return true end)
		background:addEventListener("tap", function() return true end)

	-- TITLE --
		local titleGroup = display.newGroup()
		titleGroup.x, titleGroup.y = _CX, 75
		sceneGroup:insert( titleGroup )

		local title = display.newText( { 
		parent = titleGroup, 
		text = event.params.text, 
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		align = 'center'} )

	-- REPLAY BUTTON --
		-- Start the game
		self.playButton = widget.newButton( {
		defaultFile = 'uipack_fixed/PNG/blue_button04.png',
		overFile = 'uipack_fixed/PNG/blue_button05.png',
		width = 120, height = 60,
		x = _CX, y = _CY + 100,
		label = ' Replay', labelAlign = 'center',
		font = "kenvector_future_thin.ttf", fontSize = 20,
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = function ( )
			composer.removeScene( 'scenes.game' )
			composer.gotoScene( 'scenes.game', {time = 200, effect = 'slideRight'} )
		end } )
		sceneGroup:insert( self.playButton )

	-- MAIN MENU BUTTON
		-- Go back to the menu
		self.menuButton = widget.newButton( {
		defaultFile = 'uipack_fixed/PNG/blue_button04.png',
		overFile = 'uipack_fixed/PNG/blue_button05.png',
		width = 130, height = 60,
		x = _CX, y = _CY + 200,
		label = ' Main Menu', labelAlign = 'center',
		font = "kenvector_future_thin.ttf", fontSize = 20,
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = function ( )
			composer.removeScene( 'scenes.game' )
			composer.gotoScene( 'scenes.menu', {time = 500, effect = 'slideUp'})
		end } )
		sceneGroup:insert( self.menuButton )
end
 

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end
 
 
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end
 
 
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