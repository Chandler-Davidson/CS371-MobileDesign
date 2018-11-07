local composer = require('composer')
local timer = require('timer')
local physics = require('physics')

local Player = require('classes.Player')
local Enemy = require('classes.Enemy')
local Ball = require('classes.Ball')

-- Current instance of singleton objects
local player
local enemy
local ball

-- Number used to determine sprite colors and difficulty
local currentLevel

local playerScore, enemyScore = 0, 0

local scene = composer.newScene( )

function scene:create( event )
	local sceneGroup = self.view

	currentLevel = event.params.currentLevel

	print( 'Starting Level: ' .. currentLevel )

	-- Commonly used coordinates
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

	-- ENVIROMENT --
		-- Background --
		local courts = {'blue-white', 'green-white', 'red-white', 'tan-blue'}
		local background = display.newImage( 'kenney_sportspack/Courts/' .. courts[ currentLevel ] .. '.png', _CX, _CY )
		background:scale( .85, .85 )
		sceneGroup:insert( background )

		-- Walls --
		local leftWall = display.newRect( sceneGroup, -5, _CY, 10, _H )
		local rightWall = display.newRect( sceneGroup, _W + 5, _CY, 10, _H )

		physics.addBody( leftWall, 'static', { bounce = 1 } )
		physics.addBody( rightWall, 'static', { bounce = 1 } )

		-- Hit Sensors --
		-- Bounds for where the players can hit the ball
		local hitBounds = display.newRect( display.contentCenterX, 475, display.contentWidth, 90 )
		hitBounds.isVisible = false
		hitBounds.tag = 'hitBounds'
		physics.addBody( hitBounds, "static", { isSensor=true } )

		local enemyHitBounds = display.newRect( display.contentCenterX, 15, display.contentWidth, 90 )
		enemyHitBounds.isVisible = false
		enemyHitBounds.tag = 'hitBounds'
		physics.addBody( enemyHitBounds, "static", { isSensor=true } ) 

		local ballBounds = display.newRect( _CX, 550, _W * 2 , 30 )
		ballBounds.tag = 'ballBounds'
		physics.addBody( ballBounds, "static", { isSensor=true } )

		-- Bar to control player's movement
		self.controlBar = display.newRect( sceneGroup, _CX, _H - 20, _W, 100 )
		self.controlBar:setFillColor( 1, 1, 1, 0.5 )
		transition.to( self.controlBar, { time = 1000, alpha = 0.01 } )

		-- Score Displays --
		local levelDisplay = display.newText( sceneGroup, 'Level ' .. currentLevel, 130, _H + 5, 'kenvector_future_thin.ttf', 25 )
		self.playerScoreDisplay = display.newText( sceneGroup, 0, _W - 43, _H, 'kenvector_future_thin.ttf', 30 )
		self.enemyScoreDisplay = display.newText( sceneGroup, 0, 51, 3, 'kenvector_future_thin.ttf', 30 )
		levelDisplay.alpha = .6
		self.playerScoreDisplay.alpha = .6
		self.enemyScoreDisplay.alpha = .6

	-- PLAYERS --
		-- Human --
		player = Player:new()
		player:spawn( _CX, _H - 20 )

		-- Computer --
		enemy = Enemy:new( { difficulty = 3 * currentLevel } )
		enemy:spawn( _CX, 20, currentLevel )	-- spawn( x, y, color )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	-- Update enemy's position with the ball
	local function updatePlayers(  )
		if ball then
			-- player:move( ball:getLocation() )
			enemy:move( ball:getLocation() )
		end
	end

	-- Move the player's position
	local function move( event )

	-- Drag movement for player control
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

	-- Swing the player's racket
	local function swing(  )
		if ball then
			dx, dy = ball.shape:getLinearVelocity( )

			-- Ball is in play and in right direction
			if ( ball:inBounds() and ball.isHittable and dy > 0 ) then

				-- Ball has to hit the player's racket
				local racket = player.racketShape
				if ball.shape.x >= racket.x - racket.width / 2 and ball.shape.x <= racket.x + racket.width then
					ball:hit()
				end

			end
		end

		-- Swing racket regardless
		player:swing( )
	end
 
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then

		-- Resume play
		self.playing = true

		if ball then
			ball:play( )
		else
			scene:startRound( )
		end

		player:setAlpha( 1 )
		enemy:setAlpha( 1 )

		timer.performWithDelay( 10, updatePlayers, -1 )
		Runtime:addEventListener( 'tap', swing )
		self.controlBar:addEventListener( 'touch', move )
		Runtime:addEventListener( "accelerometer", function (  )
			composer.gotoScene( 'scenes.options', { time = 300, effect = 'fade', params = { sceneFrom = self } } )
		end )
	end
end

function scene:startRound( )
	print('STARTING A NEW ROUND')

	-- COUNTDOWN --
		local counterBackground = display.newRoundedRect( self.view, display.contentCenterX, display.contentCenterY - 30, 40, 40, 15)
		counterBackground:setFillColor( .5 )
		counterBackground.alpha = 0

		local counter = display.newText( self.view, '3', display.contentCenterX + 5, display.contentCenterY - 30, 'kenvector_future_thin.ttf', 40 )
		counter.alpha = 0

		local secondsLeft = 3
		timer.performWithDelay( 1000, function (  )

		-- Still counting down
		if secondsLeft > 0 then
			counter.text = secondsLeft

			-- Ease the transition
			transition.fadeIn( counter, { time = 200} )
			transition.fadeIn( counterBackground, { time = 200 } )
			secondsLeft = secondsLeft - 1
			counter.alpha = 0
			counterBackground.alpha = 0
		else
			-- Once done, hide
			counter.alpha = 0
			counterBackground.alpha = 0
		end
	end, 4 )

	-- Once the countdown is done, start the round
	timer.performWithDelay( 4000, function (  )

		-- Check in case pause is called during countdown
		if self.playing == true then
			ball = Ball:new( { moveSpeedY = 100 * currentLevel } )
			ball:spawn( self, display.contentCenterX, display.contentCenterY )
		end
	end )
	
end

function scene:roundOver( win )
	ball = nil

	local string

	-- Win == player won
	if win then
		string = composer.getVariable( 'playerName' ) .. ' WON'
		playerScore = playerScore + 1
	else
		string = 'CPU WON'
		enemyScore = enemyScore + 1
	end

	local roundText = display.newText( string, display.contentCenterX, display.contentCenterY + 20, native.systemFontBold, 20 )
	roundText.alpha = 0

	transition.to( roundText, {time = 1000, alpha = 1, onComplete = function ( )
		transition.to( roundText, {time = 1000, alpha = 0} )
	end } )

	-- Game over
	if ( math.abs( playerScore - enemyScore ) > 2 ) then
		print('Transitioning to new level')
		-- composer.gotoScene( 'scenes.levelTransition', { time = 300, effect = 'fade', params = { playerWon = playerScore > enemyScore, currentLevel = currentLevel + 1 } } )
		
		-- Delay transitions so collisions can finish
		timer.performWithDelay( 50, function (  )
			composer.gotoScene( 'scenes.levelTransition', { timer = 300, effect = 'slideRight', params = { playerWon = playerScore > enemyScore, currentLevel = currentLevel + 1 } } )
		end )
	else
		self.playerScoreDisplay.text = playerScore
		self.enemyScoreDisplay.text = enemyScore

		self:startRound()

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then

		self.playing = false

		if ball then
			ball:pause()
		end

		-- Manualy hide player objects to reuse upon re-entry
		player:setAlpha( 0.5  )
		enemy:setAlpha( 0.5 )
 
	elseif ( phase == "did" ) then
 
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Remove scene objects
	player:remove()
	enemy:remove()

	if ball then
		ball:remove()
	end
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