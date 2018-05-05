----------------------------------------------------
-- On Screen Keyboard for the awesome window manager
----------------------------------------------------
-- Coded  by: Farhaven  <gbe@ring0.de>
-- Hacked by: Adrian C. <anrxc@sysphere.org>
-- Hacked for Awesome4 by: Chinese_soup <chinese-soup@github.com>
-- Licensed under the WTFPL version 2
--   * http://sam.zoy.org/wtfpl/COPYING
----------------------------------------------------
-- To use this module add:
--     require("osk")
-- to your rc.lua, and call it from a keybinding:
--     osk(position, screen)
--
-- Parameters:
--   position - optional, "bottom" by default
--   screen   - optional, screen.count() by default -- TODO: FIX
----------------------------------------------------

local beautiful = require("beautiful")
local great = require("awful")
local util     = require("awful.util")
local wibox    = require("wibox")
local button   = require("awful.button")
local gears = require("gears")
local table    = table
local wibar = require("awful.wibar")
local widget = require("awful.widget")
local ipairs   = ipairs
local tostring = tostring
local setmetatable = setmetatable
local capi     = {
    widget     = widget,
     screen     = screen,
     fake_input = root.fake_input
 }

module("osk")

kbd = {}
box = wibox() -- FIXME: global, because need to toggle visiblity from the outside FIXME: overcome this somehow?

kbd.codes = {
    q=24,    w=25, e=26, r=27, t=28, z=29, u=30, i=31, o=32,   p=33,  Backspace=22, ["😂"]="😂",
    a=38,    s=39, d=40, f=41, g=42, h=43, j=44, k=45, l=46, ["?"]=59, Return=36,
    Caps=66, y=52, x=53, c=54, v=55, b=56, n=57, m=58, Space=65, Delete=22, ["."]=60,
}

local function create_button_row(...)
    local widgets = { } --layout = wibox.layout.flex.horizontal }
    local arg={...}

    for _,i in ipairs(arg) do
        local emoji = false
        
        if(i:match("😂") ~= nil)  -- TODO,obviously
        then
            emoji = true
        end

        local ww = wibox.widget{
            markup = "<span color='#aaaaaa'>" .. i .. "</span>",
            align  = 'center',
            valign = 'center',
            forced_height = 60,
            font = "Droid Sans Mono Bold 11",
            forced_width = 100,
            widget = wibox.widget.textbox,
        }
        
        local w = wibox.container.background(ww)
        w.shape              = gears.shape.rounded_rect
        w.bg                 = "#0f0f0f"
        
        
        w:buttons(util.table.join(
            button({ }, 1, 
                function()
                    --w:font = "Droid Sans Mono Bold 14"
                    ww.font = "Droid Sans Mono Bold 16"
                    w.bg = "#6f6f6f"

                end,

                function ()
                    ww.font = "Droid Sans Mono Bold 11"
                    w.bg = "#0f0f0f"
                    --w:font = "Droid Sans Mono Bold 11"
                    if(emoji == false)
                    then
                        capi.fake_input("key_press",   kbd.codes[i])
                        capi.fake_input("key_release", kbd.codes[i])
                    else
                        great.util.spawn("xdotool type " .. i ) -- fixme
                        --great.util.spawn("xdotool type asdf")
                   end

                end)
            
        ))

        table.insert(widgets, w)
    end

    return widgets
end

setmetatable(_M, { __call = function (_, pos, scr, height)
    if not kbd.init then
        local l = wibox.widget {
            homogeneous   = true,
            spacing       = 3,
            min_cols_size = 10,
            min_rows_size = 3,
            layout        = wibox.layout.grid, 
        }
        
        local table1 = create_button_row("q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "Backspace", "😂")
        local table2 = create_button_row("a", "s", "d", "f", "g", "h", "j", "k", "l", ":", "?", "Return") 
        local table3 = create_button_row("Caps", "y", "x", "c", "Space", "v", "b", "n", "m", ".")
            
        for _,i in ipairs(table1) do
            --great.util.spawn("notify-send 'mrdka" .. _ .. "'")
            l:add_widget_at(table1[_], 1, _, 0, 0)
        end
        
        for _,i in ipairs(table2) do
            --great.util.spawn("notify-send 'mrdka" .. _ .. "'")
            l:add_widget_at(table2[_], 2, _, 0, 0)
        end
        
        for _,i in ipairs(table3) do
            --great.util.spawn("notify-send 'mrdka" .. _ .. "'")
            l:add_widget_at(table3[_], 3, _, 0, 0)
        end
<<<<<<< HEAD
        box = wibar({height = height, position = pos, screen = scr, widget = l})
=======
        box = wibar({height = 300, position = pos, screen = scr, widget = l})
>>>>>>> fc35aaf18acb499ff4891ed54d1e63fb44b9ff92
        

        kbd.init = true
        box.visible = false
    end

    box.visible = not box.visible
end })


