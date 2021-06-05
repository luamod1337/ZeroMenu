local vm = require("ZeroMenuLib/enums/VehicleMapper")
local vb = require("ZeroMenuLib/enums/VehicleBones")
local om = require("ZeroMenuLib/enums/ObjectMapper")
local pm = require("ZeroMenuLib/enums/PedMapper")

local vehicleBuilder, spawnVehicle, spawnPed
local spawnedVehicleList,spawnedObjectList, spawnedPedList, vehicleParentList, pedParentList, objectParentList

function createVehicleBuilderEntry(parent,config)
  vehicleBuilder = menu.add_feature("Vehicle Builder","parent",parent.id,loadVehicles)  
  spawnVehicle = menu.add_feature("Spawn Vehicle","action",vehicleBuilder.id,spawnVehicle)  
  spawnVehicle = menu.add_feature("Spawn Object by Hash","action",vehicleBuilder.id,spawnObjectByHash)  
  spawnVehicle = menu.add_feature("Spawn Object by Name","action",vehicleBuilder.id,spawnObjectByName)  
  spawnPed = menu.add_feature("Spawn Ped by Name","action",vehicleBuilder.id,spawnPedByName)  
    
  vehicleParentList = menu.add_feature("Vehicles","parent",vehicleBuilder.id,nil)  
  pedParentList = menu.add_feature("Peds","parent",vehicleBuilder.id,loadPeds)  
  objectParentList = menu.add_feature("Objects","parent",vehicleBuilder.id,loadObjects)  
  
  spawnedVehicleList = {}
  spawnedObjectList = {}
  spawnedPedList = {}
end

function loadPeds()
  for pedCount = 1, #spawnedPedList do
    local pedData = spawnedPedList[pedCount]
    if(pedData['function'] == nil) then   
      pedData['function'] = menu.add_feature(pedData['name'].. " (" .. pedData['id'] .. ")","parent",pedParentList.id,nil)
      local attachObject = menu.add_feature("Attach Object","parent",pedData['function'].id,nil)
      local attachVehicle = menu.add_feature("Attach Vehicle","parent",pedData['function'].id,nil)
      local attachPed = menu.add_feature("Attach Ped","parent",pedData['function'].id,nil)
      local addPTFX = menu.add_feature("Add PTFX","parent",pedData['function'].id,nil)
    end
  end
end

function loadObjects()
  for objectCount = 1, #spawnedObjectList do
    local objectData = spawnedObjectList[objectCount]
    if(objectData['function'] == nil) then   
      objectData['function'] = menu.add_feature(objectData['name'].. " (" .. objectData['id'] .. ")","parent",objectParentList.id,nil)
      local attachObject = menu.add_feature("Attach Object","parent",objectData['function'].id,nil)
      local attachVehicle = menu.add_feature("Attach Vehicle","parent",objectData['function'].id,nil)
      local attachPed = menu.add_feature("Attach Ped","parent",objectData['function'].id,nil)
      local addPTFX = menu.add_feature("Add PTFX","parent",objectData['function'].id,nil)
    end
  end
end

function loadVehicles()
  for vehicleCount = 1, #spawnedVehicleList do
    local vehicleData = spawnedVehicleList[vehicleCount]
    if(vehicleData['function'] == nil) then   
      vehicleData['function'] = menu.add_feature(vehicleData['name'].. " (" .. vehicleData['id'] .. ")","parent",vehicleParentList.id,nil)
      local attachObject = menu.add_feature("Attach Object","parent",vehicleData['function'].id,nil)
      local attachVehicle = menu.add_feature("Attach Vehicle","parent",vehicleData['function'].id,nil)
      local attachPed = menu.add_feature("Attach Ped","parent",vehicleData['function'].id,nil)
      local addPTFX = menu.add_feature("Add PTFX","parent",vehicleData['function'].id,nil)
      loadVehicleList(attachVehicle,vehicleData)
      loadObjectList(attachObject,vehicleData)    
      loadPedList(attachPed,vehicleData)    
    end
  end
end

function updateVehicleList(vehicleData)
  for vehicleCount = 1, #spawnedVehicleList do
    local vehicleFeature = spawnedVehicleList[vehicleCount]
    if(vehicleFeature['function'] ~= nil) then
      local vehicleAttachFeats = vehicleFeature['function'].children[2]  
      addVehicleFeatureIfNonExisting(vehicleData,vehicleAttachFeats,spawnedVehicleList[vehicleCount])
    end
  end
end

function updateParentVehicleList(vehicleData)
  for vehicleCount = 1, #spawnedVehicleList do
    local vehicleFeature = spawnedVehicleList[vehicleCount]
    if(vehicleFeature['function'] ~= nil) then
      addParentVehicleFeatureIfNonExisting(vehicleData,vehicleFeature)
    end
  end  
end

function updatePedList(pedData)
  for vehicleCount = 1, #spawnedVehicleList do
    local vehicleFeature = spawnedVehicleList[vehicleCount]
    if(vehicleFeature['function'] ~= nil) then
      local pedAttachFeats = vehicleFeature['function'].children[3]  
      addPedFeatureIfNonExisting(pedData,pedAttachFeats,vehicleFeature)
    end
  end  
end

function updateObjectList(objectData)
  for vehicleCount = 1, #spawnedVehicleList do
    local vehicleFeature = spawnedVehicleList[vehicleCount]
    if(vehicleFeature['function'] ~= nil) then
      local objectAttachFeats = vehicleFeature['function'].children[1]
      addObjectFeatureIfNonExisting(objectData,objectAttachFeats,vehicleFeature)
    end
  end
end

function addPedFeatureIfNonExisting(ped,parent,parentVehicle)
  local name = ped['name'] .. "(" .. ped['id'] .. ")"
  local add = true
  for vehicleAttachI = 1, #parent.children do
    local vehicleAttachFeats = parent.children[vehicleAttachI]
    if(vehicleAttachFeats[vehicleAttachI] ~= nil) then
      if(vehicleAttachFeats[vehicleAttachI].name == name) then
        add = false
      end
    end        
  end
  if(add) then
    local feature = nil
    feature = menu.add_feature(name,"action_value_str",parent.id,function()
        local offset = v3(0,0,0)
        local rot = v3(0,0,0)
        local bone = entity.get_entity_bone_index_by_name(parentVehicle['id'],vb.GetUseAbleBones(parentVehicle['id'])[feature.value+1])        
        entity.attach_entity_to_entity(ped['id'],parentVehicle['id'],bone,offset,rot,false,true,false,0,true)        
      end)
      feature.set_str_data(feature,vb.GetUseAbleBones(parentVehicle['id']))
  end
end

function addParentFeatureIfNonExisting(parentVehicle,parent)
  local name = ped['name'] .. "(" .. ped['id'] .. ")"
  local add = true
  for vehicleAttachI = 1, #parent.children do
    local vehicleAttachFeats = parent.children[vehicleAttachI]
    if(vehicleAttachFeats[vehicleAttachI] ~= nil) then
      if(vehicleAttachFeats[vehicleAttachI].name == name) then
        add = false
      end
    end        
  end
  if(add) then
    local feature = nil
    feature = menu.add_feature(name,"action_value_str",parent.id,function()
        local offset = v3(0,0,0)
        local rot = v3(0,0,0)
        local bone = entity.get_entity_bone_index_by_name(parentVehicle['id'],vb.GetUseAbleBones(parentVehicle['id'])[feature.value+1])        
        entity.attach_entity_to_entity(ped['id'],parentVehicle['id'],bone,offset,rot,false,true,false,0,true)        
      end)
      feature.set_str_data(feature,vb.GetUseAbleBones(parentVehicle['id']))
  end
end

function addVehicleFeatureIfNonExisting(vehicle,parent,parentVehicle)
  local name = vehicle['name'] .. "(" .. vehicle['id'] .. ")"
  local add = true
  for vehicleAttachI = 1, #parent.children do
    local vehicleAttachFeats = parent.children[vehicleAttachI]
    if(vehicleAttachFeats[vehicleAttachI] ~= nil) then
      if(vehicleAttachFeats[vehicleAttachI].name == name) then
        add = false
      end          
    end        
  end
  if(add) then
    local feature = nil
    feature = menu.add_feature(name,"action_value_str",parent.id,function()
        local offset = v3(0,0,0)
        local rot = v3(0,0,0)        
        local bone = entity.get_entity_bone_index_by_name(parentVehicle['id'],vb.GetUseAbleBones(parentVehicle['id'])[feature.value+1])
        entity.attach_entity_to_entity(parentVehicle['id'],vehicle['id'],bone,offset,rot,false,true,false,0,true)        
      end)
      feature.set_str_data(feature,vb.GetUseAbleBones(parentVehicle['id']))
  end
end
function addObjectFeatureIfNonExisting(vehicle,parent,parentVehicle)
  local name = vehicle['name'] .. "(" .. vehicle['id'] .. ")"
  local add = true
  for vehicleAttachI = 1, #parent.children do
    local vehicleAttachFeats = parent.children[vehicleAttachI]
    if(vehicleAttachFeats[vehicleAttachI] ~= nil) then
      if(vehicleAttachFeats[vehicleAttachI].name == name) then
        print(vehicleAttachI .. " " .. vehicleAttachFeats[vehicleAttachI].name)
        add = false
      end          
    end        
  end
  if(add) then
    local feature = nil
    feature = menu.add_feature(name,"action_value_str",parent.id,function()
        local offset = v3(0,0,0)
        local rot = v3(0,0,0)        
        local bone = entity.get_entity_bone_index_by_name(parentVehicle['id'],vb.GetUseAbleBones(parentVehicle['id'])[feature.value+1])
        entity.attach_entity_to_entity(parentVehicle['id'],vehicle['id'],bone,offset,rot,false,true,false,0,true)        
      end)
      feature.set_str_data(feature,vb.GetUseAbleBones(parentVehicle['id']))
  end
end

function loadObjectList(parent,vehicleParent)
  for objectCount = 1, #spawnedObjectList do
    local objectData = spawnedObjectList[objectCount]
    
    local feature = nil
    feature = menu.add_feature(objectData['name'] .. " (" .. objectData['hash'] .. ")","action_value_str",parent.id,function()
      local offset = v3(0,0,0)
      local rot = v3(0,0,0)
      --local bone = entity.get_entity_bone_index_by_name(vehicleData['id'],"wheel_lf")
      local bone = entity.get_entity_bone_index_by_name(vehicleParent['id'],vb.GetUseAbleBones(vehicleParent['id'])[feature.value+1])
      entity.attach_entity_to_entity(objectData['id'],vehicleParent['id'],bone,offset,rot,false,true,false,0,true)        
    end)
    feature.set_str_data(feature,vb.GetUseAbleBones(vehicleParent['id']))
  end
end

function loadPedList(parent,vehicleParent)
  for pedCount = 1, #spawnedPedList do
    local pedData = spawnedPedList[pedCount]
    
    local feature = nil
    feature = menu.add_feature(pedData['name'] .. " (" .. pedData['hash'] .. ")","action_value_str",parent.id,function()
      local offset = v3(0,0,0)
      local rot = v3(0,0,0)
      --local bone = entity.get_entity_bone_index_by_name(vehicleData['id'],"wheel_lf")
      local bone = entity.get_entity_bone_index_by_name(vehicleParent['id'],vb.GetUseAbleBones(vehicleParent['id'])[feature.value+1])
      entity.attach_entity_to_entity(pedData['id'],vehicleParent['id'],bone,offset,rot,false,true,false,0,true)        
    end)
    feature.set_str_data(feature,vb.GetUseAbleBones(vehicleParent['id']))
  end
end

function loadVehicleList(parent,vehicleParent)
  for vehicleCount = 1, #spawnedVehicleList do
    local vehicleData = spawnedVehicleList[vehicleCount]
    
    if(vehicleData['id'] ~= vehicleParent['id']) then
      local feature = nil
      feature = menu.add_feature(vehicleData['name'] .. " (" .. vehicleData['id'] .. ")","action_value_str",parent.id,function()
        local offset = v3(0,0,0)
        local rot = v3(0,0,0)        
        local bone = entity.get_entity_bone_index_by_name(vehicleParent['id'],vb.GetUseAbleBones(vehicleParent['id'])[feature.value+1])
        entity.attach_entity_to_entity(vehicleData['id'],vehicleParent['id'],bone,offset,rot,false,true,false,0,true)        
      end)
      feature.set_str_data(feature,vb.GetUseAbleBones(vehicleParent['id']))
    end
  end
end

local requestedVehicle = nil
function spawnVehicle()
  local rightHash = nil
  if requestedVehicle == nil then
    local r, s = input.get("Enter Vehicle", "tampa", 64, 0)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end    
    requestedVehicle = s
  end
  
  local HashByName = vm.GetHashFromName(requestedVehicle)
  local HashByModel = vm.GetHashFromModel(requestedVehicle)
            
  if(HashByName ~= nil)then
    rightHash = HashByName
  end
  if(HashByModel ~= nil)then
    rightHash = HashByModel
  end 
  if(rightHash ~= nil) then
    if(streaming.has_model_loaded(rightHash)) then
      local v3 = player.get_player_coords(player.player_id())
      local vehicleData = {}
      vehicleData['hash'] = rightHash
      vehicleData['name'] = requestedVehicle
      vehicleData['id'] = vehicle.create_vehicle(rightHash,v3,entity.get_entity_heading(player.get_player_ped(player.player_id())),true,false)
      spawnedVehicleList[#spawnedVehicleList+1] = vehicleData
      streaming.set_model_as_no_longer_needed(rightHash)
      requestedVehicle = nil
      ui.notify_above_map("Spawned Vehicle " .. rightHash,"ZeroMenu",140)
      updateVehicleList(vehicleData)
    else
      streaming.request_model(rightHash)
      return HANDLER_CONTINUE
    end
  end
end

local requestedPed = nil
function spawnPedByName()
  local rightHash = nil
  if requestedPed == nil then
    local r, s = input.get("Enter Ped Name", "Cow", 64, 0)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end    
    requestedPed = s
  end
  
  local HashByName = pm.GetHashFromName(requestedPed)
  local HashByModel = pm.GetHashFromModel(requestedPed)
            
  if(HashByName ~= nil)then
    rightHash = HashByName
  end
  if(HashByModel ~= nil)then
    rightHash = HashByModel
  end 
  
  if(rightHash ~= nil) then
    if(streaming.has_model_loaded(rightHash)) then
      local v3 = player.get_player_coords(player.player_id())
      local pedData = {}
      pedData['hash'] = rightHash
      pedData['name'] = requestedPed      
      pedData['id'] = ped.create_ped(0,rightHash,v3,entity.get_entity_heading(player.get_player_ped(player.player_id())),true,false)
      spawnedPedList[#spawnedPedList+1] = pedData
      streaming.set_model_as_no_longer_needed(rightHash)
      ui.notify_above_map("Spawned Ped " .. requestedPed,"ZeroMenu",140)
      requestedPed = nil
      updatePedList(pedData)
    else
      streaming.request_model(rightHash)
      ui.notify_above_map("request hash " .. requestedPed,"ZeroMenu",140)
      return HANDLER_CONTINUE
    end
  else    
      ui.notify_above_map("Unknown Ped " .. requestedPed,"ZeroMenu",140)
      requestedPed = nil
  end
end

local dict = nil
local flame = nil
function attach_ptfx(entity)  
    if(dict == nil) then
      local r, s = input.get("Enter Dictonary", "core", 64, 0)
      if r == 1 then return HANDLER_CONTINUE end
      if r == 2 then return HANDLER_POP end    
      dict = s  
    end
    
    if(flame == nil) then
      local r, s = input.get("Enter PTFX", "ent_amb_candle_flame", 64, 0)
      if r == 1 then return HANDLER_CONTINUE end
      if r == 2 then return HANDLER_POP end      
      flame = s
    end
    
    local r, s = input.get("Enter Scale Value for PTFX", 5.0, 64, 5)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end      
    local scale = s
    
    graphics.set_next_ptfx_asset(dict)
    while not graphics.has_named_ptfx_asset_loaded(dict) do
      graphics.request_named_ptfx_asset(dict)
      system.wait(10)
      return HANDLER_CONTINUE 
    end
    
    local offset = v3(0,0,0)
    local rot = v3(0,90,0)
    graphics.start_ptfx_looped_on_entity(flame,entity,offset,rot,scale)
    ui.notify_above_map("spawned candle","ZeroMenu",140)
    flame = nil
    dict = nil
  return HANDLER_POP 
end

local requestedObject = 0
function spawnObjectByName()
  if requestedObject == 0 then
    local r, s = input.get("Enter Object Name", "hei_prop_heist_safedepdoor", 64, 0)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    requestedObject = s
  end
  local object = {}
  object['id'] = spawnObjectHash(om.GetHashFromModel(requestedObject))
  object['hash'] = om.GetHashFromModel(requestedObject)
  object['name'] = requestedObject
  spawnedObjectList[#spawnedObjectList+1] = object
  updateObjectList(object)
  ui.notify_above_map("Spawned " .. requestedObject,"ZeroMenu",140)
  requestedObject = nil
end

function spawnObjectByHash()
  if requestedObject == 0 then
    local r, s = input.get("Enter Object Hash", "", 64, 0)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    requestedObject = s
  end
  local object = {}
  object['id'] = spawnObjectHash(requestedObject)
  object['hash'] = requestedObject
  object['name'] = om.GetModelFromHash(requestedObject)
  spawnedObjectList[#spawnedObjectList+1] = object
  updateObjectList(object)
  requestedObject = nil
  ui.notify_above_map("Spawned " .. requestedObject,"ZeroMenu",140)
end

local count = 0
function spawnObjectHash(requestedObject)
  if(streaming.has_model_loaded(requestedObject)) then  
    local objectCandle = object.create_object(requestedObject,player.get_player_coords(player.player_id()),true,true)
    requestedObject = 0
    streaming.set_model_as_no_longer_needed(requestedObject) 
    ui.notify_above_map("Spawned Object " .. requestedObject,"ZeroMenu",140)
    count = 0
    return objectCandle
  else
    streaming.request_model(requestedObject)
    if(count > 10) then
      count = 0
      requestedObject = 0
      ui.notify_above_map("Couldn't request Object","ZeroMenu",140)
      return nil
    else
      count = count +1
      return HANDLER_CONTINUE
    end    
  end
end