#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# type: ignore
# spell:ignore CGHID

# TODO: make a functions that would translate pyautogui code to this

# sleep will be exposed as auto.sleep
from time import sleep
from contextlib import contextmanager
import re

from typing import overload, Literal
import Quartz
from Quartz.CoreGraphics import (
    CGEventCreateKeyboardEvent,
    CGEventPost,
    kCGHIDEventTap,
    CGEventCreateMouseEvent,
    CGPoint,
    kCGEventMouseMoved,
    kCGEventLeftMouseDown,
    kCGEventLeftMouseUp,
    kCGEventRightMouseDown,
    kCGEventRightMouseUp,
    kCGEventOtherMouseDown,
    kCGEventOtherMouseUp,
)

# --- Global pause and fail-safe ---
PAUSE: float = 0.2
FAILSAFE: bool = True
FAILSAFE_POINT: tuple[int, int] = (0, 0)

KEY_MAP: dict[str, int] = {
    "a": 0,
    "b": 11,
    "c": 8,
    "d": 2,
    "e": 14,
    "f": 3,
    "g": 5,
    "h": 4,
    "i": 34,
    "j": 38,
    "k": 40,
    "l": 37,
    "m": 46,
    "n": 45,
    "o": 31,
    "p": 35,
    "q": 12,
    "r": 15,
    "s": 1,
    "t": 17,
    "u": 32,
    "v": 9,
    "w": 13,
    "x": 7,
    "y": 16,
    "z": 6,
    "0": 29,
    "1": 18,
    "2": 19,
    "3": 20,
    "4": 21,
    "5": 23,
    "6": 22,
    "7": 26,
    "8": 28,
    "9": 25,
    "-": 27,
    "=": 24,
    "[": 33,
    "]": 30,
    "\\": 42,
    ";": 41,
    "'": 39,
    ",": 43,
    ".": 47,
    "/": 44,
    "tab": 48,
    "\t": 48,
    "space": 49,
    " ": 49,
    "return": 36,
    "enter": 36,
    "\n": 36,
    "backspace": 51,
    "delete": 117,
    "del": 117,
    "esc": 53,
    "up": 126,
    "down": 125,
    "left": 123,
    "right": 124,
    "capslock": 57,  # of course pressing capslock would not work
    "shift": 56,
    "shift_l": 56,
    "shift_r": 60,
    "ctrl": 59,
    "ctrl_l": 59,
    "ctrl_r": 62,
    "alt": 58,
    "alt_l": 58,
    "alt_r": 61,
    "cmd": 55,
    "command": 55,
    "cmd_l": 55,
    "cmd_r": 55,
    "win": 55,
    "f1": 122,
    "f2": 120,
    "f3": 99,
    "f4": 118,
    "f5": 96,
    "f6": 97,
    "f7": 98,
    "f8": 100,
    "f9": 101,
    "f10": 109,
    "f11": 103,
    "f12": 111,
    "f13": 105,
    "f14": 107,
    "f15": 113,
    "f16": 106,
    "f17": 64,
    "f18": 79,
    "f19": 80,
    "f20": 90,
}

button_map: dict[str, tuple[int, int, int]] = {
    "left": (kCGEventLeftMouseDown, kCGEventLeftMouseUp, Quartz.kCGMouseButtonLeft),
    "right": (
        kCGEventRightMouseDown,
        kCGEventRightMouseUp,
        Quartz.kCGMouseButtonRight,
    ),
    "middle": (kCGEventOtherMouseDown, kCGEventOtherMouseUp, 2),
}


# region Quartz low level code
def _key_down(key_name: str) -> None:
    if key_name in KEY_MAP:
        down = CGEventCreateKeyboardEvent(None, KEY_MAP[key_name], True)
        CGEventPost(kCGHIDEventTap, down)
    elif len(key_name) == 1:
        event = Quartz.CGEventCreateKeyboardEvent(None, 0, True)
        Quartz.CGEventKeyboardSetUnicodeString(event, len(key_name), key_name)
        CGEventPost(kCGHIDEventTap, event)
    else:
        raise ValueError(f"Unknown key: {key_name}")

    sleep(0.02)


def _key_up(key_name: str) -> None:
    if key_name in KEY_MAP:
        down = CGEventCreateKeyboardEvent(None, KEY_MAP[key_name], False)
        CGEventPost(kCGHIDEventTap, down)
    elif len(key_name) == 1:
        event = Quartz.CGEventCreateKeyboardEvent(None, 0, False)
        Quartz.CGEventKeyboardSetUnicodeString(event, len(key_name), key_name)
        CGEventPost(kCGHIDEventTap, event)
    else:
        raise ValueError(f"Unknown key: {key_name}")

    sleep(0.02)


def _move_to(x: int, y: int) -> None:
    evt = CGEventCreateMouseEvent(None, kCGEventMouseMoved, CGPoint(x, y), 0)
    CGEventPost(kCGHIDEventTap, evt)


def _mouse_button_down(
    x: int, y: int, button: Literal["left", "right", "middle"] = "left"
) -> None:
    if button not in button_map:
        raise ValueError(f"Unknown button: {button}")
    down_evt, _, btn = button_map[button]
    down = CGEventCreateMouseEvent(None, down_evt, CGPoint(x, y), btn)
    CGEventPost(kCGHIDEventTap, down)

    sleep(0.02)


def _mouse_button_up(
    x: int, y: int, button: Literal["left", "right", "middle"] = "left"
) -> None:
    if button not in button_map:
        raise ValueError(f"Unknown button: {button}")
    _, up_evt, btn = button_map[button]
    up = CGEventCreateMouseEvent(None, up_evt, CGPoint(x, y), btn)
    CGEventPost(kCGHIDEventTap, up)

    sleep(0.02)


# endregion


def _check_fail_safe() -> None:
    if FAILSAFE and position() == FAILSAFE_POINT:
        raise Exception("Fail-safe triggered from mouse being at top-left corner")


# region --- Keyboard ---
def press(key_name: str, /, repeat: int = 1, interval: float = 0) -> None:
    """Press and release a key one or more times."""

    _check_fail_safe()
    for _ in range(repeat):
        _key_down(key_name)
        _key_up(key_name)
        sleep(interval)
    sleep(PAUSE)


def hotkey(*keys: str, repeat: int = 1, interval: float = 0) -> None:
    """Press multiple keys simultaneously (modifier combos)."""

    _check_fail_safe()
    for _ in range(repeat):
        for key in keys:
            _key_down(key)
            # MacOS is a little slow so we need to give it some time to see the modifiers pressed
            sleep(0.04)

        for key in reversed(keys):
            _key_up(key)

        sleep(interval)

    sleep(PAUSE)


def write(text: str, interval: float = 0) -> None:
    """Type out a string by pressing each character in order."""
    _check_fail_safe()
    for char in text:
        _key_down(char)
        _key_up(char)
        sleep(interval)
    sleep(PAUSE)


# endregion

# region --- Mouse ---


@overload
def click(
    repeat: int = 1,
    interval: float = 0,
    button: Literal["left", "right", "middle"] = "left",
) -> None: ...


@overload
def click(
    x: int,
    y: int,
    /,
    repeat: int = 1,
    interval: float = 0,
    button: Literal["left", "right", "middle"] = "left",
) -> None: ...


@overload
def click(
    pos: tuple[int, int],
    /,
    repeat: int = 1,
    interval: float = 0,
    button: Literal["left", "right", "middle"] = "left",
) -> None: ...


def click(
    *args,
    repeat: int = 1,
    interval: float = 0,
    button: Literal["left", "right", "middle"] = "left",
):
    """Click the mouse at given coordinates, tuple, or current position."""

    _check_fail_safe()
    match args:
        case [int() as x, int() as y]:
            x, y = x, y
        case [(int() as x, int() as y)]:
            x, y = x, y
        case []:
            x, y = position()

    for _ in range(repeat):
        _mouse_button_down(x, y, button)
        _mouse_button_up(x, y, button)
        sleep(interval)

    sleep(PAUSE)


@overload
def move(
    x: int,
    y: int,
    /,
    duration: float = 0.5,
    steps: int = 20,
) -> None: ...


@overload
def move(
    to: tuple[int, int],
    /,
    duration: float = 0.5,
    steps: int = 20,
) -> None: ...


def move(
    *args,
    duration: float = 0.0,
    steps: int = 20,
) -> None:
    _check_fail_safe()

    x1, y1 = position()
    match args:
        case [(int() as x2, int() as y2)]:
            x2, y2 = x2, y2
        case [int() as x2, int() as y2]:
            x2, y2 = x2, y2
        case _:
            raise TypeError("drag_to() takes 2 tuples or 4 integers")

    if duration == 0.0:
        _move_to(x2, y2)
        return

    for i in range(1, steps + 1):
        xi = x1 + (x2 - x1) * i / steps
        yi = y1 + (y2 - y1) * i / steps
        _move_to(xi, yi)
        sleep(duration / steps)
    sleep(PAUSE)


@overload
def drag(
    x1: int,
    y1: int,
    x2: int,
    y2: int,
    button: Literal["left", "right", "middle"] = "left",
    duration: float = 0.5,
    steps: int = 20,
) -> None: ...


@overload
def drag(
    from_: tuple[int, int],
    to: tuple[int, int],
    button: Literal["left", "right", "middle"] = "left",
    duration: float = 0.5,
    steps: int = 20,
) -> None: ...


def drag(
    *args,
    button: Literal["left", "right", "middle"] = "left",
    duration: float = 0.5,
    steps: int = 20,
) -> None:
    """Drag the mouse from point A to B using smooth movement."""
    _check_fail_safe()

    match args:
        case [(int() as x1, int() as y1), (int() as x2, int() as y2)]:
            x1, y1, x2, y2 = x1, y1, x2, y2
        case [int() as x1, int() as y1, int() as x2, int() as y2]:
            x1, y1, x2, y2 = x1, y1, x2, y2
        case _:
            raise TypeError("drag_to() takes 2 tuples or 4 integers")

    _mouse_button_down(x1, y1, button)

    for i in range(1, steps + 1):
        xi = x1 + (x2 - x1) * i / steps
        yi = y1 + (y2 - y1) * i / steps
        _move_to(xi, yi)
        sleep(duration / steps)

    _mouse_button_up(x2, y2, button)
    sleep(PAUSE)


# endregion


# --- Utilities ---


def position() -> tuple[int, int]:
    """Return the current mouse cursor position."""
    loc = Quartz.CGEventGetLocation(Quartz.CGEventCreate(None))
    return int(loc.x), int(loc.y)


def size() -> tuple[int, int]:
    """Return the width and height of the main display."""
    main_display = Quartz.CGMainDisplayID()
    bounds = Quartz.CGDisplayBounds(main_display)
    return int(bounds.size.width), int(bounds.size.height)


# --- Context manager for holding a key ---


@contextmanager
def hold(key: str):
    """
    Hold down a key for the duration of the context block.

    Example:
        with hold("shift"):
            print("Shift is held!")
    """
    _key_down(key)
    try:
        yield
    finally:
        _key_up(key)


def from_pyautogui(code: str) -> str:
    new_code: list[str] = []
    lines = code.splitlines()

    INT = r"-?\d+"
    FLOAT = r"-?\d*\.\d+"
    NUMBER = rf"{INT}|{FLOAT}"
    STR = r"\".*\"|\"{3}.*\"{3}|\'.*\'|\'{3}.*\'{3}"
    VARIABLE = r"[_a-zA-Z][_a-zA-Z0-9]*"
    SOMETHING = rf"({NUMBER}|{STR}|{VARIABLE})"

    i = 0
    while i < len(lines):
        if not lines[i].lstrip().startswith("pyautogui."):
            new_code.append(lines[i])
            i += 1
            continue

        line: str = re.match(r"\s*", lines[i]).group()
        lines[i] = lines[i].lstrip()

        if lines[i].startswith("pyautogui.press"):
            line += "auto.press("
            line += re.search(r'"."', lines[i]).group()
            if "presses" in lines[i]:
                line += ", repeat="
                line += re.search(rf"presses\s*=\s*({INT})", lines[i]).group(1)
            if "interval" in lines[i]:
                line += ", interval="
                line += re.search(rf"interval\s*=\s*({FLOAT})", lines[i]).group(1)

        elif lines[i].startswith(("pyautogui.write", "pyautogui.typewrite")):
            line += "auto.write("
            line += re.search(rf"{STR}", lines[i]).group()
            if "interval" in lines[i]:
                line += ", interval="
                line += re.search(rf"interval\s*=\s*({FLOAT})", lines[i]).group(1)

        elif lines[i].startswith("pyautogui.hotkey"):
            line += "auto.hotkey("
            line += re.search(rf"({STR},?\s*)+", lines[i]).group()
            if "interval" in lines[i]:
                line += ", interval="
                line += re.search(rf"interval\s*=\s*({FLOAT})", lines[i]).group(1)

        line += ")"
        new_code.append(line)

        i += 1

    return "\n".join(new_code)
