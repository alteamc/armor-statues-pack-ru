#!/bin/bash
printf "%s" "Compiling book.json... "

booktmp="$(mktemp)"
jq -r .pools[0].entries[0].functions[0].tag data/armor_statues/loot_tables/book.json |
python -c "import json, hjson, sys; json.dump(hjson.load(sys.stdin), sys.stdout)"    |
jq . > "$booktmp"

nf="$(find data/armor_statues/loot_tables/book -type f -iname "page_*.json" -printf . | wc -c)"
i=0; while [ "$i" -lt "$nf" ]; do
  tmp="$(mktemp)"
  jq --arg page "$(jq -c . "data/armor_statues/loot_tables/book/page_$i.json")" ".pages[$i] |= \$page" "$booktmp" > "$tmp"
  mv "$tmp" "$booktmp"
  i="$((i + 1))"
done

tmp="$(mktemp)"
jq --arg book "$(jq -c . "$booktmp")" ".pools[0].entries[0].functions[0].tag = \$book" data/armor_statues/loot_tables/book.json > "$tmp"
mv "$tmp" data/armor_statues/loot_tables/book.json
echo "done."
