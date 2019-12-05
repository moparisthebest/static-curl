#!/bin/sh

CURL_VERSION='7.67.0'

[ "$1" != ""] && CURL_VERSION="$1"

set -exu

cd "$(dirname "$0")"

apk add gnupg

wget https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz.asc

gpg --no-default-keyring --yes -o ./curl.gpg --dearmor mykey.asc
gpg --no-default-keyring --keyring ./curl.gpg --verify curl-${CURL_VERSION}.tar.gz.asc

tar xzf curl-${CURL_VERSION}.tar.gz

cd curl-${CURL_VERSION}/

apk add build-base clang openssl-dev

export CC=clang

LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure --disable-shared --enable-static --disable-libcurl-option --without-brotli --disable-manual --disable-unix-sockets --disable-dict --disable-file --disable-gopher --disable-imap --disable-smtp --disable-rtsp --disable-telnet --disable-tftp --disable-pop3 --without-zlib --disable-threaded-resolver --disable-ipv6 --disable-smb --disable-ntlm-wb --disable-tls-srp

make -j4 V=1 curl_LDFLAGS=-all-static

strip src/curl

ls -lah src/curl; file src/curl
ldd src/curl || true

#./src/curl -v http://www.moparisthebest.com/; ./src/curl -v https://www.moparisthebest.com/ip

cp src/curl /tmp/

cd ..
rm -rf curl-${CURL_VERSION}/
