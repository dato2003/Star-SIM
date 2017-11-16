-----------------------------------------------------------------------------------------
--
-- Twitter.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local Posts = 0
local Likes = 0
local Shares = 0

function doesFileExist( fname)
    local results = false
    local filePath = system.pathForFile( fname, system.DocumentsDirectory )
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )
        if not file then
            print( "File error: " .. errorString )
        else
            print( "File found: " .. fname )
            results = true
            file:close()
        end
    end
    return results
end


function WriteFile(saveData,File)
local path = system.pathForFile( File, system.DocumentsDirectory )
local file, errorString = io.open( path, "w" )
 
if not file then
    print( "File error: " .. errorString )
else
    file:write( saveData )
    io.close( file )
end
file = nil
end


function ReadFile(File)
local path = system.pathForFile( File, system.DocumentsDirectory )
local file, errorString = io.open( path, "r" )
local contents

if not file then
    print( "File error: " .. errorString )
else
    contents = file:read( "*n" )
    io.close( file )
end
file = nil
return contents
end


function GetInfo()
	if doesFileExist("TweetsCount.txt") then
		Posts = ReadFile("TweetsCount.txt")
		if Posts == nil then
			Posts = 0
		end
	else
		Posts = 0
	end
	if doesFileExist("ReTweetsCount.txt") then
		Likes = ReadFile("ReTweetsCount.txt")
		if Likes == nil then
			Likes = 0
		end
	else
		Likes = 0
	end
	if doesFileExist("HeartsCount.txt") then
		Shares = ReadFile("HeartsCount.txt")
		if Shares == nil then
			Shares = 0
		end
	else
		Shares = 0
	end
end


function BackToMenu(event)
    if event.phase == "began" then
        composer.gotoScene("menu","fade",500)
    end
end

function Achievement_2_Unlocked( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
			timer.resume(Automat)
			WriteFile("1","Achievement_2.txt")
        end
    end
end

function Automation()
	Posts = Posts + Likes + (2 * Shares)
	local NewName="Posts:" .. Posts
	Tweet_Count.text = NewName

	if Posts + Likes + (2 * Shares) > 50 then
	WriteFile(Posts,"TweetsCount.txt")
	end

	if Likes % 10 == 0 then
	WriteFile(Likes,"ReTweetsCount.txt")
	end

	if Shares % 10 == 0 then
	WriteFile(Shares,"HeartsCount.txt")
	end

	if Posts >= 1000000 then
		if doesFileExist("Achievement_2.txt")==false then
			local alert = native.showAlert("Nice","You Got 1000000 Tweets Achievement Unlocked ",{"YAY"},Achievement_2_Unlocked)
			timer.pause(Automat)
		end
	end
end

function Post_Action(event)
    if event.phase == "began" then
        Posts=Posts+1
        local NewName="Posts:" .. Posts
        Tweet_Count.text=NewName
    end
end

function ReTweet(event)
	if event.phase == "began" then
		if Posts>=10 then
			Likes=Likes+1
			Posts=Posts-10
			local NewName="ReTweets:" .. Likes
        	ReTweet_Count.text=NewName
			NewName="Posts:" .. Posts
			Tweet_Count.text=NewName
		else
			local alert = native.showAlert("Not enough Posts","You Dont have enough Tweets",{"OK"})
		end
	end
end

function Heart(event)
	if event.phase == "began" then
		if Posts>=20 then
			Shares=Shares+1
			Posts=Posts-20
			local NewName="Shares:"..Shares
			Heart_Count.text=NewName
			NewName="Posts:" .. Posts
			Tweet_Count.text=NewName
		else
			local alert = native.showAlert("Not enough Posts","You Dont have enough Tweets",{"OK"})
		end
	end
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	GetInfo()

	Automat = timer.performWithDelay( 1000 , Automation , -1)


	-- display a background image
	local background = display.newImageRect( "Twitter_Files/Twitter_Background.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
    local BackButton = widget.newButton
	{
        label = "Back To Menu",
        onEvent = BackToMenu,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={0,0,1,1}, over={0,0,1,0.4} },
        strokeColor = { default={0,0.5,0.8,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }

	BackButton.x=display.actualContentWidth*0.5
	BackButton.y=display.actualContentHeight*0.8

	local TweetButton = widget.newButton
	{
        label = "Tweet",
        onEvent = Post_Action,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={0,0,1,1}, over={0,0,1,0.4} },
        strokeColor = { default={0,0.5,0.8,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }

    TweetButton.x=display.actualContentWidth*0.5
	TweetButton.y=display.actualContentHeight*0.5

	Tweet_Count = display.newText( "Followers:" .. Posts, screenW*0.5, screenW*0.01, native.systemFont,30)
    Tweet_Count:setFillColor( 0/255, 100/255, 255/255 )

	local ReTweet_Button = widget.newButton
	{
		width = 70,
		height = 70,
		defaultFile = "Twitter_Files/ReTweet.png",
		overFile = "Twitter_Files/ReTweet.png",
		onEvent = ReTweet
	}
	ReTweet_Button.x=display.actualContentWidth*0.2
	ReTweet_Button.y=display.actualContentHeight*0.65
	

	ReTweet_Count = display.newText( "ReTweets:" .. Likes, screenW*0.5, screenW*0.4, native.systemFont,30)
    ReTweet_Count:setFillColor( 0/255, 100/255, 255/255 )

	local Heart_Button = widget.newButton
	{
		width = 70,
		height = 70,
		defaultFile = "Twitter_Files/Heart.png",
		overFile = "Twitter_Files/Heart.png",
		onEvent = Heart
	}
	Heart_Button.x=display.actualContentWidth*0.7
	Heart_Button.y=display.actualContentHeight*0.65


	Heart_Count = display.newText( "Hearts:" .. Shares, screenW*0.5, screenW*0.2, native.systemFont,30)
	Heart_Count:setFillColor( 0/255, 100/255, 255/255 )

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
    sceneGroup:insert( BackButton )
	sceneGroup:insert( TweetButton )
	sceneGroup:insert( Tweet_Count )
	sceneGroup:insert( ReTweet_Button )
	sceneGroup:insert( ReTweet_Count )
	sceneGroup:insert( Heart_Button )
	sceneGroup:insert( Heart_Count )
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
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene