#!/bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

for vendor in LibRaw RawSpeed; do
  for platform in macOS iOS iOS_Simulator; do
    echo "Building ${vendor} ${platform}"
    "${SCRIPT_DIR}/build_vendor_platform.sh" $vendor $platform
  done
done
