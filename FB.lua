-----------------------------------------------------------------------------------------
--
-- FB.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local BackGroundID = 2


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
	if doesFileExist("PostsCount.txt") then
		Posts = ReadFile("PostsCount.txt")
		if Posts == nil then
			Posts = 0
		end
	else
		Posts = 0
	end
	if doesFileExist("LikesCount.txt") then
		Likes = ReadFile("LikesCount.txt")
		if Likes == nil then
			Likes = 0
		end
	else
		Likes = 0
	end
	if doesFileExist("SharesCount.txt") then
		Shares = ReadFile("SharesCount.txt")
		if Shares == nil then
			Shares = 0
		end
	else
		Shares = 0
	end
end


function Achievement_1_Unlocked( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
			timer.resume(Automat)
        end
    end
end

function Automation()
	Posts = Posts + Likes + (2 * Shares)
	local NewName="Posts:" .. Posts
	Post_Count.text = NewName

	if Posts % 50 == 0 then
	WriteFile(Posts,"PostsCount.txt")
	end

	if Likes % 10 == 0 then
	WriteFile(Likes,"LikesCount.txt")
	end

	if Shares % 10 == 0 then
	WriteFile(Shares,"SharesCount.txt")
	end

	if Posts >= 1000000 then
		local alert = native.showAlert("Nice","You Got 1000000 Posts Achievement Unlocked ",{"YAY"})
		timer.pause(Automat)
	end
end

function BackGroundChanger()
	if BackGroundID == 1 then
		background1.isVisible=false
		background2.isVisible=true
		BackGroundID = 2
	elseif BackGroundID == 2 then
		background2.isVisible=false
		background3.isVisible=true
		BackGroundID = 3
	elseif BackGroundID == 3 then
		background3.isVisible=false
		background1.isVisible=true
		BackGroundID = 1
	end
end


function BackToMenu(event)
    if event.phase == "began" then
        composer.gotoScene("Choose","fade",500)
    end
end

function Post_Action(event)
    if event.phase == "began" then
        Posts=Posts+1
        local NewName="Posts:" .. Posts
        Post_Count.text=NewName
    end
end

function Like(event)
	if event.phase == "began" then
		if Posts>=10 then
			Likes=Likes+1
			Posts=Posts-10
			local NewName="Likes:" .. Likes
        	Like_Count.text=NewName
			NewName="Posts:" .. Posts
			Post_Count.text=NewName
		else
			local alert = native.showAlert("Not enough Posts","You Dont have enough Posts",{"OK"})
		end
	end
end

function Share(event)
	if event.phase == "began" then
		if Posts>=20 then
			Shares=Shares+1
			Posts=Posts-20
			local NewName="Shares:"..Shares
			Share_Count.text=NewName
			NewName="Posts:" .. Posts
			Post_Count.text=NewName
		else
			local alert = native.showAlert("Not enough Posts","You Dont have enough Posts",{"OK"})
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

	Automat = timer.performWithDelay( 1000 , Automation , 0)
	
	BackGroundChange = timer.performWithDelay( 5000 , BackGroundChanger , 0)

	-- display a background image
	background2 = display.newImageRect( "FB_Files/FB_Background_2.png", display.actualContentWidth, display.actualContentHeight )
	background2.anchorX = 0
	background2.anchorY = 0
	background2.x = 0 + display.screenOriginX 
	background2.y = 0 + display.screenOriginY

	background1 = display.newImageRect( "FB_Files/FB_Background_1.png", display.actualContentWidth, display.actualContentHeight )
	background1.anchorX = 0
	background1.anchorY = 0
	background1.x = 0 + display.screenOriginX 
	background1.y = 0 + display.screenOriginY
	background1.isVisible = false


	background3 = display.newImageRect( "FB_Files/FB_Background_3.png", display.actualContentWidth, display.actualContentHeight )
	background3.anchorX = 0
	background3.anchorY = 0
	background3.x = 0 + display.screenOriginX 
	background3.y = 0 + display.screenOriginY
	background3.isVisible = false
	
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

    local PostButton = widget.newButton
	{
        label = "Post",
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

    PostButton.x=display.actualContentWidth*0.5
	PostButton.y=display.actualContentHeight*0.5

    Post_Count = display.newText( "Posts:" .. Posts, screenW*0.5, screenW*0.01, native.systemFont,30)
    Post_Count:setFillColor( 144/255, 188/255, 255/255 )
	
	local Like_Button = widget.newButton
	{
		width = 70,
		height = 70,
		defaultFile = "FB_Files/Like_Pic.png",
		overFile = "FB_Files/Like_Pic.png",
		onEvent = Like
	}
	Like_Button.x=display.actualContentWidth*0.2
	Like_Button.y=display.actualContentHeight*0.65
	

	Like_Count = display.newText( "Likes:" .. Likes, screenW*0.2, screenW*0.2, native.systemFont,30)
    Like_Count:setFillColor( 0/255, 234/255, 255/255 )

	local Share_Button = widget.newButton
	{
		width = 70,
		height = 70,
		defaultFile = "FB_Files/Share_Pic.png",
		overFile = "FB_Files/Share_Pic.png",
		onEvent = Share
	}
	Share_Button.x=display.actualContentWidth*0.7
	Share_Button.y=display.actualContentHeight*0.65


	Share_Count = display.newText( "Shares:" .. Shares, screenW*0.7, screenW*0.2, native.systemFont,30)
	Share_Count:setFillColor( 0/255, 234/255, 255/255 )


	-- all display objects must be inserted into group
	sceneGroup:insert( background1 )
	sceneGroup:insert( background2 )
	sceneGroup:insert( background3 )
    sceneGroup:insert( BackButton )
    sceneGroup:insert( PostButton )
    sceneGroup:insert( Post_Count )
	sceneGroup:insert( Like_Button )
	sceneGroup:insert( Like_Count )
	sceneGroup:insert( Share_Button )
	sceneGroup:insert( Share_Count)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		if Posts ~= 0 then 
		timer.resume(Automat)
		timer.resume(BackGroundChange)
		end
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
		timer.pause(Automat)
		timer.pause(BackGroundChange)

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