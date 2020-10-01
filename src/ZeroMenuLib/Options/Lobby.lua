require("ZeroMenuLib/Util/Util")

local modders = {}
local modderFilePath = os.getenv("APPDATA") .. "\\PopstarDevs\\2Take1Menu\\scripts\\ZeroMenuLib\\data\\modders.csv"

local logModderOption,warnOfLoadedModdersOption

function createLobbyOptions(parent,config)
  if not utils.file_exists(modderFilePath) then
      local file = io.open(modderFilePath, "a")
      file:write("date,scid,name,reason,ip\n")
      file:close()
    end    
    local LobbyParent = menu.add_feature("Lobby","parent",parent.id,nil)    
    --createConfigedMenuOption(name,type,parent,script_function,config,configValueName,defaultValue,defaultValueMax)
    logModderOption = createConfigedMenuOption("Log Modder","toggle",LobbyParent.id,logModders,config,"logModder",false,nil)    
    warnOfLoadedModdersOption = createConfigedMenuOption("Info about known Modders","toggle",LobbyParent.id,infoModders,config,"infoModder",false,nil)    
end

function logModders()
  for slot = 0, 31 do
    if player.is_player_valid(slot) then      
      if isPlayerModder(slot) and modders[player.get_player_name(slot)] == nil then
        storeModder(slot)     
        modders[player.get_player_name(slot)] = 1
      elseif modders[player.get_player_name(slot)] ~= nil and warnOfLoadedModdersOption.on then
        local modderData = modders[player.get_player_name(slot)]
        ui.notify_above_map(player.get_player_name(slot) .. " is a known Modder for " .. modderData["reason"] .. " (" .. modderData["date"] .. ")" ,"ZeroMenu",140)
        if player.get_player_scid(slot) ~= modderData["scid"] then
          ui.notify_above_map("Scid missmatch " .. player.get_player_name(slot) .. " had scid " .. modderData["scid"] .. " but now he has " .. player.get_player_scid(slot),"ZeroMenu",140)
        end
      end    
    end
  end
  if logModderOption.on then
      return HANDLER_CONTINUE
    else
      return HANDLER_POP
    end
end

function loadModderFile()
  if utils.file_exists(modderFilePath)then      
      local file = io.open(modderFilePath, "r")
      for line in io.lines(file) do 
        --if not tostring(line:sub(1,1)) == '#' then
        if not starts_with(line,'#') then
          for date, scid,name,reason in string.gmatch(line, "(%w+),(%w+)") do
            print("readed modder " .. name .. " (" .. scid  ..") marked for " .. reason .. " on " .. date .. " with ip " .. ip)
            local modderDataTable = {}
            modderDataTable["date"] = date
            modderDataTable["name"] = name
            modderDataTable["scid"] = scid
            modderDataTable["reason"] = reason
            modderDataTable["ip"] = ip
            modders[name] = modderDataTable
          end
        end     
      end    
      file:close()
    else
      return false
    end
end

function storeModder(slot)
  local file = io.open(modderFilePath, "a")
  file:write(
    os.date("[%d/%m/%Y %H:%M:%S]") .. 
      ", " .. player.get_player_scid(slot) .. 
      "," .. player.get_player_name(slot) .. 
      "," .. player.get_player_modder_flags(slot) .. "," .. player.get_player_ip(slot) .. "\n")
    file:close()  
end