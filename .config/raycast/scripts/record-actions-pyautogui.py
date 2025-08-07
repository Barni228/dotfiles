#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Record actions PyAutoGui
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎦
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description Generate PyAutoGui code to replicate everything you recorded

# type: ignore
from pynput import mouse, keyboard
import re
import pyperclip
import math

WAIT_TIME = 0.5
DRAG_SPEED = 800  # pixels per second
ALT_CHAR_MAP = {
    # alt
    "ç": "c",
    "å": "a",
    "∫": "b",
    "∂": "d",
    "´": "e",
    "ƒ": "f",
    "©": "g",
    "˙": "h",
    "î": "i",
    "∆": "j",
    "˚": "k",
    "¬": "l",
    "µ": "m",
    "˜": "n",
    "ø": "o",
    "π": "p",
    "œ": "q",
    "®": "r",
    "ß": "s",
    "†": "t",
    "¨": "u",
    "√": "v",
    "∑": "w",
    "≈": "x",
    "¥": "y",
    "Ω": "z",
    # alt shift
    "Ç": "C",
    "Å": "A",
    "„": "B",
    "Î": "I",
    "‰": "E",
    "ˇ": "F",
    "˘": "G",
    "⁄": "H",
    "Ó": "O",
    "Ò": "P",
    "Â": "Q",
    "¸": "R",
    "Í": "U",
    "Ï": "Y",
    "": "Z",
}
actions: list[str] = []
held_modifiers: set[keyboard.Key] = set()
drag_start: tuple[int, int] | None = None

modifier_keys = {
    keyboard.Key.ctrl: "ctrl",
    keyboard.Key.ctrl_l: "ctrl",
    keyboard.Key.ctrl_r: "ctrl",
    keyboard.Key.alt: "alt",
    keyboard.Key.alt_l: "alt",
    keyboard.Key.alt_r: "alt",
    keyboard.Key.cmd: "command",
    keyboard.Key.cmd_l: "command",
    keyboard.Key.cmd_r: "command",
    keyboard.Key.shift: "shift",
    keyboard.Key.shift_l: "shift",
    keyboard.Key.shift_r: "shift",
}


def get_held_modifiers() -> set[str]:
    return {modifier_keys[key] for key in held_modifiers}


def add_action(action: str) -> None:
    actions.append(action)


def on_click(x: int, y: int, button: mouse.Button, pressed: bool) -> None:
    global drag_start

    x, y = round(x), round(y)

    if pressed:
        drag_start = (x, y)
    else:
        # if we released at different location than where we pressed
        if drag_start is not None and (x, y) != drag_start:
            add_action(f"pyautogui.moveTo({drag_start[0]}, {drag_start[1]})")
            distance = math.dist(drag_start, (x, y))
            duration = distance / DRAG_SPEED
            add_action(
                f'pyautogui.dragTo({x}, {y}, duration={duration:.2f}, button="{button.name}")'
            )
        # if this is the same location
        else:
            if button == mouse.Button.left:
                add_action(f"pyautogui.click({x:.0f}, {y:.0f})")
            else:
                add_action(f'pyautogui.click({x:.0f}, {y:.0f}, button="{button.name}")')
        drag_start = None


def on_press(key: keyboard.Key) -> None:
    # ignore MacOS fn key
    if key_str(key) is None:
        return

    elif key == keyboard.Key.caps_lock:
        stop()
        # return false will stop the listener
        # but since we have multiple
        # return False

    elif key in modifier_keys:
        # there is a bug with MacOS where if you hold multiple modifiers,
        # when you release them it will say that you pressed them again
        # you can't press the same modifier (e.g. shift_r) twice without releasing first
        if key in held_modifiers:
            held_modifiers.remove(key)
            return

        # if we pressed shift and we are already holding shift, add wait
        if modifier_keys[key] == "shift" and "shift" in get_held_modifiers():
            add_action("pyautogui.sleep(WAIT_TIME)\n")

        held_modifiers.add(key)

    # if we hold modifiers other than shift, make this a hotkey
    elif (len(key_str(key)) == 1 and get_held_modifiers() - {"shift"}) or (
        len(key_str(key)) > 1 and get_held_modifiers()
    ):
        line = "pyautogui.hotkey("
        # order is which to press modifiers, so there is no `shift command` but `command shift`
        order = ["command", "ctrl", "alt", "shift"]
        for mod in order:
            if mod in get_held_modifiers():
                line += f'"{mod}", '

        line += f'"{key_str(key).lower()}")'
        add_action(line)

    else:
        add_action(f'pyautogui.press("{key_str(key)}")')


def on_release(key: keyboard.Key) -> None:
    if key in held_modifiers:
        held_modifiers.remove(key)


def stop() -> None:
    mouse_listener.stop()
    keyboard_listener.stop()

    output = [
        "import pyautogui\n",
        "# EXTREMELY IMPORTANT, ALWAYS ADD THIS",
        'pyautogui.press("shift")\n',
    ]

    if any("WAIT_TIME" in a for a in actions):
        output.append(f"WAIT_TIME = {WAIT_TIME}\n")

    output += actions

    make_nicer(output)
    final_code = "\n".join(output)
    pyperclip.copy(final_code)
    print("Generated code copied to clipboard.")


def make_nicer(actions: list[str]) -> None:
    combine_press_to_write(actions)
    combine_same(actions, "pyautogui.press", ", interval=0.1, presses={}")
    combine_same(actions, "pyautogui.click", ", interval=0.1, clicks={}")
    combine_same(actions, "pyautogui.sleep", " * {}")


def combine_press_to_write(actions: list[str]) -> None:
    PRESS_CHAR_REGEX = r'pyautogui\.press\("(.|space)"\)'
    PRESS_CHAR_REGEX_NO_SPACE = r'pyautogui\.press\("(.)"\)'

    i = 0
    # I don't wait it to combine press("space") press("space") into write("  ")
    while i < len(actions):
        if (
            i + 1 < len(actions)
            and re.fullmatch(PRESS_CHAR_REGEX_NO_SPACE, actions[i])
            and re.fullmatch(PRESS_CHAR_REGEX, actions[i + 1])
        ):
            actions[i] = 'pyautogui.write("' + re.fullmatch(
                PRESS_CHAR_REGEX_NO_SPACE, actions[i]
            ).group(1)
            while i + 1 < len(actions):
                match_ = re.fullmatch(PRESS_CHAR_REGEX, actions[i + 1])
                if not match_:
                    break

                # because we pop, no need to increment index
                actions.pop(i + 1)
                actions[i] += match_.group(1).replace("space", " ")

            actions[i] += '")'

        i += 1


def combine_same(actions: list[str], common_prefix: str, append: str) -> None:
    """
    Combine consecutive identical actions in the list that start with a given prefix.

    If the same action appears multiple times in a row, it's replaced with one line that includes
    the number of presses using the provided format string.

    Args:
        actions (list[str]): The list of recorded action strings.
        common_prefix (str): The prefix to match at the start of each action string.
        append (str): A format string like 'presses={}' to append the count of repeated actions.
    """
    i = 0
    while i + 1 < len(actions):
        if actions[i].startswith(common_prefix) and actions[i] == actions[i + 1]:
            presses = 2
            actions.pop(i + 1)
            while i + 1 < len(actions):
                if actions[i] == actions[i + 1]:
                    presses += 1
                    actions.pop(i + 1)
                else:
                    break

            # we might have a comment or "\n" after ")"
            before, parenthesis, after = actions[i].rpartition(")")
            actions[i] = before + append.format(presses) + parenthesis + after

        i += 1


def key_str(key: keyboard.Key) -> str:
    try:
        ch = key.char
        if ch in ALT_CHAR_MAP:
            return ALT_CHAR_MAP[ch]
        return ch
    except AttributeError:
        return key.name


# Start listeners
mouse_listener = mouse.Listener(on_click=on_click)
keyboard_listener = keyboard.Listener(on_press=on_press, on_release=on_release)
mouse_listener.start()
keyboard_listener.start()
mouse_listener.join()
keyboard_listener.join()
