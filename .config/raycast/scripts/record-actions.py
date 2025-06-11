#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Record actions
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🎦
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description Generate pyautogui code to replicate everything you recorded

# TODO: add scrolling
# TODO: make it not have multiple `click` calls if you click the same place multiple times

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
typed_chars: str = ""
held_modifiers: set[str] = set()
add_wait_next: bool = False
next_shift_ignore: bool = False
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


def add_action(action: str) -> None:
    flush_typing()
    actions.append(action)


def flush_typing() -> None:
    global typed_chars
    if typed_chars:
        actions.append(f'pyautogui.write("{typed_chars}")')
        typed_chars = ""


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
            add_action(f"pyautogui.dragTo({x}, {y}, duration={duration:.2f})")
        # if this is the same location
        else:
            if button == mouse.Button.left:
                add_action(f"pyautogui.click({x:.0f}, {y:.0f})")
            else:
                add_action(f'pyautogui.click({x:.0f}, {y:.0f}, button="{button.name}")')
        drag_start = None


# Scroll event handler
def on_scroll(x: int, y: int, dx: int, dy: int) -> None:
    flush_typing()
    # direction = "up" if dy > 0 else "down"
    for _ in range(abs(dy)):
        add_action(f"pyautogui.scroll({dy}, x={x:.0f}, y={y:.0f})")


def on_press(key: keyboard.Key) -> None:
    global add_wait_next, typed_chars, next_shift_ignore

    # ignore MacOS fn key
    if key_str(key) is None:
        return

    if key_str(key) == "shift" and next_shift_ignore:
        next_shift_ignore = False
        return

    if key == keyboard.Key.caps_lock:
        flush_typing()
        stop()
        return

    if key in modifier_keys:
        key_name = modifier_keys[key]

        if key_name == "shift" and "shift" in held_modifiers:
            next_shift_ignore = True
            add_action("pyautogui.sleep(WAIT_TIME)\n")

        # there is a bug with MacOS where if you hold multiple modifiers,
        # when you release them it will say that you pressed them again
        if key_name in held_modifiers:
            held_modifiers.remove(key_name)
            return

        held_modifiers.add(key_name)
        return

    # if we hold modifiers other than shift, make this a hotkey
    if held_modifiers - {"shift"}:
        line = "pyautogui.hotkey("
        # order is which to press modifiers, so there is no `shift command` but `command shift`
        order = ["command", "ctrl", "alt", "shift"]
        for mod in order:
            if mod in held_modifiers:
                line += f'"{mod}", '

        line += f'"{key_str(key).lower()}")'
        add_action(line)
        return

    if len(key_str(key)) == 1:
        typed_chars += key_str(key)

    elif key == keyboard.Key.space:
        typed_chars += " "

    else:
        flush_typing()
        add_action(f'pyautogui.press("{key_str(key)}")')


def on_release(key: keyboard.Key) -> None:
    if key in modifier_keys and modifier_keys[key] in held_modifiers:
        held_modifiers.remove(modifier_keys[key])


def stop() -> None:
    flush_typing()
    mouse_listener.stop()
    keyboard_listener.stop()

    # EXTREMELY IMPORTANT
    output = [
        "import pyautogui\n",
        "# EXTREMELY IMPORTANT, ALWAYS ADD THIS",
        'pyautogui.press("shift")\n',
    ]
    if any("WAIT_TIME" in a for a in actions):
        output.append(f"WAIT_TIME = {WAIT_TIME}\n")

    output += actions
    output += [
        "",
        "# Confirmation code",
        'pyautogui.hotkey("command", "space")',
        # 'pyautogui.write("Enter Text")',
        # 'pyautogui.press("enter")',
        'pyautogui.write("Done!")',
        # 'pyautogui.hotkey("command", "enter")',
    ]
    make_nicer(output)
    final_code = "\n".join(output)
    pyperclip.copy(final_code)
    print("Generated code copied to clipboard.")


def make_nicer(actions: list[str]) -> None:
    index = 0

    INTGER = r"-?\d+"
    while index < len(actions):
        action = actions[index]
        if action.startswith("pyautogui.scroll"):
            dy, x, y = re.search(
                rf"({INTGER}), x=({INTGER}), y=({INTGER})", action
            ).groups()
            dy = int(dy)
            actions.pop(index)
            while True:
                if index >= len(actions):
                    break

                if not actions[index].startswith("pyautogui.scroll"):
                    break

                dy2, x2, y2 = re.search(
                    rf"({INTGER}), x=({INTGER}), y=({INTGER})", actions[index]
                ).groups()
                if x != x2 or y != y2:
                    break

                print(dy2)
                dy += int(dy2)
                actions.pop(index)

            actions.insert(index, f"pyautogui.scroll({dy}, x={x}, y={y})")

        index += 1

    # for i, action in enumerate(actions):
    #     # replace pyautogui.write(" ") with pyautogui.press('space')
    #     action = action.replace('pyautogui.write(" ")', "pyautogui.press('space')")
    #     # replace pyautogui.write("a") with pyautogui.press("a")
    #     action = re.sub(r'pyautogui\.write\("(.)"\)', 'pyautogui.press("\1")', action)
    #     actions[i] = action


def key_str(key: keyboard.Key) -> str:
    try:
        ch = key.char  # type: ignore
        if ch in ALT_CHAR_MAP:
            return ALT_CHAR_MAP[ch]
        return ch
    except AttributeError:
        return key.name


# Start listeners
mouse_listener = mouse.Listener(on_click=on_click, on_scroll=on_scroll)
keyboard_listener = keyboard.Listener(on_press=on_press, on_release=on_release)  # type: ignore
mouse_listener.start()
keyboard_listener.start()
mouse_listener.join()
keyboard_listener.join()
