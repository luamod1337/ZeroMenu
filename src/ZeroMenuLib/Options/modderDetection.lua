require("ZeroMenuLib/Util/Util")

local zModderMain

-- features
local god,positionchecker,controlchecker,displayIngameInfo
local annouceCheaterSMS,annouceCheaterChat,displaySusIngameInfo,nameBoundsCheaterChat,vehicleGodChecker,vehicleSpeedCheck,zModderMainSettings,markasModder

-- integers

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

-- Total Time a check takes
local checkDuration = 60

-- list for all players containing lists
playerList = nil
local susList

local lastGC = 0


function createModderDetectionMenuEntry(parent,config)

	zModderMain = menu.add_feature("Zero's Modder Detection", "parent", parent.id, nil)
  
  
  
	-- Main Features
	god = createConfigedMenuOption("Godmode check","toggle",zModderMain.id,scanPlayers,config,"godCheck",false,nil)
	god.threaded = false

  positionchecker = createConfigedMenuOption("Position check","toggle",zModderMain.id,scanPlayers,config,"PositionCheck",false,nil)
  positionchecker.threaded = false
  
  vehicleGodChecker = createConfigedMenuOption("Vehicle God check","toggle",zModderMain.id,scanPlayers,config,"vehiclegodcheck",false,nil)
  vehicleGodChecker.threaded = false

  nameBoundsCheaterChat = createConfigedMenuOption("Check Name bounds","toggle",zModderMain.id,nil,config,"checkNameBounds",false,nil)
  nameBoundsCheaterChat.threaded = false

  vehicleSpeedCheck = createConfigedMenuOption("Check Vehicle Speed","toggle",zModderMain.id,nil,config,"vehiclespeedcheck",false,nil)
  vehicleSpeedCheck.threaded = false  

  zModderMainSettings = menu.add_feature("Settings", "parent", zModderMain.id, nil)

  displayIngameInfo = createConfigedMenuOption("Display All Player Infos","toggle",zModderMainSettings.id,nil,config,"displayinfos",false,nil)
  displayIngameInfo.threaded = false  
  
  displaySusIngameInfo = createConfigedMenuOption("Display All Sus Player Infos","toggle",zModderMainSettings.id,nil,config,"displaySUSinfos",false,nil)
  displaySusIngameInfo.threaded = false  
  


  
  
  annouceCheaterSMS = createConfigedMenuOption("Annouce Cheater per SMS","toggle",zModderMainSettings.id,nil,config,"modderSMS",false,nil)
  annouceCheaterSMS.threaded = false

  annouceCheaterChat = createConfigedMenuOption("Annouce Cheater per Chat","toggle",zModderMainSettings.id,nil,config,"modderCHAT",false,nil)
  annouceCheaterChat.threaded = false
  
  markasModder = createConfigedMenuOption("Mark as Modder","toggle",zModderMainSettings.id,nil,config,"modderMARK",false,nil)
  markasModder.threaded = false
  
  
  if config:isFeatureEnabled("PositionCheck") then
    positionchecker.on = true
  end
  
    if config:isFeatureEnabled("vehiclespeedcheck") then
    vehicleSpeedCheck.on = true
  end
  
  if config:isFeatureEnabled("checkNameBounds") then
    nameBoundsCheaterChat.on = true
  end
  
  
  if config:isFeatureEnabled("vehiclegodcheck") then
    vehicleGodChecker.on = true
  end
  
  if config:isFeatureEnabled("displaySUSinfos") then
    displaySusIngameInfo.on = true
  end
  
  if config:isFeatureEnabled("modderSMS") then
    annouceCheaterSMS.on = true
  end
  
  if config:isFeatureEnabled("modderCHAT") then
    annouceCheaterChat.on = true
  end
  
	if config:isFeatureEnabled("godCheck") then
    god.on = true
  end
    
  if config:isFeatureEnabled("displayinfos") then
    displayIngameInfo.on = true
  end
	
	playerList = {}
	susList = {}

	--vpnIPList = loadVPNList()
	checkedList = {}
end

function scanPlayers()
  -- check every player
  drawDisplayInfo()
  annouceModder()
  drawSusInfo()
  for slot = 0, 31 do
    -- valid player ?
    if player.is_player_valid(slot) then   
    --  local perPlayerList = playerList[player.get_player_name(slot)]      
      if(not isreCreateData(slot)) then
        if (os.time() -  playerList[player.get_player_name(slot)]['lastCheck']) >= 1 then
          if(playerList[player.get_player_name(slot)]['willbeInside'] > 0) then
            if(isPlayerInside(slot)) then
              playerList[player.get_player_name(slot)]['willbeInside'] = 0
              --ui.notify_above_map("reseting " .. player.get_player_name(slot),"ZModder Detection",140)
            else
              playerList[player.get_player_name(slot)]['willbeInside'] = playerList[player.get_player_name(slot)]['willbeInside']+1
            end
          end
          -- player is inside something
          if(not isPlayerInside(slot)) then
            playerList[player.get_player_name(slot)]['wasInside'] = false
            -- check for godmode
            if(checkForGod(slot) and (playerList[player.get_player_name(slot)]['distanceMoved'] > 0 or playerList[player.get_player_name(slot)]['moved'])) then
              playerList[player.get_player_name(slot)]['godTime'] = (playerList[player.get_player_name(slot)]['godTime']+1)
            end
            
            if(checkForGod(slot) and (playerList[player.get_player_name(slot)]['distanceMoved'] > 0 or playerList[player.get_player_name(slot)]['moved'])) then
              playerList[player.get_player_name(slot)]['godTime'] = (playerList[player.get_player_name(slot)]['godTime']+1)
            end
            
            local distanceMovedSecond = calculateDistanceMoved(slot)
            playerList[player.get_player_name(slot)]['distanceMoved'] = (playerList[player.get_player_name(slot)]['distanceMoved'] + distanceMovedSecond)
            playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'] =  distanceMovedSecond
            
            if(playerList[player.get_player_name(slot)]['distanceMoved'] > 0) then
              playerList[player.get_player_name(slot)]['moved'] = true
            end
            
            if(playerList[player.get_player_name(slot)]['godTime'] > (checkDuration*0.9) and player.get_player_modder_flags(slot) ==0 and not playerList[player.get_player_name(slot)]['godannounce']) then
              ui.notify_above_map(player.get_player_name(slot) .. " is using god since " .. playerList[player.get_player_name(slot)]['godTime'] .. " seconds","ZModder Detection",140)
              if(markasModder.on)then
                player.set_player_as_modder(slot,1)
              end              
              markSus(player.get_player_name(slot),"god")
              playerList[player.get_player_name(slot)]['godannounce'] = true
            end
            
            if(playerList[player.get_player_name(slot)]['godvehicle'] > (checkDuration*0.9) and player.get_player_modder_flags(slot) ==0 and not playerList[player.get_player_name(slot)]['godvehicleannounced']) then
               ui.notify_above_map(player.get_player_name(slot) .. " is using god vehicle since " .. playerList[player.get_player_name(slot)]['godvehicle'] .. " seconds","ZModder Detection",140)
               markSus(player.get_player_name(slot),"Godmode Vehicle")
               playerList[player.get_player_name(slot)]['godvehicleannounced'] = true
            end
            
            if(round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0) > 112 and player.get_player_vehicle(slot) ~= 0) then
                 playerList[player.get_player_name(slot)]['vehiclespeedTime'] = playerList[player.get_player_name(slot)]['vehiclespeedTime'] + 1
              end
            
            if(distanceMovedSecond > 500 and positionchecker.on and playerList[player.get_player_name(slot)]['moved'] and not playerList[player.get_player_name(slot)]['wasInside']) then            
              if(not isValidPos(slot)) then                
                ui.notify_above_map(player.get_player_name(slot) .. " teleported (moved " .. round(distanceMovedSecond,0) .. " in 1 Second)","ZModder Detection",140)            
                playerList[player.get_player_name(slot)]['willbeInside'] = 1
              end
            end
            
            --playerList[player.get_player_name(slot)]['willbeInside'] = playerList[player.get_player_name(slot)]['willbeInside']+1
            if(playerList[player.get_player_name(slot)]['willbeInside'] > 30 ) then 
              ui.notify_above_map(player.get_player_name(slot) .. " willbeinside = " .. playerList[player.get_player_name(slot)]['willbeInside'],"ZModder Detection",140)            
              markSus(player.get_player_name(slot),"teleport2")
              playerList[player.get_player_name(slot)]['willbeInside'] = 0
            end
            if(nameBoundsCheaterChat.on and (string.len(player.get_player_name(slot)) < 6 or string.len(player.get_player_name(slot)) > 16)) then
                ui.notify_above_map("Name out of Bounds for: " .. player.get_player_name(slot),"ZModder Detection",140)            
                markSus(player.get_player_name(slot),"Name Length")
            end
            if(player.is_player_in_any_vehicle(slot) and entity.get_entity_god_mode(player.get_player_vehicle(slot))) then              
              playerList[player.get_player_name(slot)]['godvehicle'] = (playerList[player.get_player_name(slot)]['godvehicle']+1)
            end
          else
            playerList[player.get_player_name(slot)]['wasInside'] = true
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
        playerList[player.get_player_name(slot)]['godvehicle'] = 0
        playerList[player.get_player_name(slot)]['godvehicleannounced'] = false
        playerList[player.get_player_name(slot)]['wasInside'] = false
        playerList[player.get_player_name(slot)]['vehiclespeedTime'] = 0
        playerList[player.get_player_name(slot)]['willbeInside'] = 0         
      end      
    end  
  end
  if god.on then
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end

function markSus(player,reason)
  if(susList[player] == nil) then
    susList[player] = {}
    susList[player]["reason"] = ""
  end
  -- local r = Regex("^(".. reason .. ")")
 -- local r = Regex("\b".. reason .. "\b")
 -- local m = r.search(r, susList[player]["reason"])

 -- if(m.count == 0) then
 --   susList[player]["reason"] = susList[player]["reason"] .. "," .. reason
 -- end  +
 
 if(string.find(susList[player]["reason"],"," .. reason) == nil and string.find(susList[player]["reason"],reason .. "," ) == nil) then
    susList[player]["reason"] = susList[player]["reason"] .. "," .. reason
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
  local distance = math.sqrt((newCord['x'] - oldCord['x'])^2 + (newCord['y'] - oldCord['y']^2) + (newCord['z'] - oldCord['z']^2))
  
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

function isValidPos(slot)
  local cords = player.get_player_coords(slot)
  print(player.get_player_name(slot) .. ": " .. round(cords.x,0) .. "," .. round(cords.y,0) .. "," .. round(cords.z,0))  
  -- 11.0,85.0,78.0 Garage outside
  -- 32.0,81.0,75.0 Garage raus
  if((round(cords.x,0) >= -1080.0 and round(cords.x,0) <= -1090.0) and (round(cords.y,0) >= -1260.0 and round(cords.y,0) <= -1270.0)) then
    return true
  end
  if(round(cords.x,0) == 1104.0 and round(cords.y,0) == -3101.0) then
    return true
  end
  if(round(cords.x,0) == 11.0 and round(cords.y,0) == 85.0) then
  
  end
  return false
end

function annouceModder() 
  if(annouceCheaterSMS.on) then
    for slot = 0, 31 do
      if(player.get_player_modder_flags(slot) ~= 0)then
        for slotX = 0, 31 do
          if(player.get_player_modder_flags(slotX) ~= 0)then
            if(player.get_player_modder_flags(slotX) ~= 0)then
              player.send_player_sms(slotX,"Player " .. player.get_player_name(slot) .. " detected as Modder for " .. player.get_modder_flag_text(player.get_player_modder_flags(slot)))
            end         
          end 
        end
      end
    end
  end
  if(annouceCheaterChat.on) then
    for slot = 0, 31 do
      if(player.get_player_modder_flags(slot) ~= 0)then
        for slotX = 0, 31 do
          if(slotX ~= slot) then
            if(player.get_player_modder_flags(slotX) ~= 0)then
              player.send_chat_message("Player " .. player.get_player_name(slot) .. " detected as Modder for " .. player.get_modder_flag_text(player.get_player_modder_flags(slot)),false)
            end  
          end                  
        end
      end
    end
  end  
end

function drawSusInfo()
  if(displaySusIngameInfo.on and not displayIngameInfo.on) then
    local baseV2 = v2(0.045,0.009)
    for slot = 0, 31 do
      if(player.is_player_valid(slot) and playerList[player.get_player_name(slot)] ~= nil) then
        if(susList[player.get_player_name(slot)] ~= nil)then
          if(player.get_player_modder_flags(slot) ~= 0) then
           drawRedText(player.get_player_name(slot) .. " " .. susList[player.get_player_name(slot)]['reason'],baseV2)
          else
            drawText(player.get_player_name(slot) .. " " .. susList[player.get_player_name(slot)]['reason'],baseV2)
          end
          baseV2 = v2(baseV2.x,baseV2.y + 0.02)
        end
      end
    end
  end
end

function drawDisplayInfo()
  -- if(displayIngameInfo.on and not displaySusIngameInfo.on) then    
    local baseV2 = v2(0.045,0.009)
    for slot = 0, 31 do
      if(player.is_player_valid(slot) and playerList[player.get_player_name(slot)] ~= nil and trackedPlayer ~= nil and trackedPlayer[player.get_player_name(slot)] ~= nil and trackedPlayer[player.get_player_name(slot)] == 1) then
        
       -- if(playerList[player.get_player_name(slot)]['godTime'] > 0 or round(playerList[player.get_player_name(slot)]['distanceMoved'],0) > 0) then
          
          if(displayIngameInfo.on) then
            drawText(player.get_player_name(slot) .. " (" .. playerList[player.get_player_name(slot)]['totalChecked'] .. ")",baseV2)
            baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end
          
          
          if(round(playerList[player.get_player_name(slot)]['distanceMoved'],0) and round(playerList[player.get_player_name(slot)]['distanceMoved'],0) > 0 and displayIngameInfo.on)then
            local xoffset = leftOffsetByNumber(round(playerList[player.get_player_name(slot)]['distanceMoved'],0))
            baseV2 = v2((baseV2.x + xoffset),baseV2.y) 
            drawText("Distance Moved: " .. round(playerList[player.get_player_name(slot)]['distanceMoved'],0),baseV2)
            baseV2 = v2((baseV2.x - xoffset),baseV2.y)        
            baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end
          
          if(displayIngameInfo.on and round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0) > 0)then
            local xoffset = leftOffsetByNumber(round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0))
            baseV2 = v2((baseV2.x + xoffset),baseV2.y) 
            drawText("Distance Moved last Second: " .. round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0),baseV2)
            baseV2 = v2((baseV2.x - xoffset),baseV2.y)        
            baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end
          
          if(playerList[player.get_player_name(slot)]['godTime'] > 0 and displayIngameInfo.on) then 
            if(playerList[player.get_player_name(slot)]['godTime'] > (playerList[player.get_player_name(slot)]['totalChecked']/2))then
              drawRedText("God Time: " .. playerList[player.get_player_name(slot)]['godTime'] .. "/" .. playerList[player.get_player_name(slot)]['totalChecked'],baseV2)
            else 
              drawText("God Time: " .. playerList[player.get_player_name(slot)]['godTime'] .. "/" .. playerList[player.get_player_name(slot)]['totalChecked'],baseV2)
            end
              baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end
          if(displayIngameInfo.on and playerList[player.get_player_name(slot)]['godvehicle'] > (playerList[player.get_player_name(slot)]['totalChecked']/2)) then 
             drawText("God Vehicle Time: " .. playerList[player.get_player_name(slot)]['godvehicle'] .. "/" .. playerList[player.get_player_name(slot)]['totalChecked'],baseV2)
             baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end
          
          if(displayIngameInfo.on and playerList[player.get_player_name(slot)]['willbeInside'] > 0) then 
             drawText("Time since last teleport: " .. playerList[player.get_player_name(slot)]['willbeInside'],baseV2)
             baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end
          
          if(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'] > 0 and not playerList[player.get_player_name(slot)]['wasInside']) then
            if(round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0) > 112 and player.get_player_vehicle(slot) ~= nil) then
              if (playerList[player.get_player_name(slot)]['vehiclespeedTime'] > 2) then
                markSus(player.get_player_name(slot),"Vehicle Speed")
              end             
             
              if(displayIngameInfo.on and round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0) > 0) then
                local ms = round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0)
                drawRedText("m/s: " .. ms .. " (" .. (ms * 3.6) .. " km/h)",baseV2)
              end
            else
              if(displayIngameInfo.on) then
                local ms = round(playerList[player.get_player_name(slot)]['lastSecondDistanceMoved'],0)
                drawText("m/s: " .. ms .. " (" .. (ms * 3.6) .. " km/h)",baseV2)
              end
            end
            baseV2 = v2(baseV2.x,baseV2.y + 0.02)
          end     
        --end 
        if(player.is_player_in_any_vehicle(slot)) then
          
          local vm = require("ZeroMenuLib/enums/VehicleMapper")
          local hash = entity.get_entity_model_hash(ped.get_vehicle_ped_is_using(player.get_player_ped(slot)))
          if(hash ~= nil) then
            if(streaming.is_model_a_heli(hash) or streaming.is_model_a_plane(hash)) then
              local vehicleName = vm.GetNameFromHash(hash)
              if(vehicleName == nil) then vehicleName = "Unknown Plane" end
              drawText("Is flying a " .. vehicleName,baseV2)
            else
              local vehicleName = vm.GetNameFromHash(hash)
              if(vehicleName == nil) then vehicleName = "Unknown Vehicle" end
              drawText("Is driving a " .. vehicleName,baseV2)
            end
          end
          
        else
          drawText("Walks ",baseV2)
        end
        --Abstand zum N�chsten Eintrag
          baseV2 = v2(baseV2.x,baseV2.y + 0.02)       
      end    
    end
 -- end  
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
  local baseV2N = v2((baseV2.x + (string.len(text) * 0.0015)),baseV2.y)
  ui.draw_text(text,baseV2N)
end
function drawText(text,baseV2)
  ui.set_text_scale(0.28)
  ui.set_text_font(0)
  ui.set_text_color(255, 255, 255, 255)
  ui.set_text_centre(1)
  ui.set_text_outline(1)
  local baseV2N = v2((baseV2.x + (string.len(text) * 0.0015)),baseV2.y)
  ui.draw_text(text,baseV2N)
end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end