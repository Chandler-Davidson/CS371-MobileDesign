local composer= require( "composer" )
local timer = require('timer')
local physics = require('physics')
local Player = require('classes.Player')
local EnemyFactory = require('classes.enemyFactory')
 
local scene = composer.newScene()

local player
local enemyFactory
local hits = 0

-- Move function using controlBar
local function move( event )
	-- Add dramatic movement towards outside
	-- if player.playerSprite ~= nil then
	-- 	player:move( event.x )
	if player.playerSprite then
		if event.phase == "began" then		
			player.markX = player.playerSprite.x
		 elseif event.phase == "moved" then	 	
		 	local x = (event.x - event.xStart) + player.markX	 	
		 	
		 	if (x <= 20 + player.playerSprite.width/2) then
			   player.playerSprite.x = 20+player.playerSprite.width/2;
			elseif (x >= display.contentWidth-20-player.playerSprite.width/2) then
			   player.playerSprite.x = display.contentWidth-20-player.playerSprite.width/2;
			else
			   player.playerSprite.x = x;		
			end
		end
	end
end

local function fire( )
	if player and player.playerSprite then
		player:fire()
	end
end


function scene:create( event ) 
	local sceneGroup = self.view

	-- Commonly used coordinates 
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

	-- SCENE ENVIROMENT -- 
		-- Draw the sky sprite
		local background = display.newImage( sceneGroup, 'images/sky.png', _CX, _CY ) 

		-- On collision with Bullet, remove bullet. Avoid memory leak.
		local bulletBounds = display.newRect( sceneGroup, _CX, -50, _W, 10 )
		physics.addBody( bulletBounds, 'static' )

		enemyBounds = display.newRect( sceneGroup, _CX, 600, _W, 10 )
		physics.addBody( enemyBounds, 'static' )
		enemyBounds.tag = 'enemyBounds'

		-- Rect to control player's position
		local controlBar = display.newRect( sceneGroup, _CX, _H - 65, _W, 70 )
		controlBar:setFillColor( 1, 1, 1, 0.5 )

		-- Add listeners for movement and combat
		controlBar:addEventListener( 'touch', move )
		Runtime:addEventListener( 'tap', fire )

		-- Display the current HP of the player
		local hpDispalay = display.newText( {
			parent = sceneGroup,
			text = "HP: " .. 5, 
			x = 60, y = -10, 
			font = "kenvector_future_thin.ttf", 
			fontSize = 32 } ) 

		-- Display the current #hits
		local hitsDispalay = display.newText( {
			parent = sceneGroup,
			text = "Hits: " .. 0, 
			x = 74, y = 20, 
			font = "kenvector_future_thin.ttf", 
			fontSize = 32 } ) 

	-- GAME LOOPS --
		-- Main Loop--
		timer.performWithDelay( 100, function (  )
			if player ~= nil then
				local hp, hits = player:getStats()

				-- Update dispaly
				hpDispalay.text = "HP: " .. hp

				hitsDispalay.text = "Hits: " .. hits

				-- Check game conditions
				if hp <= 0 then
					self:endGame('Game Over')
				end
			end
		end, -1)
end

function scene:endGame( text )
	text = text or 'Winner!'
	player:remove()
	player = nil
	enemyFactory:pause()
	transition.to(enemyBounds, { y = 0 })
	composer.gotoScene( 'scenes.gameOver', {time = 500, effect = 'fade', params = { text = text }} )
end
 
 
-- show()
function scene:show( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
 
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

		-- CHARACTERS -- 
			-- HUMAN PLAYER --
				-- Init player object
				player = Player:new( {hitPoints = 5} )
				player:spawn( _CX, 350)

			-- ENEMY PLAYERS -- 
				enemyFactory = EnemyFactory:new()
				enemyFactory:spawn( self, player ) 
	end
end

 
-- hide()
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
	end
end
 
 
-- destroy()
function scene:destroy( event )
 
	local sceneGroup = self.view

	-- player:remove()
	enemyFactory:remove()
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