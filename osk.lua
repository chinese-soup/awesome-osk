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
--     osk(position, screen, height)
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

kbd.modifiers = {}

kbd.codes = {
    q=24,  w=25, e=26, r=27, t=28, z=29, u=30, i=31, o=32,   p=33,  ["⌫"]=22, ["Alt"]=64, ["Mod4"]=133, ["Control"]=37, ["Alt"]=64, 
    a=38,  s=39, d=40, f=41, g=42, h=43, j=44, k=45, l=46, ["?"]=59, Return=36,
    Caps=66, y=52, x=53, c=54, v=55, b=56, n=57, m=58, Space=65, Delete=22, ["."]=60, ["Up"]=22,
}

local function create_button_row(...)
    local widgets = { } 
    local arg={...}

    for _,i in ipairs(arg) do
        local is_emoji = false
        local modifier = ""
        
        if(i[1] ~= nil) -- if the argument is a table and not a string
        then
            if(i[2] == "emoji") -- if the argument has emoji flag as table[2]
            then
                is_emoji = true
                i = i[1]
            elseif(i[2] == "modifier")
            then
                modifier = i[1]
                i = i[1]
                
            end
        end
            
        local ww = wibox.widget{
            markup = "<span color='#aaaaaa'>" .. i .. "</span>",
            align  = 'center',
            valign = 'center',
            forced_height = 60,
            font = "Droid Sans Mono Bold 11",
            forced_width = 80, 
            widget = wibox.widget.textbox,
        }
        
        local w = wibox.container.background(ww)
        w.shape              = gears.shape.rounded_rect
        w.bg                 = "#0f0f0f"
        
        
        w:buttons(util.table.join(
            button({ }, 1, 
                function()
                    ww.font = "Droid Sans Mono Bold 16"
                    w.bg = "#6f6f6f"

                end,

                function ()
                    gears.debug.dump(kbd.modifiers)

                    if(modifier == "Control" or modifier == "Alt" or modifier == "Mod4") 
                    then
                        table.insert(kbd.modifiers, modifier)
                        --great.key.execute({modifiers}, "w")
                        --capi.fake_input("key_press",   kbd.codes[i])
                    elseif(is_emoji == false)
                    then
                        -- great.key.execute(kbd.modifiers, i)
                        ww.font = "Droid Sans Mono Bold 11"
                        w.bg = "#0f0f0f"

                        --if(i == "Control" or i == "Alt" or i == "Mod4") then
                        if(kbd.modifiers ~= {})
                        then
                            for _, y in ipairs(kbd.modifiers) do
                                capi.fake_input("key_press",  kbd.codes[y])    
                                
                            end
                        end
                        
                        capi.fake_input("key_press",   kbd.codes[i])
                        capi.fake_input("key_release", kbd.codes[i])
                        
                        if(kbd.modifiers ~= {})
                        then
                            for _, y in ipairs(kbd.modifiers) do
                                capi.fake_input("key_release",  kbd.codes[y])    
                                -- widgets[y]["font"] = "Droid Sans Mono Bold 9"
                                table.remove(kbd.modifiers, _)
                            end
                        end
                        
                        kbd.modifiers = {}
                    else
                        great.util.spawn("xdotool type " .. i ) -- fixme
                        ww.font = "Droid Sans Mono Bold 11"
                        w.bg = "#0f0f0f"
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
            spacing       = 2,
            min_cols_size = 10,
            min_rows_size = 3,
            layout        = wibox.layout.grid, 
        }
        
        local table1 = create_button_row("q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "⌫") -- TODO: what to fix is obvious
        local table2 = create_button_row("Caps", "a", "s", "d", "f", "g", "h", "j", "k", "l", ":", "?", "Return", "Up") 
        local table3 = create_button_row({"Control", "modifier"}, {"Mod4", "modifier"}, {"Alt", "modifier"}, "y", "x", "c", "space", "v", "b", "n", "m", ".", "Left", "Down", "Right")
        local emojitable = create_button_row({"😂", "emoji"}, {"🤔", "emoji"})
            
        for _,i in ipairs(table1) do
            l:add_widget_at(table1[_], 1, _, 1, 1)
        end
        
        for _,i in ipairs(table2) do
            l:add_widget_at(table2[_], 2, _, 1, 1)
        end
        
        for _,i in ipairs(table3) do
            l:add_widget_at(table3[_], 3, _, 1, 1)
        end

        for _,i in ipairs(emojitable) do
            --great.util.spawn("notify-send '" .. tostring(table.getn()) .. " lol'")
            l:add_widget_at(emojitable[_], 1, 9+5+_, 1, 1) -- TODO: get row length+x
        end

        
        box = wibar({height = height, position = pos, screen = scr, widget = l})
        

        kbd.init = true
        box.visible = false
    end

    box.visible = not box.visible
end })


