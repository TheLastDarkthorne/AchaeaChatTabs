local echo = AchaeaChatTabs.helpers.echo
if matches[2] then
  AchaeaChatTabs.resetChat(true)
  echo("Chat colors reset!")
else
  AchaeaChatTabs.resetChat()
  echo("Chat reset!")
end