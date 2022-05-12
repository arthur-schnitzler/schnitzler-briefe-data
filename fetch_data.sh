# bin/bash

rm -rf ./data/editions
mkdir -p ./data/editions
rm -rf ./data/indices
mkdir -p ./data/indices

rm main.zip

wget https://github.com/arthur-schnitzler/arthur-schnitzler-arbeit/archive/refs/heads/main.zip
unzip main
rm main.zip

mv ./arthur-schnitzler-arbeit-main/editions ./data/editions
mv ./arthur-schnitzler-arbeit-main/indices ./data/indices

rm -rf ./arthur-schnitzler-arbeit-main
