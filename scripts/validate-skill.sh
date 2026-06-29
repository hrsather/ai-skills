#!/usr/bin/env bash
set -euo pipefail

exit_code=0

for file in "$@"; do
  # Must start with YAML frontmatter
  if ! head -1 "$file" | grep -q '^---$'; then
    echo "ERROR: $file — missing opening '---' frontmatter delimiter"
    exit_code=1
    continue
  fi

  # Extract frontmatter block (between first and second ---)
  frontmatter=$(awk '/^---$/{if(++n==2) exit} n==1' "$file")

  for field in name description; do
    if ! echo "$frontmatter" | grep -qE "^${field}:"; then
      echo "ERROR: $file — missing required frontmatter field: $field"
      exit_code=1
    fi
  done

  if ! echo "$frontmatter" | grep -qE "^metadata:"; then
    echo "ERROR: $file — missing required frontmatter field: metadata"
    exit_code=1
  fi
done

exit $exit_code
