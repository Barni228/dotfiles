#!/Users/andypukhalyk/python/venv/bin/python3


import argparse
import os
import sys
import hashlib


def main() -> None:
    parser = argparse.ArgumentParser(description="List files in directory with SHA256 hashes (parallel).")
    parser.add_argument("directory", help="Directory to scan")
    parser.add_argument("-o", "--output-file", type=str, default=None, help="Output file")
    parser.add_argument(
        "-l", "--length", type=int, default=-1, help="Length of hash to output, -1 for default"
    )
    parser.add_argument(
        "-0", "--no-hash", action="store_true", help="Do not generate hashes, just list files"
    )
    parser.add_argument("-a", "--all", action="store_true", help="Include hidden files")
    parser.add_argument("-s", "--separator", type=str, default="  ", help="Separator between hash and path")
    parser.add_argument("-q", "--quiet", action="store_true", help="Do not show progress bar")
    args = parser.parse_args()

    if not os.path.isdir(args.directory):
        print(f"Error: '{args.directory}' is not a directory", file=sys.stderr)
        sys.exit(1)

    file_paths: list[str] = []

    for root, dirs, files in os.walk(args.directory):
        # Remove hidden directories so os.walk won't enter them
        if not args.all:
            dirs[:] = [d for d in dirs if not d.startswith(".")]

        for name in files:
            if not args.all and name.startswith("."):
                continue
            path: str = os.path.join(root, name)
            # remove the './' because i don't like it
            path = path.removeprefix("./")
            file_paths.append(path)

    # sort files by their path
    file_paths.sort()

    lines: list[str] = []

    for path in file_paths:
        if not args.quiet:
            percentage = len(lines) / len(file_paths)
            bar_len = 20
            print(f"[{('=' * int(percentage * bar_len)).ljust(bar_len)}] {percentage * 100:.2f}%", end="\r")

        if args.no_hash:
            lines.append(path)
        else:
            lines.append(f"{hash_no_error(path, args.length)}{args.separator}{path}")

    if args.output_file is None:
        print(*lines, sep="\n")
    else:
        with open(args.output_file, "w", encoding="utf-8") as out_f:
            out_f.write("\n".join(lines) + "\n")


def hash_no_error(path: str, length: int = -1) -> str:
    """Hash a file and return the hash or an error message as string"""
    try:
        return hash_file(path, length)
    except Exception as e:
        return f"ERROR: {e}"


def hash_file(path: str, length: int = -1) -> str:
    """Hash a file and return the hash as string, or exception"""
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)

    hash = h.hexdigest()
    if length != -1:
        hash = hash[:length]

    return hash


if __name__ == "__main__":
    main()
