#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Spell Cheat Sheet
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Show VSCode spell checker cheat sheet

message = """\
You can add comment inline to only affect that line, or by itself to affect the rest of the file

hjkl # spell:ignore hjkl
hjkl

You can use cspell:, spell:, or spell-checker: as the prefix, case insensitive

Ignore words, so don't highlight them and don't suggest them
# spell:ignore word1 word2 word3

Make words correct, so they will be suggested
# spell:words word1 word2 word3

Make multiple words in one allowed, likethisone
# spell:enableCompoundWords

Ignore everything that matches a regex
# spell:ignoreRegExp 0x[0-9a-f]+     -- will ignore c style hex numbers
"""

print(message)
