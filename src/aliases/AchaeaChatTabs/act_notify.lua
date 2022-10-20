if not matches[2] then
  cecho("\n<green>AchaeaChatTabs: <grey>Tabs that currently have OS notification on are:")
  for k,v in pairs(AchaeaChatTabs.chatEMCO.notifyTabs) do
    cecho("\n<white>" .. k)
  end
end

local tabName = matches[2]:title()
local echo = AchaeaChatTabs.echo
local ok = AchaeaChatTabs.chatEMCO:addNotifyTab(tabName)

if ok then
  echo(f"Enabled OS notifications for tab {tabName}")
elseif ok == false then
  echo(f"Tab {tabName} already had notifications enabled!")
else
  echo(f"Tab {tabName} does not exist")
end