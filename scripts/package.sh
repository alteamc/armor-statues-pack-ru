#!/bin/sh
./scripts/format.sh

mkdir -p build/datapacks
find . -type f ! \(                                                                                                    \
  -path ./.git/\* -o                                                                                                   \
  -path ./reference/\* -o                                                                                              \
  -path ./Makefile -o                                                                                                  \
  -path ./.gitignore -o                                                                                                \
  -path ./.gitlab-ci.yml -o                                                                                            \
  -path ./VERSION -o                                                                                                   \
  -path ./data/armor_statues/loot_tables/book/\*                                                                       \
\) | zip "build/datapacks/Armor Statues $(cat VERSION).zip" -@
