#!/Users/andypukhalyk/.dotfiles/.config/raycast/scripts/venv/bin/python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Regex Cheat Sheet
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🔤

# Documentation:
# @raycast.description Show common regular expression syntax and examples

message = r"""
🔍 **Regex Cheat Sheet**

**Basic Syntax**
.        # Any character except newline
^        # Start of string
$        # End of string
*        # 0 or more repetitions (greedy)
+        # 1 or more repetitions (greedy)
?        # 0 or 1 repetition (greedy)
*?, +?, ??  # Non-greedy versions — match as little as possible
{n}      # Exactly n repetitions
{n,}     # n or more repetitions
{n,m}    # Between n and m repetitions

**Character Classes**
\d       # Digit [0-9]
\D       # Not digit
\w       # Word character [a-zA-Z0-9_]
\W       # Not word character
\s       # Whitespace
\S       # Not whitespace
[abc]    # a, b, or c
[^abc]   # Not a, b, or c
[a-z]    # Range from a to z

**Anchors**
^abc     # Match "abc" at the start of string
abc$     # Match "abc" at the end of string
\b       # Word boundary
\B       # Not a word boundary

**Groups & Lookarounds**
(...)          # Capturing group: (\d+) on "Item 42" → "42"
(?P<name>...)  # Named group: (?P<year>\d{4}) on "2025-08-06" → year="2025"
(?:...)        # Non-capturing group: (?:abc)+ on "abcabc" → "abcabc"
(?=...)        # Lookahead: \w+(?=\.) matches "file" in "file.txt"
(?!...)        # Negative lookahead: \d{3}(?!-) matches "123" in "123 456"
(?<=...)       # Lookbehind: (?<=\$)\d+ matches "100" in "$100"
(?<!...)       # Negative lookbehind: (?<!@)\w+ matches "name" in "user name"

**Escaping & Flags**
\          # Escape special character
(?i)       # Case-insensitive mode
(?m)       # Multiline mode (^ and $ match line boundaries)
(?s)       # Dot matches newline

**Examples**
\d{4}-\d{2}-\d{2}         # Match dates like 2025-08-06
^[A-Za-z0-9._%+-]+@       # Match start of an email
https?:\/\/\S+            # Match a URL
"""

print(message)
