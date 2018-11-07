local composer = require('composer')
local scene = composer.newScene()
local widget = require('widget')

-- Display group used to clear text upon removal of scene
local textGroup
 
function scene:create( event )
	local sceneGroup = self.view

	-- Commonly used coordinates
		local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

	-- BACGROUND --
		local background = display.newRect(sceneGroup, 0, 0, 570, 600)
		background.fill = {
		type = 'gradient',
		color1 = {8/255, 158/255, 0/255},
		color2 = {104/255, 183/255, 95/255}
		}

		background.x = _W / 2
		background.y = _H / 2

	-- TITLE --
		local titleGroup = display.newGroup()
		titleGroup.x, titleGroup.y = _CX, 50
		sceneGroup:insert( titleGroup )

		local title = display.newText( { 
		parent = titleGroup, 
		text = "Options", 
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		align = 'center'} )

		-- Animate the title into place
		transition.from( title, {time = 500, delay = 1, y = 400, transition = easing.outExpo} )

	-- BACK BUTTON --
		self.backButton = widget.newButton( {
		defaultFile = 'uipack_fixed/PNG/green_boxCheckmark.png',
		--overFile = 'uipack_fixed/PNG/blue_button02.png',
		width = 50, height = 50,
		x = 35, y = _H + 5,
		onRelease = function ( )
		composer.gotoScene( 'scenes.menu', {time = 200, effect = 'slideRight', params = {currentLevel = 1}} )
		end } )

	sceneGroup:insert( self.backButton )

end

function scene:show( event )
 
	 local sceneGroup = self.view
	 local phase = event.phase
 
	 if ( phase == "will" ) then
			-- Called when the scene is still off screen (but is about to come on screen).
	 elseif ( phase == "did" ) then
			-- Called when the scene is now on screen.
			-- Insert code here to make the scene come alive.
			-- Example: start timers, begin animation, play audio, etc.
	 end
end
 
function scene:hide( event )
 
	 local sceneGroup = self.view
	 local phase = event.phase
 
	 if ( phase == "will" ) then
			-- Called when the scene is on screen (but is about to go off screen).
			-- Insert code here to "pause" the scene.
			-- Example: stop timers, stop animation, stop audio, etc.
	 elseif ( phase == "did" ) then
			-- Called immediately after scene goes off screen.
	 end
end

function scene:destroy( event )
	 local sceneGroup = self.view
	 titleGroup:removeSelf()
	 optionsGroup:removeSelf( )
	 playGroup:removeSelf( )
	 creditText = nil
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene