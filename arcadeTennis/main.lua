display.setStatusBar(display.HiddenStatusBar)

composer = require('composer')

-- Define initial game settings as globals --
composer.setVariable( 'playerName', 'PLAYER' )
composer.setVariable( 'playerSensitivity', 5 )
audio.setVolume( 1 )

-- Start the game
composer.gotoScene( 'scenes.menu', { time = 500, effect = 'fade'} )