#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title AutoClicker
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 👆
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description Click the mouse as fast as possible

# type: ignore
from pynput import keyboard
from pynput.mouse import Controller, Button

import threading

# clicking with pynput is 20x faster than pyautogui (even with PAUSE = 0)
mouse = Controller()

clicking = False
running = True


def on_press(key):
    global clicking
    if key == keyboard.Key.shift_l or key == keyboard.Key.shift_r:
        clicking = True
    # elif key == keyboard.Key.caps_lock:
    #     running = False
    #     return False


def on_release(key):
    global running
    if key == keyboard.Key.shift_l or key == keyboard.Key.shift_r:
        # clicking = False
        running = False
        return False


def click_loop():
    global running, clicking

    while running:
        if clicking:
            mouse.click(Button.left)

    print("Stopped 🛑")


thread = threading.Thread(target=click_loop)
thread.start()

with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()
