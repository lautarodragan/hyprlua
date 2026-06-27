# hyprlua

Some handy functions you can use from Hyprland's lua config.

## How?

1. Clone this repo somewhere. For example: `~/lualibs/hyprlua`.
2. Import it in Hyprland's lua conig: `package.path = package.path .. ";~/lualibs/?.lua"`
3. Call the functions like so:

```lua
-- in a mods.lua file

local mods = {}

mods.mod1 = "SUPER"
mods.mod2 = "MOD3"

return mods

-- in your binds.lua file (or hyprland.lua, or wherever you define your binds) 

hl.bind(mods.mod2 .. " + KP_End",  functions.dps.toggle('decoration', 'blur'))
hl.bind(mods.mod2 .. " + KP_Down", functions.dps.toggle('decoration', 'shadow'))
hl.bind(mods.mod2 .. " + KP_Next", functions.dps.toggle('decoration', 'glow'))

hl.bind(mods.mod1 .. " + F1", functions.set_active_workspace_layout("scrolling"))
hl.bind(mods.mod1 .. " + F2", functions.set_active_workspace_layout("dwindle"))
hl.bind(mods.mod1 .. " + F3", functions.set_active_workspace_layout("monocle"))

hl.bind(mods.mod1 .. " + Tab",  functions.next_window_in_ws)
hl.bind(mods.mod1 .. " + Home", functions.focus_first_window_in_ws)

hl.bind(mods.mod1 .. " + Z", functions.zoom_next)

hl.bind(mods.mod1 .. " + KP_Add",      functions.resize_window(.1),  { repeating = true })
hl.bind(mods.mod1 .. " + KP_Subtract", functions.resize_window(-.1), { repeating = true })
```
