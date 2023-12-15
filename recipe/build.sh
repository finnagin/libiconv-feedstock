#!/usr/bin/env sh

set -euxo pipefail

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./build-aux
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./libcharset/build-aux

# this bit of code will refresh the flags.h header
# for now we have hard coded the changes as a patch.
# if [[ "${target_platform}" == osx-* ]]; then
#     mv lib/flags.h lib/flags.h.bak
#     ${CC_FOR_BUILD} ${CFLAGS} lib/genflags.c -o genflags
#     ./genflags > lib/flags.h
#     rm -f genflags
#     # Debugging: Show generated diff
#     diff -u lib/flags.h.bak lib/flags.h || true
#     # Check that UTF-8.MAC is included
#     grep utf8mac lib/flags.h
# fi

./configure --prefix=${PREFIX}  \
            --host=${HOST}      \
            --build=${BUILD}    \
            --enable-static     \
            --disable-rpath

if [[ "${target_platform}" == osx-* ]]; then
    # make -f Makefile.devel CC="${CC}" CFLAGS="${CFLAGS}" totally-clean
    make -f Makefile.devel CC="${CC}" CFLAGS="${CFLAGS}"
fi

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" != "1" ]]; then
  make check
fi
