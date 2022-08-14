local dev,sparkel,burning_candle_f,call_ptfx_f,vehicleArcobatic,spawnobject,hashbyshoot,ropeTestFunc,invisiblebyshoot,catGangFeature
local lastAcro = 0

local vm = require("ZeroMenuLib/enums/VehicleMapper")

function createDevEntry(parent,config)
  dev = menu.add_feature("Dev","parent",parent.id,nil)  
  menu.add_feature("Shit Bird Attack","action",dev.id,shitAttack) 
  sparkel = menu.add_feature("Sparkel","action",dev.id,sparkel) 
  
  call_ptfx_f = menu.add_feature("Call Ptfx","action",dev.id,call_ptfx)
  vehicleArcobatic = menu.add_feature("Arcobatic Right", "toggle", dev.id, ArcrobaticRight)
  spawnobject = menu.add_feature("Spawn Object", "action", dev.id, spawnObject)
  spawnVehicleHash = menu.add_feature("Spawn Vehicle by Hash", "action", dev.id, spawnVehicle)
    
  menu.add_feature("Reset Base Vehicle","action",dev.id,resetSpawnedVehcile)
  menu.add_feature("Get Vehicle Hash","action",dev.id,getHashOfVehicle)
  
  menu.add_feature("Vehicle Tire Radius","action",dev.id,whateverTireRadius)
  menu.add_feature("Vehicle Tire Width","action",dev.id,whateverTireWidth)
  menu.add_feature("Vehicle Rim Width","action",dev.id,whateverRimWidth)
  menu.add_feature("Vehicle Wheel Render Size","action",dev.id,whateverWheelRenderSize)
  
    
  hashbyshoot = menu.add_feature("Get Hash by Aim","toggle",dev.id,hashbyshooting)
  
  invisiblebyshoot = menu.add_feature("Aim to make Invisible","toggle",dev.id,makeObjectInvisible)
  
  menu.add_feature("Get Model","action",dev.id,function()   
    local model = player.get_player_model(player.player_id()) 
    if util.isModelAnimal(self,model) then
      menu.notify("You model is " .. model .. " a animal","ZeroMenu",5,140)  
    else
      menu.notify("You model is " .. model .. " not a animal","ZeroMenu",5,140)  
    end
  end)
  
  
  menu.add_feature("Set Parachute","action",dev.id,function()
    local veh = player.get_player_vehicle(player.player_id())
    local parachute_model = vehicle.get_vehicle_parachute_model(veh)
   
   -- if(parachute_model ~= nil) then
   --   menu.notify("Vehicle has allready a parachute model with id = " .. parachute_model,"ZeroMenu",10,5)
   -- else      
      
   -- end
   local parachute = "230075693"
   if(not streaming.has_model_loaded(parachute)) then   
    streaming.request_model(parachute)
    streaming.set_vehicle_model_has_parachute(entity.get_entity_model_hash(veh),true)
    return HANDLER_CONTINUE
   else
    vehicle.set_vehicle_parachute_model(veh,parachute)       
    menu.notify("Vehicle parachute set to '" .. parachute .. "'" ,"ZeroMenu",10,5)
    return HANDLER_POP
   end
  end)
  
  menu.add_feature("Display KD","action",dev.id,function()
    local kd = script.get_global_f(1853131  + (1 + (player.player_id() * 888)) + 205 + 26)
    menu.notify("You have a KD of " .. kd ,"ZeroMenu",5,140)
  end)
  
  menu.add_feature("Set Model","action",dev.id,function()
    
    
    
    local r, s = input.get("Enter Model Hash", "", 64, 0)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
      local modelHash = s
    if streaming.is_model_a_ped(modelHash) then
      while not streaming.has_model_loaded(modelHash) do
        print("requesting model " .. modelHash)
        streaming.request_model(modelHash)
        system.wait(0)
      end
      print("Setting Player Model to " .. modelHash)
      if streaming.has_model_loaded(modelHash) then print(modelHash .. " has loaded") end
      player.set_player_model(modelHash) 
    end    
  end)
  
  menu.add_feature("Display Money","action",dev.id,function()
  
    local moneyz = script.get_global_i(1853131   + (1 + (player.player_id() * 888)) + 205 + 56)
    menu.notify("you have " .. moneyz .. " $" ,"ZeroMenu",5,140)
  
  end)
  
  catGangFeature = menu.add_feature("Cat Gang","toggle",dev.id,catGang)
  
   menu.add_feature("Set Max Gear", "action", dev.id, function()
    local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
    local r, s = input.get("Enter new Torque", 10, 64, 3)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    menu.notify("Changed max gear to " .. s ,"ZeroMenu",5,140)
    local oldMaxGear = vehicle.get_vehicle_max_gear(veh)
    local timeout = 0
    while(network.has_control_of_entity(veh) == false and timeout < 10) do
      network.request_control_of_entity(veh)      
      system.wait(0)
      timeout = timeout+1
    end
    
    vehicle.set_vehicle_max_gear(veh,s)
    
    for i=oldMaxGear,s do 
      vehicle.set_vehicle_gear_ratio(veh,i,i)
      if(vehicle.get_vehicle_gear_ratio(veh,i) ~= nil) then
        menu.notify("Gear: " .. i .. ", ratio = " .. vehicle.get_vehicle_gear_ratio(veh,i) ,"ZeroMenu",5,140)
     end
      
    end
    
   end)
  
  menu.add_feature("Get Bullet by holded gun","action",dev.id,getBulletFromGun)
  
  menu.add_feature("Display Vehicle Rotation","action",dev.id,function()
    local pvehicle = player.get_player_vehicle(player.player_id())    
    if(pvehicle ~= nil) then
      local rotation = entity.get_entity_rotation(pvehicle)
      menu.notify(rotation.x .. "," .. rotation.y .. "," .. rotation.z ,"ZeroMenu",5,140)
    end
  
  end)
  
end

function getBulletFromGun()
  local ped = player.get_player_ped(player.player_id())
  --local r, s = input.get("Enter new Torque", 10, 64, 1)
   -- if r == 1 then return HANDLER_CONTINUE end
   -- if r == 2 then return HANDLER_POP end
   print("Bullet = " .. weapon.get_ped_ammo_type_from_weapon(ped,"0xAF3696A1"))
   menu.notify("Bullet = " .. weapon.get_ped_ammo_type_from_weapon(ped,"0xAF3696A1") ,"ZeroMenu",10,140)

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
    
    menu.notify("spawned bird... at " .. pos.x .. ":" .. pos.y .. ":" .. pos.z,"ZeroMenu",5,140)
    
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
    menu.notify("Spawned Object","ZeroMenu",5,140)
    return HANDLER_POP
  else
    streaming.request_model(requestedObject)
    if(count > 10) then
      count = 0
      requestedObject = 0
     menu.notify("Couldn't request Object","ZeroMenu",5,140)
      return HANDLER_POP
    else
      count = count +1
      return HANDLER_CONTINUE
    end    
  end
end

local requestedVehicleHash = 0
function spawnVehicle()
  if requestedVehicleHash == 0 then
    local r, s = input.get("Enter Vehicle Hash", "", 64, 3)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    requestedVehicleHash = s
  end
  if(streaming.has_model_loaded(requestedVehicleHash)) then  
    --local objectCandle = object.create_object(requestedVehicleHash,player.get_player_coords(player.player_id()),true,true)
    vehicle.create_vehicle(requestedVehicleHash,player.get_player_coords(player.player_id()),entity.get_entity_heading(player.get_player_ped(player.player_id())),true,false)
    requestedVehicleHash = 0
    streaming.set_model_as_no_longer_needed(requestedVehicleHash) 
    menu.notify("Spawned Object","ZeroMenu",5,140)
    return HANDLER_POP
  else
    streaming.request_model(requestedVehicleHash)
    if(count > 10) then
      count = 0
      requestedVehicleHash = 0
     menu.notify("Couldn't request Object","ZeroMenu",5,140)
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
      menu.notify("request " .. dict .. " asset","ZeroMenu",5,140)
      system.wait(10)
      return HANDLER_CONTINUE 
    end
    
    local objectCandle = object.create_object(candle,player.get_player_coords(player.player_id()),true,true)
    local offset = v3(0,0,0)
    local rot = v3(0,90,0)
    graphics.start_ptfx_looped_on_entity(flame,objectCandle,offset,rot,scale)
    menu.notify("spawned candle","ZeroMenu",5,140)
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
    menu.notify("Vehicle has this hash: " .. hash,"ZeroMenu",5,140)
  else
    menu.notify("No hash found!","ZeroMenu",5,140)
  end  
end

function whateverTireRadius()
  local veh = player.get_player_vehicle(player.player_id())
  local r, s = input.get("Enter Tire Radius", "core", 64, 5)
  if r == 1 then return HANDLER_CONTINUE end
  if r == 2 then return HANDLER_POP end    
  vehicle.set_vehicle_wheel_tire_radius(veh,0,s)
  vehicle.set_vehicle_wheel_tire_radius(veh,1,s)
  vehicle.set_vehicle_wheel_tire_radius(veh,2,s)
  vehicle.set_vehicle_wheel_tire_radius(veh,3,s)
end

function whateverTireWidth()
  local veh = player.get_player_vehicle(player.player_id())
  local r, s = input.get("Enter Tire Radius", "core", 64, 5)
  if r == 1 then return HANDLER_CONTINUE end
  if r == 2 then return HANDLER_POP end    
  vehicle.set_vehicle_wheel_tire_width(veh,0,s)
  vehicle.set_vehicle_wheel_tire_width(veh,1,s)
  vehicle.set_vehicle_wheel_tire_width(veh,2,s)
  vehicle.set_vehicle_wheel_tire_width(veh,3,s)
end
function whateverRimWidth()
  local veh = player.get_player_vehicle(player.player_id())
  local r, s = input.get("Enter Rim Radius", "core", 64, 5)
  if r == 1 then return HANDLER_CONTINUE end
  if r == 2 then return HANDLER_POP end    
  vehicle.set_vehicle_wheel_rim_radius(veh,0,s)
  vehicle.set_vehicle_wheel_rim_radius(veh,1,s)
  vehicle.set_vehicle_wheel_rim_radius(veh,2,s)
  vehicle.set_vehicle_wheel_rim_radius(veh,3,s)
end

function whateverWheelRenderSize()
  local veh = player.get_player_vehicle(player.player_id())
  local r, s = input.get("Enter Rim Radius", "core", 64, 5)
  if r == 1 then return HANDLER_CONTINUE end
  if r == 2 then return HANDLER_POP end    
  vehicle.set_vehicle_wheel_render_size(veh,0,s)
  vehicle.set_vehicle_wheel_render_size(veh,1,s)
  vehicle.set_vehicle_wheel_render_size(veh,2,s)
  vehicle.set_vehicle_wheel_render_size(veh,3,s)
end

function hashbyshooting()
  local lastEntity = player.get_entity_player_is_aiming_at(player.player_id())
  if(lastEntity ~= nil) then
    ui.draw_text(entity.get_entity_model_hash(lastEntity),v2(0.5,0.5))
  end
  if(hashbyshoot.on) then
    return HANDLER_CONTINUE
  else
    return HANDLER_POP 
  end   
end


local catGangPeds = nil
local catGangBikes = nil
function catGang()
  local catHash = 0x573201B8
  if catGangPeds == nil then
  catGangPeds = {}
    --created peds
    while not streaming.has_model_loaded(catHash) do
      streaming.request_model(catHash)
      system.wait(0)
    end
    for i = 1, 10 do
      local cat = ped.create_ped(
        -1,
        catHash,
        entity.get_entity_coords(player.player_id()),
        entity.get_entity_heading(player.player_id()),
        true,
        false
      )
      menu.notify("Spawned a cat","ZeroMenu",5,140)
      catGangPeds[#catGangPeds] = cat
      --ai.task_follow_to_offset_of_entity(cat,player.player_id(),v3(0,0,0),1,10,10,true)
    end
  else
    --control peds
    
    if player.is_player_in_any_vehicle(player.player_id()) then
      local playerVehicle = player.get_player_vehicle(player.player_id())
      --spawn bikes
      if catGangBikes == nil then
        catGangBikes = {}
        for i = 1, #catGangPeds do
          local cat = catGangPeds[i]          
          local catbike = vehicle.create_vehicle("4180675781",entity.get_entity_coords(cat),entity.get_entity_heading(player.get_player_ped(cat)),true,false)
          catGangBikes[#catGangBikes] = catbike
          ai.task_vehicle_follow(cat,catbike,player.get_player_ped(player.player_id()),entity.get_entity_speed(playerVehicle),4194304,10)
        end
      end
    else
      --despawn bikes
      if catGangBikes ~= nil then
        for i = 1, #catGangBikes do
          entity.delete_entity(catGangBikes[i])
        end
      end
      --pr�fe ob spieler in der n�he
      if arePlayerNearby() then
        --Gehe zu einem Spieler in der N�he statt zu einem Selbst
      else
        for i = 1, #catGangPeds do
            local cat = catGangPeds[i]    
            ai.task_follow_to_offset_of_entity(cat,player.get_player_ped(player.player_id()),v3(0,0,0),1,10,10,true)
        end
      end
      catGangBikes = nil
      
    end
  end
  if(catGangFeature.on) then
    return HANDLER_CONTINUE
  else
    return HANDLER_POP 
  end   
end

function arePlayerNearby()
  return false
end

function makeObjectInvisible()
  local lastEntity = player.get_entity_player_is_aiming_at(player.player_id())
  if(lastEntity ~= nil and entity.is_entity_visible(lastEntity) and lastEntity > 0) then
    --ui.draw_text(entity.get_entity_model_hash(lastEntity),v2(0.5,0.5))
    entity.set_entity_visible(lastEntity,false)
    menu.notify("Made " .. lastEntity .. " invisible","ZeroMenu",5,40)
  else
    menu.notify("Made " .. lastEntity .. " not invisible","ZeroMenu",5,40)
    menu.notify("Made " .. lastEntity .. " not invisible","ZeroMenu",5,40)
    menu.notify("Made " .. lastEntity .. " not invisible","ZeroMenu",5,40)
    
  end
  if(invisiblebyshoot.on) then
    return HANDLER_CONTINUE
  else
    return HANDLER_POP 
  end   
end
