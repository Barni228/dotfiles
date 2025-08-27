# spell:ignore tcgetattr TCSADRAIN tcsetattr
import tty
import termios
import sys
from . import colored_print


from random import shuffle
from time import time
from typing import TypeVar
from collections.abc import Iterable, Mapping, Callable

T = TypeVar("T")
StrInt = str | int

# Mapping[StrInt, StrInt | Iterable[StrInt]], but it is more explicit because type checker gets confused
Ignore = (
    dict[str, str]
    | dict[str, int]
    | dict[str, Iterable[str]]
    | dict[str, Iterable[int]]
    | dict[int, str]
    | dict[int, int]
    | dict[int, Iterable[str]]
    | dict[int, Iterable[int]]
)

SCORE_MESSAGE = """
Time:     {}s
Correct:  {}/{}
Accuracy: {}%
"""[1:-1]


def choice_input(prompt: str, values: Iterable[T], input_f: Callable[..., T] = input) -> T:
    while (k := input_f(prompt)) not in values:
        continue
    else:
        return k


def char_input(prompt, chars=1) -> str:
    print(prompt, end="", flush=True)
    fd = sys.stdin.fileno()
    text = ""
    for _ in range(chars):
        old_set = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            char = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_set)
        if ord(char) == 3:  # ctrl-c
            raise KeyboardInterrupt
        elif ord(char) == 4:  # ctrl-d
            raise EOFError
        text += char
        print(char, end="", flush=True)
    print(flush=True)
    return text


def fast_input(prompt: str, stop: StrInt | Iterable[StrInt] | Callable[[str], bool] | None = None) -> str:
    print(prompt, end="", flush=True)
    typed = ""

    # Save terminal settings
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setcbreak(fd)  # Disable line buffering
        while True:
            ch = sys.stdin.read(1)
            if ch == "\x7f":  # Backspace
                if typed:
                    typed = typed[:-1]
                    # \b moves cursor left by one character, so we override it with a space
                    sys.stdout.write("\b \b")
                    sys.stdout.flush()
            elif ch == "\n":
                print()
                return typed
            elif ch == "\x04":
                sys.stdout.write("^D\n")
                sys.stdout.flush()
                raise EOFError
            else:
                typed += ch
                sys.stdout.write(ch)
                sys.stdout.flush()
                if (
                    (isinstance(stop, StrInt) and same(typed, stop))
                    # if it is iterable, but not a string (str is Iterable)
                    or (
                        isinstance(stop, Iterable)
                        and not isinstance(stop, str)
                        and any([same(typed, j) for j in stop])
                    )
                    or (isinstance(stop, Callable) and stop(typed))
                ):
                    print()
                    return typed
    except KeyboardInterrupt:
        sys.stdout.write("^C\n")
        sys.stdout.flush()
        raise KeyboardInterrupt
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


def print_answer_key(questions: Mapping[StrInt, StrInt | Iterable[StrInt]] | Ignore) -> None:
    longest = max(len(str(question)) for question in questions)
    questions = {str(question).ljust(longest): answer for question, answer in questions.items()}
    for question, answer in questions.items():
        if isinstance(answer, StrInt):
            print(f"{question} = {answer}")
        else:
            print(f"{question} = {' | '.join(str(ans) for ans in answer)}")


class Quiz:
    def __init__(
        self, questions: Mapping[StrInt, StrInt | Iterable[StrInt]] | Ignore, max_time: float | None = None
    ) -> None:
        self.game: list[tuple[StrInt, StrInt | Iterable[StrInt]]] = [(i, questions[i]) for i in questions]  # type: ignore
        shuffle(self.game)
        self.len = len(self.game)
        self.index = -1
        self.score = 0
        self.max_time = max_time

    def __iter__(self):
        return self

    def __next__(self) -> tuple[StrInt, StrInt | Iterable[StrInt]]:
        self.index += 1
        if self.index < self.len:
            return self.game[self.index]
        else:
            raise StopIteration

    def start(self, input_f: Callable[..., str] = input, give_input_answer: bool = False) -> None:
        s = time()
        for i in self:
            if give_input_answer:
                guess = input_f(f"{i[0]}\t", i[1])
            else:
                guess = input_f(f"{i[0]}\t")
            if (
                (isinstance(i[1], StrInt) and same(guess, i[1]))
                # or (not isinstance(i[1], str) and guess in i[1])
                or (
                    not isinstance(i[1], str)
                    and isinstance(i[1], Iterable)
                    and any([same(guess, j) for j in i[1]])
                )
            ):
                self.score += 1
            else:
                colored_print.print_colored(" Wrong!", color=colored_print.Color.RED)
        print(scoreFormat(time() - s, self.score, self.len, self.max_time))


def scoreFormat(time_: float, score: int, max_score: int, max_time: float | None = None) -> str:
    if max_time is not None and time_ > max_time:
        time_color = colored_print.Color.RED
    else:
        time_color = colored_print.Color.BLUE

    if score >= max_score:
        score_color = colored_print.Color.BLUE
    else:
        score_color = colored_print.Color.RED
    reset = colored_print.Color.RESET

    return SCORE_MESSAGE.format(
        f"{time_color}{round(time_)}{reset}",
        f"{score_color}{score}{reset}",
        f"{score_color}{max_score}{reset}",
        f"{score_color}{round(score / max_score * 100)}{reset}",
    )


def same(a: StrInt, b: StrInt) -> bool:
    try:
        return int(a) == int(b)
    except ValueError:
        return str(a) == str(b)
