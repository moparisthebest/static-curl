#!/bin/sh

rm -rf /tmp/static-curl/
mkdir -p /tmp/static-curl/
cp build.sh mykey.asc /tmp/static-curl/

docker run -it --rm -v /tmp/static-curl:/tmp alpine /tmp/build.sh

mv /tmp/static-curl/curl .
rm -rf /tmp/static-curl/
