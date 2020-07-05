#!/bin/sh

# to test locally, run one of:
# docker run --rm -v $(pwd):/tmp alpine /tmp/build.sh
# docker run --rm -v $(pwd):/tmp multiarch/alpine:armhf-latest-stable /tmp/build.sh
# docker run --rm -v $(pwd):/tmp i386/alpine /tmp/build.sh
# docker run --rm -v $(pwd):/tmp ALPINE_IMAGE_HERE /tmp/build.sh

CURL_VERSION='7.71.1'

[ "$1" != ""] && CURL_VERSION="$1"

set -exu

# change to the directory this script is in, we assume mykey.asc is there
cd "$(dirname "$0")"

if [ ! -f curl-${CURL_VERSION}.tar.gz ]
then

    # for gpg verification of the curl download below
    apk add gnupg

    wget https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz.asc

    # convert mykey.asc to a .pgp file to use in verification
    gpg --no-default-keyring --yes -o ./curl.gpg --dearmor mykey.asc
    # this has a non-zero exit code if it fails, which will halt the script
    gpg --no-default-keyring --keyring ./curl.gpg --verify curl-${CURL_VERSION}.tar.gz.asc

fi

rm -rf "curl-${CURL_VERSION}/"
tar xzf curl-${CURL_VERSION}.tar.gz

cd curl-${CURL_VERSION}/

# dependencies to build curl
apk add build-base clang openssl-dev nghttp2-dev nghttp2-static libssh2-dev libssh2-static

# these are missing on at least armhf
apk add openssl-libs-static zlib-static || true

# gcc is apparantly incapable of building a static binary, even gcc -static helloworld.c ends up linked to libc, instead of solving, use clang
export CC=clang

# set up any required curl options here
#LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure --disable-shared --enable-static --disable-libcurl-option --without-brotli --disable-manual --disable-unix-sockets --disable-dict --disable-file --disable-gopher --disable-imap --disable-smtp --disable-rtsp --disable-telnet --disable-tftp --disable-pop3 --without-zlib --disable-threaded-resolver --disable-ipv6 --disable-smb --disable-ntlm-wb --disable-tls-srp --disable-crypto-auth --with-ssl

LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure --disable-shared --enable-static --disable-ldap --enable-ipv6 --enable-unix-sockets --with-ssl --with-libssh2

make -j4 V=1 curl_LDFLAGS=-all-static

# binary is ~13M before stripping, 2.6M after
strip src/curl

# print out some info about this, size, and to ensure it's actually fully static
ls -lah src/curl
file src/curl
ldd src/curl || true

./src/curl -V

#./src/curl -v http://www.moparisthebest.com/; ./src/curl -v https://www.moparisthebest.com/ip

# we only want to save curl here, by moving it to /tmp/ for now
mv src/curl /tmp/
