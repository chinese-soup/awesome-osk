# awesome-osk
On-screen keyboard for Awesome 4.2+

# Why
I've recently bought myself a ThinkPad X230 and accidentally it was the touch model.
Since I use awesome wm I've looked around for some on screen keyboards, but most of them didn't cut it for me (focus losing etc. and laziness of setting it up properly).
I thought about a native OSK inside the wm, so I fired up google and found [this osk for awesome 3.x](https://github.com/sigma/awesome-configs/blob/master/osk.lua).
To nobody's surprise it didn't work on awesome 4 initially, so decided to hack it up and fix it so it works on Awesome 4 and make it a bit more easily customizable.

# Disclaimer
The code is pretty bad, as I started out with some actual Lua coding with this project and I am bad at coding in general.
Feel free to send PRs, pro-tips & complains.

# How to install
* Put osk.lua to ~/.config/awesome
* Add these lines to theme.lua 
```
local osk = require("osk")
osk()
osk.box.visible = false -- if you want to hide the keyboard on start up
-- TODO: Add widget switcher & keyboard shortcut code
```

# COPYING
```
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.

```
