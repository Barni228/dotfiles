#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ask
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description THIS IS FOR MY DRIVING COURSE ONLY

import pyautogui

pyautogui.press("shift")

start_pos = 300, 285
end_pos = 1152, 832

pyautogui.PAUSE = 0.2

# this is my hotkey to copy text from image
pyautogui.hotkey("command", "shift", "7")
pyautogui.moveTo(*start_pos)
pyautogui.dragTo(*end_pos, duration=0.2, button="left")

pyautogui.hotkey("alt", "space")
pyautogui.hotkey("command", "v")
pyautogui.press("enter")
