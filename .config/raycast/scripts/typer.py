#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Typer
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⌨️
# @raycast.argument1 { "type": "text", "placeholder": "delay", "optional": true }

# Documentation:
# @raycast.description Type text from clipboard with insane speed

from sys import argv
import pyperclip
import pyautogui
import time

if len(argv) > 1 and argv[1].isdigit():
    time.sleep(int(argv[1]))
else:
    time.sleep(0.1)  # default

# for some reason, first time pyautogui presses a button it does something weird (always lowercase),
# so if we first press shift and release it, nothing should happen
# but other keys will no longer be first thing to be pressed so they will work as expected
pyautogui.press("shift")

pyautogui.write(pyperclip.paste())
