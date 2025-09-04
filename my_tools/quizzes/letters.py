#!/Users/andypukhalyk/my_tools/quizzes/.venv/bin/python3


from helpers import quiz
import argparse
import random

letters = {
    "a": 1,
    "b": 2,
    "c": 3,
    "d": 4,
    "e": 5,
    "f": 6,
    "g": 7,
    "h": 8,
    "i": 9,
    "j": 10,
    "k": 11,
    "l": 12,
    "m": 13,
    "n": 14,
    "o": 15,
    "p": 16,
    "q": 17,
    "r": 18,
    "s": 19,
    "t": 20,
    "u": 21,
    "v": 22,
    "w": 23,
    "x": 24,
    "y": 25,
    "z": 26,
}

max_time = len(letters)

bigger = "bg=+2>."
smaller = "sl-_1<,"


def main():
    global max_time

    parser = argparse.ArgumentParser(description="Letters to numbers quiz")
    parser.add_argument("-k", "--show-key", action="store_true", help="show the answer key and exit")
    parser.add_argument("-r", "--reverse", action="store_true", help="reverse the quiz (numbers to letters)")
    parser.add_argument(
        "-i",
        "--input",
        action="store_true",
        help="Use regular input, instead of fast input (you have to press enter)",
    )
    parser.add_argument("-u", "--uppercase", action="store_true", help="use uppercase letters")
    parser.add_argument(
        "-c",
        "--compare",
        action="store_true",
        help=f"compare letters to each other ([{bigger}] for bigger, [{smaller}] for smaller)",
    )
    questions = letters.copy()
    start_args = [quiz.fast_input, True]

    args = parser.parse_args()

    # first uppercase keys
    if args.uppercase:
        questions = {letter.upper(): num for letter, num in questions.items()}
    # then reverse, so we don't uppercase numbers
    if args.reverse:
        questions = {str(num): letter for letter, num in questions.items()}

    if args.compare:
        start_args = [quiz.char_input, False]
        max_time *= 2
        arr = [letter for letter in questions.keys()]
        questions = {}
        while len(questions) < len(letters):
            a = random.choice(arr)
            arr.remove(a)
            b = random.choice(arr)
            arr.append(a)
            questions[f"{a} {b}"] = list(bigger) if a > b else list(smaller)

    # then show key, so it can be uppercased and reversed
    if args.show_key:
        # # this line does nothing, except to make typechecker happy
        # questions = cast(dict[str | int, str | int], questions)
        quiz.print_answer_key(questions)
        return

    if args.input:
        start_args = []

    quiz.Quiz(questions, max_time=max_time).start(*start_args)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        quit(130)

    except EOFError:
        pass
