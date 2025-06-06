local EMCO = require("AchaeaChatTabs.emco")
AchaeaChatTabs = AchaeaChatTabs or {}
AchaeaChatTabs.helpers = AchaeaChatTabs.helpers or {}
local defaultConfig = {activeColor = "green", inactiveColor = "rgb(60,60,60)", activeBorder = "rgb(0,180,0)", activeText = "yellow", inactiveText = "white", background = "black", windowBorder = "green"}
AchaeaChatTabs.config = AchaeaChatTabs.config or defaultConfig
local default_constraints = {name = "AchaeaChatTabsContainer", x = "-25%", y = "-60%", width = "25%", height = "60%", attached = "right"}
local baseStyle = Geyser.StyleSheet:new(f [[
  border-width: 2px; 
  border-style: solid; 
]])
local activeStyle = Geyser.StyleSheet:new(f [[
  border-color: {AchaeaChatTabs.config.activeBorder};
  background-color: {AchaeaChatTabs.config.activeColor};
]], baseStyle)
local inactiveStyle = Geyser.StyleSheet:new(f [[
  border-color: {AchaeaChatTabs.config.inactiveColor};
  background-color: {AchaeaChatTabs.config.inactiveColor};
]], baseStyle)
local adjLabelStyle = Geyser.StyleSheet:new(f[[
  background-color: rgba(0,0,0,100%);
  border: 4px double;
  border-color: {AchaeaChatTabs.config.windowBorder};
  border-radius: 4px;]])

function AchaeaChatTabs.createChat()
  AchaeaChatTabs.emcoContainer = AchaeaChatTabs.emcoContainer or Adjustable.Container:new(default_constraints)
  AchaeaChatTabs.chatEMCO = AchaeaChatTabs.chatEMCO or EMCO:new({
    name = "AchaeaChat",
    title = "AchaeaChat",
    x = 0,
    y = 0,
    height = "100%",
    width = "100%",
    consoles = {"All", "Local", "City", "House", "Tells", "Group", "Order", "Clans", "Misc"},
    allTab = true,
    allTabName = "All",
    blankLine = true,
    blink = true,
    bufferSize = 10000,
    deleteLines = 500,
    timestamp = true,
    fontSize = 12,
    font = "Ubuntu Mono",
    consoleColor = AchaeaChatTabs.config.background,
    activeTabCSS = activeStyle:getCSS(),
    inactiveTabCSS = inactiveStyle:getCSS(),
    activeTabFGColor = AchaeaChatTabs.config.activeText,
    activeTabBGColor = AchaeaChatTabs.config.activeColor,
    inactiveTabFGColor = AchaeaChatTabs.config.inactiveText,
    commandLine = false,
  }, AchaeaChatTabs.emcoContainer)
end
AchaeaChatTabs.createChat()

function AchaeaChatTabs.resetChat(onlycolors)
  if onlycolors == true then
    AchaeaChatTabs.config = defaultConfig
    AchaeaChatTabs.helpers.retheme()
  else
    AchaeaChatTabs.chatEMCO = nil
    AchaeaChatTabs.emcoContainer = nil
    AchaeaChatTabs.config = defaultConfig
    AchaeaChatTabs.createChat()
    AchaeaChatTabs.helpers.retheme()
    AchaeaChatTabs.emcoContainer:unlockContainer()
  end
end

local chatEMCO = AchaeaChatTabs.chatEMCO
local filename = getMudletHomeDir() .. "/EMCO/AchaeaChat.lua"
local confFile = getMudletHomeDir() .. "/EMCO/AchaeaChatOptions.lua"

--[[
if io.exists(filename) then
  chatEMCO:load()
end
if io.exists(confFile) then
  AchaeaChatTabs.emcoContainer:load()
end
]]

chatEMCO:replayAll(10)
function AchaeaChatTabs.echo(msg)
  msg = msg or ""
  cecho(f"<green>AchaeaChatTabs: <reset>{msg}\n")
end

function AchaeaChatTabs.helpers.retheme()
  activeStyle:set("background-color", AchaeaChatTabs.config.activeColor)
  activeStyle:set("border-color", AchaeaChatTabs.config.activeBorder)
  inactiveStyle:set("background-color", AchaeaChatTabs.config.inactiveColor)
  inactiveStyle:set("border-color", AchaeaChatTabs.config.inactiveColor)
  adjLabelStyle:set("border-color", AchaeaChatTabs.config.windowBorder)
  local als = adjLabelStyle:getCSS()
  AchaeaChatTabs.emcoContainer.adjLabelstyle = als
  AchaeaChatTabs.emcoContainer.adjLabel:setStyleSheet(als)
  chatEMCO.activeTabCSS = activeStyle:getCSS()
  chatEMCO.inactiveTabCSS = inactiveStyle:getCSS()
  chatEMCO:setActiveTabFGColor(AchaeaChatTabs.config.activeText)
  chatEMCO:setInactiveTabFGColor(AchaeaChatTabs.config.inactiveText)
  chatEMCO:setConsoleColor(AchaeaChatTabs.config.background)
  chatEMCO:adjustTabBackgrounds()
  chatEMCO:switchTab(chatEMCO.currentTab)
  --AchaeaChatTabs.chatEMCO = nil
  AchaeaChatTabs.createChat()
end

function AchaeaChatTabs.helpers.setConfig(cfg, val)
  local validOptions = table.keys(AchaeaChatTabs.config)
  if not table.contains(validOptions, cfg) then
    return nil, f"invalid option: valid options are {table.concat(validOptions, ', ')}"
  end
  AchaeaChatTabs.config[cfg] = val
  AchaeaChatTabs.helpers.retheme()
  return true
end

function AchaeaChatTabs.helpers.echo(msg)
  msg = msg or ""
  cecho(f "<green>AchaeaChatTabs: <reset>{msg}\n")
end

AchaeaChatTabs.gaggedMobs = {}
local gaggedMobFile = getMudletHomeDir() .. "/AchaeaChatGaggedMobs.lua"
if io.exists(gaggedMobFile) then
  table.load(gaggedMobFile, AchaeaChatTabs.gaggedMobs)
end

function AchaeaChatTabs.loadGaggedMobs()
  if io.exists(gaggedMobFile) then
    table.load(gaggedMobFile, AchaeaChatTabs.gaggedMobs)
  end
end

function AchaeaChatTabs.saveGaggedMobs()
  table.save(gaggedMobFile, AchaeaChatTabs.gaggedMobs)
end

function AchaeaChatTabs.load()
  AchaeaChatTabs.loadGaggedMobs()
  if io.exists(filename) then
    chatEMCO:load()
  end
  if io.exists(confFile) then
    local conf = {}
    table.load(confFile, conf)
    AchaeaChatTabs.config = table.update(AchaeaChatTabs.config, conf)
  end
  --[[
  if io.exists(filename) then
    chatEMCO:hide()
    chatEMCO:load()
    chatEMCO:show()
  end
  ]]
  AchaeaChatTabs.emcoContainer:load()
  AchaeaChatTabs.helpers.retheme()
end

function AchaeaChatTabs.save()
  chatEMCO:save()
  AchaeaChatTabs.saveGaggedMobs()
  table.save(confFile, AchaeaChatTabs.config)
  AchaeaChatTabs.emcoContainer:save()
end

local channelToTab = {
  ct = "City",
  armytell = "City",
  ht = "House",
  hnt = "House",
  gt = "Group",
  party = "Group",
  intrepid = "Group",
  tell = "Tells",
  says = "Local",
  emotes = "Local",
  ot = "Order",
  newbie = "Misc",
  deathsight = "Misc",
  shouts = "Misc",
  market = "Misc"
}

local function addNDBdecho(txt)
  local format = string.match(txt, "<%d+.->")
  local names = ndb.findnames(txt)
  if not names then
    return txt
  end
  local done = {}
  for _, name in pairs(names) do
    if not done[name] then
      local color = ndb.getcolor(name) or "<white>"
      color = color:gsub("<", "")
      color = color:gsub(">", "")
      if color == "" then -- they're a rogue, most likely, since the ndb has the name but returned "" as the color
        debugc("AchaeaChatTabs got '' from ndb.getcolor for " .. name .. ". We are assuming they are rogue and looking up the correct color in ndb.conf or mm.conf. If it can't find either it will fallback to white")
        color = ndb.roguescolor
        color = color or (mm and mm.conf and mm.conf.roguescolor)
        color = color or "white"
      end
      color = string.format("<%d,%d,%d>", unpack(color_table[color]))
      if format then
        txt = txt:gsub(name, color .. name .. format)
      else
        txt = txt:gsub(name, color .. name .. string.format("<%d,%d,%d>", unpack(color_table["grey"])))
      end
      done[name] = true
    end
  end
  return txt
end

AchaeaChatTabs.addNDBdecho = addNDBdecho

local function chatCapture()
  local info = gmcp.Comm.Channel.Text
  local gaggedMobs = AchaeaChatTabs.gaggedMobs
  local talker = info.talker
  if gaggedMobs[talker] then
    return
  end
  for pattern,_ in pairs(gaggedMobs) do
    if talker:match(pattern) then
      return
    end
  end
  local channel = "Misc"
  if info.channel:starts("tell ") then
    channel = "Tells"
  end
  if info.channel:match("clt") then
    channel = "Clans"
  end
  if channelToTab[info.channel] then
    channel = channelToTab[info.channel]
  end
  local txt = ansi2decho(info.text)
  txt = txt:gsub(string.char(27) .. [[.-]] .. string.char(4), "")
  if ndb then
    txt = addNDBdecho(txt)
  end
  chatEMCO:decho(channel, txt)
end

if AchaeaChatTabs.chatCaptureEventID then
  killAnonymousEventHandler(AchaeaChatTabs.chatCaptureEventID)
end
AchaeaChatTabs.chatCaptureEventID = registerAnonymousEventHandler("gmcp.Comm.Channel.Text", chatCapture)

local function startGMCPChat()
  cecho("<green>AchaeaChatTabs:<reset> Turning on GMCP comm channels\n")
  sendGMCP([[Core.Supports.Add ["Comm.Channel 1"] ]])
end

if not AchaeaChatTabs.loginHandler then
  AchaeaChatTabs.loginHandler = registerAnonymousEventHandler("gmcp.Char.Name", startGMCPChat)
end

if not AchaeaChatTabs.loadHandler then
  AchaeaChatTabs.loadHandler = registerAnonymousEventHandler("sysLoadEvent", AchaeaChatTabs.load)
end