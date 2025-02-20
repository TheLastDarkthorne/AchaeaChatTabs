local lecho = AchaeaChatTabs.echo
local valid_options = {"font", "fontSize", "blink", "blankLine", "timestamp", "save", "load", "show", "hide", "commandLine"}
local valid_options_string = table.concat(valid_options)
local option = matches[2]
local value = matches[3]
if not table.contains(valid_options, option) then
  lecho("Tried to change a config value that does not exist: valid options are " .. valid_options_string)
  return
end
local chatEMCO = AchaeaChatTabs.chatEMCO
local EMCO = require("AchaeaChatTabs.emco")
local gaggedMobFile = getMudletHomeDir() .. "AchaeaChatGaggedMobs.lua"
if option == "save" then
  AchaeaChatTabs.save()
  lecho("Options saved")
elseif option == "load" then
  AchaeaChatTabs.load()
  lecho("Options loaded")
elseif option == "show" then
  AchaeaChatTabs.emcoContainer:show()
elseif option == "hide" then
  AchaeaChatTabs.emcoContainer:hide()
else
  if value == nil then
    lecho("You need to provide a value when trying to configure things")
    return
  end
  if option == "font" then
    local validFont = table.contains(getAvailableFonts(), value)
    if not validFont then
      lecho("You tried to set the font to one that Mudlet doesn't recognize. This will not do.")
    else
      chatEMCO:setFont(value)
    end
  elseif table.contains({"blink", "blankLine", "timestamp", "commandLine"}, option) then
    value = EMCO:fuzzyBoolean(value)
    if value then
      if option == "timestamp" then
        chatEMCO:enableTimestamp()
      elseif option == "blankLine" then
        chatEMCO:enableBlankLine()
      elseif option == "blink" then
        chatEMCO:enableBlink()
      elseif option == "commandLine" then
        chatEMCO:enableAllCmdLines()
      end
    else
      if option == "timestamp" then
        chatEMCO:disableTimestamp()
      elseif option == "blankLine" then
        chatEMCO:disableBlankLine()
      elseif option == "blink" then
        chatEMCO:disableBlink()
      elseif option == "commandLine" then
        chatEMCO:disableAllCmdLines()
      end
    end
  else
    value = tonumber(value)
    if value then
      chatEMCO:setFontSize(value)
    else
      lecho("You tried to set the fontSize to a nonnumber. Attempted: " .. matches[3])
    end
  end
end
