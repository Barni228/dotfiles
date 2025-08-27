#!/Users/andypukhalyk/my_tools/quizzes/.venv/bin/python3

# spell:ignore qwertyuiopasdfghjklzxcvbnm

import re

# import helpers.quiz as quiz

from helpers import quiz
import argparse

MAX_TIME = 50


MORSE_TO_LETTER = {
    " ": " ",
    "ඞ": " ",
    ".-": "a",
    "-...": "b",
    "-.-.": "c",
    "-..": "d",
    ".": "e",
    "..-.": "f",
    "--.": "g",
    "....": "h",
    "..": "i",
    ".---": "j",
    "-.-": "k",
    ".-..": "l",
    "--": "m",
    "-.": "n",
    "---": "o",
    ".--.": "p",
    "--.-": "q",
    ".-.": "r",
    "...": "s",
    "-": "t",
    "..-": "u",
    "...-": "v",
    ".--": "w",
    "-..-": "x",
    "-.--": "y",
    "--..": "z",
    ".----": "1",
    "..---": "2",
    "...--": "3",
    "....-": "4",
    ".....": "5",
    "-....": "6",
    "--...": "7",
    "---..": "8",
    "----.": "9",
    "-----": "0",
    "..--..": "?",
    "-.-.--": "!",
    ".-.-.-": ".",
    "--..--": ",",
    "-.-.-.": ";",
    "---...": ":",
    ".-.-.": "+",
    "-....-": "-",
    "-..-.": "/",
    "-...-": "=",
}
LETTER_TO_MORSE = {v: k for k, v in MORSE_TO_LETTER.items()}

SELECT_MESSAGE = """\
1 - morse to letter
2 - letter to morse
3 - translate: """


def processMorse(morse: str) -> str:
    table = morse.maketrans({"…": "...", "—": "--", "_": "-", "–": "-"})
    return morse.translate(table)


def morse_to_text(morse: str) -> str:
    result = ""
    morse = morse.replace("  ", " ඞ ")
    for i in morse.split():
        result += MORSE_TO_LETTER.get(i) or ""

    return result.replace(" ඞ ", " ")


def text_to_morse(text: str) -> str:
    return " ".join(LETTER_TO_MORSE[i] for i in text)


def morse_trans(text: str) -> str:
    text = re.sub(r"\s", " ", text)
    morse = processMorse(text)
    if re.search(r"[^-.\s]", morse):
        return text_to_morse(text)
    else:
        return morse_to_text(morse)


def main() -> None:
    parser = argparse.ArgumentParser(description="Morse code translator")
    parser.add_argument(
        "mode",
        help="What to do (possible modes: 1, 2, 3)",
        type=int,
        choices=(1, 2, 3),
        nargs="?",
    )

    parser.add_argument("-l", "--lock", action="store_true", help="Don't ask to switch to other modes")

    parser.add_argument("-t", "--translate", type=str, help="Translate text")

    parser.add_argument("-1", "--once", action="store_true", help="Stop after first exercise")

    parser.add_argument("-y", "--yes", action="store_true", help='Always say "y" to "Again?: " prompt')

    args = parser.parse_args()

    if args.translate:
        print(morse_trans(args.translate))
        return

    running = True
    ask = True

    if args.mode:
        mode = str(args.mode)
        ask = False

    try:
        while running:
            if ask:
                mode = quiz.choice_input(SELECT_MESSAGE, "123q", quiz.char_input)

            match mode:  # type: ignore
                case "1":
                    game = quiz.Quiz({k: v for k, v in MORSE_TO_LETTER.items() if v.isalpha()}, MAX_TIME)

                    def input_f(prompt):
                        return quiz.choice_input(
                            prompt,
                            values="qwertyuiopasdfghjklzxcvbnm",
                            input_f=quiz.char_input,
                        )

                    game.start(
                        input_f,
                    )

                case "2":
                    game = quiz.Quiz({v: k for k, v in MORSE_TO_LETTER.items() if v.isalpha()}, MAX_TIME)

                    def input_f(prompt):
                        return quiz.choice_input(
                            prompt,
                            values={k for k, v in MORSE_TO_LETTER.items() if v.isalpha()},
                        )

                    game.start(input_f)

                case "3":
                    print(morse_trans(input("What to translate: ")))

                case "q":
                    return

            if args.once:
                return

            elif args.lock:
                ask = False

            if not args.yes:
                running = quiz.char_input("Again?: ").lower() == "y"

            else:
                running = True
                print()

    except KeyboardInterrupt:
        print("^C")
        quit(130)
    except EOFError:
        print("^D")
        # quit(2)


if __name__ == "__main__":
    main()
