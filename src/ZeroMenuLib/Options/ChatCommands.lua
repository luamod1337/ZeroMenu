
require("ZeroMenuLib/Util/Util")

local eventName = require("ZeroMenuLib/enums/EventName")
local eModderDetectionFlags = require("ZeroMenuLib/enums/ModderDetectionFlag")
local forceTyp = require("ZeroMenuLib/enums/ForceTyp")

local chatLog
local chatLogOption,chatCommandsOption,upgradeCommand,slapCommand
local chatLogPath =os.getenv("APPDATA") .. "\\PopstarDevs\\2Take1Menu\\scripts\\ZeroMenu2\\chat.log"


function createChatCommands(parent,config)
  chatCommandParent = menu.add_feature("Chatevents", "parent", parent.id, nil)
  event.add_event_listener(eventName.CHAT,onChatEvent)
    
    
  chatLogOption = menu.add_feature("Chatlog", "toggle", chatCommandParent.id, nil)
  chatCommandsOption = menu.add_feature("Enable Chatcommands", "toggle", chatCommandParent.id, nil)
  upgradeCommand = menu.add_feature("Enable Upgrade Command", "toggle", chatCommandParent.id, nil)
  slapCommand = menu.add_feature("Enable Slap Command", "toggle", chatCommandParent.id, nil)
    
  chatLog = io.open (chatLogPath,"a")
  chatLog:write("#Created using 1337Zeros ZeroMenu\n")

if not utils.file_exists(chatLogPath) then
    file = io.open(chatLogPath, "w")
    file:write("#Created using 1337Zeros ZeroMenu\n")
    file:close()
  end
end


function onChatEvent(event)
  --print(os.date("[%d/%m/%Y %H:%M:%S]") .. " " .. event.player .. " > " .. event.body .. "\n")
  if chatLogOption.on then
    logChat(event.player,event.body)
  end
  if chatCommandsOption.on and starts_with(event.body,"!")then  
    onChatCommand(event.player,event.body)  
  end
end

function starts_with(str, start)
   return str:sub(1, #start) == start
end

function logChat(playerVar,messageVar)  
  if gameplay.is_game_state(0) then
    local playerXScid = player.get_player_name(playerVar) .. "|" .. player.get_player_scid(playerVar)
    if isPlayerModder(playerVar) then    
      local playerXScid = "[M] " ..player.get_player_name(playerVar) .. "|" .. player.get_player_scid(playerVar)  
    end
    file = io.open(chatLogPath, "a")
    file:write(os.date("[%d/%m/%Y %H:%M:%S]") .. " " .. playerXScid .. " > " .. messageVar .. "\n")
    file:close()
  end  
end

function onChatCommand(slot,messageVar)
  local splittedMessage = splitString(messageVar)
  print(#splittedMessage)
  if player.is_player_valid(slot) then
    if #splittedMessage == 1 then
      if splittedMessage[0] == "!upgrade" and upgradeCommand.on then
        local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot))
        local speed = tonumber(splittedMessage[1])
        if veh ~= nil then
          if not network.has_control_of_entity(veh) then
            network.request_control_of_entity(veh)  
          end 
          entity.set_entity_max_speed(veh,speed*1000)
          vehicle.modify_vehicle_top_speed(veh,speed)
          vehicle.set_vehicle_engine_torque_multiplier_this_frame(veh,speed)
          entity.get_entity_model_hash(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())))
          ui.notify_above_map("Tuned Vehicle of " .. player.get_player_name(slot),"ZeroMenu - Chat",140)
        end
      else if splittedMessage[0] == "!slap" and slapCommand.on then
        local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot)) 
        if veh ~= nil then
          if veh ~= nil then
            if not network.has_control_of_entity(veh) then
              network.request_control_of_entity(veh)  
            end          
            entity.set_entity_max_speed(veh,10000)
            local rotation = v3()
              rotation.z = 180
              rotation.y = 0
              rotation.x = 0
            entity.set_entity_rotation(veh,rotation)
            vehicle.set_vehicle_forward_speed(veh, 100)
        else 
          
          local ped = player.get_player_ped(slot)
          if not network.has_control_of_entity(ped) then
              network.request_control_of_entity(ped)  
          end    
          entity.apply_force_to_entity(ped,forceTyp.MinForce,10,0,0,10,0,0,true,true)
        end
      end
    end
  end
end

function pushAwayGrief(feat,slot)
  local rotation = v3()
    rotation.z = 180
    rotation.y = 0
    rotation.x = 0
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot)) 
  if veh ~= nil then
    if not network.has_control_of_entity(veh) then
      network.request_control_of_entity(veh)  
    end 
  if lastSpeed == 0 then
    local r, s = input.get("Enter new Torque", 10000, 64, 0)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    lastSpeed = s
  end  
    entity.set_entity_max_speed(veh,10000)
    vehicle.set_vehicle_out_of_control(veh,false,false)   
    entity.set_entity_rotation(veh,rotation)
    vehicle.set_vehicle_forward_speed(veh, lastSpeed)
    if feat.on then
      return HANDLER_CONTINUE
    end
  end     
end

function splitString(message)
   t = {}
   cnt = 0
   for i in string.gmatch(message, "%S+") do
     t[cnt] = i
     cnt = cnt +1
   end
  return t
end