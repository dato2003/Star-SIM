-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local widget=require("widget")
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function FbPath(event)
	if event.phase=="began" then
		composer.gotoScene("FB","fade",500)
	end
end

function InstaPath(event)
	if event.phase=="began" then
		composer.gotoScene("Instagram","fade",500)
	end
end

function TwittPath(event)
	if event.phase=="began" then
		composer.gotoScene("Twitter","fade",500)
	end
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )
	
	local ChooseTXT = display.newText("Choose your Media",display.contentCenterX,display.actualContentHeight*0.2,native.systemFont,36)
	
	local FbButton = widget.newButton
	{
        width = 100,
        height = 100,
        defaultFile = "FB_Files/FB.png",
        overFile = "FB_Files/FB-over.png",
        onEvent = FbPath
    }

	FbButton.x=display.contentCenterX-100
	FbButton.y=display.contentCenterY

	local InstaButton = widget.newButton
	{
        width = 100,
        height = 100,
        defaultFile = "Instagram_Files/Instagram.png",
        overFile = "Instagram_Files/Instagram-over.png",
        onEvent = InstaPath
    }

	InstaButton.x=display.contentCenterX+100
	InstaButton.y=display.contentCenterY

	local TwittButton = widget.newButton
	{
        width = 100,
        height = 100,
        defaultFile = "Twitter_Files/Twitter.png",
        overFile = "Twitter_Files/Twitter-over.png",
        onEvent = TwittPath
    }

	TwittButton.x=display.contentCenterX
	TwittButton.y=display.contentCenterY

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( ChooseTXT )
	sceneGroup:insert( FbButton )
	sceneGroup:insert( InstaButton )
	sceneGroup:insert( TwittButton )
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

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene