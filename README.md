:mechanical_arm: Static curl :mechanical_arm:
-----------
[![Build Status](https://ci.moparisthe.best/job/moparisthebest/job/static-curl/job/master/badge/icon%3Fstyle=plastic)](https://ci.moparisthe.best/job/moparisthebest/job/static-curl/job/master/)

These are a couple simple scripts to build a fully static curl binary using alpine linux docker containers.  Currently it is a featureful build with OpenSSL, libssh2, nghttp2, and zlib, supporting most protocols.  Tweak configure options in [build.sh](build.sh#L50) if you need something else (and/or suggest or PR).

Grab the [latest release](https://github.com/moparisthebest/static-curl/releases/latest) from one of these links, by CPU architecture:
  - [curl-amd64](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-amd64)
  - [curl-i386](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-i386)
  - [curl-aarch64](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-aarch64)
  - [curl-armv7](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-armv7)
  - [curl-armhf](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-armhf)
  - [curl-ppc64le](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-ppc64le)

Static binaries for windows are provided directly by [curl](https://curl.haxx.se/windows/) itself.

Development
-----------

File explanation:
  - [build.sh](build.sh) - runs inside an alpine docker container, downloads curl, verifies it with gpg, and builds it
  - [mykey.asc](mykey.asc) - Daniel Stenberg's [GPG key](https://daniel.haxx.se/address.html) used for signing/verifying curl releases
