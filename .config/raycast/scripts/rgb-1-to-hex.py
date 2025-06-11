#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title rgb 1 to hex
# @raycast.mode silent
# @raycast.refreshTime 1h

# Optional parameters:
# @raycast.icon 🎨

# Documentation:
# @raycast.description convert rgb 1 to hex


from pyperclip import copy, paste
from re import findall

rgb = findall(r"[0-9.]+", paste())
rgb = list(map(float, rgb))

if len(rgb) == 3:
    copy(f"#{round(rgb[0] * 255):02x}{round(rgb[1] * 255):02x}{round(rgb[2] * 255):02x}")
elif len(rgb) == 4:
    copy(
        f"#{round(rgb[0] * 255):02x}{round(rgb[1] * 255):02x}{round(rgb[2] * 255):02x}{round(rgb[3] * 255):02x}"
    )
else:
    print("Invalid RGB")
    quit(1)

print("Copied to clipboard🎨")
