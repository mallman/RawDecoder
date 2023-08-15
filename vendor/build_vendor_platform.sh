#!/bin/bash

set -eu

if [ $# -ne 2 ]; then
  echo "Usage: $(basename $0) <vendor_dir> <platform>"
  echo "Where <platform> is one of"
  echo "  macOS"
  echo "  iOS"
  echo "  iOS_Simulator"
  exit 1
fi

VENDOR="$1"
PLATFORM=$2

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
BASE_DIR="${SCRIPT_DIR}/${VENDOR}"

if [ ! -d "${BASE_DIR}" ]; then
  echo "No vendor directory ${VENDOR}"
  exit 1
fi

if [ "${PLATFORM}" = "macOS" ]; then
  CMAKE_SYSTEM_NAME=
  CMAKE_OSX_SYSROOT=macosx
  BINARY_PACKAGE_BUILD=OFF
  ARCHS="arm64;x86_64"
elif [ "${PLATFORM}" = "iOS" ]; then
  CMAKE_SYSTEM_NAME=iOS
  CMAKE_OSX_SYSROOT=iphoneos
  BINARY_PACKAGE_BUILD=ON
  ARCHS=arm64
elif [ "${PLATFORM}" = "iOS_Simulator" ]; then
  CMAKE_SYSTEM_NAME=iOS
  CMAKE_OSX_SYSROOT=iphonesimulator
  BINARY_PACKAGE_BUILD=ON
  ARCHS="arm64;x86_64"
else
  echo "Invalid platform: ${PLATFORM}"
  exit 1
fi

. "${BASE_DIR}/include.sh"

if [ ! -d "${SOURCE_DIR}" ]; then
  echo "Missing vendor source dir: ${SOURCE_DIR}"
  echo "Clone a working directory of the vendor source repo there or place a source tree"
  echo "See README.md for more information"
  exit 1
fi

config_and_build
