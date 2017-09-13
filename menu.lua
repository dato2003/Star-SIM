-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn
local Turn=1

-- 'onRelease' event listener for playBtn
function onPlayBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "Choose", "fade", 500 )
	
	return true	-- indicates successful touch
end

function GotoAchievements(event)
	if event.phase == "began" then
		composer.gotoScene("Achievement","fade",500)
	end
end

function MusicSwitch(event)
	if event.phase == "began"  and Turn == 1  then
		audio.pause(backgroundMusicChannel)
		Turn = 0
		SoundBtn:setLabel("Music On")
	elseif event.phase == "began" and Turn == 0 then
		audio.resume(backgroundMusicChannel)
		Turn = 1
		SoundBtn:setLabel("Music Off")
	end
end


function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local backgroundMusic = audio.loadStream("Music/BackGroundMusic.mp3")
	backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 } )

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newText("Star Sim",display.contentCenterX,display.actualContentHeight*0.2,native.systemFont,40)
	
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label = "Be a Star",
        onEvent = onPlayBtnRelease,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.actualContentHeight*0.5
	

	AchievementBtn = widget.newButton{
		label = "Achievement",
        onEvent = GotoAchievements,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
	}
	AchievementBtn.x = display.contentCenterX
	AchievementBtn.y = display.actualContentHeight*0.7


	SoundBtn = widget.newButton{
		label = "Music Off",
        onEvent = MusicSwitch,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
	}
	SoundBtn.x = display.contentCenterX
	SoundBtn.y = display.actualContentHeight*0.6

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( AchievementBtn )
	sceneGroup:insert( SoundBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene