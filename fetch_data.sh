# bin/bash

rm -rf ./data/editions
mkdir -p ./data/editions
rm -rf ./data/indices
mkdir -p ./data/indices
rm -rf ./data/meta
mkdir -p ./data/meta

rm main.zip

wget https://github.com/arthur-schnitzler/arthur-schnitzler-arbeit/archive/refs/heads/main.zip
unzip main
rm main.zip
mv ./arthur-schnitzler-arbeit-main/editions ./data
mv ./arthur-schnitzler-arbeit-main/indices ./data
mv ./arthur-schnitzler-arbeit-main/meta ./data

rm -rf ./arthur-schnitzler-arbeit-main

echo "and now some XSLTs"
ant
