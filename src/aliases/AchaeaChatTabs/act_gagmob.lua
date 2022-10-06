local gaggedMobs = AchaeaChatTabs.gaggedMobs
local mob = matches[2]
local echo = AchaeaChatTabs.echo
if gaggedMobs[mob] then
  echo(f"Mob {mob} is already gagged")
  return
end
gaggedMobs[mob] = true
AchaeaChatTabs.saveGaggedMobs()
echo(f"Mob {mob} added to the gag list")