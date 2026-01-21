#!/Users/andypukhalyk/my_tools/quizzes/.venv/bin/python3

from helpers import quiz
import argparse

months = {
    "January": "1",
    "February": "2",
    "March": "3",
    "April": "4",
    "May": "5",
    "June": "6",
    "July": "7",
    "August": "8",
    "September": "9",
    "October": "10",
    "November": "11",
    "December": "12",
}

# 1 seconds per question
max_time = len(months)

max_len = max(len(k) for k in months)
months_equal_space = {month.ljust(max_len, " "): num for month, num in months.items()}


def main():
    parser = argparse.ArgumentParser(description="Months to numbers quiz")
    # TODO
    parser.add_argument("-k", "--show-key", action="store_true", help="show the answer key and exit")
    parser.add_argument(
        "-i",
        "--input",
        action="store_true",
        help="Use regular input, instead of fast input (you have to press enter)",
    )
    questions = months_equal_space.copy()
    start_args = [quiz.fast_input, True]
    args = parser.parse_args()

    if args.show_key:
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
