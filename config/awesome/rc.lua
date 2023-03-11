-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local c = client.focus


-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Autorun programs
autorun = true
autorunApps = 
{ 
    "picom",  
    "/home/b4391co/.config/polybar/launch.sh",
    "nitrogen --restore",
}

if autorun then
   for app = 1, #autorunApps do
       awful.util.spawn(autorunApps[app])
   end
end



-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                        title = "Oops, an error happened!",
                        text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default alt.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
alt = "Mod1"
super = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,

}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "Manual", terminal .. " -e man awesome" },
    { "Edit config", editor_cmd .. " " .. awesome.conffile },
    { "Restart", awesome.restart },
    { "Quit", function() awesome.quit() end },
 }
 beautiful.menu_height=20
 beautiful.menu_width=180
 beautiful.menu_bg_normal="#374247"
 beautiful.menu_bg_focus="f7f4e0"
 --beautiful.menu_fg_normal=""
 beautiful.menu_fg_focus="374247"

 mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                     { "open terminal", "xfce4-terminal" },
                                     { " firefox", "firefox" },
                                     { " vivaldi", "vivaldi" },
                                     { " vs code", "code" },
                                     { " files", "nautilus" }
                                   }
                         })
 
 mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                      menu = mymainmenu })
 

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}

beautiful.menubar_border_width=25
beautiful.menubar_width=850
beautiful.menubar_height=850

beautiful.menubar_all_categories=true
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ alt }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ alt }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ alt,           }, "h",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ alt, "Control" }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ alt, "Control" }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ alt,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    --awful.key({ alt,           }, "s",
    --    function ()
    --        awful.client.focus.byidx( 1)
    --    end,
    --    {description = "focus next by index", group = "client"}
    --),
    --awful.key({ alt,           }, "w",
    --    function ()
    --        awful.client.focus.byidx(-1)
    --    end,
    --    {description = "focus previous by index", group = "client"}
    --),
    
    awful.key({ alt }, "a", function()
        awful.client.focus.bydirection("left")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ alt }, "s", function()
        awful.client.focus.bydirection("down")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ alt }, "w", function()
        awful.client.focus.bydirection("up")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ alt }, "d", function()
        awful.client.focus.bydirection("right")
        if client.focus then client.focus:raise() end
    end),

-- Move client to next tag
awful.key({ alt, "Shift" , "Control",}, "Right",
function()
    if client.focus then
        local s = awful.screen.focused()
        if s.selected_tag then
        local t = (s.selected_tag.index % 9 + 1)
        local tag = s.tags[t]
        client.focus:move_to_tag(tag)
        awful.tag.viewnext()
        end
end
end,
{description = "Move client to next tag", group = "client" }),

-- Move client to prev tag
awful.key({ alt, "Shift", "Control",}, "Left",
function()
    if client.focus then
        local s = awful.screen.focused()
        if s.selected_tag then
        local t = s.selected_tag.index - 1
        if t == 0 then t = 9 end
        local tag = s.tags[t]
        client.focus:move_to_tag(tag)
        awful.tag.viewprev()
        end
  end
end,
{description = "Move client to next tag", group = "client" }),

-- Move client to next tag no move preview
awful.key({ alt, "Shift" , }, "Right",
function()
    if client.focus then
        local s = awful.screen.focused()
        if s.selected_tag then
        local t = (s.selected_tag.index % 9 + 1)
        local tag = s.tags[t]
        client.focus:move_to_tag(tag)
        --awful.tag.viewnext()
        end
end
end,
{description = "Move client to next tag", group = "client" }),

-- Move client to prev tag no move preview
awful.key({ alt, "Shift",}, "Left",
function()
    if client.focus then
        local s = awful.screen.focused()
        if s.selected_tag then
        local t = s.selected_tag.index - 1
        if t == 0 then t = 9 end
        local tag = s.tags[t]
        client.focus:move_to_tag(tag)
        --awful.tag.viewprev()
        end
  end
end,
{description = "Move client to next tag", group = "client" }),

    awful.key({ alt,           }, "r", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ alt, "Shift"   }, "s", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ alt, "Shift"   }, "w", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ alt, "Control" }, "s", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ alt, "Control" }, "w", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ alt,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ alt,           }, "",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ alt,           }, "Return", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = "launcher"}),
    awful.key({ alt, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
    awful.key({ alt, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),

    -- TECLAS DE FUNCIONES
    --- Brillo
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn("brightnessctl set 5%+ -q", false)
		awesome.emit_signal("widget::brightness")
		awesome.emit_signal("module::brightness_osd:show", true)
	end, { description = "increase brightness", group = "hotkeys" }),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn("brightnessctl set 5%- -q", false)
		awesome.emit_signal("widget::brightness")
		awesome.emit_signal("module::brightness_osd:show", true)
	end, { description = "decrease brightness", group = "hotkeys" }),
	
    --- Volume control
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("amixer sset Master 5%+", false)
		awesome.emit_signal("widget::volume")
		awesome.emit_signal("module::volume_osd:show", true)
	end, { description = "increase volume", group = "hotkeys" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("amixer sset Master 5%-", false)
		awesome.emit_signal("widget::volume")
		awesome.emit_signal("module::volume_osd:show", true)
	end, { description = "decrease volume", group = "hotkeys" }),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn("amixer sset Master toggle", false)
	end, { description = "mute volume", group = "hotkeys" }),

	--- Music
	awful.key({}, "XF86AudioPlay", function()
		playerctl_daemon:play_pause()
	end, { description = "play pause music", group = "hotkeys" }),
	awful.key({}, "XF86AudioPrev", function()
		playerctl_daemon:previous()
	end, { description = "previous music", group = "hotkeys" }),
	awful.key({}, "XF86AudioNext", function()
		playerctl_daemon:next()
	end, { description = "next music", group = "hotkeys" }),

    -- Open VSCODE, VIVAILDY FIREFOX

    awful.key({ alt, "Control" }, "v", function () awful.spawn("vivaldi-stable") end,
    {description = "vivaldi", group = "launcher"}),
    awful.key({ alt, "Control" }, "x", function () awful.spawn("brave-browser") end,
    {description = "brave-browser ", group = "launcher"}),
    awful.key({ alt, "Control" }, "c", function () awful.spawn("code") end,
    {description = "code", group = "launcher"}),
    awful.key({ super            }, "e", function () awful.spawn("nautilus") end,
    {description = "nautilus", group = "launcher"}),
    awful.key({                   }, "Print", function () awful.spawn("flameshot gui") end,
    {description = "flameshot", group = "launcher"}),
    awful.key({ super            }, "r", function () awful.spawn("rofi -show run -show-icons -theme ~/.config/rofi/themes/rounded-blue-dark") end,
    {description = "rofi", group = "launcher"}),
    awful.key({ super            }, "d", function () awful.spawn("rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/themes/rofi.rasi") end,
    {description = "rofi", group = "launcher"}),
    awful.key({ alt,           }, "Tab", function () awful.spawn("rofi -show window -show-icons -theme ~/.config/rofi/themes/rounded-blue-dark") end,
    {description = "rofi", group = "launcher"}),
    awful.key({ super,  "Shift"  }, "r", function () awful.spawn("rofi -show ssh -show-icons -theme ~/.config/rofi/themes/rounded-blue-dark") end,
    {description = "rofi", group = "launcher"}),
    awful.key({ super  }, "d", function () awful.spawn("rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/themes/rofi.rasi") end,
    {description = "rofi", group = "launcher"}),
    awful.key({ super,           }, "l", function () awful.spawn("i3lock-everblush") end,
    {description = "i3lock", group = "launcher"}),

    awful.key({ alt, "Control" }, "d",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ alt, "Control" }, "a",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ alt, "Shift"   }, "d",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ alt, "Shift"   }, "a",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    --awful.key({ alt, "Control" }, "d",     function () awful.tag.incncol( 1, nil, true)    end,
    --          {description = "increase the number of columns", group = "layout"}),
    --awful.key({ alt, "Control" }, "a",     function () awful.tag.incncol(-1, nil, true)    end,
    --          {description = "decrease the number of columns", group = "layout"}),
    awful.key({ alt,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ alt, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ alt, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ alt },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ alt }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ alt }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    --awful.key({ alt,           }, "f",
    --    function (c)
    --        c.fullscreen = not c.fullscreen
    --        c:raise()
    --    end,
    --    {description = "toggle fullscreen", group = "client"}),
    awful.key({ alt, "Control"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ alt, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ alt, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ alt,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ alt,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ alt,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ alt,           }, "f",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ alt, "Control" }, "f",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ alt, "Shift"   }, "f",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ alt }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ alt, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ alt, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ alt, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ alt }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ alt }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    --{ rule_any = {type = { "normal", "dialog" }
    --  }, properties = { titlebars_enabled = true }
    --},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- custom config
beautiful.useless_gap=3

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

awful.spawn.with_shell("nitrogen --restore")
local wallpaper_cmd="feh --bg-fill /home/b4391co/Imágenes/wallpaper.png"
os.execute(wallpaper_cmd)




--- Brightness OSD
--- ~~~~~~~~~~~~~~
local icon = wibox.widget({
	{
		image = icons.brightness,
		resize = true,
		widget = wibox.widget.imagebox,
	},
	forced_height = dpi(150),
	top = dpi(12),
	bottom = dpi(12),
	widget = wibox.container.margin,
})

local osd_header = wibox.widget({
	text = "Brightness",
	font = beautiful.font_name .. "Bold 12",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local osd_value = wibox.widget({
	text = "0%",
	font = beautiful.font_name .. "Bold 12",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local slider_osd = wibox.widget({
	nil,
	{
		id = "bri_osd_slider",
		bar_shape = gears.shape.rounded_rect,
		bar_height = dpi(24),
		bar_color = "#ffffff20",
		bar_active_color = "#f2f2f2EE",
		handle_color = "#ffffff",
		handle_shape = gears.shape.circle,
		handle_width = dpi(24),
		handle_border_color = "#00000012",
		handle_border_width = dpi(1),
		maximum = 100,
		widget = wibox.widget.slider,
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical,
})

local bri_osd_slider = slider_osd.bri_osd_slider

bri_osd_slider:connect_signal("property::value", function()
	local brightness_level = bri_osd_slider:get_value()
	awful.spawn("brightnessctl set " .. brightness_level .. "%", false)

	-- Update textbox widget text
	osd_value.text = brightness_level .. "%"

	-- Update the brightness slider if values here change
	awesome.emit_signal("widget::brightness:update", brightness_level)

	if awful.screen.focused().show_bri_osd then
		awesome.emit_signal("module::brightness_osd:show", true)
	end
end)

bri_osd_slider:connect_signal("button::press", function()
	awful.screen.focused().show_bri_osd = true
end)

bri_osd_slider:connect_signal("mouse::enter", function()
	awful.screen.focused().show_bri_osd = true
end)

-- The emit will come from brightness slider
awesome.connect_signal("module::brightness_osd", function(brightness)
	bri_osd_slider:set_value(brightness)
end)

local brightness_osd_height = dpi(250)
local brightness_osd_width = dpi(250)

screen.connect_signal("request::desktop_decoration", function(s)
	local s = s or {}
	s.show_bri_osd = false

	s.brightness_osd_overlay = awful.popup({
		type = "notification",
		screen = s,
		height = brightness_osd_height,
		width = brightness_osd_width,
		maximum_height = brightness_osd_height,
		maximum_width = brightness_osd_width,
		bg = beautiful.transparent,
		ontop = true,
		visible = false,
		offset = dpi(5),
		preferred_anchors = "middle",
		preferred_positions = { "left", "right", "top", "bottom" },
		widget = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					{
						{
							layout = wibox.layout.align.horizontal,
							expand = "none",
							nil,
							icon,
							nil,
						},
						{
							layout = wibox.layout.fixed.vertical,
							spacing = dpi(5),
							{
								layout = wibox.layout.align.horizontal,
								expand = "none",
								osd_header,
								nil,
								osd_value,
							},
							slider_osd,
						},
						spacing = dpi(10),
						layout = wibox.layout.fixed.vertical,
					},
				},
				left = dpi(24),
				right = dpi(24),
				widget = wibox.container.margin,
			},
			bg = beautiful.black,
			shape = gears.shape.rounded_rect,
			widget = wibox.container.background,
		},
	})

	-- Reset timer on mouse hover
	s.brightness_osd_overlay:connect_signal("mouse::enter", function()
		awful.screen.focused().show_bri_osd = true
		awesome.emit_signal("module::brightness_osd:rerun")
	end)
end)

local hide_osd = gears.timer({
	timeout = 2,
	autostart = true,
	callback = function()
		local focused = awful.screen.focused()
		focused.brightness_osd_overlay.visible = false
		focused.show_bri_osd = false
	end,
})

awesome.connect_signal("module::brightness_osd:rerun", function()
	if hide_osd.started then
		hide_osd:again()
	else
		hide_osd:start()
	end
end)

local placement_placer = function()
	local focused = awful.screen.focused()
	local brightness_osd = focused.brightness_osd_overlay
	awful.placement.centered(brightness_osd)
end

awesome.connect_signal("module::brightness_osd:show", function(bool)
	placement_placer()
	awful.screen.focused().brightness_osd_overlay.visible = bool
	if bool then
		awesome.emit_signal("module::brightness_osd:rerun")
		awesome.emit_signal("module::volume_osd:show", false)
	else
		if hide_osd.started then
			hide_osd:stop()
		end
	end
end)


local awful = require("awful")
local menu = require("ui.widgets.menu")
local hotkeys_popup = require("awful.hotkeys_popup")
local apps = require("configuration.apps")
local focused = awful.screen.focused()

--- Beautiful right-click menu
--- ~~~~~~~~~~~~~~~~~~~~~~~~~~

local instance = nil

local function awesome_menu()
	return menu({
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Show Help",
			on_press = function()
				hotkeys_popup.show_help(nil, awful.screen.focused())
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Manual",
			on_press = function()
				awful.spawn(apps.default.terminal .. " -e man awesome")
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Edit Config",
			on_press = function()
				awful.spawn(apps.default.text_editor .. " " .. awesome.conffile)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Restart",
			on_press = function()
				awesome.restart()
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Quit",
			on_press = function()
				awesome.quit()
			end,
		}),
	})
end

local function widget()
	return menu({
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Applications",
			on_press = function()
				awful.spawn(apps.default.app_launcher, false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Terminal",
			on_press = function()
				awful.spawn(apps.default.terminal, false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Web Browser",
			on_press = function()
				awful.spawn(apps.default.web_browser, false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "File Manager",
			on_press = function()
				awful.spawn(apps.default.file_manager, false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Text Editor",
			on_press = function()
				awful.spawn(apps.default.code_editor, false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Music Player",
			on_press = function()
				awful.spawn(apps.default.music_player, false)
			end,
		}),
		menu.separator(),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Dashboard",
			on_press = function()
				awesome.emit_signal("central_panel::toggle", focused)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Info Center",
			on_press = function()
				awesome.emit_signal("info_panel::toggle", focused)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Notification Center",
			on_press = function()
				awesome.emit_signal("notification_panel::toggle", focused)
			end,
		}),
		menu.separator(),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Exit",
			on_press = function()
				awesome.emit_signal("module::exit_screen:show")
			end,
		}),
		menu.sub_menu_button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "AwesomeWM",
			sub_menu = awesome_menu(),
		}),
	})
end

if not instance then
	instance = widget()
end
return instance