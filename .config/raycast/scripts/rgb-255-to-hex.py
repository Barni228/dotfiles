#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title rgb 255 to hex
# @raycast.mode silent
# @raycast.refreshTime 1h

# Optional parameters:
# @raycast.icon 🎨

# Documentation:
# @raycast.description convert rgb to hex


from pyperclip import copy, paste
from re import findall

rgb = findall(r"\d+", paste())

if len(rgb) == 3:
    copy(f"{int(rgb[0]):02x}{int(rgb[1]):02x}{int(rgb[2]):02x}")
elif len(rgb) == 4:
    copy(f"{int(rgb[0]):02x}{int(rgb[1]):02x}{int(rgb[2]):02x}{int(rgb[3]):02x}")
else:
    print("Invalid RGB")
    quit(1)

print("Copied to clipboard🎨")
# copy("#%02x%02x%02x" % (int(rgb[0]), int(rgb[1]), int(rgb[2])))
