local vm = require("ZeroMenuLib/enums/VehicleMapper")
local om = require("ZeroMenuLib/enums/ObjectMapper")
local pm = require("ZeroMenuLib/enums/PedMapper")

local vb = require("ZeroMenuLib/enums/VehicleBones")
local pb = require("ZeroMenuLib/enums/PedBones")


local vehicleBuilder, spawnVehicle, spawnPed
local spawnedVehicleList,spawnedObjectList, spawnedPedList, vehicleParentList, pedParentList, objectParentList

local featToEntity

function createVehicleBuilderEntry(parent,config)
  vehicleBuilder = menu.add_feature("Vehicle Builder","parent",parent.id,loadVehicles)  
  spawnVehicle = menu.add_feature("Spawn Vehicle","action",vehicleBuilder.id,spawnVehicle)  
  spawnVehicle = menu.add_feature("Spawn Object by Hash","action",vehicleBuilder.id,spawnObjectByHash)  
  spawnVehicle = menu.add_feature("Spawn Object by Name","action",vehicleBuilder.id,spawnObjectByName)  
  spawnPed = menu.add_feature("Spawn Ped by Name","action",vehicleBuilder.id,spawnPedByName)  
    
  vehicleParentList = menu.add_feature("Vehicles","parent",vehicleBuilder.id,nil)  
  pedParentList = menu.add_feature("Peds","parent",vehicleBuilder.id,nil)  
  objectParentList = menu.add_feature("Objects","parent",vehicleBuilder.id,nil)  
  
  spawnedVehicleList = {}
  spawnedObjectList = {}
  spawnedPedList = {}
  featToEntity  = {}
end

function notifySpawnedStuff()

  ui.notify_above_map("Spawned " .. #spawnedVehicleList .. " Vehicles\n" .. "Spawned " .. #spawnedObjectList ..  " Objects\n" .. "Spawned " .. #spawnedPedList ..     " Peds","ZeroMenu",140)
--ui.notify_above_map("Spawned " .. #spawnedObjectList ..  " Objects","ZeroMenu",140)
--ui.notify_above_map("Spawned " .. #spawnedPedList ..     " Peds","ZeroMenu",140)

end

function processSpawnedVehicle(vehicleData)
  --vehicleParentList  
  local tempFeature = menu.add_feature(vehicleData['name'] .. "(" .. vehicleData['id'] .. ")","parent",vehicleParentList.id,nil)
  local attachSettings = menu.add_feature("Attach Settings","parent",tempFeature.id,nil)
  
  menu.add_feature("-- Offset -- ","action",attachSettings.id,nil)
  local offsetX = menu.add_feature("X","autoaction_value_i",attachSettings.id,nil)
  offsetX.min = -500
  offsetX.max = 500
  local offsetY = menu.add_feature("Y","autoaction_value_i",attachSettings.id,nil)
  offsetY.min = -500
  offsetY.max = 500
  local offsetZ = menu.add_feature("Z","autoaction_value_i",attachSettings.id,nil)
  offsetZ.min = -500
  offsetZ.max = 500
  
  menu.add_feature("-- Rotation -- ","action",attachSettings.id,nil)
  local rotationX = menu.add_feature("X","autoaction_value_i",attachSettings.id,nil)
  rotationX.min = 0
  rotationX.max = 365
  local rotationY = menu.add_feature("Y","autoaction_value_i",attachSettings.id,nil)
  rotationY.min = 0
  rotationY.max = 365
  local rotationZ = menu.add_feature("Z","autoaction_value_i",attachSettings.id,nil)
  rotationZ.min = 0
  rotationZ.max = 365
  
  -- Attach PTFX
  local attachptfx = menu.add_feature("Attach PTFX","action",tempFeature.id,attach_ptfx)
  attachptfx.data = {entity = vehicleData['id'],parentSettings = attachSettings}
  --Attach Vehicle
  local attachVehicle = menu.add_feature("Attach Vehicle","parent",tempFeature.id,loadAttachAbleVehicleList)
  attachVehicle.data = {entity = vehicleData,parentSettings = attachSettings,type = "vehicle"}
  --Attach Object
  local attachObject = menu.add_feature("Attach Object","parent",tempFeature.id,loadAttachAbleObjectList)
  attachObject.data = {entity = vehicleData,parentSettings = attachSettings,type = "vehicle"}
  --Attach Ped
  local attachPed = menu.add_feature("Attach Ped","parent",tempFeature.id,loadAttachAblePedList)
  attachPed.data = {entity = vehicleData,parentSettings = attachSettings,type = "vehicle"}
    
  --Delete
  menu.add_feature("Delete","action",tempFeature.id,
  function()
    entity.delete_entity(vehicleData['id'])
    ui.notify_above_map("Deleted " .. vehicleData['name'] ..  " (" .. vehicleData['id'] .. ")","ZeroMenu",140)      
    for i=1,#tempFeature.children do
      menu.delete_feature(tempFeature.children[1].id)
    end
    menu.delete_feature(tempFeature.id)    
    table.remove(spawnedVehicleList,vehicleData['arrayID'])
  end)  
end

function processSpawnedObject(objectData)
  --vehicleParentList  
  local tempFeature = menu.add_feature(objectData['name'] .. "(" .. objectData['id'] .. ")","parent",objectParentList.id,nil)
  local attachSettings = menu.add_feature("Attach Settings","parent",tempFeature.id,nil)
  
  menu.add_feature("-- Offset -- ","action",attachSettings.id,nil)
  local offsetX = menu.add_feature("X","autoaction_value_i",attachSettings.id,nil)
  offsetX.min = -500
  offsetX.max = 500
  local offsetY = menu.add_feature("Y","autoaction_value_i",attachSettings.id,nil)
  offsetY.min = -500
  offsetY.max = 500
  local offsetZ = menu.add_feature("Z","autoaction_value_i",attachSettings.id,nil)
  offsetZ.min = -500
  offsetZ.max = 500
  
  menu.add_feature("-- Rotation -- ","action",attachSettings.id,nil)
  local rotationX = menu.add_feature("X","autoaction_value_i",attachSettings.id,nil)
  rotationX.min = 0
  rotationX.max = 365
  local rotationY = menu.add_feature("Y","autoaction_value_i",attachSettings.id,nil)
  rotationY.min = 0
  rotationY.max = 365
  local rotationZ = menu.add_feature("Z","autoaction_value_i",attachSettings.id,nil)
  rotationZ.min = 0
  rotationZ.max = 365
  
  -- Attach PTFX
  local attachptfx = menu.add_feature("Attach PTFX","action",tempFeature.id,attach_ptfx)
  attachptfx.data = {entity = objectData['id'],parentSettings = attachSettings,type = "object"}
  --Attach Vehicle
  local attachVehicle = menu.add_feature("Attach Vehicle","parent",tempFeature.id,loadAttachAbleVehicleList)
  attachVehicle.data = {entity = objectData,parentSettings = attachSettings,type = "object"}
  --Attach Object
  local attachObject = menu.add_feature("Attach Object","parent",tempFeature.id,loadAttachAbleObjectList)
  attachObject.data = {entity = objectData,parentSettings = attachSettings,type = "object"}
  --Attach Ped
  local attachPed = menu.add_feature("Attach Ped","parent",tempFeature.id,loadAttachAblePedList)
  attachPed.data = {entity = objectData,parentSettings = attachSettings}
    
  --Delete
  menu.add_feature("Delete","action",tempFeature.id,
  function()
    entity.delete_entity(objectData['id'])
    ui.notify_above_map("Deleted " .. objectData['name'] ..  " (" .. objectData['id'] .. ")","ZeroMenu",140)      
    for i=1,#tempFeature.children do
      menu.delete_feature(tempFeature.children[1].id)
    end
    menu.delete_feature(tempFeature.id)    
    table.remove(spawnedVehicleList,objectData['arrayID'])
  end)  
end

function processSpawnedPed(pedData)
  --vehicleParentList  
  local tempFeature = menu.add_feature(pedData['name'] .. "(" .. pedData['id'] .. ")","parent",pedParentList.id,nil)
  local attachSettings = menu.add_feature("Attach Settings","parent",tempFeature.id,nil)
  
  menu.add_feature("-- Offset -- ","action",attachSettings.id,nil)
  local offsetX = menu.add_feature("X","autoaction_value_i",attachSettings.id,nil)
  offsetX.min = -500
  offsetX.max = 500
  local offsetY = menu.add_feature("Y","autoaction_value_i",attachSettings.id,nil)
  offsetY.min = -500
  offsetY.max = 500
  local offsetZ = menu.add_feature("Z","autoaction_value_i",attachSettings.id,nil)
  offsetZ.min = -500
  offsetZ.max = 500
  
  menu.add_feature("-- Rotation -- ","action",attachSettings.id,nil)
  local rotationX = menu.add_feature("X","autoaction_value_i",attachSettings.id,nil)
  rotationX.min = 0
  rotationX.max = 365
  local rotationY = menu.add_feature("Y","autoaction_value_i",attachSettings.id,nil)
  rotationY.min = 0
  rotationY.max = 365
  local rotationZ = menu.add_feature("Z","autoaction_value_i",attachSettings.id,nil)
  rotationZ.min = 0
  rotationZ.max = 365
  
  -- Attach PTFX
  local attachptfx = menu.add_feature("Attach PTFX","action",tempFeature.id,attach_ptfx)
  attachptfx.data = {entity = pedData['id'],parentSettings = attachSettings,type = "ped"}
  --Attach Vehicle
  local attachVehicle = menu.add_feature("Attach Vehicle","parent",tempFeature.id,loadAttachAbleVehicleList)
  attachVehicle.data = {entity = pedData,parentSettings = attachSettings,type = "ped"}
  --Attach Object
  local attachObject = menu.add_feature("Attach Object","parent",tempFeature.id,loadAttachAbleObjectList)
  attachObject.data = {entity = pedData,parentSettings = attachSettings,type = "ped"}
  --Attach Ped
  local attachPed = menu.add_feature("Attach Ped","parent",tempFeature.id,loadAttachAblePedList)
  attachPed.data = {entity = pedData,parentSettings = attachSettings}
    
  --Delete
  menu.add_feature("Delete","action",tempFeature.id,
  function()
    entity.delete_entity(pedData['id'])
    ui.notify_above_map("Deleted " .. pedData['name'] ..  " (" .. pedData['id'] .. ")","ZeroMenu",140)      
    for i=1,#tempFeature.children do
      menu.delete_feature(tempFeature.children[1].id)
    end
    menu.delete_feature(tempFeature.id)    
    table.remove(spawnedVehicleList,pedData['arrayID'])
  end)
end

function loadAttachAbleVehicleList(feat,data)
  local parent = data.entity
  for i=1,#spawnedVehicleList do
    if(isChild(feat,tostring(spawnedVehicleList[i]['name'] .. " (" .. spawnedVehicleList[i]['id'] .. ")")) == false) then
      if(spawnedVehicleList[i]['id'] ~= parent['id']) then
        local attachVehicleFunc = menu.add_feature(spawnedVehicleList[i]['name'] .. " (" .. spawnedVehicleList[i]['id'] .. ")","action_value_str",feat.id,attachVehicle)
        attachVehicleFunc.data = {parentVehicleObject = parent,parentVehicle = parent['id'], childVehicle = spawnedVehicleList[i]['id'],parentSettings = data.parentSettings}      
        local bones = nil
        if(data.type == "vehicle") then
          bones = vb.GetUseAbleBones(parent['id'])
        elseif(data.type == "ped") then
          bones = pb.GetUseAbleBones(parent['id'])
        else
          bones = {"center"}          
        end
        attachVehicleFunc.set_str_data(attachVehicleFunc,bones)
        
        --Save feat for deleting later
        local featList = spawnedVehicleList[i]['feats']  
        if(featList == nil) then
          spawnedVehicleList[i]['feats'] = {}
        end
        local featList = spawnedVehicleList[i]['feats']  
        featList[#featList+1] = attachVehicleFunc
      end
    end
  end
end

function loadAttachAblePedList(feat,data)
  local parent = data.entity
  for i=1,#spawnedPedList do
    if(isChild(feat,tostring(spawnedPedList[i]['name'] .. " (" .. spawnedPedList[i]['id'] .. ")")) == false) then
      if(spawnedPedList[i]['id'] ~= parent['id']) then
        local attachVehicleFunc = menu.add_feature(spawnedPedList[i]['name'] .. " (" .. spawnedPedList[i]['id'] .. ")","action_value_str",feat.id,attachVehicle)
        attachVehicleFunc.data = {parentVehicleObject = parent,parentVehicle = parent['id'], childVehicle = spawnedPedList[i]['id'],parentSettings = data.parentSettings}      
        
        print("loadAttachAblePedList: Getting Bones for " .. parent['id'])
        local bones = {"center"}
        if(data.type == "vehicle") then
          bones = vb.GetUseAbleBones(parent['id'])
        elseif(data.type == "ped") then
          bones = pb.GetUseAbleBones(parent['id'])
        else
          bones = {"center"}          
        end
        
        attachVehicleFunc.set_str_data(attachVehicleFunc,bones)
        
        --Save feat for deleting later
        local featList = spawnedPedList[i]['feats']  
        if(featList == nil) then
          spawnedPedList[i]['feats'] = {}
        end
        local featList = spawnedPedList[i]['feats']  
        featList[#featList+1] = attachVehicleFunc
      end
    end
  end
end

function loadAttachAbleObjectList(feat,data)
  local parent = data.entity
  for i=1,#spawnedObjectList do
    if(isChild(feat,tostring(spawnedObjectList[i]['name'] .. " (" .. spawnedObjectList[i]['id'] .. ")")) == false) then
      if(spawnedObjectList[i]['id'] ~= parent['id']) then
        local attachVehicleFunc = menu.add_feature(spawnedObjectList[i]['name'] .. " (" .. spawnedObjectList[i]['id'] .. ")","action_value_str",feat.id,attachVehicle)
        attachVehicleFunc.data = {parentVehicleObject = parent,parentVehicle = parent['id'], childVehicle = spawnedObjectList[i]['id'],parentSettings = data.parentSettings}      
        local bones = {"center"}     
        print("searching for a bone for type: " .. data.type)    
        print("loadAttachAbleObjectList: Getting Bones for " .. parent['id'])
        
        if(data.type == "vehicle") then
          print("type: vehicle")
          bones = vb.GetUseAbleBones(parent['id'])
        elseif(data.type == "ped") then
          print("type: ped")
          bones = pb.GetUseAbleBones(parent['id'])
        else
          bones = {"center"}          
        end        
        attachVehicleFunc.set_str_data(attachVehicleFunc,bones)
        ui.notify_above_map("Found " .. #bones .. " Bones for " .. parent['id'],"ZeroMenu",140)
        --Save feat for deleting later
        local featList = spawnedObjectList[i]['feats']  
        if(featList == nil) then
          spawnedObjectList[i]['feats'] = {}
        end
        local featList = spawnedObjectList[i]['feats']  
        featList[#featList+1] = attachVehicleFunc
      end
    end
  end
end

function isChild(parentFeat,name)
   for i=1,#parentFeat.children do
      if(parentFeat.children[i].name == name) then
        return true
      end
   end
   return false
end

function attachVehicle(feat,data)

  local offsetX = data.parentSettings.children[2].value
  local offsetY = data.parentSettings.children[3].value
  local offsetZ = data.parentSettings.children[4].value
  
  local rotationX = data.parentSettings.children[6].value
  local rotationY = data.parentSettings.children[7].value
  local rotationZ = data.parentSettings.children[8].value

  local offset = v3(offsetX,offsetY,offsetZ)
  local rot = v3(rotationX,rotationY,rotationZ)
  local bone = nil
  if(data.type == "vehicle") then
    bone = entity.get_entity_bone_index_by_name(data.parentVehicle,vb.GetUseAbleBones(data.parentVehicle)[feat.value+1])
  elseif(data.type == "ped") then
    bone = entity.get_entity_bone_index_by_name(data.parentVehicle,pb.GetUseAbleBones(data.parentVehicle)[feat.value+1])
  else
    bone = 0
  end
  entity.attach_entity_to_entity(data.childVehicle,data.parentVehicle,bone,offset,rot,false,true,false,0,true)
  
  --make everything no collideable to each other
  
  local attachedStuff = data.parentVehicleObject['attachedStuff']
  
  if(attachedStuff == nil) then
    attachedStuff = {}
  end
  attachedStuff[#attachedStuff+1] = data.childVehicle
  data.parentVehicleObject['attachedStuff'] = attachedStuff
  
  for i=1,#attachedStuff do
    local entityX = attachedStuff[i]
    for i=1,#attachedStuff do
      entity.set_entity_no_collsion_entity(attachedStuff[i],entityX,true)
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
  
  if(rightHash == nil or streaming.is_model_in_cdimage(rightHash) == false) then
      ui.notify_above_map("Unknown Hash!","ZeroMenu",140)   
      requestedVehicle = nil
      return HANDLER_POP
  end
  
  if(rightHash ~= nil) then
    if(streaming.has_model_loaded(rightHash)) then
      local v3 = player.get_player_coords(player.player_id())
      local vehicleData = {}
      vehicleData['hash'] = rightHash
      vehicleData['name'] = requestedVehicle
      vehicleData['id'] = vehicle.create_vehicle(rightHash,v3,entity.get_entity_heading(player.get_player_ped(player.player_id())),true,false)
      local arrayID = #spawnedVehicleList+1
      vehicleData['arrayID'] = arrayID
      spawnedVehicleList[arrayID] = vehicleData
      streaming.set_model_as_no_longer_needed(rightHash)
      requestedVehicle = nil
      ui.notify_above_map("Spawned Vehicle " .. rightHash,"ZeroMenu",140)      
      notifySpawnedStuff()
      processSpawnedVehicle(vehicleData)
    else
      while not streaming.has_model_loaded(rightHash) do
          streaming.request_model(rightHash)
          system.wait(0)
      end
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
      processSpawnedPed(pedData)
      notifySpawnedStuff()
      requestedPed = nil
    else
      while not streaming.has_model_loaded(rightHash) do
          streaming.request_model(rightHash)
          system.wait(0)
      end
      return HANDLER_CONTINUE
    end
  else    
      ui.notify_above_map("Unknown Ped " .. requestedPed,"ZeroMenu",140)
      requestedPed = nil
  end
end

local requestedObject = 0
function spawnObjectByName()
  if requestedObject == 0 then
    local r, s = input.get("Enter Object Name", "hei_prop_heist_safedepdoor", 64, 0)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    requestedObject = s
  end
  local objectData = {}
  
  local objectHash = om.GetHashFromModel(requestedObject)
  
  if(streaming.has_model_loaded(objectHash)) then  
    local objectCandle = object.create_object(objectHash,player.get_player_coords(player.player_id()),true,true)
    requestedObject = 0
    streaming.set_model_as_no_longer_needed(objectHash) 
    ui.notify_above_map("Spawned Object " .. requestedObject,"ZeroMenu",140)
    count = 0
    objectData['id'] =  objectCandle
  else
    while not streaming.has_model_loaded(objectHash) do
      streaming.request_model(objectHash)
      system.wait(0)
    end 
    return HANDLER_CONTINUE
  end
  if(streaming.is_model_in_cdimage(objectHash) == false) then  
      ui.notify_above_map("Unknown Hash1 " .. requestedObject,"ZeroMenu",140)   
      requestedVehicle = nil
      return HANDLER_POP
  end
  
  if(objectData['id'] == nil) then
      ui.notify_above_map("Unknown Hash2 " .. requestedObject,"ZeroMenu",140)   
      requestedVehicle = nil
      return HANDLER_POP
  end
  objectData['hash'] = om.GetHashFromModel(requestedObject)
  objectData['name'] = requestedObject
  spawnedObjectList[#spawnedObjectList+1] = objectData
  ui.notify_above_map("Spawned " .. requestedObject,"ZeroMenu",140)   
  processSpawnedObject(objectData)
  notifySpawnedStuff()
  requestedObject = 0
end

function spawnObjectByHash()
  if requestedObject == 0 then
    local r, s = input.get("Enter Object Hash", "", 64, 3)
    if r == 1 then return HANDLER_CONTINUE end
    if r == 2 then return HANDLER_POP end
    requestedObject = tonumber(s)
  end
  if(streaming.is_model_in_cdimage(requestedObject) == false) then
      ui.notify_above_map("Unknown Hash " .. requestedObject,"ZeroMenu",140)   
      requestedObject = nil
      return HANDLER_POP
  end
  if(requestedObject == nil) then
      ui.notify_above_map("Unknown Hash " .. requestedObject,"ZeroMenu",140)   
      requestedObject = nil
      return HANDLER_POP
  end
  local objectData = {}
  if(streaming.has_model_loaded(requestedObject)) then  
    local objectCandle = object.create_object(requestedObject,player.get_player_coords(player.player_id()),true,true)
    streaming.set_model_as_no_longer_needed(requestedObject) 
    ui.notify_above_map("Spawned Object " .. requestedObject,"ZeroMenu",140)
    count = 0
    objectData['id'] =  objectCandle
  else
    while not streaming.has_model_loaded(requestedObject) do
      streaming.request_model(requestedObject)
      system.wait(0)
    end 
    return HANDLER_CONTINUE
  end
  print("1: " .. requestedObject)
  print("2: " .. om.GetModelFromHash(requestedObject))
  objectData['hash'] = requestedObject
  objectData['name'] = om.GetModelFromHash(requestedObject)
  spawnedObjectList[#spawnedObjectList+1] = objectData
  requestedObject = nil
  ui.notify_above_map("Spawned " .. objectData['name'],"ZeroMenu",140)   
  processSpawnedObject(objectData)
  notifySpawnedStuff()
end


local dict = nil
local flame = nil
function attach_ptfx(feat,data)  
  local entity = data.entity
  
  local offsetX = data.parentSettings.children[2].value
  local offsetY = data.parentSettings.children[3].value
  local offsetZ = data.parentSettings.children[4].value
  
  local rotationX = data.parentSettings.children[6].value
  local rotationY = data.parentSettings.children[7].value
  local rotationZ = data.parentSettings.children[8].value
  
  --ui.notify_above_map("offset=(" .. offsetX .. "," .. offsetY .. "," .. offsetZ .. ")\n rot=" .. "(" .. rotationX .. "," .. rotationY .. "," .. rotationZ .. ")\n","ZeroMenu",140)
  
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
    system.wait(0)
    return HANDLER_CONTINUE 
  end
    
  local offset = v3(offsetX,offsetY,offsetZ)
  local rot = v3(rotationX,rotationY,rotationZ)
  graphics.start_networked_ptfx_looped_on_entity(flame,entity,offset,rot,scale)
  flame = nil
  dict = nil
  return HANDLER_POP 
end