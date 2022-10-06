local gaggedMobs = AchaeaChatTabs.gaggedMobs
local mob = matches[2]
local echo = AchaeaChatTabs.echo
if not gaggedMobs[mob] then
  echo(f"Mob {mob} is not gagged, so I cannot ungag them.")
  return
end
gaggedMobs[mob] = nil
AchaeaChatTabs.saveGaggedMobs()
echo(f"Mob {mob} removed from the gag list")