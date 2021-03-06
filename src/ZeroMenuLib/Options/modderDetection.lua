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

-- list for all players containing lists
local playerList
local lastGC = 0

local vpnIPList

local checkedList

local VPNCheckerThread,VPNCheckerThread2


local doVar = true

function createModderDetectionMenuEntry(parent,config)

	zModderMain = menu.add_feature("Zero's Modder Detection", "parent", parent.id, nil)
	
  --config:saveIfNotExist("godCheck",false)
  --config:saveIfNotExist("visibleCheck",false)
  --config:saveIfNotExist("PositionCheck",false)
  --config:saveIfNotExist("RequestCheck",false)
  --config:saveIfNotExist("IpCheck",false)

	-- Main Features
	god = createConfigedMenuOption("Godmode check","toggle",zModderMain.id,checkPlayersForGod,config,"godCheck",false,nil)
	--god	= menu.add_feature("Godmode check", "toggle", zModderMain.id, checkPlayersForGod)
	god.threaded = false

	if config:isFeatureEnabled("godCheck") then
    god.on = true
  end
	visible = createConfigedMenuOption("Visible check (EXP)","toggle",zModderMain.id,checkInvisible,config,"visibleCheck",false,nil)
	--visible	= menu.add_feature("Visible check", "toggle", zModderMain.id, checkInvisible)
	visible.threaded = false

	if config:isFeatureEnabled("visibleCheck") then
    visible.on = true
  end

	positionchecker = createConfigedMenuOption("Position check","toggle",zModderMain.id,logDistanceMovedPerSec,config,"PositionCheck",false,nil)
  --positionchecker = menu.add_feature("Position Checker", "toggle", zModderMain.id, logDistanceMovedPerSec)
  positionchecker.threaded = false

  if config:isFeatureEnabled("PositionCheck") then
    positionchecker.on = true
  end

  controlchecker = createConfigedMenuOption("Request Control Checker  (EXP)","toggle",zModderMain.id,checkRequestControl,config,"RequestCheck",false,nil)
  --controlchecker = menu.add_feature("Request Control Checker", "toggle", zModderMain.id, checkRequestControl)
  controlchecker.threaded = false

  if config:isFeatureEnabled("RequestCheck") then
    controlchecker.on = true
  end

	playerList = {}

	--vpnIPList = loadVPNList()
	checkedList = {}
end


function loadVPNList()
  vpnlist = {}

 local file = io.open(vpipv4, "r");
 for line in file:lines() do
    vpnlist[line] = true;
 end
  return vpnlist;
end

function checkInvisible()
  for slot = 0, 31 do
    if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
      updatePlayerInfos(slot)
      local perPlayerList = playerList[player.get_player_name(slot)]
      if not entity.is_entity_visible(player.get_player_ped(slot)) and perPlayerList['distanceMoved'] >  0 then
        ui.notify_above_map(player.get_player_name(slot) .. " is invisible ","ZModder Detection",140)
      end
    end
  end
    if visible.on then
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end

function checkRequestControl()
  for slot = 0, 31 do
    if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
      updatePlayerInfos(slot)
      local perPlayerList = playerList[player.get_player_name(slot)]
      if perPlayerList['lastControlCheck'] ~= nil then
        if (os.time() - perPlayerList['lastControlCheck']) > 1 then
          if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
          ped = player.get_player_ped(slot)
            if not network.has_control_of_entity(ped) then
              network.request_control_of_entity(ped)
            end
            if not network.has_control_of_entity(ped) then
              ui.notify_above_map(player.get_player_name(slot) .. " blocked request  ","ZModder Detection",140)
            end
          end
        else
          perPlayerList['lastControlCheck'] = os.time()
        end
      else
         perPlayerList['lastControlCheck'] = os.time()
      end
    end
  end
  if controlchecker.on then
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end

function checkPlayersForGod()
	for slot = 0, 31 do
		if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
			-- add a player if not inside
			updatePlayerInfos(slot)

			local perPlayerList = playerList[player.get_player_name(slot)]
			
			if perPlayerList['totalGodTime'] >= minCheckTime/2 then
				if perPlayerList['totalChecked'] >= minCheckTime then
					-- inside rc vehicle car?
					--if player.get_player_vehicle(slot) == 0 then
					-- if entity.is_entity_visible(player.get_player_ped(slot)) then
  					 ui.notify_above_map(player.get_player_name(slot) .. " is using god since " .. perPlayerList['totalGodTime'] .. " of " .. minCheckTime .. " seconds","ZModder Detection",140)
             player.set_player_as_modder(slot,1)
					 --end

					--end
				end
			end
		end
	end
	if god.on then
		return HANDLER_CONTINUE
	else
		return HANDLER_POP
	end
end


function logDistanceMovedPerSec()
	for slot = 0, 31 do
		if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
			-- add a player if not inside
			updatePlayerInfos(slot)
			local perPlayerList = playerList[player.get_player_name(slot)]

			if  perPlayerList['distanceMoved'] >  500 and player.get_player_coords(slot).y > 0 then
				ui.notify_above_map(player.get_player_name(slot) .. " moved " .. perPlayerList['distanceMoved'] .. " teleport?","ZModder Detection",140)
			end
		end
	end
	if positionchecker.on then
		return HANDLER_CONTINUE
	else
		return HANDLER_POP
	end
end

-- This function is called by every subfeature
-- It updates the information stored about the players and resets them after > minCheckTime
function updatePlayerInfos(slot)
	if playerList[player.get_player_name(slot)] == nil then
		playerList[player.get_player_name(slot)] = {}
		playerList[player.get_player_name(slot)]['cords'] = player.get_player_coords(slot)
		playerList[player.get_player_name(slot)]['scid'] = player.get_player_scid(slot)
		playerList[player.get_player_name(slot)]['distanceMoved'] = 0
		playerList[player.get_player_name(slot)]['totalMoveCheck'] = 0
		playerList[player.get_player_name(slot)]['lastCheck'] = os.time()
		playerList[player.get_player_name(slot)]['totalChecked'] = 0

		playerList[player.get_player_name(slot)]['gotTime'] = 0
		playerList[player.get_player_name(slot)]['totalGodTime'] = 0
		print("new data for slot " .. slot)
	end

	local perPlayerList = playerList[player.get_player_name(slot)]

	-- tped to a interior, reset distancemoved
	if isPlayerInside(slot) then
		perPlayerList['distanceMoved'] = 0
		-- perPlayerList['totalGodTime'] = 0
	end

	-- Check the player for unnormal stuff
	if perPlayerList['totalChecked'] >= (minCheckTime+1) then
		if perPlayerList['totalGodTime'] > 0 and perPlayerList['distanceMoved'] > 0 then
			debugPrint(player.get_player_name(slot) .. "'s godtime = " .. perPlayerList['totalGodTime'])
			debugPrint(player.get_player_name(slot) .. "'s distance moved = " .. perPlayerList['distanceMoved'])
			debugPrint(os.date("%X") .. " reset " .. player.get_player_name(slot))
		end
		if(slot == 5) then
		  print("reset slot 5")
		end
		perPlayerList['totalChecked'] = 0
		perPlayerList['distanceMoved'] = 0
		perPlayerList['totalGodTime'] = 0
		perPlayerList['cords'] = player.get_player_coords(slot)
	end
  
  
  
	--Prüfe ojede Sekunde vergangen ist
	if (os.time() - perPlayerList['lastCheck']) >= 1 then
	
	if(slot == 5) then
      debugPrint(player.get_player_name(slot) .. "'s godtime = " .. perPlayerList['totalGodTime'])
      debugPrint(player.get_player_name(slot) .. "'s distance moved = " .. perPlayerList['distanceMoved'])
  end
  
		--check for movement
		local oldCord = perPlayerList['cords']
		local newCord = player.get_player_coords(slot)
		local distance = math.sqrt(math.pow(newCord['x'] - oldCord['x'],2) + math.pow(newCord['y'] - oldCord['y'],2) + math.pow(newCord['z'] - oldCord['z'],2))

    if(slot == 5) then
      -- print("oldCord: " .. oldCord)
      -- print("newCord: " .. newCord)
      print("distance: " .. distance)
      print("summed distance = " .. perPlayerList['distanceMoved'])
    end

		perPlayerList['distanceMoved'] = (perPlayerList['distanceMoved'] + distance)
		perPlayerList['cords'] = player.get_player_coords(slot)
		perPlayerList['lastCheck'] = os.time()
		perPlayerList['totalChecked'] = (perPlayerList['totalChecked']+1)
    playerList[player.get_player_name(slot)] = perPlayerList

if(slot == 5) then
      -- print("oldCord: " .. oldCord)
      -- print("newCord: " .. newCord)
      print("distance: " .. distance)
      print("summed distance = " .. perPlayerList['distanceMoved'])
    end

		--check for godtime
		if player.is_player_god(slot) then
			if interior.get_interior_from_entity(player.get_player_ped(slot)) ~= nil and interior.get_interior_from_entity(player.get_player_ped(slot)) == 0 and not isPlayerInside(slot) then
			 -- check if "inside" below map
			 if(player.get_player_coords(slot).z > -50) then
  			 if perPlayerList['distanceMoved'] > 0 then
  			 
            perPlayerList['totalGodTime'] = (perPlayerList['totalGodTime']+1)
            --perPlayerList['distanceMoved'] = 0
            -- print(interior.get_interior_from_entity(player.get_player_ped(slot)))
            -- print(isPlayerInside(slot))
          end
       --else
       --   print("ignoring " .. player.get_player_name(slot) .. " z > -50 (" .. player.get_player_coords(slot).z .. ")")
       --   print("(" .. player.get_player_coords(slot).x .. "," .. player.get_player_coords(slot).y .. "," .. player.get_player_coords(slot).z ..")")
			 end
				
			end
		end
		--Clear disconnected Users every min
		if (os.time() - lastGC) >= 60 then
			local tempPlayerList = {}
			for slot = 0, 31 do
				-- Is the player stored?
				if playerList[player.get_player_name(slot)] ~= nil then
					tempPlayerList[player.get_player_name(slot)] = playerList[player.get_player_name(slot)]
				end
			end
			--delete references
			playerList = nil
			-- relink list
			playerList = tempPlayerList

			lastGC = os.time()
		end
	end
end
function isPlayerInside(slot)
  local interior = script.get_global_i(2424073 + (slot * 421) + 235 + 1)
  --print(interior)
  return interior ~= 0
end
function debugPrint(message)
  if debugSetting then
    print(message)
  end
end