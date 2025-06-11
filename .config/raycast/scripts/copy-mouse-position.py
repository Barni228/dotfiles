#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy Mouse Position
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖱️

# Documentation:
# @raycast.description Copy the current mouse position

import pyautogui
import pyperclip

x, y = pyautogui.position()
pyperclip.copy(f"{x}, {y}")

print(f"{x}, {y}")
