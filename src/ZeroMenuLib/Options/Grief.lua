
function createGriefEntry(config)
  local parent = menu.add_player_feature("ZeroMenu Grief","parent",0,nil)  
  menu.add_player_feature("Vehicle Speed Grief","action",0,speedVehicleGriefPlayer) 
  menu.add_player_feature("Vehicle Speed Upgrade Grief","action",0,speedVehicleUpgradeGriefPlayer)
  menu.add_player_feature("Vehicle Door Grief","action",0,doorVehicleGriefPlayer)
 
  menu.add_player_feature("Push Grief","toggle",0,pushAwayGrief)  
  menu.add_player_feature("Disable Vehicle","toggle",0,disableVehicle)  
  menu.add_player_feature("Net event Log","toggle",0,logNetEventsAndBlock)  
  griefscream = menu.add_player_feature("Scream Grief","toggle",0,screamGriefPlayer)
  griefcontrol = menu.add_player_feature("Control Grief","toggle",0,controlVehicleGriefPlayer)

end


function speedVehicleGriefPlayer(feat, slot)
  if slot ~= player.player_id()  then
    if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
      local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot))
      if veh ~= nil then
        if not network.has_control_of_entity(veh) then
          network.request_control_of_entity(veh)  
        end 
        entity.set_entity_max_speed(veh,1)
        vehicle.modify_vehicle_top_speed(veh,1)
        vehicle.set_vehicle_engine_torque_multiplier_this_frame(veh,1)
        ui.notify_above_map("Set Max Speed to 1 for slot " .. slot ,"ZeroMenu Grief",140)
      else
        ui.notify_above_map("Target isn't inside a Vehicle","ZeroMenu Grief",140)
      end     
    else
      ui.notify_above_map("Invalid Player","ZeroMenu Grief",140)
    end
  else
    ui.notify_above_map("I wouldn't grief yourself!","ZeroMenu Grief",140)
  end
end


local logThisPlayer = {}

function logNetEventsAndBlock(feat,slot)
  
  if(feat.on) then    
    logThisPlayer[player.get_player_name(slot)] = 1
  else  
    logThisPlayer[player.get_player_name(slot)] = 0 
  end
 hook.register_net_event_hook(netEventCallBack)
 hook.register_script_event_hook(scriptEventCallBack)
  
end

function netEventCallBack(slot,target,eventID)
  if target == player.player_id() then
    if (logThisPlayer[player.get_player_name(slot)] ~= nil and logThisPlayer[player.get_player_name(slot)]  == 1) then
      local eventToInt = require("ZeroMenuLib/enums/EventToInt")
      local eventname = eventToInt[eventID]
      if eventname ~= nil then
        ui.notify_above_map("blocked event " .. eventname .. " from " .. player.get_player_name(slot),"Net Event Block - ZeroMenu",140)
        logEvent("blocked event " .. eventname .. " from " .. player.get_player_name(slot))
      else
        ui.notify_above_map("blocked event " .. eventID .. " from " .. player.get_player_name(slot),"Net Event Block - ZeroMenu",140)
        logEvent("blocked event " .. eventID .. " from " .. player.get_player_name(slot))
      end
      
      return false
    end
  end
end

function scriptEventCallBack(slot, target, params, count)
  if target == player.player_id() then
    if (logThisPlayer[player.get_player_name(slot)] ~= nil and logThisPlayer[player.get_player_name(slot)]  == 1) then
      ui.notify_above_map("blocked script event " .. count .. " from " .. player.get_player_name(slot),"Script Event Block - ZeroMenu",140)
      logEvent("blocked script event (size: " .. count .. ") from " .. player.get_player_name(slot))
      local cnt = 0
      for k in pairs(params) do 
        ui.notify_above_map("paramteter " .. cnt .. " = " .. k,"Script Block - ZeroMenu",140)
        logEvent("paramteter " .. cnt .. " = " .. k)
        cnt = cnt+1
      end
      return false
    end
  end
end
local chatEventPath =os.getenv('APPDATA') .. "\\PopstarDevs\\2Take1Menu\\scripts\\ZeroMenuLib\\data\\event.log"

function logEvent(message)    
  if not utils.file_exists(chatEventPath) then
   -- utils.make_dir(chatEventPath)
    file = io.open(chatEventPath, "w")
    file:write("#Created using 1337Zeros ZeroMenu\n")
    file:close()
  end

  file = io.open(chatEventPath, "a")
  file:write(os.date("[%d/%m/%Y %H:%M:%S]") .. " " .. message ..  "\n")
  file:close()
end

function disableVehicle(feat,slot)
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot)) 
  if veh ~= nil then
    if not network.has_control_of_entity(veh) then
      network.request_control_of_entity(veh)  
    end 
    vehicle.set_vehicle_out_of_control(veh,false,false)
    entity.set_entity_max_speed(veh,1)
    vehicle.modify_vehicle_top_speed(veh,1)
    vehicle.set_vehicle_engine_torque_multiplier_this_frame(veh,1)
    vehicle.set_vehicle_engine_on(veh,false,true,true)
  end
  if feat.on then
      return HANDLER_CONTINUE
    else
      return HANDLER_POP      
    end
end

local lastSpeed = 0

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
    local r, s = input.get("Enter new Torque", 10000, 64, 3)
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
    else
      return HANDLER_POP      
    end
  end   	
end
function controlVehicleGriefPlayer(feat, slot)
  if slot ~= player.player_id()  then
    if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
      local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot))
      if veh ~= nil then
        if not network.has_control_of_entity(veh) then
          network.request_control_of_entity(veh)  
        end 
        entity.set_entity_max_speed(veh,1)
        vehicle.set_vehicle_out_of_control(veh,false,false)   
        ui.notify_above_map("Set out of control for slot " .. slot ,"ZeroMenu Grief",140)
      else
        ui.notify_above_map("Target isn't inside a Vehicle","ZeroMenu Grief",140)
      end     
    else
      ui.notify_above_map("Invalid Player","ZeroMenu Grief",140)
    end
  else
    ui.notify_above_map("I wouldn't grief yourself!","ZeroMenu Grief",140)
  end
  
  if feat.on then    
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end
function speedVehicleUpgradeGriefPlayer(feat, slot)
  if slot ~= player.player_id()  then
    if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
      local r, s = input.get("Enter new Torque", 1000000, 64, 3)
      if r == 1 then return HANDLER_CONTINUE end
      if r == 2 then return HANDLER_POP end
      
      local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot))
      if veh ~= nil then
        if not network.has_control_of_entity(veh) then
          network.request_control_of_entity(veh)  
        end 
        entity.set_entity_max_speed(veh,s)
        vehicle.modify_vehicle_top_speed(veh,1000000)        
        vehicle.set_vehicle_engine_torque_multiplier_this_frame(veh,s)
        ui.notify_above_map("Set Max Speed to " .. s,"ZeroMenu Grief",140)
      else
        ui.notify_above_map("Target isn't inside a Vehicle","ZeroMenu Grief",140)
      end     
    else
      ui.notify_above_map("Invalid Player","ZeroMenu Grief",140)
    end
  else
    ui.notify_above_map("I wouldn't grief yourself!","ZeroMenu Grief",140)
  end
 --if grief_upgrade.on then    
  --  return HANDLER_CONTINUE
  --else
  --  return HANDLER_POP
  --end
end

function doorVehicleGriefPlayer(feat, slot)
  if slot ~= player.player_id()  then
    if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then
      local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot))
      if veh ~= nil then
        if not network.has_control_of_entity(veh) then
          network.request_control_of_entity(veh)  
        end 
        vehicle.set_vehicle_doors_locked(veh,4)
        ui.notify_above_map("Locked doors of vehicle","ZeroMenu Grief",140)
      else
        ui.notify_above_map("Target isn't inside a Vehicle","ZeroMenu Grief",140)
      end     
    else
      ui.notify_above_map("Invalid Player","ZeroMenu Grief",140)
    end
  else
    ui.notify_above_map("I wouldn't grief yourself!","ZeroMenu Grief",140)
  end
 --if grief_door.on then    
  --  return HANDLER_CONTINUE
  --else
  --  return HANDLER_POP
  --end
end

function screamGriefPlayer(feat, slot)
  if player.get_player_scid(slot) ~= -1 and player.get_player_scid(slot) ~= 4294967295 then     
    -- AUDIO::PLAY_SOUND_FROM_COORD(-1, "Horn", sub_f5aa(), "DLC_Apt_Yacht_Ambient_Soundset", 0, 500, 0);
    audio.play_sound_from_coord(-1,"Prison_Finale_Buzzard_Rocket_Player", entity.get_entity_coords(player.get_player_ped(slot)), "DLC_HEISTS_GENERIC_SOUNDS", true, 5, true)        
    audio.play_sound_from_coord(-1,"CREAK_01", entity.get_entity_coords(player.get_player_ped(slot)), "DOCKS_HEIST_SETUP_SOUNDS", true, 5, true)        
        
    audio.play_sound_from_coord(-1,"Horn", entity.get_entity_coords(player.get_player_ped(slot)), "DLC_Apt_Yacht_Ambient_Soundset", true, 5, false)        
    audio.play_sound_from_coord(-1,"SHUTTER_FLASH", entity.get_entity_coords(player.get_player_ped(slot)), "CAMERA_FLASH_SOUNDSET", true, 5, false)        
        
    ui.notify_above_map("Horned him","ZeroMenu Grief",140)
  else
    ui.notify_above_map("Invalid Player","ZeroMenu Grief",140)
  end
  if feat.on then    
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end

function chaseVehicle(feat, slot)

  if ped.get_vehicle_ped_is_using(player.get_player_ped(slot)) ~= nil then
    
    local r, s = input.get("Chase distance",100, 64, 3)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    
    ai.set_task_vehicle_chase_ideal_persuit_distance(player.get_player_ped(player.get_player_ped(player.player_id()),s))    
    ai.task_vehicle_chase(player.get_player_ped(player.get_player_ped(player.player_id())),slot)  
  end
end

function setHeliBladeSpeed(feat, slot)
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(slot))
  local r, s = input.get("Enter new Torque", 0, 64, 3)
  if r == 1 then return HANDLER_CONTINUE end
  if r == 2 then return HANDLER_POP end
  
  if veh ~= nil and streaming.is_model_a_heli(entity.get_entity_model_hash(veh)) then
    vehicle.set_heli_blades_speed(veh,s)
  end
  if feat.on then    
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end