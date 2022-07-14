#!/bin/sh

# to test locally, run one of:
# docker run --rm -v $(pwd):/tmp -w /tmp -e ARCH=amd64 alpine /tmp/build.sh
# docker run --rm -v $(pwd):/tmp -w /tmp -e ARCH=aarch64 multiarch/alpine:aarch64-latest-stable /tmp/build.sh
# docker run --rm -v $(pwd):/tmp -w /tmp -e ARCH=ARCH_HERE ALPINE_IMAGE_HERE /tmp/build.sh

CURL_VERSION='7.84.0'

[ "$1" != "" ] && CURL_VERSION="$1"

set -exu

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

# apply patches if needed
#patch -p1 < ../static.patch
#apk add autoconf automake libtool
#autoreconf -fi
# end apply patches

# set up any required curl options here
#LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure --disable-shared --enable-static --disable-libcurl-option --without-brotli --disable-manual --disable-unix-sockets --disable-dict --disable-file --disable-gopher --disable-imap --disable-smtp --disable-rtsp --disable-telnet --disable-tftp --disable-pop3 --without-zlib --disable-threaded-resolver --disable-ipv6 --disable-smb --disable-ntlm-wb --disable-tls-srp --disable-crypto-auth --without-ngtcp2 --without-nghttp2 --disable-ftp --disable-mqtt --disable-alt-svc --without-ssl

LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure --disable-shared --enable-static --disable-ldap --enable-ipv6 --enable-unix-sockets --with-ssl --with-libssh2

make -j4 V=1 LDFLAGS="-static -all-static"

# binary is ~13M before stripping, 2.6M after
strip src/curl

# print out some info about this, size, and to ensure it's actually fully static
ls -lah src/curl
file src/curl
# exit with error code 1 if the executable is dynamic, not static
ldd src/curl && exit 1 || true

./src/curl -V

#./src/curl -v http://www.moparisthebest.com/; ./src/curl -v https://www.moparisthebest.com/ip

# we only want to save curl here
mkdir -p /tmp/release/
mv src/curl "/tmp/release/curl-$ARCH"
cd ..
rm -rf "curl-${CURL_VERSION}/"
