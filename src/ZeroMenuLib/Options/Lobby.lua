require("ZeroMenuLib/Util/Util")

local modders = {}
local modderFilePath = os.getenv("APPDATA") .. "\\PopstarDevs\\2Take1Menu\\scripts\\ZeroMenuLib\\data\\modders.csv"

local logModderOption,warnOfLoadedModdersOption

function createLobbyOptions(parent,config)
  if not utils.file_exists(path) then
      file = io.open(path, "a")
      file:write("#Created using 1337Zeros config.lua\n")
      file:write("date,scid,name,reason\n")
      file:close()
    end    
    local LobbyParent = menu.add_feature("Lobby","parent",parent.id,nil)    
    --createConfigedMenuOption(name,type,parent,script_function,config,configValueName,defaultValue,defaultValueMax)
    logModderOption = createConfigedMenuOption("Log Modder","toggle",LobbyParent.id,logModders,config,"logModder",false,nil)    
    warnOfLoadedModdersOption = createConfigedMenuOption("Info about known Modders","toggle",LobbyParent.id,infoModders,config,"infoModder",false,nil)    
end


function logModders()
  for slot = 0, 31 do
    if player.is_player_valid(i) then      
      if isPlayerModder(i) and modders[player.get_player_name(i)] == nil then
        storeModder(i)      
      elseif modders[player.get_player_name(i)] ~= nil and warnOfLoadedModdersOption.on then
        local modderData = modders[player.get_player_name(i)]
        ui.notify_above_map(player.get_player_name(i) .. " is a known Modder for " .. modderData["reason"] .. " (" .. modderData["date"] .. ")" ,"ZeroMenu",140)
        if player.get_player_scid(i) ~= modderData["scid"] then
          ui.notify_above_map("Scid missmatch " .. player.get_player_name(i) .. " had scid " .. modderData["scid"] .. " but now he has " .. player.get_player_scid(i),"ZeroMenu",140)
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
      file = io.open(path, "r")
      for line in io.lines(file) do 
        --if not tostring(line:sub(1,1)) == '#' then
        if not starts_with(line,'#') then
          for date, scid,name,reason in string.gmatch(line, "(%w+),(%w+)") do
            print("readed modder " .. name .. " (" .. scid  ..") marked for " .. reason .. " on " .. date )
            local modderDataTable = {}
            modderDataTable["date"] = date
            modderDataTable["name"] = name
            modderDataTable["scid"] = scid
            modderDataTable["reason"] = reason
            modders[name] = modderDataTable
          end
        end     
      end    
    else
      return false
    end
end

function storeModder(slot)
  file = io.open(modderFilePath, "a")
  file:write(os.date("[%d/%m/%Y %H:%M:%S]") .. ", " .. player.get_player_scid(slot) .. "," .. player.get_player_name(slot) .. "," .. player.get_player_modder_flags(slot) "\n")
  file:close()  
end