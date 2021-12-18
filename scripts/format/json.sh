#!/bin/bash
echo "Formatting JSON..."

find data -type f -iname "*.json" -print0                                                                              \
| while IFS= read -r -d "" file; do
  printf "Formatting %s... " "$(file="${file#./data/}"; printf "%s" "${file%.json}")"
  tmp="$(mktemp)"
  if ! err="$(jq . "$file" 2>&1 >"$tmp")"; then
    echo "ERROR:"
    echo "$err"
    rm "$tmp"

    exit 1
  else
    mv "$tmp" "$file"
    echo "OK."
  fi
done
