-- run this command to have hammerspoon in .config folder (default is ~/.hammerspoon)
-- defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

-- this will add a `clear` command to hammerspoon console, so i don't have to type `hs.console.clearConsole()`
clear = hs.console.clearConsole

require("mouse-gesture")
-- this doesn't actually work well, so I just use karabiner
-- require("remap-dragging")

-- this is same as hs.alert.show
hs.alert("Reloaded")
