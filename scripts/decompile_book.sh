#!/bin/bash
printf "%s" "Decompiling book.json... "

mkdir -p data/armor_statues/loot_tables/book
booktmp="$(mktemp)"
jq -r .pools[0].entries[0].functions[0].tag data/armor_statues/loot_tables/book.json |
python -c "import json, hjson, sys; json.dump(hjson.load(sys.stdin), sys.stdout)"    |
jq . > "$booktmp"

np=-1
while IFS= read -r page; do
  np="$((np + 1))"
  pagetmp="$(mktemp)"
  jq . <<< "$page" > "$pagetmp"
  mv "$pagetmp" "data/armor_statues/loot_tables/book/page_$np.json"
done <<< "$(jq -r .pages[] "$booktmp")"

echo "done."
