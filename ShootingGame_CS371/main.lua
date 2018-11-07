display.setStatusBar(display.HiddenStatusBar)

-- Go to the first scene
composer = require('composer')
composer.gotoScene( 'scenes.menu', {time = 500, effect = 'fade'} )