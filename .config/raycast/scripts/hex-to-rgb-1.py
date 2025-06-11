#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title hex to rgb 1
# @raycast.mode silent
# @raycast.refreshTime 1h

# Optional parameters:
# @raycast.icon 🎨

# Documentation:
# @raycast.description convert hex color to rgb color (0 to 1)


from pyperclip import copy, paste

hex = paste().strip()
hex = hex.lstrip("#")
if len(hex) == 3:
    RGB = int(hex[0] * 2, 16), int(hex[1] * 2, 16), int(hex[2] * 2, 16)
elif len(hex) == 6:
    RGB = int(hex[:2], 16), int(hex[2:4], 16), int(hex[4:6], 16)
else:
    print("Invalid hex code:", repr(hex))
    quit(1)
copy(f"{RGB[0] / 255}, {RGB[1] / 255}, {RGB[2] / 255}")
print("Copied to clipboard🎨")
