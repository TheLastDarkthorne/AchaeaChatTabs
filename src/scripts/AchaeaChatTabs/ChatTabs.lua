local EMCO = require("AchaeaChatTabs.emco")
AchaeaChatTabs = AchaeaChatTabs or {}
local default_constraints = {name = "AchaeaChatTabsContainer", x = "-25%", y = "-60%", width = "25%", height = "60%", attached = "right"}
AchaeaChatTabs.emcoContainer = AchaeaChatTabs.emcoContainer or Adjustable.Container:new(default_constraints)
AchaeaChatTabs.chatEMCO = AchaeaChatTabs.chatEMCO or EMCO:new({
  name = "AchaeaChat",
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
  commandLine = true,
}, AchaeaChatTabs.emcoContainer)
local chatEMCO = AchaeaChatTabs.chatEMCO
local filename = getMudletHomeDir() .. "/EMCO/AchaeaChat.lua"
if io.exists(filename) then
  chatEMCO:load()
end
chatEMCO:replayAll(10)
function AchaeaChatTabs.echo(msg)
  msg = msg or ""
  cecho(f"<green>AchaeaChatTabs: <reset>{msg}\n")
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
end

function AchaeaChatTabs.save()
  chatEMCO:save()
  AchaeaChatTabs.saveGaggedMobs()
end

local channelToTab = {
  ct = "City",
  ht = "House",
  hnt = "House",
  gt = "Group",
  tell = "Tells",
  says = "Local",
  emotes = "Local",
  ot = "Order",
  ft = "Misc",
  newbie = "Misc",
  market = "Misc",
}

local function addNDBdecho(txt)
  if svo then ndb = svo.ndb end
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
      txt = txt:gsub(name, color .. name .. format)
      done[name] = true
    end
  end
  return txt
end

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
