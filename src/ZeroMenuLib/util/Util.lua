util = {}
util.__index = util

local eModderDetectionFlags = require("ZeroMenuLib/enums/ModderDetectionFlag")

function util:createConfigedMenuOption(name,type,parent,script_function,config,configValueName,defaultValue,defaultValueMax)

  local feature = menu.add_feature(name,type,parent,script_function)    
  config:saveIfNotExist(configValueName,defaultValue)
  config:registerConfigedFunction(configValueName,feature,type)
  if type == "toggle" then
    if config:isFeatureEnabled(configValueName) then
      feature.on = true
    end
  elseif type == "autoaction_value_i" then
    config:saveIfNotExist(configValueName.."_max",defaultValue)  
    feature.max = tonumber(config:getValue(configValueName.."_max"))
    feature.value = tonumber(config:getValue(configValueName))
  end
  return feature;
end


function util:isPlayerModder(slot)
  return player.get_player_modder_flags(slot) ~= 0
end

function util:starts_with(str, start)
   return str:sub(1, #start) == start
end

function util:getSlotFromName(name)
  for slot = 0, 31 do
    if player.is_player_valid(slot) then
      local tempName = player.get_player_name(slot)
      if starts_with(tempName,name) then
        return slot
      end
    end
  end
  return nil
end

function util:dirVector(p45, h45, d)
  h45 = math.rad((h45 - 180) * -1)
  p45.x = p45.x + (math.sin(h45) * -d)
  p45.y = p45.y + (math.cos(h45) * -d)
  return p45
end

function util:formatIP(ip)
  return string.format("%i.%i.%i.%i", (ip >> 24) & 0xff, ((ip >> 16) & 0xff), ((ip >> 8) & 0xff), ip & 0xff)
end

function util:calculateDistanceMovedBetweenCoords(oldCord,newCord)

  local difX = (newCord['x'] - oldCord['x'])^2
  local difY = (newCord['y'] - oldCord['y'])^2
  local difZ = (newCord['z'] - oldCord['z'])^2
  local distance = math.sqrt(difX + difY + difZ)  
  return distance
end
-- Dont call this repeated (slow)
-- store the value
function util:getPlayerMoney(slot)
  return script.get_global_i(1853131   + (1 + (slot * 888)) + 205 + 56)
end

function util:getKDOf(slot) 
  return script.get_global_f(1853131  + (1 + (slot * 888)) + 205 + 26)
end

function util:splitStringAt(str,pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t, cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end


function util:stringToBoolean(value)
  if line == 'true' then
    return true
  else
    return false
  end
end

function util:isModelAnimal(model) 
  if model == 0xCE5FF074 then    
    --Boar
    return true
  elseif model == 0x573201B8 then
    --Cat
    return true
  elseif model == 0xAAB71F62 then
    --ChickenHawk
    return true
  elseif model == 0xA8683715 then
    --Chimp
    return true
  elseif model == 351016938 then
    --Chop
    return true
  elseif model == 0x56E29962 then
    --Cormorant
    return true
  elseif model == 0xFCFA9E1E then
    --Cow
    return true
  elseif model == 0x644AC75E then
    --Coyote
    return true
  elseif model == 0x18012A9F then
    --Crow
    return true
  elseif model == 0xD86B5A95 then
    --Deer
    return true
  elseif model == 0x8BBAB455 then
    --Dolphin
    return true
  elseif model == 0x2FD800B7 then
    --Fish
    return true
  elseif model == 0x6AF51FAF then
    --Hen
    return true
  elseif model == 0x471BE4B2 then
    --Humpback
    return true
  elseif model == 1318032802 then
    --Husky
    return true
  elseif model == 0x8D8AC8B9 then
    --KillerWhale
    return true
  elseif model == 0x1250D7BA then
    --MountainLion
    return true
  elseif model == 0xB11BAB56 then
    --Pig
    return true
  elseif model == 0x06A20728 then
    --Pigeon
    return true
  elseif model == 0x431D501C then
    --Poodle
    return true
  elseif model == 0x6D362854 then
    --Pug
    return true
  elseif model == 0xDFB55C81 then
    --Rabbit
    return true
  elseif model == 0xC3B52966 then
    --Rat
    return true
  elseif model == 0x349F33E1 then
    --Retriever
    return true
  elseif model == 0xC2D06F53 then
    --Rhesus
    return true
  elseif model == 0x9563221D then
    --Rottweiler
    return true
  elseif model == 0xD3939DFD then
    --Seagull
    return true
  elseif model == 0x3C831724 then
    --HammerShark
    return true
  elseif model == 0x06C3F072 then
    --TigerShark
    return true
  elseif model == 0x431FC24C then
    --Shepherd
    return true
  elseif model == 0xA148614D then
    --Stingray
    return true
  elseif model == 0xAD7844BB then
    --Westy
    return true
  end  
  return false
end

function util:set_proofs(ped, bullet, fire, explosion, collision,melee, steam, drown)
    return native.call(0xFAEE099C6F890BB8, ped, bullet, fire, explosion, collision, melee, steam, 1, drown)
end
function util:set_visible(ped, toggle)
    return native.call(0xEA1C610A04DB6BBB, ped, toggle, 0)
end

function util:set_still(ped,time)
  return native.call(0x919BE13EED931959,ped,time)
end

function util:SET_VEHICLE_SIREN(veh, active)
  return native.call(0xF4924635A19EB37D,veh,active)
end
function util:SET_VEHICLE_HAS_MUTED_SIRENS(veh, active)
  return native.call(0xD8050E0EB60CF274,veh,active)
end



return util