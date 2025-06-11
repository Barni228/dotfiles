#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Run clipboard
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description Run code in clipboard

import pyperclip

exec(pyperclip.paste())
