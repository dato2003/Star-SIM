local composer = require( "composer" )
local scene = composer.newScene()
----------------------------------------------------------------------------------------------------------------
local widget = require "widget"

local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


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


function BackToMenu(event)
    if event.phase == "began" then
        composer.gotoScene("menu","fade",500)
    end
end


function scrollListener( event )
 
    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end
 
    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end
 
    return true
end

function Checker()
    if doesFileExist("PostsCount.txt") then
      local Posts = ReadFile("PostsCount.txt")
      if Posts >= 1000000 then
          Achievements_1_Status.text = "Done"
      end
    end
end

function scene:create( event )
  local sceneGroup = self.view


  local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )


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
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }

	BackButton.x=display.actualContentWidth*0.5
	BackButton.y=display.actualContentHeight*0.8


    local TEXT_1 = display.newText( "Achievements List", screenW*0.5, 0, native.systemFont, 30 )
    TEXT_1:setFillColor( 213/255, 129/255, 0/255 )



    Achievements = widget.newScrollView
    {
        x = screenW*0.5,
        y = screenH*0.4,
        width = screenW*0.9,
        height = screenH*0.7,
        backgroundColor = { 0.8, 0.8, 0.8 },
        horizontalScrollDisabled = true,
        listener = scrollListener
    }

    local ScrW = Achievements.width
    local ScrH = Achievements.height

    Achievements_1 = display.newText( "Get 1 Million Posts on Facebook", ScrW*0.5, ScrH * 0.2 , native.systemFont, 16 )
    Achievements_1:setFillColor( 213/255, 129/255, 0/255 )
    Achievements:insert( Achievements_1 )

    Achievements_1_Status = display.newText( "Not Done", ScrW*0.5, ScrH * 0.3 , native.systemFont, 16 )
    Achievements_1_Status:setFillColor( 213/255, 129/255, 0/255 )
    Achievements:insert( Achievements_1_Status )

    Checker()


    sceneGroup:insert( background )
    sceneGroup:insert( BackButton )
    sceneGroup:insert( Achievements )
    sceneGroup:insert( TEXT_1 )
end

--------------------------------------------------------------------------------
-- "scene:show()"
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- "scene:hide()"
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- "scene:destroy()"
--------------------------------------------------------------------------------
function scene:destroy( event )
  local sceneGroup = self.view

  -- Called prior to the removal of scene's view ("sceneGroup").
  -- Insert code here to clean up the scene.
  -- Example: remove display objects, save state, etc.
end

--------------------------------------------------------------------------------
-- Listener setup
--------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
--------------------------------------------------------------------------------

return scene