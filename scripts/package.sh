#!/bin/sh
./scripts/format.sh

set -x
mkdir -p build/datapacks
find . -type f ! \(                                                                                                    \
  -path ./.git/\* -o                                                                                                   \
  -path ./reference/\* -o                                                                                              \
  -path ./Makefile -o                                                                                                  \
  -path ./.gitignore -o                                                                                                \
  -path ./.gitlab-ci.yml -o                                                                                            \
  -path ./data/armor_statues/loot_tables/book/\*                                                                       \
\) | zip "build/datapacks/Armor Statues $(cat VERSION).zip" -@
