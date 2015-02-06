-- Start.lua

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
physics = require "physics"
physics.start()
physics.setGravity(0,0)

--leader boards
local gameNetwork = require( "gameNetwork" )
local playerName

local function loadLocalPlayerCallback( event )
   playerName = event.data.alias
   --saveSettings()  --save player data locally using your own "saveSettings()" function
end

local function gameNetworkLoginCallback( event )
   gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
   return true
end

local function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
end

local function gameNetworkSetup()
   if ( system.getInfo("platformName") == "Android" ) then
      gameNetwork.init( "google", gpgsInitCallback )
   else
      gameNetwork.init( "gamecenter", gameNetworkLoginCallback )
   end
end

------HANDLE SYSTEM EVENTS------
local function systemEvents( event )
   print("systemEvent " .. event.type)
   if ( event.type == "applicationSuspend" ) then
      print( "suspending..........................." )
   elseif ( event.type == "applicationResume" ) then
      print( "resuming............................." )
   elseif ( event.type == "applicationExit" ) then
      print( "exiting.............................." )
   elseif ( event.type == "applicationStart" ) then
      gameNetworkSetup()  --login to the network here
   end
   return true
end

Runtime:addEventListener( "system", systemEvents )

-- function
function game(event)
     if event.phase == "ended" then
        storyboard.gotoScene( "game" )
     end
end

function scrollground(event)
    local xOffset = -5
    ground1.x = ground1.x + xOffset
    ground2.x = ground2.x + xOffset
    ground3.x = ground3.x + xOffset
    ground4.x = ground4.x + xOffset
    if (ground1.x) < -(display.contentWidth) then
        ground1.x = (display.contentWidth*1.55)
    end
    if (ground2.x) < -(display.contentWidth) then
        ground2.x = (display.contentWidth*1.55)
    end
    if (ground3.x) < -(display.contentWidth) then
        ground3.x = (display.contentWidth*1.55)
    end
    if (ground4.x) < -(display.contentWidth) then
        ground4.x = (display.contentWidth*1.55)
    end 
end

function showLeaderboards()
   if ( system.getInfo("platformName") == "Android" ) then
      gameNetwork.show( "leaderboards" )
   else
      gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime"} } )
   end
   return true
end

--Create scene start
function scene:createScene( event )
   local sceneGroup = self.view
   display.setDefault( "textureWrapX", "repeat" )
   display.setDefault( "textureWrapY", "repeat" )
   x,y = display.contentCenterX, display.contentCenterY
   background = display.newImageRect("assets/bg.png" , display.viewableContentWidth + 50, display.viewableContentHeight + 100 )
   background.x = x; background.y = y-45
   sceneGroup:insert(background)
   ground1 = display.newImageRect("assets/ground.png" , display.viewableContentWidth + 50, 150)
   ground1.x = x; ground1.y = 480
   physics.addBody(ground1, "static",{density=1, bounce=0.1, friction=.2})
   sceneGroup:insert(ground1)
   ground2 = display.newImageRect("assets/ground.png" , display.viewableContentWidth + 50, 150)
   ground2.x = x*2; ground2.y = 480
   physics.addBody(ground2, "static",{density=1, bounce=0.1, friction=.2})
   sceneGroup:insert(ground2)
   ground3 = display.newImageRect("assets/ground.png" , display.viewableContentWidth + 50, 150)
   ground3.x = x*3; ground3.y = 480
   physics.addBody(ground3, "static",{density=1, bounce=0.1, friction=.2})
   sceneGroup:insert(ground3)
   ground4 = display.newImageRect("assets/ground.png" , display.viewableContentWidth + 50, 150)
   ground4.x = x*4; ground4.y = 480
   sceneGroup:insert(ground4)
   titulo = display.newImageRect("assets/titulo.png" , display.viewableContentWidth/2, 80)
   titulo.x = x; titulo.y = y-100
   sceneGroup:insert(titulo)
   playb = display.newImageRect("assets/play.png" , display.viewableContentWidth/3, 75)
   playb.x = x*0.5; playb.y = y+130
   sceneGroup:insert(playb)
   leaderb = display.newImageRect("assets/leaderboards.png" , display.viewableContentWidth/3, 75)
   leaderb.x = x*1.5; leaderb.y = y+130
   sceneGroup:insert(leaderb)
end

-- funtion is call it before the scene is show on the screen
function scene:enterScene( event )
   local sceneGroup = self.view
        leaderb:addEventListener("touch", showLeaderboards)
        playb:addEventListener("touch", game)
        Runtime:addEventListener( "enterFrame", scrollground )
end

-- funtion is call it after the scene is show on the screen
function scene:enterScene( event )
   local sceneGroup = self.view
        playb:addEventListener("touch", game)
        Runtime:addEventListener( "enterFrame", scrollground )
end

-- funtion call it before the scene is off the screen
function scene:exitScene( event )
   local sceneGroup = self.view
        playb:removeEventListener("touch", game)
        Runtime:removeEventListener( "enterFrame", scrollground )
end

-- funtion call it before the scene is show on the screen
function scene:didExitScene( event )
   local sceneGroup = self.view
end

-- funtion call to destroy the scene start
function scene:destroyScene( event )
   local sceneGroup = self.view
end

-- cuando llamo el overlay
function scene:overlayBegan( event )
        local group = self.view
        local overlay_name = event.sceneName
end

-- cuando oculto el overlay
function scene:overlayEnded( event )
        local group = self.view
        local overlay_name = event.sceneName
end

-- listeners
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "overlayBegan", scene )
scene:addEventListener( "overlayEnded", scene )

return scene