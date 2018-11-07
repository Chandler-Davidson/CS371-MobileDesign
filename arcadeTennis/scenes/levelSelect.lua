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
		color1 = { 8/255, 158/255, 0/255 },
		color2 = { 104/255, 183/255, 95/255 } }

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

	-- FOREGROUND --
	-- local foregroundGroup = display.newGroup( )
	-- local spriteData = require('spriteSheets')
	-- local UISheet = graphics.newImageSheet( "uipack_fixed/Spritesheet/greySheet.png", spriteData:getUIOptions() )

	-- foregroundGroup.x, foregroundGroup.y = _CX, _CY
	-- local foregroundContainer = display.newImage( foregroundGroup, 'uipack_fixed/PNG/grey_panel.png')

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

	self.leveloneButton = widget.newButton( {
		defaultFile = 'uipack_fixed/PNG/green_button04.png',
		overFile = 'uipack_fixed/PNG/green_button05.png',
		width = 120, height = 60,
		x = display.contentCenterX, y = display.contentCenterY -10,
		label = ' Level 1', labelAlign = 'center',
		font = "kenvector_future_thin.ttf", 
		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1, 0.5 } },
		onRelease = function ( )
			composer.gotoScene( 'scenes.game', {time = 200, effect = 'slideRight', params = {currentLevel =1}} )
		end } )
	sceneGroup:insert( self.leveloneButton )


	self.leveltwoButton = widget.newButton( {
		defaultFile = 'uipack_fixed/PNG/green_button04.png',
		overFile = 'uipack_fixed/PNG/green_button05.png',
		width = 120, height = 60,
		x = display.contentCenterX, y = display.contentCenterY + 70,
		label = 'Level 2', labelAlign = 'center',
		font = "kenvector_future_thin.ttf", 
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = function ( )
			composer.gotoScene( 'scenes.game', {time = 200, effect = 'slideRight', params = {currentLevel = 2}} )
		end } )
	sceneGroup:insert( self.leveltwoButton )


	self.levelthreeButton = widget.newButton( {
		defaultFile = 'uipack_fixed/PNG/green_button04.png',
		overFile = 'uipack_fixed/PNG/green_button05.png',
		width = 120, height = 60,
		x = display.contentCenterX, y = display.contentCenterY +150,
		label = 'Level 3', labelAlign = 'center',
		font = "kenvector_future_thin.ttf", 
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = function ( )
			composer.gotoScene( 'scenes.game', {time = 200, effect = 'slideRight', params = {currentLevel = 3}} )
		end } )
	sceneGroup:insert( self.levelthreeButton )
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
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene