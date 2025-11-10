echo "downloading saxon from maven central"
wget https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/9.9.1-7/Saxon-HE-9.9.1-7.jar -O saxon.jar && mkdir -p saxon && mv saxon.jar saxon/