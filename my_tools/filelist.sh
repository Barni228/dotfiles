#!/usr/bin/env bash
# Usage: filelist <directory> <output_file>

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <directory> <output_file>"
  exit 1
fi

DIR="$1"
OUTPUT="$2"

if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory"
  exit 1
fi

# Generate hash list
find "$DIR" -type f -print0 \
  | xargs -0 sha256sum \
  | sort -k2 > "$OUTPUT"

echo "Wrote file list with hashes to $OUTPUT"