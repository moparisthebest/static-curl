<img src="https://raw.githubusercontent.com/moparisthebest/static-curl/master/static-curl.svg?sanitize=true" alt="no not that kind" width="32" /> Static curl <img src="https://raw.githubusercontent.com/moparisthebest/static-curl/master/static-curl.svg?sanitize=true" alt="no not that kind" width="32" />
-----------
[![Travis-CI Build Status](https://api.travis-ci.org/moparisthebest/static-curl.svg?branch=master)](https://travis-ci.org/moparisthebest/static-curl)

These are a couple simple scripts to build a fully static curl binary using an alpine linux docker container.  Currently it is a minimal build with OpenSSL and only supporting HTTP and FTP.  Tweak configure options in [build.sh](build.sh#L33) if you need something else (and/or suggest or PR).

Grab the latest release (curl 7.67.0) from one of these links, by CPU architecture:
  - [curl-amd64](https://github.com/moparisthebest/static-curl/releases/download/v7.67.0/curl-amd64)
  - [curl-i386](https://github.com/moparisthebest/static-curl/releases/download/v7.67.0/curl-i386)
  - [curl-aarch64](https://github.com/moparisthebest/static-curl/releases/download/v7.67.0/curl-aarch64)

Development
-----------

File explanation:
  - [build.sh](build.sh) - runs inside an alpine docker container, downloads curl, verifies it with gpg, and builds it
  - [docker_build.sh](docker_build.sh) - runs build.sh inside docker
  - [mykey.asc](mykey.asc) - Daniel Stenberg's [GPG key](https://daniel.haxx.se/address.html) used for signing/verifying curl releases
  - [bicep curl](https://thenounproject.com/term/curl/499187) by Laymik from [the Noun Project](https://thenounproject.com)
