

function createConfigedMenuOption(name,type,parent,script_function,config,configValueName,defaultValue,defaultValueMax)
  local feature = menu.add_feature(name,type,parent,script_function)  
  config:saveIfNotExist(configValueName,defaultValue)
  if type == "toggle" then
    if config:isFeatureEnabled(configValueName) then
      feature.on = true
    end
  elseif type == "autoaction_value_i" then
    config:saveIfNotExist(configValueName.."_max",defaultValue)  
    feature.max_i = tonumber(config:getValue(configValueName.."_max"))
    feature.value_i = tonumber(config:getValue(configValueName))
  end
  return feature;
end


function isPlayerModder(playerName)
  if player.is_player_modder(playerName,eModderDetectionFlags.MDF_MANUAL) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_PLAYER_MODEL) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_SCID_0) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_SCID_SPOOF) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_INVALID_OBJECT_CRASH) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_INVALID_PED_CRASH) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_CLONE_SPAWN) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_PLAYER_MODEL) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_MANUAL) or
     player.is_player_modder(playerName,eModderDetectionFlags.MDF_PLAYER_MODEL) then      
      return true
   end 
   return false
end

function starts_with(str, start)
   return str:sub(1, #start) == start
end