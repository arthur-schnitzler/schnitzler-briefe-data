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

wget https://github.com/arthur-schnitzler/schnitzler-briefe-arbeit/archive/refs/heads/main.zip
unzip main
rm main.zip
mv ./schnitzler-briefe-arbeit-main/editions ./data
mv ./schnitzler-briefe-arbeit-main/indices ./data
mv ./schnitzler-briefe-arbeit-main/meta ./data
mv ./schnitzler-briefe-arbeit-main/tocs ./data

# Loop through files and delete those with a number greater than 3373
#for file in ./data/editions/L*.xml; do
#  filename=$(basename "$file")
#  number=$(echo "$filename" | sed -n 's/L\([0-9]\+\)\.xml/\1/p')
#  if [ "$number" -gt 3522 ]; then
#    rm "$file"
#  fi
#done

rm -rf ./schnitzler-briefe-arbeit-main

echo "and now some XSLTs"
ant
