#!/usr/bin/env sh
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./build-aux
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./libcharset/build-aux
set -ex

# refresh the flags
if [[ "$OSTYPE" == "darwin"* ]]; then
    mv lib/flags.h lib/flags.h.bak
    ${CC} ${CFLAGS} lib/genflags.c -o genflags
    ./genflags > lib/flags.h
    rm -f genflags
    diff -u lib/flags.h.bak lib/flags.h
fi

./configure --prefix=${PREFIX}  \
            --host=${HOST}      \
            --build=${BUILD}    \
            --enable-static     \
            --disable-rpath

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  make check
fi
