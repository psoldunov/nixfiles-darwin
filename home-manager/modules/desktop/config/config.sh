# New window spawns to the right or bottom of the current window
yabai -m config window_placement second_child

# Set all padding and gaps to 20pt (default: 0)
yabai -m config top_padding    8
yabai -m config bottom_padding 8
yabai -m config left_padding   8
yabai -m config right_padding  8
yabai -m config window_gap     8

# external bar settings
# yabai -m config external_bar all:38:0

yabai -m config window_zoom_persist on

# # on or off (default: off)
yabai -m config auto_balance off

# Floating point value between 0 and 1 (default: 0.5)
yabai -m config split_ratio 0.5

# set mouse to follow focus (default: off)
yabai -m config mouse_follows_focus off

# set mouse interaction modifier key (default: fn)
yabai -m config mouse_modifier alt

# set modifier + left-click drag to move window (default: move)
yabai -m config mouse_action1 move

# set modifier + right-click drag to resize window (default: resize)
yabai -m config mouse_action2 resize

# set focus follows mouse mode (default: off, options: off, autoraise, autofocus)
yabai -m config focus_follows_mouse autofocus

# space settings
# yabai -m space 1 --layout float

# topmost settings
yabai -m config window_topmost off

# shadow settings
yabai -m config window_shadow float

# Rules
yabai -m rule --add app='Plexamp' sticky=on