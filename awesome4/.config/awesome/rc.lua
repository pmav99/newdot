-- vim: set foldmethod=marker :
--
-- {{{ Imports
-- Standard Lua Library
local io = require("io")
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
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- 3rd party libraries
local lain = require("lain")
local net_widgets = require("net_widgets")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then
      return
    end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err),
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/multicolor/theme.lua")
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- common
local M = "Mod4"
local A = "Mod1"
local S = "Shift"
local C = "Control"
local terminal = "kitty --single-instance --detach" or "wezterm" or "terminator" or "terminology" or "urxvtc" or "xterm"
local editor = os.getenv("EDITOR") or "nano" or "vi"
editor_cmd = terminal .. " -e " .. editor

-- user defined
naughty.config.defaults.icon_size = 64
local browser = "firefox -P default"
local gui_editor = "nvim-qt"
local tagnames = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
--local tagnames   = { 1, 2, 3, 4, 5, 6, 7, 8, 9, "u", "i", "o", "p" }

-- table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  --awful.layout.suit.floating,
  --awful.layout.suit.tile,
  --awful.layout.suit.tile.left,
  --awful.layout.suit.tile.bottom,
  --awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  --lain.layout.termfair.center,
  --awful.layout.suit.fair.horizontal,
  --awful.layout.suit.spiral,
  --awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  --awful.layout.suit.max.fullscreen,
  --awful.layout.suit.magnifier,
  --awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}

-- lain
-- lain.layout.termfair.nmaster        = 2
-- lain.layout.termfair.ncol           = 1
-- lain.layout.termfair.center.nmaster = 2
-- lain.layout.termfair.center.ncol    = 1
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil

  return function()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ theme = { width = 250 } })
    end
  end
end

-- Autostart applications
local function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  {
    "hotkeys",
    function()
      return false, hotkeys_popup.show_help
    end,
  },
  { "manual",      terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart",     awesome.restart },
  {
    "quit",
    function()
      awesome.quit()
    end,
  },
}

mymainmenu = awful.menu({
  items = {
    { "awesome",       myawesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal },
  },
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- {{{ Create Widgets

local markup = lain.util.markup

-- {{{ Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local clockicon = wibox.widget.imagebox(beautiful.widget_clock)
local mytextclock =
    wibox.widget.textclock(markup("#7788af", "%A %d %B ") .. markup("#535f7a", ">") .. markup("#de5e1e", " %H:%M "), 1)
--- }}}

-- {{{ Calendar
local calendar = lain.widget.cal({
  attach_to = { mytextclock },
  notification_preset = {
    font = "Inconsolata 18",
    --fg   = beautiful.fg_normal,
    --bg   = beautiful.bg_normal,
    fg = "#FFFFFF",
    bg = "#000000",
  },
})
--}}}

-- {{{ fs
local fsicon = wibox.widget.imagebox(beautiful.widget_fs)
local fswidget = lain.widget.fs({
  notification_preset = {
    font = "Inconsolata 18",
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
  },
})
-- }}}

-- {{{ CPU
local cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu = lain.widget.cpu({
  settings = function()
    cpu_perc = string.format("CPU % 3d%%", tonumber(cpu_now.usage))
    widget:set_markup(markup("#e33a6e", cpu_perc))
  end,
})
-- }}}

-- {{{ MEM
local memicon = wibox.widget.imagebox(beautiful.widget_mem)
local memory = lain.widget.mem({
  settings = function()
    mem_perc = string.format("MEM % 3d%%", mem_now.perc)
    widget:set_markup(markup("#e0da37", mem_perc))
  end,
})
-- }}}

-- Coretemp
local tempicon = wibox.widget.imagebox(beautiful.widget_temp)
local temp = lain.widget.temp({
  settings = function()
    widget:set_markup(markup("#f1af5f", coretemp_now .. "°C "))
  end,
})

-- Battery
--local baticon = wibox.widget.imagebox(beautiful.widget_batt)
--local bat = lain.widget.bat({
--settings = function()
--if bat_now.perc ~= "N/A" then
--bat_now.perc = bat_now.perc .. "%"
--end
--if bat_now.ac_status == 1 then
--bat_now.perc = bat_now.perc .. " plug"
--end

--widget:set_text(bat_now.perc .. " ")
--end
--})

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- ALSA volume
local volicon = wibox.widget.imagebox(beautiful.widget_vol)
local volume = lain.widget.alsa({
  settings = function()
    if volume_now.status == "off" then
      volume_now.level = volume_now.level .. "M"
    end
    widget:set_markup(markup("#7493d2", volume_now.level .. "% "))
  end,
})

-- Net
--local netdownicon = wibox.widget.imagebox(beautiful.widget_netdown)
--local netdowninfo = wibox.widget.textbox()
--local netupicon = wibox.widget.imagebox(beautiful.widget_netup)
--local netupinfo = lain.widget.net({
--settings = function()

--widget:set_markup(markup("#e54c62", net_now.sent .. " "))
--netdowninfo:set_markup(markup("#87af5f", net_now.received .. " "))
--end
--})

-- MPD
--local mpdicon = wibox.widget.imagebox()
--local mpdwidget = lain.widget.mpd({
--settings = function()
--mpd_notification_preset = {
--text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
--mpd_now.album, mpd_now.date, mpd_now.title)
--}

--if mpd_now.state == "play" then
--artist = mpd_now.artist .. " > "
--title  = mpd_now.title .. " "
--mpdicon:set_image(beautiful.widget_note_on)
--elseif mpd_now.state == "pause" then
--artist = "mpd "
--title  = "paused "
--else
--artist = ""
--title  = ""
----mpdicon:set_image() -- not working in 4.0
--mpdicon._private.image = nil
--mpdicon:emit_signal("widget::redraw_needed")
--mpdicon:emit_signal("widget::layout_changed")
--end
--widget:set_markup(markup("#e54c62", artist) .. markup("#b2b2b2", title))
--end
--})
--- }}} Create widgets

-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ M }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ M }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() and c.first_tag then
        c.first_tag:view_only()
      end
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c:raise()
    end
  end),
  awful.button({}, 3, client_menu_toggle_fn()),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end)
)

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
  awful.tag(tagnames, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end)
  ))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s, border_width = 0, height = 20 })

  -- Add widgets to the wibox
  s.mywibox:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mylauncher,
      s.mytaglist,
      s.mypromptbox,
      --mpdicon,
      --mpdwidget,
    },
    s.mytasklist, -- Middle widget
    --nil,
    {           -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mykeyboardlayout,
      wibox.widget.systray(),
      --mailicon,
      --mail.widget,
      --netdownicon,
      --netdowninfo,
      --netupicon,
      --netupinfo.widget,
      net_widgets.wireless({ interface = "wlan0" }),
      volicon,
      volume,
      memicon,
      memory.widget,
      cpuicon,
      cpu.widget,
      fsicon,
      fswidget.widget,
      tempicon,
      temp.widget,
      --baticon,
      --bat.widget,
      clockicon,
      mytextclock,
      s.mylayoutbox,
    },
  })
end)

-- Keep windows on the same numbered tags when a monitor disappears.
tag.connect_signal("request::screen", function(old_tag)
  local old_screen = old_tag.screen
  local destination = screen.primary

  if destination == old_screen then
    destination = nil
  end
  if not destination then
    for s in screen do
      if s ~= old_screen then
        destination = s
        break
      end
    end
  end
  if not destination then
    return
  end

  local replacement = awful.tag.find_by_name(destination, old_tag.name)
  if not replacement then
    old_tag.screen = destination
    return
  end

  local was_selected = old_tag.selected
  for _, c in ipairs(old_tag:clients()) do
    local new_tags = {}
    for _, current_tag in ipairs(c:tags()) do
      if current_tag.screen == old_screen then
        new_tags[#new_tags + 1] = awful.tag.find_by_name(destination, current_tag.name) or current_tag
      else
        new_tags[#new_tags + 1] = current_tag
      end
    end
    c.screen = destination
    c:tags(new_tags)
  end

  if was_selected then
    replacement:view_only()
  end
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({}, 3, function()
    mymainmenu:toggle()
  end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))
-- }}}
--
local toggle_unit = "/home/panos/.local/my_bin/toggle_unit"

local toggle_btop = function() awful.spawn(toggle_unit .. " kitty-btop") end
local toggle_ipython = function() awful.spawn(toggle_unit .. " kitty-ipython") end
local toggle_journalctl = function() awful.spawn(toggle_unit .. " kitty-journalctl") end
local toggle_slack = function() awful.spawn(toggle_unit .. " chromium-slack") end
local toggle_teams = function() awful.spawn(toggle_unit .. " chromium-teams") end
local toggle_obsidian = function() awful.spawn(toggle_unit .. " obsidian") end
local toggle_gemini = function()  awful.spawn(toggle_unit .. " chromium-gemini") end
local toggle_webmail = function()  awful.spawn(toggle_unit .. " chromium-webmail") end
local toggle_viber = function()  awful.spawn(toggle_unit .. " viber") end


-- {{{ Key bindings
globalkeys = gears.table.join(

  awful.key({ M }, "p", toggle_btop, { description = "toggle btop", group = "dropdowns" }),
  awful.key({ M }, "i", toggle_ipython, { description = "toggle ipython", group = "dropdowns" }),
  awful.key({ M }, "l", toggle_journalctl, { description = "toggle journactl", group = "dropdowns" }),
  awful.key({ M }, "s", toggle_slack, { description = "toggle slack", group = "dropdowns" }),
  awful.key({ M }, "t", toggle_teams, { description = "toggle teams", group = "dropdowns" }),
  awful.key({ M }, "o", toggle_obsidian, { description = "toggle obsidian", group = "dropdowns" }),
  awful.key({ M }, "g", toggle_gemini, { description = "toggle gemini", group = "dropdowns" }),
  awful.key({ M }, "w", toggle_webmail, { description = "toggle webmail", group = "dropdowns" }),
  awful.key({ M }, "v", toggle_viber, { description = "toggle viber", group = "dropdowns" }),

  -- Applications
  awful.key({ M }, "q", function() awful.spawn(browser) end, { description = "launch browser", group = "applications" }),

  -- awful.key({ M }, "l", function() calendar.show(7) end, { description = "show calendar", group = "applications" }),
  -- awful.key({ M }, "h", function() fswidget.show(7) end, { description = "show filesystem", group = "applications" }),
  awful.key({ M }, "e", function() awful.spawn(gui_editor) end, { description = "open editor", group = "applications" }),

  -- Custom Shortcut Keys
  awful.key({ M }, "r", function() awful.screen.focused().mypromptbox:run() end, { description = "run prompt", group = "applications" }),
  awful.key({ M }, "Return", function() awful.spawn(terminal) end, { description = "open a terminal", group = "applications" }),

  awful.key({ M }, "h", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
  awful.key({ M }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

  -- Non-empty tag browsing
  awful.key({ M }, "Left", awful.tag.viewprev, { description = "view previous tag", group = "view tag" }),
  awful.key({ M }, "Right", awful.tag.viewnext, { description = "view next tag", group = "view tag" }),
  awful.key({ A }, "Left", function() lain.util.tag_view_nonempty(-1) end, { description = "view previous nonempty tag", group = "view tag" }),
  awful.key({ A }, "Right", function() lain.util.tag_view_nonempty(1) end, { description = "view next nonempty tag", group = "view tag" }),

  -- view previous
  awful.key({ M }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = "view previous client", group = "view client" }),

  -- Default client focus
  awful.key({ M }, "j", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),
  awful.key({ M }, "k", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus previous by index", group = "client" }),

  -- ALSA volume control
  awful.key({ A }, "=", function()
    awful.spawn(string.format("amixer set %s 5%%+", volume.channel))
    volume.update()
  end, { description = "increase volume", group = "volume" }
  ),
  awful.key({ A }, "-", function()
    awful.spawn(string.format("amixer set %s 5%%-", volume.channel))
    volume.update()
  end, { description = "decrease volume", group = "volume" }
  ),
  awful.key({ A }, "m", function()
    awful.spawn(string.format("amixer set %s toggle", volume.togglechannel or volume.channel))
    volume.update()
  end, { description = "mute volume", group = "volume" }
  ),

  -- By direction client focus
  --awful.key({ M }, "j",
  --function()
  --awful.client.focus.bydirection("down")
  --if client.focus then client.focus:raise() end
  --end),
  --awful.key({ M }, "k",
  --function()
  --awful.client.focus.bydirection("up")
  --if client.focus then client.focus:raise() end
  --end),
  --awful.key({ M }, "h",
  --function()
  --awful.client.focus.bydirection("left")
  --if client.focus then client.focus:raise() end
  --end),
  --awful.key({ M }, "l",
  --function()
  --awful.client.focus.bydirection("right")
  --if client.focus then client.focus:raise() end
  --end),

  --awful.key({ M,           }, "w", function () mymainmenu:show() end,
  --{description = "show main menu", group = "awesome"}),

  -- Layout manipulation
  awful.key({ M, S }, "j", function()
    awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),
  awful.key({ M, S }, "k", function()
    awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),
  awful.key({ M, C }, "j", function()
    awful.screen.focus_relative(1)
  end, { description = "focus the next screen", group = "screen" }),
  awful.key({ M, C }, "k", function()
    awful.screen.focus_relative(-1)
  end, { description = "focus the previous screen", group = "screen" }),
  -- awful.key({ M }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

  -- Show/Hide Wibox
  awful.key({ M, C }, "b", function()
    for s in screen do
      s.mywibox.visible = not s.mywibox.visible
    end
  end, { description = "Show/Hide wibox", group = "client" }),

  ---- On the fly useless gaps change
  --awful.key({ A, C }, "=", function () lain.util.useless_gaps_resize(1) end),
  --awful.key({ A, C }, "-", function () lain.util.useless_gaps_resize(-1) end),

  ---- Dynamic tagging
  --awful.key({ M, S }, "n", function () lain.util.add_tag() end),
  --awful.key({ M, S }, "r", function () lain.util.rename_tag() end),
  --awful.key({ M, S }, "Left", function () lain.util.move_tag(1) end),   -- move to next tag
  --awful.key({ M, S }, "Right", function () lain.util.move_tag(-1) end), -- move to previous tag
  --awful.key({ M, S }, "d", function () lain.util.delete_tag() end),

  -- Standard program
  awful.key({ M, C }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
  awful.key({ M, S }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
  -- awful.key({ M }, "l", function()
  --   awful.tag.incmwfact(0.05)
  -- end, { description = "increase master width factor", group = "layout" }),
  -- awful.key({ M }, "h", function()
  --   awful.tag.incmwfact(-0.05)
  -- end, { description = "decrease master width factor", group = "layout" }),
  -- awful.key({ M, S }, "h", function()
  --   awful.tag.incnmaster(1, nil, true)
  -- end, { description = "increase the number of master clients", group = "layout" }),
  -- awful.key({ M, S }, "l", function()
  --   awful.tag.incnmaster(-1, nil, true)
  -- end, { description = "decrease the number of master clients", group = "layout" }),
  -- awful.key({ M, C }, "h", function()
  --   awful.tag.incncol(1, nil, true)
  -- end, { description = "increase the number of columns", group = "layout" }),
  -- awful.key({ M, C }, "l", function()
  --   awful.tag.incncol(-1, nil, true)
  -- end, { description = "decrease the number of columns", group = "layout" }),
  awful.key({ M }, "space", function()
    awful.layout.inc(1)
  end, { description = "select next layout", group = "layout" }),
  -- awful.key({ M, S }, "space", function()
  --   awful.layout.inc(-1)
  -- end, { description = "select previous", group = "layout" }),

  -- awful.key({ M, C }, "n", function()
  --   local c = awful.client.restore()
  --   -- Focus restored client
  --   if c then
  --     client.focus = c
  --     c:raise()
  --   end
  -- end, { description = "restore minimized", group = "client" }),

  -- MPD control
  --awful.key({ A, C }, "Up",
  --function ()
  --awful.spawn.with_shell("mpc toggle || ncmpc toggle || pms toggle")
  --mpdwidget.update()
  --end),
  --awful.key({ A, C }, "Down",
  --function ()
  --awful.spawn.with_shell("mpc stop || ncmpc stop || pms stop")
  --mpdwidget.update()
  --end),
  --awful.key({ A, C }, "Left",
  --function ()
  --awful.spawn.with_shell("mpc prev || ncmpc prev || pms prev")
  --mpdwidget.update()
  --end),
  --awful.key({ A, C }, "Right",
  --function ()
  --awful.spawn.with_shell("mpc next || ncmpc next || pms next")
  --mpdwidget.update()
  --end),
  --

  -- Copy primary to clipboard
  awful.key({ M }, "c", function()
    awful.spawn("xsel | xsel -b")
  end)
)

clientkeys = gears.table.join(
  awful.key({ M }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),
  awful.key({ M, S }, "c", function(c)
    c:kill()
  end, { description = "close", group = "client" }),
  awful.key(
    { M, C },
    "space",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }
  ),
  -- awful.key({ M, C }, "Return", function(c)
  --   c:swap(awful.client.getmaster())
  -- end, { description = "move to master", group = "client" }),
  awful.key({ M, S }, "o", function(c)
    c:move_to_screen()
  end, { description = "move to screen", group = "client" }),
  -- awful.key({ M }, "t", function(c)
  --   c.ontop = not c.ontop
  -- end, { description = "toggle keep on top", group = "client" }),
  -- awful.key({ M }, "n", function(c)
  --   -- The client currently has the input focus, so it cannot be
  --   -- minimized, since minimized clients can't have the focus.
  --   c.minimized = true
  -- end, { description = "minimize", group = "client" })
  awful.key({ M }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { description = "(un)maximize", group = "client" })
  -- awful.key({ M, C }, "m", function(c)
  --   c.maximized_vertical = not c.maximized_vertical
  --   c:raise()
  -- end, { description = "(un)maximize vertically", group = "client" }),
  -- awful.key({ M, S }, "m", function(c)
  --   c.maximized_horizontal = not c.maximized_horizontal
  --   c:raise()
  -- end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys,
    -- View tag only.
    awful.key({ M }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end, { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ M, C }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end, { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ M, S }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, { description = "move focused client to tag #" .. i, group = "tag" })
    -- Toggle tag on focused client.
    -- awful.key({ M, C, S }, "#" .. i + 9, function()
    --   if client.focus then
    --     local tag = client.focus.screen.tags[i]
    --     if tag then
    --       client.focus:toggle_tag(tag)
    --     end
    --   end
    -- end, { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    client.focus = c
    c:raise()
  end),
  awful.button({ M }, 1, awful.mouse.client.move),
  awful.button({ M }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false,
      titlebars_enabled = true,
    },
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
      },
      class = {
        "Arandr",
        "Gpick",
        "Kruler",
        "MessageWin", -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "pinentry",
        "veromix",
        "xtightvncviewer",
      },

      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "pop-up",  -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = { floating = true },
  },

  -- Add titlebars to normal clients and dialogs
  { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "firefox" },
  -- properties = { screen = 1, tag = "2" } },
  -- { rule_any = {
  --     class = { "Chromium" },
  --     properties = {
  --         sticky = false,
  --         floating = false,
  --         titlebars_enabled = true,
  --     },
  -- }},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the window as a slave (put it at the end of others instead of setting it as master)
  if not awesome.startup then
    awful.client.setslave(c)
  end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c, { size = 16 }):setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end)

-- ===================================================================
-- Client Focusing
-- ===================================================================

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

client.connect_signal("exit", function(reason_restart)
  local file = io.open("/tmp/awesomewm-last-selected-tags", "w+")
  file:write("asdf")
  file:close()
  if not reason_restart then
    return
  end

  --
  --    for s in client.screen do
  --       file:write(s.selected_tag.index, '\n')
  --    end
  --
end)
--
-- client.connect_signal('startup', function(c)
--    local file = io.open('/tmp/awesomewm-last-selected-tags', 'r')
--    if not file then return end
--
--    local selected_tags = {}
--
--    for line in file:lines() do
--       table.insert(selected_tags, tonumber(line))
--    end
--
--    for s in client.screen do
--       local i = selected_tags[s.index]
--       local t = s.tags[i]
--       t:view_only()
--    end
--
--    file:close()
-- end)

-- autorun
awful.spawn.with_shell("~/.config/awesome/autorun.sh")
-- }}}
