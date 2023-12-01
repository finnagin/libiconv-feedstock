#!/usr/bin/env sh
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./build-aux
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./libcharset/build-aux
set -ex

./configure --prefix=${PREFIX}  \
            --host=${HOST}      \
            --build=${BUILD}    \
            --enable-static     \
            --disable-rpath

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  make check
fi
