# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Imports

import os
import subprocess

# Qtile Imports

from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

# Leader key

mod = "mod4"     # Super Key

# Script Directory

home = os.path.expanduser('~')
scripts = os.path.join(home + '/scripts/')

# User scripts

passmenu_otp = os.path.join(scripts + '__passmenu-otp.sh')
clearboard = os.path.join(scripts + '__clearboard.sh')

# Binaries

term = "kitty"
browser = "flatpak run io.github.zen_browser.zen -P"
screenshooter = "flameshot gui"
pkm = "obsidian"
messenger = "deltachat-desktop"
filebrowser = "kitty -e ranger"
screenrecorder = "obs"

# Functions

@lazy.function
def toggle_view(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()

@lazy.function
def smart_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == 'columns':
        qtile.current_group.layout = 'max'
    elif current_layout_name == 'max':
        qtile.current_group.layout = 'columns'

# Keybindings

keys = [
    # Binaries keybindings
    Key([mod], "Return", lazy.spawn(term)),
    Key([mod], "g", lazy.spawn(screenshooter)),
    Key([mod], "F1", lazy.spawn(browser)),
    Key([mod], "F2", lazy.spawn(messenger)),
    Key([mod], "e", lazy.spawn(filebrowser)),

    # Qtile keybindings
    Key([mod, "shift"], "Tab", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout."),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Quit Qtile"),

    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Motion
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down a section"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up a section"),

    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),

    # Columns essentials
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod, "shift"], "space", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod, "shift", "control"], "h", lazy.layout.swap_column_left(), desc="Swap columns to left"),
    Key([mod, "shift", "control"], "l", lazy.layout.swap_column_right(), desc="Swap columns to right"),

    # Extra management
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "m", lazy.layout.maximize(), desc='Toggle between min and max sizes'),
    Key([mod], "t", lazy.window.toggle_floating(), desc='toggle floating'),
    Key([mod], "f", smart_layout(), lazy.window.toggle_fullscreen(), desc='toggle fullscreen'),
    Key([mod, "shift"], "m", toggle_view(), desc="Toggle hide/show all windows on current group"),

    Key([mod], "period", lazy.next_screen(), desc='Move focus to next monitor'),
    Key([mod], "comma", lazy.prev_screen(), desc='Move focus to prev monitor'),

    # KeyChords

    # "c" for call
    KeyChord([mod], "c", [
        Key([], "o", lazy.spawn(pkm)),
        Key([], "r", lazy.spawn(screenrecorder)),
        Key([], "c", lazy.spawn(clearboard), desc= 'Clears clipboard')
    ]),
    # "d" for dmenu
    KeyChord([mod], "d", [
        Key([], "p", lazy.spawn('passmenu'), desc="pass over dmenu"),
        Key([], "o", lazy.spawn(passmenu_otp), desc="pass over dmenu")
    ])
]

# Group Settings

groups = []
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9",]
group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9",]

group_layouts = ["columns", "columns", "columns", "columns", "columns", "columns", "columns", "columns", "columns"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

# Customization

ElegantVagrant = [
    ["#000000", "#000000"], # color00
    ["#ffffff", "#ffffff"], # color01
    ["#1c1f24", "#1c1f24"], # color02
    ["#02f789", "#02f789"], # color03
    ["#f067fc", "#f067fc"], # color04
    ["#7C5CFF", "#7C5CFF"], # color05
    ["#f4f113", "#f4f113"], # color06
    ["#5e12ea", "#5e12ea"], # color07
    ["#46d9ff", "#46d9ff"], # color08
    ["#fc0f99", "#fc0f99"], # color09
]

colors = ElegantVagrant

# Layouts

layout_theme = {"border_width": 2,
                "margin": 1,
                "border_focus": colors[7],
                "border_normal": colors[0]
                }

layouts = [
    #layout.Bsp(**layout_theme),
    #layout.Floating(**layout_theme)
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    #layout.MonadTall(**layout_theme),
    #layout.MonadWide(**layout_theme),
    #layout.Tile(**layout_theme),
    layout.Max(
         border_width = 0,
         margin = 0,
         ),
    #layout.Stack(**layout_theme, num_stacks=2),
    layout.Columns(
        border_widt = 2,
        margin = 1,
        border_focus = colors[7],
        border_normal = colors[0],
        border_focus_stack = colors[9],
    ),
    #layout.TreeTab(**layout_theme),
    #layout.Zoomy(**layout_theme),
]

# Widgets

widget_defaults = dict(
    font="Ubuntu Bold",
    fontsize = 12,
    padding = 0,
    background=colors[0]
)

extension_defaults = widget_defaults.copy()

def init_widgets_list():
    widgets_list = [
        widget.Prompt(
                 font = "Ubuntu Mono",
                 fontsize=14,
                 foreground = colors[1]
        ),
        widget.Spacer(length = 4),
        widget.CurrentLayoutIcon(
                 foreground = colors[1],
                 padding = 0,
                 scale = 0.7
                 ),
#        widget.CurrentLayout(
#                 foreground = colors[1],
#                 padding = 5
#                 ),
        widget.GroupBox(
                 fontsize = 11,
                 margin_y = 3,
                 margin_x = 4,
                 padding_y = 2,
                 padding_x = 3,
                 borderwidth = 3,
                 active = colors[8],
                 inactive = colors[1],
                 rounded = False,
                 highlight_color = colors[2],
                 highlight_method = "line",
                 this_current_screen_border = colors[7],
                 this_screen_border = colors [4],
                 other_current_screen_border = colors[7],
                 other_screen_border = colors[4],
                 ),
        widget.WindowName(
                 foreground = colors[8],
                 max_chars = 80
                 ),
        widget.Spacer(length = 7),
        widget.Net(
                 format = '{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}',
                 foreground = colors[3],
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Ubuntu Mono",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 14
                 ),
        #widget.Battery(
                #format = '󰁹{percent: 2.0%}',
                #foreground = colors[8],
                #),
        #widget.TextBox(
                #text = '|',
                #font = "Ubuntu Mono",
                #foreground = colors[1],
                #padding = 2,
                #fontsize = 14
                #),
        widget.CPU(
                 format = '  {load_percent}%',
                 foreground = colors[4],
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Ubuntu Mono",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.Memory(
                 foreground = colors[8],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(term + ' -e bpytop')},
                 format = '{MemUsed: .0f}{mm}',
                 fmt = '  {}',
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Ubuntu Mono",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.KeyboardLayout(
                 foreground = colors[5],
                 fmt = '  {}',
                 configured_keyboards = ['us', 'br'],
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Ubuntu Mono",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.Clock(
                 foreground = colors[6],
                 format = "%a, %b %d - %H:%M",
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Ubuntu Mono",
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 14
                 ),
        widget.Systray(padding = 3),
        widget.Spacer(length = 7),
        ]
    return widgets_list

def init_widgets_screen1():
      widgets_screen1 = init_widgets_list()
      return widgets_screen1

# def init_widgets_screen2():
#      widgets_screen2 = init_widgets_list()
#      return widgets_screen2

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26)),
#        Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26)),
#        Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26))
]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
#    widgets_screen2 = init_widgets_screen2()

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="dialog"),         # dialog boxes
        Match(wm_class="download"),       # downloads
        Match(wm_class="error"),          # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class="notification"),   # notifications
        Match(wm_class='pinentry-gtk-2'), # GPG key password entry
        Match(wm_class="toolbar"),        # toolbars
        Match(wm_class="zenity"),         # Zenity popups
        Match(title="pinentry"),          # GPG key password entry
    ]
)

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

auto_minimize = True

# Wayland Settings

wl_input_rules = None

wl_xcursor_theme = None
wl_xcursor_size = 24

# Autostart

@hook.subscribe.startup_once
def autostart():
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
# wmname = LG3D

wmname = "Qtile"
