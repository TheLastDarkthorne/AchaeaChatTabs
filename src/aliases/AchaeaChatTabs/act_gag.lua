local success = AchaeaChatTabs.chatEMCO:addGag(matches[2])
local echo = AchaeaChatTabs.echo
if success then
  echo(f"Successfully added '{matches[2]}' as a gag pattern")
  return
end
echo(f"Unable to add '{matches[2]}' as a gag pattern, this is usually because it's already added.")