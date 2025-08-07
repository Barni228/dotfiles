#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Run clipboard
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋
# @raycast.argument1 { "type": "text", "placeholder": "repeat", "optional": true }
# @raycast.argument2 { "type": "text", "placeholder": "delay", "optional": true }
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description Run copied code

import pyperclip
from sys import argv
import time

repeat = int(argv[1] or 1)
delay = float(argv[2] or 0.1)

# in case the code will copy something, we still run the code and not thing it copied
code = pyperclip.paste()

for i in range(repeat):
    time.sleep(delay)
    exec(code)

print("Done!", "✅" * repeat)
