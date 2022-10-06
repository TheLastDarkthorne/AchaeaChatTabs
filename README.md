# Achaea Chat Tabs

Set of chat tabs similarly laid out to KaiUI, but using my latest version of EMCO which provides for automatic logging among other things, and not part of an all or nothing UI.

By default, the logs are kept in `getMudletHomeDir() .. "/log/Chatbox/YYYY/MM/DD/tabname.html"`

Will start on the right side, attached to the right border. Resize, move, adjust how you see fit.

## Configuration Alias

* `act hide`
  * hides the chat tabs
* `act show`
  * shows the chat tabs again.
* `act save`
  * saves the configuration
* `act load`
  * loads the configuration
* `act font <new font name>`
  * Sets the font for the chat consoles. Will not allow you to set one which does not exist.
* `act fontSize <new font size>`
  * Sets the font size for the chat consoles
* `act blink <true|false>`
  * set whether it should blink
* `act timestamp <true|false>`
  * set whether it should add a timestamp at the front
* `act blankLine`
  * set whether it should automatically add a newline to things echoed.
* `act gaglist`
  * lists the mobs and lines being gagged in the chat tabs.
* `act gagmob <Lua pattern>`
  * add a Lua pattern to check speakers against. See [this tutorial from lua-users.org](http://lua-users.org/wiki/PatternsTutorial) for more information. If the speaker matches the pattern, anything they say or emote on any channel will be gagged from the tabbed chat consoles. Does not affect the main window. Uses gmcp.Comm.Channel.Text.talker to make the determination.
    * `act gagmob Vellis`
      * gags any mob with "Vellis" in the speaker name in gmcp.
    * `act gagmob a sick .+ child`
      * gags `a sick human child` and `a sick tsol child` and `a sick mhun child` etc
* `act ungagmob <Lua pattern>`
  * Removes a lua pattern from the gagged mobs list.
* `act gag <Lua pattern>`
  * add a Lua pattern to check lines against. See [this tutorial from lua-users.org](http://lua-users.org/wiki/PatternsTutorial) for more information. If the content of the line matches any of the patterns then the line will be gagged from the tabbed chat consoles. Does not affect the main window.
    * `act gag .- shouts "I love cheese!"`
      * will gag anyone shouting "I love cheese!"
* `act ungag <Lua pattern>`
  * removes a lua pattern from the gagged lines list.
* `act notify <tab name>`
  * will send OS notifications when somethings is written to the tab specified
    * `act notify guild`
      * sends OS notifications whenever something comes in on the Guild tab
* `act unnotify <tab name>`
  * Stop sending OS notifications for a tab
   * `act unnotify house`
    * stop sending OS notifications when something comes in on the House tab
