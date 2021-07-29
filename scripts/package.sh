#!/bin/sh
mkdir -p build/datapacks
find . -type f ! \(                                                                                                    \
  -path ./.git/\* -o                                                                                                   \
  -path ./.gitignore -o                                                                                                \
  -path ./.gitlab-ci.yml -o                                                                                            \
  -path ./data/armor_statues/loot_tables/book/\*                                                                       \
  -path ./scripts/\*                                                                                                   \
  -path ./Makefile -o                                                                                                  \
  -path ./VERSION -o                                                                                                   \
\) | zip "build/datapacks/Armor Statues $(cat VERSION).zip" -@
