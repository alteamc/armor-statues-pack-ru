#!/bin/bash
set -x
mkdir -p build/datapacks
find . -type f -not \(                                                                                                 \
  -path ./.git/\* -o                                                                                                   \
  -path ./.gitignore -o                                                                                                \
  -path ./.github/\* -o                                                                                                \
  -path ./build/\* -o                                                                                                  \
  -path ./data/armor_statues/loot_tables/book/\* -o                                                                    \
  -path ./scripts/\* -o                                                                                                \
  -path ./Makefile -o                                                                                                  \
  -path ./VERSION                                                                                                      \
\) | zip "build/datapacks/Armor Statues $(cat VERSION).zip" -@
