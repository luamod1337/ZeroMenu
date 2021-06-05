local dev,sparkel,burning_candle_f,call_ptfx_f,vehicleArcobatic,spawnobject
local lastAcro = 0



function createDevEntry(parent,config)
  dev = menu.add_feature("Dev","parent",parent.id,nil)  
  menu.add_feature("Shit Bird Attack","action",dev.id,shitAttack) 
  sparkel = menu.add_feature("Sparkel","action",dev.id,sparkel) 
  
  call_ptfx_f = menu.add_feature("Call Ptfx","action",dev.id,call_ptfx)
  vehicleArcobatic = menu.add_feature("Arcobatic Right", "toggle", dev.id, ArcrobaticRight)
  spawnobject = menu.add_feature("Spawn Object", "action", dev.id, spawnObject)
    
  menu.add_feature("Reset Base Vehicle","action",dev.id,resetSpawnedVehcile)
  menu.add_feature("Get Vehicle Hash","action",dev.id,getHashOfVehicle)
end


function shitAttack()
  local PedTypes = require("ZeroMenuLib/enums/PedType")  
  if streaming.has_model_loaded(0x06A20728) then
    local pos = player.get_player_coords(player.player_id())
    pos.x = pos.x+5
    print("type = " .. PedTypes.PED_TYPE_ANIMAL)
    local bird = ped.create_ped(PedTypes.PED_TYPE_ARMY,0x06A20728,pos,0.0,true,false)
    local bird2 = ped.create_ped(PedTypes.PED_TYPE_ARMY,0xD3939DFD,pos,0.0,true,false)
    local bird3 = ped.create_ped(PedTypes.PED_TYPE_ARMY,0xAAB71F62,pos,0.0,true,false)
        
    ai.task_combat_ped(bird,player.get_player_ped(player.player_id()),0,16)
    ai.task_combat_ped(bird2,player.get_player_ped(player.player_id()),0,16)
    ai.task_combat_ped(bird3,player.get_player_ped(player.player_id()),0,16)
    
    ui.notify_above_map("spawned bird... at " .. pos.x .. ":" .. pos.y .. ":" .. pos.z,"ZeroMenu",140)
    
    pos = player.get_player_coords(player.player_id())
    local explosionTypes = require("ZeroMenuLib/enums/ExplosionType")
    pos.z = pos.z +5
    
    fire.add_explosion(pos,explosionTypes.EXPLOSION_BIRD_CRAP,true,false,100.0, player.get_player_from_ped(player.player_id()))
    
    return HANDLER_POP
  else
    streaming.request_model(0x06A20728)
    streaming.request_model(0xD3939DFD)
    streaming.request_model(0xAAB71F62)
    print("waiting for model to load...")
    return HANDLER_CONTINUE
  end
end

function sparkel()  
  if sparkel.on then
    graphics.set_next_ptfx_asset("scr_indep_fireworks")
    while not graphics.has_named_ptfx_asset_loaded("scr_indep_fireworks") do
      graphics.request_named_ptfx_asset("scr_indep_fireworks")
      return HANDLER_CONTINUE 
    end
    graphics.start_networked_particle_fx_non_looped_at_coord("scr_indep_firework_trail_spawn", player.get_player_coords(player.player_id()), v3(60, 0, 0), 0.33, true, true, true)
  end
  return HANDLER_POP
end

function burning_candle2()
  local candle = -1915729838
    if(streaming.has_model_loaded(candle)) then
      print("candle loaded")
      graphics.set_next_ptfx_asset("scr_indep_fireworks")
      while not graphics.has_named_ptfx_asset_loaded("scr_indep_fireworks") do
        graphics.request_named_ptfx_asset("scr_indep_fireworks")
        return HANDLER_CONTINUE 
      end
      local offset = v3(0,0,0)
      local rot = v3(0,0,0)
      local objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
      graphics.start_ptfx_looped_on_entity("scr_indep_firework_trail_spawn",objectCandle,offset,rot,1.0)
      --graphics.start_networked_particle_fx_non_looped_at_coord("scr_indep_firework_trail_spawn", player.get_player_coords(player.player_id()), v3(60, 0, 0), 0.33, true, true, true)
    else
       streaming.request_model(candle)
    end
  return HANDLER_POP
end


local requestedObject = 0
local count = 0

function spawnObject()
if requestedObject == 0 then
    local r, s = input.get("Enter Object Hash", "", 64, 3)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    requestedObject = s
  end
  if(streaming.has_model_loaded(requestedObject)) then  
    local objectCandle = object.create_object(requestedObject,player.get_player_coords(player.player_id()),true,true)
    requestedObject = 0
    streaming.set_model_as_no_longer_needed(requestedObject) 
    ui.notify_above_map("Spawned Object","ZeroMenu",140)
    return HANDLER_POP
  else
    streaming.request_model(requestedObject)
    if(count > 10) then
      count = 0
      requestedObject = 0
      ui.notify_above_map("Couldn't request Object","ZeroMenu",140)
      return HANDLER_POP
    else
      count = count +1
      return HANDLER_CONTINUE
    end    
  end
end

local dict = nil
local flame = nil
function call_ptfx()  
  local candle = -1915729838
  if(streaming.has_model_loaded(candle)) then
    if(dict == nil) then
      local r, s = input.get("Enter Dictonary", "core", 64, 0)
      if r == 1 then return HANDLER_CONTINUE end
      if r == 2 then return HANDLER_POP end    
      dict = s  
    end
    
    if(flame == nil) then
      local r, s = input.get("Enter ptfx", "ent_amb_candle_flame", 64, 0)
      if r == 1 then return HANDLER_CONTINUE end
      if r == 2 then return HANDLER_POP end      
      flame = s
    end
    
    local r, s = input.get("Enter ptfx", 5.0, 64, 5)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end      
    scale = s
    
    graphics.set_next_ptfx_asset(dict)
    while not graphics.has_named_ptfx_asset_loaded(dict) do
      graphics.request_named_ptfx_asset(dict)
      ui.notify_above_map("request " .. dict .. " asset","ZeroMenu",140)
      system.wait(10)
      return HANDLER_CONTINUE 
    end
    
    local objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    local offset = v3(0,0,0)
    local rot = v3(0,90,0)
    graphics.start_ptfx_looped_on_entity(flame,objectCandle,offset,rot,scale)
    ui.notify_above_map("spawned candle","ZeroMenu",140)
    flame = nil
    dict = nil
  else
    streaming.request_model(candle)
    return HANDLER_CONTINUE
  end   
  return HANDLER_POP 
end



function ArcrobaticRight()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
  local vehRotationV3 = entity.get_entity_rotation(veh)
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

function getHashOfVehicle()
  local hash = entity.get_entity_model_hash(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())))
  if(hash ~= nil) then
    ui.notify_above_map("Vehicle has this hash: " .. hash,"ZeroMenu",140)
  else
    ui.notify_above_map("No hash found!","ZeroMenu",140)
  end  
end
