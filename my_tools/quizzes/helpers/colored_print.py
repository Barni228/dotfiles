from enum import Enum


class Color(Enum):
    BLACK = "\033[30m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN = "\033[36m"
    GREY = "\033[37m"
    RESET = "\033[0m"

    def __str__(self):
        return self.value


def print_colored(*text, color: Color, **kwargs):
    print(color, end="")
    print(*text, Color.RESET, **kwargs)
