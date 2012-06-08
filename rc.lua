--------------------------------------------------------------------------------
-- weXt-core's Awesome WM Configuration					      --
-- Last change: 07.06.2012						      --
-- Author: Philipp Marmet - weXt-core					      --
--------------------------------------------------------------------------------

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")

require("beautiful")
require("naughty")
require("calendar2")

-- require("")

-- Script for run once programms
function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

-- Autostart
awful.util.spawn_with_shell("xcompmgr -cF &")
run_once("gnome-sound-applet")
run_once("nm-applet")


-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}


-- Load Theme Zenburn
theme_path = awful.util.getdir("config") .. "/themes/zenburn/theme.lua"
beautiful.init(theme_path)


-- This is used later as the default terminal and editor to run.
-- terminal = "xterm"
-- terminal = "rxvt "
-- terminal = "roxterm"
terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

floatapps =
{
    ["gimp"] = true,
    ["gmrun"] = true,
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    ["Firefox"] = { screen = 2, tag = 3}, 
    ["Pidgin"] = { screen = 1, tag = 4},
    ["thunderbird"] = { screen = 1, tag = 5},
    ['banshee'] = { screen = 1, tag = 6},
}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
                if s == 1 then
                        tags[s] = awful.tag({ 'Terms', 'Dev', 'WWW', 'IM', 'Mail', 'Sound', 'Misc', 'Space', 'Conky' }, s, layouts[2])
                else
                        tags[s] = awful.tag({ 'Terms', 'Dev', 'WWW', 'IM', 'Mail', 'Sound', 'Misc', 'Space' }, s, layouts[1])
                end
end
-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
--   { "manual", terminal .. " -e man awesome" },
--   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "ReLoad", awesome.restart },
   { "LogOut", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })
calendar2.addCalendarToWidget(mytextclock, "<span color='#FF0000'>%s</span>")

-- Create a systray
mysystray = widget({ type = "systray" })

-- {{{ CPU graph widget
-- cpugraphwidget = widget({
--     type = 'graph',
--     name = 'cpugraphwidget',
--     align = 'right'
-- })
-- 
-- cpugraphwidget.height = 0.85
-- cpugraphwidget.width = 45
-- cpugraphwidget.bg = '#33333355'
-- cpugraphwidget.border_color = '#0a0a0a'
-- cpugraphwidget.grow = 'right'
-- 
-- cpugraphwidget:plot_properties_set('cpu', {
--     fg = '#AEC6D8',
--     fg_center = '#285577',
--     fg_end = '#285577',
--     vertical_gradient = false
-- })
-- 
-- wicked.register(cpugraphwidget, wicked.widgets.cpu, '$1', 1, 'cpu')
-- }}}

-- {{{ Memory Bar Widget
-- membarwidget = widget({ type = 'progressbar', name = 'membarwidget', align = 'right' })
-- membarwidget.height = 0.85
-- membarwidget.width = 8
-- membarwidget.bg = '#33333355'
-- membarwidget.border_color = '#0a0a0a'
-- membarwidget.vertical = true
-- membarwidget:bar_properties_set('mem',
--                                      { fg = '#AED8C6',
--                                        fg_center = '#287755',
--                                        fg_end = '#287755',
--                                        fg_off = '#222222',
--                                        vertical_gradient = true,
--                                        horizontal_gradient = false,
--                                        ticks_count = 0,
--                                        ticks_gap = 0 })
-- 
-- wicked.register(membarwidget, wicked.widgets.mem, '$1', 1, 'mem')
--- }}}

-- {{{ Load Averages Widget
-- loadwidget = widget({
--     type = 'textbox',
--     name = 'loadwidget',
--     align = 'right'
-- })
-- 
-- function widget_loadavg(format)
--     -- Use /proc/loadavg to get the average system load on 1, 5 and 15 minute intervals
--     local f = io.open('/proc/loadavg')
--     local n = f:read()
--     f:close()
-- 
--     local space1 = string.find(n, " ")
--     local space2 = string.find(n, " ", space1 + 1)
--     local space3 = string.find(n, " ", space2 + 1)
-- 
--     local load1 = n:sub(1,space1 - 2)
--     local load5 = n:sub(space1 + 1, space2 - 2)
--     local load15 = n:sub(space2 + 1, space3 - 2)
-- 
--     return {load1, load5, load15}
-- end
-- 
-- wicked.register(loadwidget, widget_loadavg, ' <span color="white">$1</span>/<span color="grey80">$2</span>/<span color="grey60">$3</span> ', 2)
-- }}}

-- {{{ Network widget
-- netwidget = widget({
--     type = 'textbox',
--     name = 'netwidget',
--     align = 'right'
-- })
-- 
-- wicked.register(netwidget, wicked.widgets.net,
--     '<span color="green">▾</span>${' .. netif ..
--     ' down} <span color="red">▴</span>${' .. netif .. ' up} ')
-- }}}

-- {{{ Battery widget
-- if host == "macbork" then
--     batteries = 1
-- 
--     -- Function to extract charge percentage
--     function read_battery_life(number)
--        return function(format)
--                  local fh = io.popen('acpi')
--                  output = fh:read("*a")
--                  fh:close()
-- 
--                  count = 0
--                  for s in string.gmatch(output, "(%d+)%%") do
--                     if number == count then
--                        return {s}
--                     end
--                     count = count + 1
--                  end
--               end
--     end
-- 
--     -- Display one vertical progressbar per battery
--     for battery=0, batteries-1 do
--        batterygraphwidget = widget({ type = 'progressbar',
--                                      name = 'batterygraphwidget',
--                                      align = 'right' })
--        batterygraphwidget.height = 0.85
--        batterygraphwidget.width = 8
--        batterygraphwidget.bg = '#333333'
--        batterygraphwidget.border_color = '#0a0a0a'
--        batterygraphwidget.vertical = true
--        batterygraphwidget:bar_properties_set('battery',
--                                              { fg = '#AEC6D8',
--                                                fg_center = '#285577',
--                                                fg_end = '#285577',
--                                                fg_off = '#222222',
--                                                vertical_gradient = true,
--                                                horizontal_gradient = false,
--                                                ticks_count = 0,
--                                                ticks_gap = 0 })
-- 
--        wicked.register(batterygraphwidget, read_battery_life(battery), '$1', 1, 'battery')
--     end
-- end
-- }}}



-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
--            s == 1 and fsicon or nil,
--            s == 1 and fswidget or nil,
--            s == 1 and neticon or nil,
--            s == 1 and netwidget or nil,
--            s == 1 and statsicon or nil,
--            s == 1 and cpugraphwidget or nil,
--            s == 1 and membarwidget or nil,
--            s == 1 and loadwidget or nil,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    awful.key({ modkey, "Control" }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),

    -- Load xrandr-config
    awful.key({ modkey,           }, "s", function () awful.util.spawn("/home/philippm/.screenlayout/docking.sh"  ) end),
    awful.key({ modkey,  "Shift"  }, "s", function () awful.util.spawn("/home/philippm/.screenlayout/notconnectet.sh"  ) end),

    -- Prompt
    awful.key({ modkey },            "r", function () awful.util.spawn("gmrun") end),
--    awful.key({ modkey }, "x",
--              function ()
--                  awful.prompt.run({ prompt = "Run Lua code: " },
--                  mypromptbox[mouse.screen].widget,
--                  awful.util.eval, nil,
--                  awful.util.getdir("cache") .. "/history_eval")
--              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { "xterm" },
      properties = { opacity = 0.5 } },
    { rule = { class = "conky" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ 
-- Autostarts
awful.util.spawn_with_shell("gnome-sound-applet")
awful.util.spawn_with_shell("notify-send 'Hi Philipp! Wish you a nice day!'")
run_once("nm-applet")
-- }}}


