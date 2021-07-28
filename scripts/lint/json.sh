#!/bin/sh
echo "Проверка синтаксиса файлов JSON..."

find data -type f -iname "*.json" -print0                                                                              \
| while IFS= read -r -d "" file; do
  printf "Проверяем %s... " "$(file="${file#./data/}"; printf "%s" "${file%.json}")"
  tmp="$(mktemp)"
  if ! err="$(jq . "$file" 2>&1 >/dev/null)"; then
    echo "ошибка:"
    echo "$err"
    rm "$tmp"

    exit 1
  else
    echo "готово."
  fi
done
