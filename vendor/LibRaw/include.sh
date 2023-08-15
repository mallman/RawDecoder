#!/bin/bash

set -eu

# Values set in env-${PLATFORM}.sh will override these settings
# Modify env-${PLATFORM}.sh to change these settings, not here
CXX_COMPILER=clang++
BUILD_CONFIG=Release
WITH_OPENMP=OFF

CONFIG_FILE="${BASE_DIR}/env-${PLATFORM}.sh"

if [ -f "${CONFIG_FILE}" ]; then
  . "${CONFIG_FILE}"
fi

SOURCE_DIR="${BASE_DIR}/LibRaw-cmake"

BUILD_DIR="${BASE_DIR}/build-${PLATFORM}"

config_and_build() {
  rm -rf "${BUILD_DIR}"

  cmake \
  -DCMAKE_SYSTEM_NAME=$CMAKE_SYSTEM_NAME \
  -DCMAKE_OSX_SYSROOT=$CMAKE_OSX_SYSROOT \
  -DCMAKE_OSX_ARCHITECTURES="${ARCHS}" \
  -DLIBRAW_PATH="${BASE_DIR}/LibRaw" \
  -DBUILD_SHARED_LIBS=OFF \
  -DENABLE_OPENMP=$WITH_OPENMP \
  -DENABLE_LCMS=OFF \
  -DENABLE_JASPER=OFF \
  -DENABLE_EXAMPLES=OFF \
  -DCMAKE_VERBOSE_MAKEFILE=OFF \
  -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE \
  -DCMAKE_BUILD_TYPE:STRING=$BUILD_CONFIG \
  -DCMAKE_CXX_COMPILER:FILEPATH="${CXX_COMPILER}" \
  -DJPEG_INCLUDE_DIR:PATH="" \
  -DJPEG_LIBRARY_DEBUG:FILEPATH="" \
  -DJPEG_LIBRARY_RELEASE:FILEPATH="" \
  -S"${SOURCE_DIR}" \
  -B"${BUILD_DIR}" \
  -G Ninja

  cmake \
  --build "${BUILD_DIR}" \
  --config $BUILD_CONFIG \
  --target raw_r --
}
