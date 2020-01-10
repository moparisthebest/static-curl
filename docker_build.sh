#!/bin/sh

DOCKER_IMAGE="$1"
shift
ARCH="$1"

BUILD_DIR=/tmp/static-curl/

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cp build.sh mykey.asc "$BUILD_DIR"

# if this is a multiarch image, must register binfmt handlers
echo "$DOCKER_IMAGE" | grep multiarch && docker run --rm --privileged multiarch/qemu-user-static:register --reset

docker run --rm -v "$BUILD_DIR":/tmp "$DOCKER_IMAGE" /tmp/build.sh || exit 1

mv "$BUILD_DIR"curl "./curl-$ARCH"
rm -rf "$BUILD_DIR" 2>/dev/null

exit 0
