#!/Users/andypukhalyk/my_tools/quizzes/.venv/bin/python3


import argparse
import os

quiz_commands = [
    "letters",
    "letters -r",
    "letters -c",
    "months",
    "morse -1l 1",
    "morse -1l 2",
    "letters -c",
    "echo All Done!",
]

quiz_indexes = []

for i in range(len(quiz_commands)):
    quiz_indexes.append(str(i + 1))

for i in range(len(quiz_commands)):
    quiz_indexes.append(chr(ord("a") + i))


def get_cmd(q: str) -> str:
    if q.isdigit():
        i = int(q) - 1
    else:
        i = ord(q) - ord("a")

    return quiz_commands[i]


def main():
    parser = argparse.ArgumentParser(description="run all quizzes")
    parser.add_argument("quiz", help="quiz to run", type=str, choices=quiz_indexes, nargs="?")
    parser.add_argument("-k", "--show-key", action="store_true", help="print all quiz commands")
    parser.add_argument("-p", "--print", action="store_true", help="print the quiz that is running")

    args = parser.parse_args()

    if args.show_key:
        if args.quiz:
            print(get_cmd(args.quiz))
        else:
            for i, cmd in enumerate(quiz_commands):
                print(f"{chr(ord('a') + i)}. {cmd}")
        return

    if not args.quiz:
        parser.error("the following argument is required: quiz")

    cmd = get_cmd(args.quiz)
    if args.print:
        print(cmd)

    cmd_arr = cmd.split()

    os.execvp(cmd_arr[0], cmd_arr)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        quit(130)

    except EOFError:
        pass
