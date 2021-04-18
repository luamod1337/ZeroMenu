require("ZeroMenuLib/Util/Util")

local speed = 15000
local distance = 50
local askedInput = false

local lastVehicle = 0



function loadVehicleMenu(parent,config)
  
  

  vehiclesubmenu = menu.add_feature("Vehicle", "parent", parent.id, nil)
  vehiclesubmenu.threaded = false


  slow = menu.add_feature("Slow", "action", vehiclesubmenu.id, slowVehicle)
  slow.threaded = false 
  
  tune = menu.add_feature("Tune", "action", vehiclesubmenu.id, tuneVehicle)
  tune.threaded = false
  
  drift = menu.add_feature("Drift", "action", vehiclesubmenu.id, tuneDriftVehicle)
  drift.threaded = false

  maxSpeed = menu.add_feature("Remove Max Speed", "action", vehiclesubmenu.id, removeMaxSpeedVehicle)
  maxSpeed.threaded = false
  
  setMaxSpeed = menu.add_feature("Set Max Speed", "action", vehiclesubmenu.id, setMaxSpeedVehicle)
  setMaxSpeed.threaded = false

  setHeliBladeSpeed = menu.add_feature("Set Heli Blade Speed", "action", vehiclesubmenu.id, setHeliBladeSpeed)
  setHeliBladeSpeed.threaded = false

  vehicleParachute = menu.add_feature("Open Vehicle Parachute", "action", vehiclesubmenu.id, openVehicleParachute)
  vehicleParachute.threaded = false
  
  freezeVehicleOnExitVar = createConfigedMenuOption("Freeze Vehicle on exit","toggle",vehiclesubmenu.id,freezeVehicleOnExit,config,"freezeVehOnExit",false,nil)
  --freezeVehicleOnExitVar = menu.add_feature("Freeze Vehicle on exit", "toggle", vehiclesubmenu.id, freezeVehicleOnExit)
  freezeVehicleOnExitVar.threaded = false
  
  noClipVehicleOnExitVar = createConfigedMenuOption("NoClip Vehicle on exit (stay nearby)","toggle",vehiclesubmenu.id,NoClipVehicleOnExit,config,"noClipVehOnExit",false,nil)
  --noClipVehicleOnExitVar = menu.add_feature("NoClip Vehicle on exit", "toggle", vehiclesubmenu.id, NoClipVehicleOnExit)
  noClipVehicleOnExitVar.threaded = false

  
  vehicleArcobatic = menu.add_feature("Arcobatic Right", "toggle", vehiclesubmenu.id, ArcrobaticRight)
  vehicleMods = menu.add_feature("Vehicle Mods", "parent", vehiclesubmenu.id, nil)
  vehicleAttach = menu.add_feature("Safety First", "action", vehicleMods.id, attachCandles)
  vehicleAttach = menu.add_feature("Add Ramp", "action", vehicleMods.id, attachRamp)
  vehicleAttachLamp = menu.add_feature("Lamp Tire", "action", vehicleMods.id, attachLampToTire)
  spawnobject = menu.add_feature("Spawn Object", "action", vehicleMods.id, spawnObject)
    
end
local requestedObject = 0
function spawnObject()

if requestedObject == 0 then
    local r, s = input.get("Enter Object Hash", 10000, 64, 3)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    requestedObject = s
  end
  if(streaming.has_model_loaded(requestedObject)) then  
    local objectCandle = object.create_object(requestedObject,player.get_player_coords(player.player_id()),true,true)
    requestedObject = 0
    streaming.set_model_as_no_longer_needed(requestedObject) 
    return HANDLER_POP
  else
    streaming.request_model(requestedObject)
    return HANDLER_CONTINUE
  end
end
function attachLampToTire()
 local lentity = player.get_player_vehicle(player.player_id())
  
  
  -- wheel_lf
  -- wheel_rf
  -- wheel_lm1
  -- wheel_rm1
  -- wheel_lm2
  -- wheel_rm2
  -- wheel_lm3
  -- wheel_rm3
  -- wheel_lr
  -- wheel_rr
  --attach_entity_to_entity(Entity subject, Entity target, int boneIndex, v3 offset, v3 rot, bool softPinning, bool collision, bool isPed, int vertexIndex, bool fixedRot)
  local candle = -647884455
  if(streaming.has_model_loaded(candle)) then  
    local objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    local offset = v3(0,0,0)
    local rot = v3(0,0,0)
        
        print(entity.is_entity_a_vehicle(lentity))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_lf"))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_rf"))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_lm1"))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_rm1"))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_lm2"))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_rm2"))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_lm3"))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_lr"))
  print(entity.get_entity_bone_index_by_name(lentity,"wheel_rr"))
        
            --attach_entity_to_entity(subject,target, int boneIndex, v3 offset, v3 rot, bool softPinning, bool collision, bool isPed, int vertexIndex, bool fixedRot)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lf"),offset,rot,false,true,false,0,true)
    objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_rf"),offset,rot,false,true,false,0,true)
    objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lm1"),offset,rot,false,true,false,0,true)
    objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_rm1"),offset,rot,false,true,false,0,true)
    objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lm2"),offset,rot,false,true,false,0,true)
    objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_rm2"),offset,rot,false,true,false,0,true)
    objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lm3"),offset,rot,false,true,false,0,true)
    objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lr"),offset,rot,false,true,false,0,true)
    objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_rr"),offset,rot,false,true,false,0,true)
    
    
    streaming.set_model_as_no_longer_needed(candle) 
    return HANDLER_POP
  else
    streaming.request_model(candle)
    return HANDLER_CONTINUE
  end
end
function attachRamp()
  local candle = 1290523964
  local lentity = player.get_player_vehicle(player.player_id())
  if(streaming.has_model_loaded(candle)) then  
    local objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    local offset = v3(0,5,0)
    local rot = v3(0,0,180)        
        

    print(entity.get_entity_bone_index_by_name(lentity,"bonnet"))
            --attach_entity_to_entity(subject,target, int boneIndex, v3 offset, v3 rot, bool softPinning, bool collision, bool isPed, int vertexIndex, bool fixedRot)
    entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"bonnet"),offset,rot,false,true,false,0,true)
    streaming.set_model_as_no_longer_needed(candle) 
    return HANDLER_POP
  else
    streaming.request_model(candle)
    return HANDLER_CONTINUE
  end


end

local callStack = 0
function attachCandles()
  local lentity = player.get_player_vehicle(player.player_id())
  
  
  -- wheel_lf
  -- wheel_rf
  -- wheel_lm1
  -- wheel_rm1
  -- wheel_lm2
  -- wheel_rm2
  -- wheel_lm3
  -- wheel_rm3
  -- wheel_lr
  -- wheel_rr
  --attach_entity_to_entity(Entity subject, Entity target, int boneIndex, v3 offset, v3 rot, bool softPinning, bool collision, bool isPed, int vertexIndex, bool fixedRot)
  --2041509221 - safety first
  local candle = -1915729838
  if(streaming.has_model_loaded(candle)) then  
    local objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    local offset = v3(0,0,0)
    local rot = v3(0,0,0)
     --[[
      print(entity.is_entity_a_vehicle(lentity))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_lf"))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_rf"))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_lm1"))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_rm1"))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_lm2"))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_rm2"))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_lm3"))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_lr"))
      print(entity.get_entity_bone_index_by_name(lentity,"wheel_rr"))
    --]]
    if(graphics.has_named_ptfx_asset_loaded("core")) then
      print("core loaded")
      graphics.set_next_ptfx_asset("core")
      graphics.start_ptfx_looped_on_entity("scr_clown_appears",player.get_player_ped(player.player_id()),offset,rot,10.0)
              --attach_entity_to_entity(subject,target, int boneIndex, v3 offset, v3 rot, bool softPinning, bool collision, bool isPed, int vertexIndex, bool fixedRot)
      --[[
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lf"),offset,rot,false,true,false,0,true)
      
      objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_rf"),offset,rot,false,true,false,0,true)
      objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lm1"),offset,rot,false,true,false,0,true)
      objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_rm1"),offset,rot,false,true,false,0,true)
      objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lm2"),offset,rot,false,true,false,0,true)
      objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_rm2"),offset,rot,false,true,false,0,true)
      objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lm3"),offset,rot,false,true,false,0,true)
      objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_lr"),offset,rot,false,true,false,0,true)
      objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      entity.attach_entity_to_entity(objectCandle,lentity,entity.get_entity_bone_index_by_name(lentity,"wheel_rr"),offset,rot,false,true,false,0,true)
      
      graphics.start_ptfx_looped_on_entity("ptfx_ribbon_candle_flame",objectCandle,offset,rot,1.0)
      --]]
      callStack = 0
      streaming.set_model_as_no_longer_needed(candle) 
      return HANDLER_POP
    else
      graphics.request_named_ptfx_asset("core")
      print("request scr_rcbarry2 ")
      if(callStack > 50)then
        print("fast out " .. callStack .. " > 10")
        return HANDLER_POP
      else
        callStack = callStack+1
      end
      return HANDLER_CONTINUE
    end
  else
    streaming.request_model(candle)
    return HANDLER_CONTINUE
  end
end

local lastAcro = 0

function ArcrobaticRight()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
  local vehRotationV3 = entity.get_entity_rotation(veh)
    --rotation.z = 0
    --rotation.x = 0
        
    if(vehRotationV3.y < 75 and (os.time() - lastAcro) > 0)then
      vehRotationV3.y = 75
      entity.set_entity_rotation(veh,vehRotationV3)
      lastAcro = os.time()
    else
      print(vehRotationV3.y)
    end
  
    if vehicleArcobatic.on then    
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
    
end

function tuneVehicle()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
  local r, s = input.get("Enter new Torque", 100, 64, 3)
  if r == 1 then return HANDLER_CONTINUE end
  if r == 2 then return HANDLER_POP end
    
  speed = s
  if veh ~= nil then
    if not network.has_control_of_entity(veh) then
      network.request_control_of_entity(veh)  
    end 
    entity.set_entity_max_speed(veh,speed*1000)
    vehicle.modify_vehicle_top_speed(veh,speed)
    vehicle.set_vehicle_engine_torque_multiplier_this_frame(veh,speed)
    entity.get_entity_model_hash(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())))
  end
end

function removeMaxSpeedVehicle()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))

  if veh ~= nil then
    if not network.has_control_of_entity(veh) then
      network.request_control_of_entity(veh)  
    end 
    entity.set_entity_max_speed(veh,150000)    
  end
end

function setMaxSpeedVehicle()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))

  local r, s = input.get("Enter new Torque", 540, 64, 3)
  if r == 1 then return HANDLER_CONTINUE end
  if r == 2 then return HANDLER_POP end

  if veh ~= nil then
    if not network.has_control_of_entity(veh) then
      network.request_control_of_entity(veh)  
    end 
    entity.set_entity_max_speed(veh,s)
  end
end

function tuneDriftVehicle()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))

  if veh ~= nil then
    if not network.has_control_of_entity(veh) then
      network.request_control_of_entity(veh)  
    end 
    entity.set_entity_max_speed(veh,30)
    vehicle.modify_vehicle_top_speed(veh,200)
  end
end
function slowVehicle()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))

  if veh ~= nil then
    if not network.has_control_of_entity(veh) then
      network.request_control_of_entity(veh)  
    end 
    entity.set_entity_max_speed(veh,1)
    vehicle.modify_vehicle_top_speed(veh,1)
    
  end
end

function loadVehicleSetting(parent,config)  
  vesettings = menu.add_feature("Vehicle Settings", "parent", parent.id, nil)
  --Speedsettings
  torgue = menu.add_feature("New Torque", "autoaction_value_i", vesettings.id, function(f)
    if f.value_i > speed then
      speed = speed+1000
    else
      speed = speed-1000
    end   
    torgue.value_i = speed
  end)
  torgue.max_i = 10000000000
  torgue.value_i = speed
  torgue.threaded = false
  
  config:saveIfNotExist("vehicletorguemax",10000000000)
  config:saveIfNotExist("vehicletorgue",speed)
  
  --distanceTP.max_i = 10000
  --distanceTP.value_i = distance
  torgue.max_i = tonumber(config:getValue("vehicletorguemax"))
  torgue.value_i = tonumber(config:getValue("vehicletorgue"))
  torgue.threaded = false
  
  
  ignoreplayers = menu.add_feature("Ignore Players", "toggle", vesettings.id, nil)
  ignoreplayers.threaded = false
  
  config:saveIfNotExist("vehicleignoreplayers",false)
  ignoreplayers.on = config:isFeatureEnabled("vehicleignoreplayers")  
end

function openVehicleParachute()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))

  if veh ~= nil then
    vehicle.set_vehicle_parachute_active(veh,true)
    ui.notify_above_map("opening parachute...","ZeroMenu",140)
  end
end

function setHeliBladeSpeed()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
  local r, s = input.get("Enter new Torque", 0, 64, 3)
  if r == 1 then return HANDLER_CONTINUE end
  if r == 2 then return HANDLER_POP end
  
  if veh ~= nil then
    vehicle.set_heli_blades_speed(veh,s)
    ui.notify_above_map("Set Blade Speed to " .. s ,"ZeroMenu",140)
  end
end



function freezeVehicleOnExit()

  if lastVehicle == 0 then
    lastVehicle = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
  elseif lastVehicle ~= 0 and ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())) == 0 then
    entity.freeze_entity(lastVehicle,true)
  elseif lastVehicle == ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())) then
    lastVehicle = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
    entity.freeze_entity(lastVehicle,false)
  end  
  if freezeVehicleOnExitVar.on then    
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end

function NoClipVehicleOnExit()
if lastVehicle == 0 then
    lastVehicle = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
  elseif lastVehicle ~= 0 and ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())) == 0 then
    entity.freeze_entity(lastVehicle,true)
  elseif lastVehicle == ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())) then
    lastVehicle = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
    entity.freeze_entity(lastVehicle,false)
  end  

    for i in ipairs(vehicle.get_all_vehicles())do
      local tempveh = vehicle.get_all_vehicles()[i]
      
      if not network.has_control_of_entity(tempveh) then
        network.request_control_of_entity(tempveh)  
      end 
      entity.set_entity_no_collsion_entity(tempveh,lastVehicle,false)
    end      
  
  if noClipVehicleOnExitVar.on then    
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end
