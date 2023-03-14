local echo = AchaeaChatTabs.helpers.echo
local aliases = {
  ["act save"] = "saves your config to disk",
  ["act load"] = "loads your config from disk",
  ["act fontSize"] = "set the font size for the consoles",
  ["act font"] = "set the font to use for the consoles",
  ["act blink <true|false>"] = "turn blinking on/off",
  ["act blankLine <true|false>"] = "turn inserting a blank line between messages on/off",
  ["act timestamp <true|false>"] = "turn timestamps on/off",
  ["act show"] = "show AchaeaChatTabs",
  ["act hide"] = "hide AchaeaChatTabs",
  ["act gaglist"] = "prints out the list of gag patterns",
  ["act gag <pattern>"] = "add a gag pattern",
  ["act ungag <pattern>"] = "remove a gag pattern",
  ["act notify <tabName>"] = "turn on OS notifications for tabName. Returns list of tabs when no arguments are provided.",
  ["act unnotify <tabName>"] = "turn off OS notifications for tabName",
  ["act color <option> <value>"] = "used to change the colors for the active/inactive tab, and the background color for the consoles. 'act color' with no options will print out available options",
  ["act update"] = "updates the package to latest version",
  ["act reset|act reset color"] = "resets the chat to defaults/resets chat colors only"
}

echo("\nAvailable aliases for AchaeaChatTabs")
echo()
for name, desc in spairs(aliases) do
  echo(f"* {name}")
  echo(f"  * {desc}")
end
