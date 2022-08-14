local util = require("ZeroMenuLib/Util/Util")
local selfMain,wander,startScenarioFeat,modelchangemain,xmlOutfitParent,doLoopedPTFX,breathFireFeat,breathScale
local vs = require("ZeroMenuLib/enums/Scenarios")
local ds = require("ZeroMenuLib/enums/DrivingStyle")
local pm = require("ZeroMenuLib/enums/PedMapper")

local loopedPTFX = {}

function createSelfMenuEntry(parent,config)
  selfMain = menu.add_feature("Self", "parent", parent.id, nil)

  wander = util.createConfigedMenuOption(self,"Wander Streets (Vehicle)","action_value_str",selfMain.id,wanderStreet,config,"wander",false,nil)
  wander.set_str_data(wander,ds.getDriveStyleList())

  startScenarioFeat = menu.add_feature("Start Scenario","action_value_str",selfMain.id,startScenario)
  startScenarioFeat.set_str_data(startScenarioFeat,vs)

  menu.add_feature("Start Dance","action",selfMain.id,dance)
  menu.add_feature("Stop Scenario","action",selfMain.id,stopScenario)

  modelchangemain = menu.add_feature("Model Change","parent",selfMain.id,loadModelList)
  
  xmlOutfitParent = menu.add_feature("XML Outfits","parent",selfMain.id,loadXMLOutfits)
  
  local breathFeat = menu.add_feature("Breathing","parent",selfMain.id,nil)
  breathScale = menu.add_feature("Scale","action_slider",breathFeat.id,nil)
  breathScale.min = 1
  breathScale.max = 10
  breathFireFeat = menu.add_feature("Fire","toggle",breathFeat.id,breathFire)
  breathBloodFeat = menu.add_feature("Blood","toggle",breathFeat.id,breathBlood)
  
  local resetOutfitAndModel = menu.add_feature("Reset Outfit","action",selfMain.id,resetOutfit)
  
  local xmlOutfitOptions = menu.add_feature("Options","parent",xmlOutfitParent.id,nil)
  
  optionAttachNoCollision = menu.add_feature("No Collision","toggle",xmlOutfitOptions.id,nil)
  optionAttachNoCollision.on = true
  
  local searchForGuns = menu.add_feature("Search for guns","toggle",xmlOutfitOptions.id,nil)
  
  doLoopedPTFX = menu.add_feature("Looped PTFX","toggle",xmlOutfitOptions.id,function()    
    if loopedPTFX ~= nil then
      for i,line in pairs(loopedPTFX) do
        --local ptfxObject = {}
        local XMLentity = line["entity"]
        if XMLentity ~= nil then
          local dict = line["dict"]
          local ptfx = line["ptfx"]
          local scale = line["scale"]  
          local delay = line["delay"]            
          local timePTFXStart = line["timePTFXStart"]            
          if os.clock() >= timePTFXStart then
            attachPTFXControlledToEntity(XMLentity,dict,ptfx,scale,false)  
            line["timePTFXStart"] = os.clock()+(delay/1000)
            --menu.notify("Doing looped xml ptfx... (next call is: " .. line["timePTFXStart"] .. ")","ZeroMenu",5,140)
          end
        end        
      end
    end
    if doLoopedPTFX.on then    
      return HANDLER_CONTINUE
    else
      return HANDLER_POP
    end
  end)
   doLoopedPTFX.on = true  
end

function breathBlood()
  local dict = "scr_solomon3"
  local ptfx = "scr_trev4_747_blood_impact"
  local playerPed = player.get_player_ped(player.player_id())
  local boneIndex = 0x796E
  
  graphics.set_next_ptfx_asset(dict)
  while not graphics.has_named_ptfx_asset_loaded(dict) do
    graphics.request_named_ptfx_asset(dict)
    system.wait(0)
    return HANDLER_CONTINUE 
  end
  local offset = v3(-0.02,0.1,0.55)
  local rot = v3(-90.0,-110.0,90.0)  
  local lastPTFX = graphics.start_networked_ptfx_looped_on_entity(ptfx,player.get_player_ped(player.player_id()),offset,rot,(breathScale.value*0.16))
  if breathBloodFeat.on then   
    system.wait(500) 
    graphics.remove_particle_fx(lastPTFX,true)
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end

function breathFire()
  local dict = "core"
  local ptfx = "ent_sht_flame"
  local playerPed = player.get_player_ped(player.player_id())
  local boneIndex = 0x796E
  
  graphics.set_next_ptfx_asset(dict)
  while not graphics.has_named_ptfx_asset_loaded(dict) do
    graphics.request_named_ptfx_asset(dict)
    system.wait(0)
    return HANDLER_CONTINUE 
  end
  local offset = v3(-0.02,0.1,0.55)
  local rot = v3(90.0,100.0,90.0)  
  graphics.start_networked_ptfx_looped_on_entity(ptfx,player.get_player_ped(player.player_id()),offset,rot,breathScale.value)
  if breathFireFeat.on then   
    system.wait(5000) 
    return HANDLER_CONTINUE
  else
    return HANDLER_POP
  end
end

function loadModelList()
  local Peds = pm.GetAllHash()
  local idx = 0

  while idx < #Peds do
    idx = idx + 1
    local entry = Peds[idx]
    menu.add_feature(entry['name'],"action",modelchangemain.id,function()
      local pedHash = entry['hash']
      while not streaming.has_model_loaded(pedHash) do
        streaming.request_model(pedHash )
        system.wait(0)
      end
      
      
      
      player.set_player_model(pedHash)
      menu.notify("Changed to " .. entry['name'],"ZeroMenu",5,140)
    end)
  end

end

function wanderStreet()
  local veh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id()))
  local temppedped = player.get_player_ped(player.player_id());
  if veh ~= nil then
    if not ai.is_task_active(temppedped,151)then
      local style = nil
      if(wander.value+1 == (#ds-1)) then
        style = ds[wander.value].id
      else
        style = ds[wander.value+1].id
      end

      ai.task_vehicle_drive_wander(temppedped,veh,200,style)
    end
  end
  if wander.on then
  else
    ped.clear_ped_tasks_immediately(temppedped)
    vehicle.set_vehicle_forward_speed(veh, 2)
  end
end

function startScenario()
  local playerPed = player.get_player_ped(player.player_id())
  local pos = player.get_player_coords(player.player_id())
  ai.task_start_scenario_at_position(playerPed,vs[startScenarioFeat.value+1],pos,1,1000000,false,false)
end

function stopScenario()
  local playerPed = player.get_player_ped(player.player_id())
  ped.clear_ped_tasks_immediately(playerPed)
end

function loadXMLOutfits()
  --Neue Options erstellen falls nicht bereits erstellt
  
  if menu.is_trusted_mode_enabled(1 << 2) then
    menu.notify("Refresh XML Outfits...","ZeroMenu",5,140)
    local xmlFolder = os.getenv('APPDATA') .. "\\PopstarDevs\\2Take1Menu\\scripts\\ZeroMenuLib\\data\\xmloutfits\\"
    local xmlOutfitFiles = utils.get_all_files_in_directory(xmlFolder,"xml")
    for xmlOutfit = 1, #xmlOutfitFiles do
      local addFeat = true
      for xmlVehicleFeat = 1,#xmlOutfitParent.children do
        if xmlOutfitParent.children[xmlVehicleFeat].name == util.splitStringAt(self,xmlOutfitFiles[xmlOutfit],".xml")[1] then
          addFeat = false
        end
      end
      if addFeat then      
        --local xmlVehicleSpawnFeat = menu.add_feature(xmlVehicleFiles[xmlVehicle],"action_value_str",xmlVehicleParent.id,spawnXMLFeatVehicle)
        local xmlVehicleSpawnFeat = menu.add_feature(util.splitStringAt(self,xmlOutfitFiles[xmlOutfit],".xml")[1],"action",xmlOutfitParent.id,processXMLOutfits)
        --local xmlVehicleSpawnFeatOptions = {"Use"}
        --xmlVehicleSpawnFeat.set_str_data(xmlVehicleSpawnFeat,xmlVehicleSpawnFeatOptions)
        xmlVehicleSpawnFeat.data = {file = xmlVehicleSpawnFeat.name}
      end
    end
  else
    menu.notify("Spawning XML Outfits requires Natives Trusted Mode Enabled!","ZeroMenu",5,140)
  end
  
  
end

function processXMLOutfits(feat,data)
  loopedPTFX = {}
  spawnXMLOutfit(data.file)
end

local xmlList = {}

function spawnXMLOutfit(file)
  local xmlFile = os.getenv('APPDATA') .. "\\PopstarDevs\\2Take1Menu\\scripts\\ZeroMenuLib\\data\\xmloutfits\\" .. file .. ".xml"  
  local testF = io.open(xmlFile,"r")
  if(testF ~= nil and xmlFile~=nil) then
    backupPlayerOutfit()
    io.close(testF)
    local handler = loadXMLFile(xmlFile)    
    local modelHash_int = tonumber(handler.root.OutfitPedData.ModelHash:sub(3), 16)
    local modelHash = handler.root.OutfitPedData.ModelHash
    
    if streaming.is_model_in_cdimage(modelHash) then
      while not streaming.has_model_loaded(modelHash) do
        streaming.request_model(modelHash)
        system.wait(0)
      end
      player.set_player_model(modelHash)
      system.wait(50)
      --ped.set_ped_random_component_variation(player.get_player_ped(player.player_id()))
      local playerPed = player.get_player_ped(player.player_id())
      xmlList[handler.root.OutfitPedData.InitialHandle] = playerPed
      processPedData(playerPed,handler.root.OutfitPedData,handler)    
      if handler.root.OutfitPedData.SpoonerAttachments ~= nil then
        processOutfitAttachment(handler.root.OutfitPedData.SpoonerAttachments.Attachment,handler)
      end
      streaming.set_model_as_no_longer_needed(modelHash)
      menu.notify("Processed Outfit ".. file ,"ZeroMenu",5,140)
    else
      menu.notify("Unknown Model ".. modelHash ,"ZeroMenu",5,140)
    end        
  end
end

local backupedOutfit = nil

function resetOutfit()
  ---backupedOutfit
end

function backupPlayerOutfit ()
  
  if backupedOutfit ~= nil then
    return
  end
  backupedOutfit = {}
  
  local pedProb = {}
  local playerPed = player.get_player_ped(player.player_id())
  backupedOutfit["model"] = entity.get_entity_model_hash(playerPed)
  
  --ped.set_ped_prop_index(playerPed,probID,drawAble,textureID,true)
  pedProb[0] = ped.get_ped_prop_index(playerPed,0)
  pedProb[1] = ped.get_ped_prop_index(playerPed,1)
  pedProb[2] = ped.get_ped_prop_index(playerPed,2)
  pedProb[3] = ped.get_ped_prop_index(playerPed,3)
  pedProb[4] = ped.get_ped_prop_index(playerPed,4)
  pedProb[5] = ped.get_ped_prop_index(playerPed,5)
  pedProb[6] = ped.get_ped_prop_index(playerPed,6)
  pedProb[7] = ped.get_ped_prop_index(playerPed,7)
  pedProb[8] = ped.get_ped_prop_index(playerPed,8)
  pedProb[9] = ped.get_ped_prop_index(playerPed,9)  
  backupedOutfit["pedProb"] = pedProb
  
  
  backupedOutfit["haircolor"] = ped.get_ped_hair_color(playerPed)
  backupedOutfit["highlightcolor"] = ped.get_ped_hair_highlight_color(playerPed)
  backupedOutfit["headblenddata"] = ped.get_ped_head_blend_data(playerPed)
  
  local facialFeatures = {}
  facialFeatures[0] = ped.get_ped_face_feature(playerPed,0)
  facialFeatures[1] = ped.get_ped_face_feature(playerPed,1)
  facialFeatures[2] = ped.get_ped_face_feature(playerPed,2)
  facialFeatures[3] = ped.get_ped_face_feature(playerPed,3)
  facialFeatures[4] = ped.get_ped_face_feature(playerPed,4)
  facialFeatures[5] = ped.get_ped_face_feature(playerPed,5)
  facialFeatures[6] = ped.get_ped_face_feature(playerPed,6)
  facialFeatures[7] = ped.get_ped_face_feature(playerPed,7)
  facialFeatures[8] = ped.get_ped_face_feature(playerPed,8)
  facialFeatures[9] = ped.get_ped_face_feature(playerPed,9)
  facialFeatures[10] = ped.get_ped_face_feature(playerPed,10)
  facialFeatures[11] = ped.get_ped_face_feature(playerPed,11)
  facialFeatures[12] = ped.get_ped_face_feature(playerPed,12)
  facialFeatures[13] = ped.get_ped_face_feature(playerPed,13)
  facialFeatures[14] = ped.get_ped_face_feature(playerPed,14)
  facialFeatures[15] = ped.get_ped_face_feature(playerPed,15)
  facialFeatures[16] = ped.get_ped_face_feature(playerPed,16)
  facialFeatures[17] = ped.get_ped_face_feature(playerPed,17)
  facialFeatures[18] = ped.get_ped_face_feature(playerPed,18)
  facialFeatures[19] = ped.get_ped_face_feature(playerPed,19)
  
  
  backupedOutfit["facialFeatures"] = facialFeatures
  
  
  
  local head_overlay_parent = {}
  
  processOverlay(0,head_overlay_parent)
  processOverlay(1,head_overlay_parent)
  processOverlay(2,head_overlay_parent)
  processOverlay(3,head_overlay_parent)
  processOverlay(4,head_overlay_parent)
  processOverlay(5,head_overlay_parent)
  processOverlay(6,head_overlay_parent)
  processOverlay(7,head_overlay_parent)
  processOverlay(8,head_overlay_parent)
  processOverlay(9,head_overlay_parent)
  processOverlay(10,head_overlay_parent)
  processOverlay(11,head_overlay_parent)
  processOverlay(12,head_overlay_parent)
  
  backupedOutfit["headoverlay"] = head_overlay_parent
  
end

function processOverlay(overlayID,tableToAdd)
  local head_overlay_table = {}
  head_overlay_table["index"] = ped.get_ped_head_overlay_value(playerPed,0)
  head_overlay_table["color"] = ped.get_ped_head_overlay_color(playerPed,0)
  head_overlay_table["highlight"] = ped.get_ped_head_overlay_highlight_color(playerPed,0)
  head_overlay_table["opacity"] = ped.get_ped_head_overlay_opacity(playerPed,0)
  head_overlay_table["colortype"] = ped.get_ped_head_overlay_color_type(playerPed,0)
  if head_overlay_table["colortype"] == nil then head_overlay_table["colortype"] = 0 end
  tableToAdd[overlayID] = head_overlay_table
end

function processOutfitAttachment(atta,handler)
  local single = false
  if(atta == nil) then
    single = true
  elseif(#atta == 0) then
    single = true
  end
  if atta == nil then return end
  if(single) then
    if(atta.Type == '1') then
      processPedToOutfitAttachment(atta,handler)
      --menu.notify("processing ped attachment " .. atta.InitialHandle,"Zeromenu",5,140)
    elseif(atta.Type == '2') then
      processVehicleToOutfitAttachment(atta,handler)
      --menu.notify("processing veh attachment " .. atta.InitialHandle,"Zeromenu",5,140)
    elseif(atta.Type == '3') then
      processObjectToOutfitAttachment(atta,handler)
      --menu.notify("processing obj attachment " .. atta.InitialHandle,"Zeromenu",5,140)
    else
      menu.notify("Unknown Typ: " .. atta.Type,"ZeroMenu",5,140)
    end
  else
    for i=1,#atta,1 do
      if(atta[i].Type == '1') then
        processPedToOutfitAttachment(atta[i],handler)
      --menu.notify("processing ped attachment " .. atta[i].InitialHandle,"Zeromenu",5,140)
      elseif(atta[i].Type == '2') then
        processVehicleToOutfitAttachment(atta[i],handler)
      --menu.notify("processing veh attachment " .. atta[i].InitialHandle,"Zeromenu",5,140)
      elseif(atta[i].Type == '3') then
        processObjectToOutfitAttachment(atta[i],handler)
      --menu.notify("processing obj attachment " .. atta[i].InitialHandle,"Zeromenu",5,140)
      else
        print("Unknown Typ-" .. i .. ": " .. atta[i].Type)
      end
    end
  end
end

function processObjectToOutfitAttachment(attachment,handler)
  local parent = xmlList[attachment.Attachment.AttachedTo]
  local objectHash = tonumber(attachment.ModelHash:sub(3), 16)
  local xmlObject = nil
  while not streaming.has_model_loaded(objectHash) do
    streaming.request_model(objectHash)
    system.wait(0)
  end
  if(streaming.is_model_a_world_object(objectHash)) then
    xmlObject = object.create_world_object(objectHash,player.get_player_coords(player.player_id()),true,toboolean(attachment.Dynamic))
  else
    xmlObject = object.create_object(objectHash,player.get_player_coords(player.player_id()),true,toboolean(attachment.Dynamic))
  end
  xmlList[attachment.InitialHandle] = xmlObject
  entity.freeze_entity(xmlObject,valueOrDefault(attachment.FrozenPos,false,attachment.InitialHandle .. ' FrozenPos'))
  entity.set_entity_gravity(xmlObject,valueOrDefault(attachment.HasGravity,true,attachment.InitialHandle .. ' HasGravity'))
  entity.set_entity_god_mode(xmlObject,valueOrDefault(attachment.IsInvincible,true,attachment.InitialHandle .. ' IsInvincible'))
  --local isVisible = toboolean(valueOrDefault(attachment.IsVisible,true,attachment.InitialHandle .. ' Attachment.IsVisible'))
  local isVisible = attachment.IsVisible == 'true'
  local attachWitCollission = true
  if(attachment.IsCollisionProof == 'true') then
   attachWitCollission = false 
  end
  if isVisible then
    entity.set_entity_visible(xmlObject,true)
  end
  
  if attachment.TaskSequence ~= nil then  
    if #attachment.TaskSequence.Task > 0 then
      --Mehrere PTFX
      for i,line in pairs(attachment.TaskSequence.Task) do
        line = attachment.TaskSequence.Task[i]        
        local dict  = line.AssetName
        local ptfx  = line.EffectName
        local scale = line.Scale    
        local looped = false
        local delay = line.Delay          
        if line.IsLoopedTask ~= nil then
          looped = line.IsLoopedTask == 'true'  
        end
        attachPTFXControlledToEntity(xmlObject,dict,ptfx,scale,looped,delay)
      end
    else
      --Ein PTFX      
      line = attachment.TaskSequence.Task        
      local dict  = line.AssetName
      local ptfx  = line.EffectName
      local scale = line.Scale    
      local looped = false
      local delay = line.Delay  
      if line.IsLoopedTask ~= nil then
        looped = line.IsLoopedTask == 'true'  
      end    
      attachPTFXControlledToEntity(xmlObject,dict,ptfx,scale,looped,delay)
    end
  end   
  
  
  local rotation = v3(valueOrDefault(attachment.PositionRotation.Pitch,0,attachment.InitialHandle .. ' Pitch'),valueOrDefault(attachment.PositionRotation.Roll,0,attachment.InitialHandle .. 'Roll'),valueOrDefault(attachment.PositionRotation.Yaw,0,attachment.InitialHandle .. 'Yaw'))
  entity.set_entity_rotation(xmlObject,rotation)
  local pos = v3(valueOrDefault(attachment.PositionRotation.X,0,attachment.InitialHandle .. ' PositionRotation.x'),valueOrDefault(attachment.PositionRotation.Y,0,attachment.InitialHandle .. ' PositionRotation.y'),valueOrDefault(attachment.PositionRotation.Z,0,attachment.InitialHandle .. ' PositionRotation.z'))
  entity.set_entity_coords_no_offset(xmlObject,pos)

  local rotation = v3(valueOrDefault(attachment.Attachment.Pitch,0,'Attachment.Pitch'),valueOrDefault(attachment.Attachment.Roll,0,attachment.InitialHandle .. ' Attachment.Roll'),valueOrDefault(attachment.Attachment.Yaw,0,'Attachment.Yaw'))
  local offset = v3(valueOrDefault(attachment.Attachment.X,0,attachment.InitialHandle .. ' Attachment.X'),valueOrDefault(attachment.Attachment.Y,0,attachment.InitialHandle .. ' Attachment.Y'),valueOrDefault(attachment.Attachment.Z,0,attachment.InitialHandle .. ' Attachment.Z'))
  --print("attaching....")
  local doCol = not optionAttachNoCollision.on
  entity.attach_entity_to_entity(xmlObject,parent,valueOrDefault(attachment.Attachment.BoneIndex,0,attachment.InitialHandle .. ' Attachment.BoneIndex'),offset,rotation,false,doCol,false,2 ,true)
  streaming.set_model_as_no_longer_needed(objectHash)
end

function attachPTFXControlledToEntity(entity,dict,ptfx,scale,looped,delay)
  graphics.set_next_ptfx_asset(dict)
  while not graphics.has_named_ptfx_asset_loaded(dict) do
    graphics.request_named_ptfx_asset(dict)
    system.wait(0)
    return HANDLER_CONTINUE 
  end
  local offset = v3(0,0,0)
  local rot = v3(0,0,0)
  if looped then  
    graphics.start_networked_ptfx_looped_on_entity(ptfx,entity,offset,rot,scale)
  else
    graphics.start_networked_ptfx_non_looped_on_entity(ptfx,entity,offset,rot,scale)
  end
   
  if looped then
    local ptfxObject = {}
    ptfxObject["entity"] = entity
    ptfxObject["dict"] = dict
    ptfxObject["ptfx"] = ptfx
    ptfxObject["scale"] = scale
    ptfxObject["delay"] = delay
    ptfxObject["timePTFXStart"] = os.clock()+(delay/1000)
  
    loopedPTFX[#loopedPTFX] = ptfxObject
  end
end

function processPedToOutfitAttachment(attachment,handler)
  local parent = xmlList[attachment.Attachment.AttachedTo]
  local pedHash = tonumber(attachment.ModelHash:sub(3), 16)
  local pedAtt = nil
  while not streaming.has_model_loaded(pedHash) do
    streaming.request_model(pedHash )
    system.wait(0)
  end
  pedAtt = ped.create_ped(-1,pedHash,player.get_player_coords(player.player_id()),player.get_player_armour(player.player_id()),true,false)
  
  processPedData(pedAtt,attachment,handler)  
  
  local rotation = v3(valueOrDefault(attachment.Attachment.Pitch,0,attachment.InitialHandle .. ' Attachment.Pitch'),valueOrDefault(attachment.Attachment.Roll,0,attachment.InitialHandle .. ' Attachment.Roll'),valueOrDefault(attachment.Attachment.Yaw,0,attachment.InitialHandle .. ' Attachment.Yaw'))

  local offset = v3(valueOrDefault(attachment.Attachment.X,0,attachment.InitialHandle .. ' Attachment.Attachment.X'),valueOrDefault(attachment.Attachment.Y,0,attachment.InitialHandle .. ' Attachment.Attachment.Y'),valueOrDefault(attachment.Attachment.Z,0,attachment.InitialHandle .. ' Attachment.Attachment.Z'))
  entity.set_entity_collision(pedAtt,true, false, true)  
  local doCol = not optionAttachNoCollision.on
  entity.attach_entity_to_entity(pedAtt,parent,valueOrDefault(attachment.Attachment.BoneIndex,0,attachment.InitialHandle .. ' Attachment.Attachment.BoneIndex'),offset,rotation,false,doCol,false,2,true)
end
function processVehicleToOutfitAttachment(attachment,handler)
  local parent = xmlList[attachment.Attachment.AttachedTo]
  if parent == nil then
    menu.notify("Couldnt find base vehicle with id: " .. attachment.Attachment.AttachedTo,"ZeroMenu",5,140)
  end
  local vehicleHash = tonumber(attachment.ModelHash:sub(3), 16)
  local vehicleAtt = nil
  while not streaming.has_model_loaded(vehicleHash) do
    streaming.request_model(vehicleHash )
    system.wait(0)
  end
  vehicleAtt = spawnRawVehicle(vehicleHash,player.get_player_coords(player.player_id()))
  xmlList[attachment.InitialHandle] = vehicleAtt
  --spawnedXmlTable[#spawnedXmlTable+1] = vehicleAtt
  processXMLVehileProberties(vehicleAtt,attachment.VehicleProperties)


  local rotation = v3(valueOrDefault(attachment.PositionRotation.Pitch,0,attachment.InitialHandle .. ' Pitch'),valueOrDefault(attachment.PositionRotation.Roll,0,attachment.InitialHandle .. 'Roll'),valueOrDefault(attachment.PositionRotation.Yaw,0,attachment.InitialHandle .. 'Yaw'))
  local pos = v3(valueOrDefault(attachment.PositionRotation.X,0,attachment.InitialHandle .. ' PositionRotation.x'),valueOrDefault(attachment.PositionRotation.Y,0,attachment.InitialHandle .. ' PositionRotation.y'),valueOrDefault(attachment.PositionRotation.Z,0,attachment.InitialHandle .. ' PositionRotation.z'))
  streaming.set_model_as_no_longer_needed(vehicleHash)
  local rotation = v3(valueOrDefault(attachment.Attachment.Pitch,0,attachment.InitialHandle .. ' Attachment.Pitch'),valueOrDefault(attachment.Attachment.Roll,0,attachment.InitialHandle .. ' Attachment.Roll'),valueOrDefault(attachment.Attachment.Yaw,0,attachment.InitialHandle .. ' Attachment.Yaw'))
  local offset = v3(valueOrDefault(attachment.Attachment.X,0,attachment.InitialHandle .. ' Attachment.X'),valueOrDefault(attachment.Attachment.Y,0,attachment.InitialHandle .. ' Attachment.Y'),valueOrDefault(attachment.Attachment.Z,0,attachment.InitialHandle .. ' Attachment.Z'))
  
  local doCol = not optionAttachNoCollision.on
  entity.attach_entity_to_entity(vehicleAtt,parent,valueOrDefault(attachment.Attachment.BoneIndex,0,attachment.InitialHandle .. ' Attachment.BoneIndex'),offset,rotation,false,doCol,false,2 ,true)
end

function processPedData(playerPed,proberties,handler)
    
  if proberties.MaxHealth ~= nil then ped.set_ped_max_health(playerPed,proberties.MaxHealth) end
  if proberties.Health ~= nil then ped.set_ped_health(playerPed,proberties.Health) end
  
  if proberties.PedProperties.HasShortHeight == 'true' then ped.set_ped_config_flag(playerPed,223,1) end
  
  --Probs  
  for i,line in pairs(proberties.PedProperties.PedProps) do
    local probID = string.sub(i,2,3)
    local commaPos = string.find(line,",")
    if commaPos ~= nil then
      local drawAble = string.sub(line,1,commaPos-1)
      local textureID = string.sub(line,commaPos+1,#line)     
      ped.set_ped_prop_index(playerPed,probID,drawAble,textureID,true)
    else
      local drawAble = line
      ped.set_ped_prop_index(playerPed,probID,line,0,true)
    end
    
    
  end
  --Comp
  for i,line in pairs(proberties.PedProperties.PedComps) do
    local compID = string.sub(i,2,3)
    --local splittedLine = util.splitStringAt(line,',')
    local commaPos = string.find(line,",")
    if commaPos ~= nil then
      local drawAble = string.sub(line,1,commaPos-1)
      local textureID = string.sub(line,commaPos+1,#line)
      --ped,componentID,drawableID,textureID,attach
      ped.set_ped_component_variation(playerPed,compID,drawAble,textureID,0)
    else
      ped.set_ped_component_variation(playerPed,compID,line,0,0)
    end
    
  end
  if proberties.PedProperties.HeadFeatures~= nil then
    local shape_first       = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.ShapeFatherId
    local shape_second      = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.ShapeMotherId
    local shape_third       = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.ShapeOverrideId
    local skinvalue_first   = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.ToneFatherId
    local skinvalue_second  = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.ToneMotherId
    local skinvalue_third   = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.ToneOverrideId
    local mix_shape         = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.ShapeVal
    local mix_skinvalue     = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.ToneVal
    local mix_third         = proberties.PedProperties.HeadFeatures.ShapeAndSkinTone.OverrideVal  
    ped.set_ped_head_blend_data(playerPed,shape_first,shape_second,shape_third,skinvalue_first,skinvalue_second,skinvalue_third,mix_shape,mix_skinvalue,mix_third)
    
    if proberties.PedProperties.HeadFeatures.HairColour ~= nil then ped.set_ped_hair_colors(playerPed,proberties.PedProperties.HeadFeatures.HairColour,proberties.PedProperties.HeadFeatures.HairColourStreaks) end
    if proberties.PedProperties.HeadFeatures.EyeColour ~= nil then ped.set_ped_eye_color(playerPed,proberties.PedProperties.HeadFeatures.EyeColour) end
    
    if proberties.PedProperties.HeadFeatures.FacialFeatures ~= nil then
      for i,line in pairs(proberties.PedProperties.HeadFeatures.FacialFeatures) do
        local id = string.sub(i,2,3)
        local val = line
        ped.set_ped_face_feature(playerPed,id,val)
      end
    end
    if proberties.PedProperties.HeadFeatures.Overlays ~= nil then
      for i,line in pairs(proberties.PedProperties.HeadFeatures.Overlays) do
        local overlayID = string.sub(i,2,3)
        local index = line["_attr"]["index"]
        local colour = line["_attr"]["colour"]
        local colourSecondary = line["_attr"]["colourSecondary"]
        local opacity = line["_attr"]["opacity"]    
        ped.set_ped_head_overlay(playerPed,overlayID,index,opacity)
        --0-> otherwise,1 -> eyebrows, beards, and chest hair,2 -> for blush and lipstick
        local colourtype = ped.get_ped_head_overlay_color_type(playerPed,overlayID)
        if colourtype == nil then colourtype = 0 end
        ped.set_ped_head_overlay_color(playerPed,overlayID,colourtype,colour,colourSecondary)       
      end
    end
  end
  
  if(proberties.IsInvincible == 'true')    then entity.set_entity_god_mode(playerPed,true) end
  if(proberties.IsVisible == 'true')    then 
    entity.set_entity_visible(playerPed,true) 
    util.set_visible(playerPed, true)
  else entity.set_entity_visible(playerPed,false) 
    entity.set_entity_visible(playerPed,false) 
    util.set_visible(playerPed, false)
  end
  if(proberties.IsOnFire == 'true')    then fire.start_entity_fire(playerPed) end
  --if(proberties.IsCollisionProof == 'true')    then entity.set_entity_collision(playerPed,true, false, true) else entity.set_entity_collision(playerPed,false, false, true) end
  
  if(proberties.PedProperties.IsStill == 'true')    then util.set_still(playerPed,2147483647) end
  
  
  util.set_proofs(playerPed, proberties.IsBulletProof == 'true', proberties.IsFireProof == 'true', proberties.IsExplosionProof == 'true', proberties.IsCollisionProof == 'true',proberties.IsMeleeProof == 'true', false, false) 
  --util.set_proofs(playerPed, true, true, true, true,true, true, true) 
  if proberties.IsFireProof == 'true' then
    menu.notify("Setting ignore Fire","ZeroMenu",5,140)
    ped.set_ped_config_flag(playerPed,430,1)
  end
end

function loadXMLFile(file)
  local xmlHandler = xmlhandler:new()
  local parser = xml2lua.parser(xmlHandler)
  local file = xml2lua.loadFile(file)
  parser:parse(file)
  return xmlHandler
end

function dance()
  if not streaming.has_anim_dict_loaded("mini@strip_club@private_dance@part2")then
    streaming.request_anim_dict("mini@strip_club@private_dance@part2")
    return HANDLER_CONTINUE
  end
  if not streaming.has_anim_dict_loaded("anim@amb@nightclub@lazlow@hi_podium@")then
    streaming.request_anim_dict("anim@amb@nightclub@lazlow@hi_podium@")
    return HANDLER_CONTINUE
  end
  if not streaming.has_anim_dict_loaded("anim@amb@nightclub@lazlow@hi_railing@")then
    streaming.request_anim_dict("anim@amb@nightclub@lazlow@hi_railing@")
    return HANDLER_CONTINUE
  end
  if not streaming.has_anim_dict_loaded("anim@amb@nightclub@mini@dance@dance_solo@female@var_a@")then
    streaming.request_anim_dict("anim@amb@nightclub@mini@dance@dance_solo@female@var_a@")
    return HANDLER_CONTINUE
  end
  if not streaming.has_anim_dict_loaded("anim@amb@nightclub@mini@dance@dance_solo@female@var_b@")then
    streaming.request_anim_dict("anim@amb@nightclub@mini@dance@dance_solo@female@var_b@")
    return HANDLER_CONTINUE
  end
  if not streaming.has_anim_dict_loaded("amb@code_human_on_bike_idles@police@front@idle_a")then
    streaming.request_anim_dict("amb@code_human_on_bike_idles@police@front@idle_a")
    return HANDLER_CONTINUE
  end
  local ran = math.random(30)
  local tempped = player.get_player_ped(player.player_id())
  local pos1 = player.get_player_coords(player.player_id())
  local teleport = false
  menu.notify("Starting dance with ran = " .. ran,"ZeroMenu",5,140)
  if ran == 1 then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_PARTYING",pos1,1,1000000,false,teleport)
  elseif ran == 2  then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_MUSICIAN",pos1,1,1000000,false,teleport)
  elseif ran == 3 then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_PROSTITUTE_HIGH_CLASS",pos1,1,1000000,false,teleport)
  elseif ran == 4      then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_PROSTITUTE_LOW_CLASS",pos1,1,1000000,false,teleport)
  elseif ran == 5    then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_PROSTITUTE_LOW_CLASS",pos1,1,1000000,false,teleport)
  elseif ran == 6     then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_PAPARAZZI",pos1,1,1000000,false,teleport)
  elseif ran == 7      then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_MUSCLE_FLEX",pos1,1,1000000,false,teleport)
  elseif ran == 8   then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_HUMAN_STATUE",pos1,1,1000000,false,teleport)
  elseif ran == 9  then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_DRUG_DEALER_HARD",pos1,1,1000000,false,teleport)
  elseif ran == 10  then
    ai.task_start_scenario_at_position(tempped,"WORLD_HUMAN_DRINKING",pos1,1,1000000,false,teleport)
  elseif ran == 11  then
    ai.task_play_anim(tempped,"amb@code_human_on_bike_idles@police@front@idle_a","idle_a",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 12  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@lazlow@hi_podium@","danceidle_hi_13_crotchgrab_laz",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 13  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@lazlow@hi_podium@","danceidle_hi_11_turnaround_laz",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 14  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@lazlow@hi_podium@","danceidle_hi_17_smackthat_laz",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 15  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@lazlow@hi_podium@","danceidle_hi_17_spiderman_laz",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 16  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@lazlow@hi_railing@","ambclub_09_mi_hi_bellydancer_laz",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 17  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@","high_left_up",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 18  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@","high_center",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 19  then
    ai.task_play_anim(tempped,"@amb@nightclub@mini@dance@dance_solo@female@var_b@","high_center",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 20  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@","med_center",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 21  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@","med_center_down",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 22  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@","med_center",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 23  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@","low_center",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 24  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@","low_center_down",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 25  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@","low_center_up",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 26  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@","high_center_up",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 27  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@","high_center_down",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 28  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@","high_center",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 29  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@male@var_a@","high_center",8.0,8.0,-1,1,0,true,true,true)
  elseif ran == 30  then
    ai.task_play_anim(tempped,"anim@amb@nightclub@mini@dance@dance_solo@male@var_b@","high_center",8.0,8.0,-1,1,0,true,true,true)
  end
end
