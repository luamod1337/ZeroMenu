require("ZeroMenuLib/Util/Util")

local zModderMain

-- features
local god,visible,neteventlogger,positionchecker,timer,timerTP,controlchecker,iPchecker,iPchecker2

-- integers
local hookID

-- LogFile
local debugFilePath = os.getenv('APPDATA') .. "\\PopstarDevs\\2Take1Menu\\NetEventLog.ini"
local vpipv4 = os.getenv('APPDATA') .. "\\PopstarDevs\\2Take1Menu\\scripts\\ZeroMenuLib\\data\\vpn-ipv4.txt"
local debugFile

-- Seconds to check players
local minCheckTime = 30
local minCheckTimeTP = 1
-- Distanced moved in minCheckTime, if greater = teleport
local distanceCheck = 500
-- Debug Mode ?
local debugSetting = true

local checkDuration = 60


-- list for all players containing lists
local playerList
local lastGC = 0

local vpnIPList

local checkedList

local VPNCheckerThread,VPNCheckerThread2


local doVar = true

function createModderDetectionMenuEntry(parent,config)

	zModderMain = menu.add_feature("Zero's Modder Detection", "parent", parent.id, nil)

	-- Main Features
	god = createConfigedMenuOption("Godmode check","toggle",zModderMain.id,scanPlayers,config,"godCheck",false,nil)
	--god	= menu.add_feature("Godmode check", "toggle", zModderMain.id, checkPlayersForGod)
	god.threaded = false

  displayIngameInfo = createConfigedMenuOption("Display Player Infos","toggle",zModderMain.id,nil,config,"displayinfos",false,nil)
  displayIngameInfo.threaded = false  
  -- god.renderer = drawDisplayInfo

  positionchecker = createConfigedMenuOption("Position check","toggle",zModderMain.id,scanPlayers,config,"PositionCheck",false,nil)
  --positionchecker = menu.add_feature("Position Checker", "toggle", zModderMain.id, logDistanceMovedPerSec)
  positionchecker.threaded = false

  if config:isFeatureEnabled("PositionCheck") then
    positionchecker.on = true
  end


	if config:isFeatureEnabled("godCheck") then
    god.on = true
  end
  
  if config:isFeatureEnabled("displayinfos") then
    displayIngameInfo.on = true
  end
	

	playerList = {}

	--vpnIPList = loadVPNList()
	checkedList = {}
end

function scanPlayers()
  -- check every player
  drawDisplayInfo()
  for slot = 0, 31 do
    -- valid player ?
    if player.is_player_valid(slot) then   
    --  local perPlayerList = playerList[player.get_player_name(slot)]
      
      if(not isreCreateData(slot)) then
        if (os.time() -  playerList[player.get_player_name(slot)]['lastCheck']) >= 1 then
          -- player is inside something
          if(not isPlayerInside(slot)) then
            -- check for godmode
            if(checkForGod(slot) and (playerList[player.get_player_name(slot)]['distanceMoved'] > 0 or playerList[player.get_player_name(slot)]['moved'])) then
              playerList[player.get_player_name(slot)]['godTime'] = (playerList[player.get_player_name(slot)]['godTime']+1)
            end
            local distanceMovedSecond = calculateDistanceMoved(slot)
            playerList[player.get_player_name(slot)]['distanceMoved'] = (playerList[player.get_player_name(slot)]['distanceMoved'] + distanceMovedSecond)
            if(playerList[player.get_player_name(slot)]['distanceMoved'] > 0) then
              playerList[player.get_player_name(slot)]['moved'] = true
            end
            
            if(playerList[player.get_player_name(slot)]['godTime'] > (checkDuration*0.9) and player.get_player_modder_flags(slot) ==0 and not playerList[player.get_player_name(slot)]['godannounce']) then
              ui.notify_above_map(player.get_player_name(slot) .. " is using god since " .. playerList[player.get_player_name(slot)]['godTime'] .. " seconds","ZModder Detection",140)
              player.set_player_as_modder(slot,1)
              playerList[player.get_player_name(slot)]['godannounce'] = true
            end
            
            playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'] =  distanceMovedSecond
            
            if(distanceMovedSecond > 500 and positionchecker.on and playerList[player.get_player_name(slot)]['moved']) then
              ui.notify_above_map(player.get_player_name(slot) .. " teleported (moved " .. round(distanceMovedSecond,0) .. " in 1 Second)","ZModder Detection",140)            
            end
            
          end     
          playerList[player.get_player_name(slot)]['cords'] = player.get_player_coords(slot)   
          playerList[player.get_player_name(slot)]['lastCheck'] = os.time()
          playerList[player.get_player_name(slot)]['totalChecked'] = ( playerList[player.get_player_name(slot)]['totalChecked']+1)
        end          
      else
        -- new joined player
        playerList[player.get_player_name(slot)] = {}
        playerList[player.get_player_name(slot)]['cords'] = player.get_player_coords(slot)
        playerList[player.get_player_name(slot)]['scid'] = player.get_player_scid(slot)
        playerList[player.get_player_name(slot)]['distanceMoved'] = 0
        playerList[player.get_player_name(slot)]['totalMoveCheck'] = 0
        playerList[player.get_player_name(slot)]['lastCheck'] = os.time()
        playerList[player.get_player_name(slot)]['totalChecked'] = 0
        playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'] = 0
        playerList[player.get_player_name(slot)]['moved'] = false
        playerList[player.get_player_name(slot)]['godTime'] = 0
        playerList[player.get_player_name(slot)]['totalGodTime'] = 0
        playerList[player.get_player_name(slot)]['godannounce'] = false
      end      
    end  
  end
  if god.on then
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end

function checkForGod(slot)
  return player.is_player_god(slot)
end

function isreCreateData(slot)
  if(playerList[player.get_player_name(slot)] == nil) then
    return true
  end
  if(playerList[player.get_player_name(slot)]['totalChecked'] > checkDuration) then
    return true
  end
  return false
end

function calculateDistanceMoved(slot)
  local oldCord =  playerList[player.get_player_name(slot)]['cords']
  local newCord = player.get_player_coords(slot)
  local distance = math.sqrt(math.pow(newCord['x'] - oldCord['x'],2) + math.pow(newCord['y'] - oldCord['y'],2) + math.pow(newCord['z'] - oldCord['z'],2))
  
  return distance
end

function isPlayerInside(slot)
  local inside = false
  if (interior.get_interior_from_entity(player.get_player_ped(slot)) ~= nil and 
     interior.get_interior_from_entity(player.get_player_ped(slot)) ~= 0) or 
     player.get_player_coords(slot).z <= -50 then
      inside = true
  end
 
  return inside
end

function drawDisplayInfo()
  if(displayIngameInfo.on) then    
    local baseV2 = v2(0.04,0.009)
    local size = v2(1,1)
    local padding = 0.02
    for slot = 0, 31 do
      if(player.is_player_valid(slot) and playerList[player.get_player_name(slot)] ~= nil) then
        if(playerList[player.get_player_name(slot)]['godTime'] > 0 or round(playerList[player.get_player_name(slot)]['distanceMoved'],0) > 0) then
          drawText(player.get_player_name(slot) .. " (" .. playerList[player.get_player_name(slot)]['totalChecked'] .. ")",baseV2)
          baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          --drawText("Checked Time: " .. playerList[player.get_player_name(slot)]['totalChecked'],baseV2)
          --baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          --print("prev. distanceMoved = " .. playerList[player.get_player_name(slot)]['distanceMoved'])
          --print("rounded prev. distanceMoved = " .. round(playerList[player.get_player_name(slot)]['distanceMoved']),2)
          if(round(playerList[player.get_player_name(slot)]['distanceMoved'],0))then
            local xoffset = leftOffsetByNumber(round(playerList[player.get_player_name(slot)]['distanceMoved'],0))
            baseV2 = v2((baseV2.x + xoffset),baseV2.y) 
            drawText("Distance Moved: " .. round(playerList[player.get_player_name(slot)]['distanceMoved'],0),baseV2)
            baseV2 = v2((baseV2.x - xoffset),baseV2.y)        
            baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end
          
          if(playerList[player.get_player_name(slot)]['godTime'] > 0) then 
            if(playerList[player.get_player_name(slot)]['godTime'] > (playerList[player.get_player_name(slot)]['totalChecked']/2))then
              drawRedText("God Time: " .. playerList[player.get_player_name(slot)]['godTime'] .. "/" .. playerList[player.get_player_name(slot)]['totalChecked'],baseV2)
            else 
              drawText("God Time: " .. playerList[player.get_player_name(slot)]['godTime'] .. "/" .. playerList[player.get_player_name(slot)]['totalChecked'],baseV2)
            end
              baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end
          if(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'] > 0) then
            if(round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0) > 112) then
              drawRedText("m/s: " .. round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0),baseV2)
            else
              drawText("m/s: " .. round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0),baseV2)
            end
            
            
            baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end        
          
          baseV2 = v2(baseV2.x,baseV2.y + 0.02)
        end
        
      end    
    end
  end  
end
function leftOffsetByNumber(number)
  if(number > 10) then
    return 0.01
  end
  if(number > 100) then
    return 0.02
  end
  if(number > 1000) then
    return 0.03
  end
  if(number > 10000) then
    return 0.04
  end
  return 0
end
function drawRedText(text,baseV2)
  ui.set_text_scale(0.28)
  ui.set_text_font(0)
  ui.set_text_color(117, 0, 0, 255)
  ui.set_text_centre(1)
  ui.set_text_outline(1)
  ui.draw_text(text,baseV2)
end
function drawText(text,baseV2)
  ui.set_text_scale(0.28)
  ui.set_text_font(0)
  ui.set_text_color(255, 255, 255, 255)
  ui.set_text_centre(1)
  ui.set_text_outline(1)
  ui.draw_text(text,baseV2)
end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end