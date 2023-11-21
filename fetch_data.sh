#!/bin/bash

rm -rf ./data/editions
mkdir -p ./data/editions
rm -rf ./data/indices
mkdir -p ./data/indices
rm -rf ./data/meta
mkdir -p ./data/meta
rm -rf ./data/tocs
mkdir -p ./data/tocs

rm main.zip

wget https://github.com/arthur-schnitzler/arthur-schnitzler-arbeit/archive/refs/heads/main.zip
unzip main
rm main.zip
mv ./arthur-schnitzler-arbeit-main/editions ./data
mv ./arthur-schnitzler-arbeit-main/indices ./data
mv ./arthur-schnitzler-arbeit-main/meta ./data
mv ./arthur-schnitzler-arbeit-main/tocs ./data

# Loop through files and delete those with a number greater than 3373
#for file in ./data/editions/L*.xml; do
#  filename=$(basename "$file")
#  number=$(echo "$filename" | sed -n 's/L\([0-9]\+\)\.xml/\1/p')
#  if [ "$number" -gt 3389 ]; then
#    rm "$file"
#  fi
#done

rm -rf ./arthur-schnitzler-arbeit-main

echo "and now some XSLTs"
ant
