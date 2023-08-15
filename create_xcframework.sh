#!/bin/sh

set -e

rm -rf archives

xcodebuild archive \
-project RawDecoder.xcodeproj \
-scheme "RawDecoder" \
-destination "generic/platform=macOS" \
-archivePath "archives/RawDecoder-macOS"

xcodebuild archive \
-project RawDecoder.xcodeproj \
-scheme "RawDecoder iOS" \
-destination "generic/platform=iOS" \
-archivePath "archives/RawDecoder-iOS"

xcodebuild archive \
-project RawDecoder.xcodeproj \
-scheme "RawDecoder iOS Simulator" \
-destination "generic/platform=iOS Simulator" \
-archivePath "archives/RawDecoder-iOS_Simulator"

rm -rf xcframework

xcodebuild -create-xcframework \
-archive archives/RawDecoder-macOS.xcarchive \
-framework RawDecoder.framework \
-archive archives/RawDecoder-iOS.xcarchive \
-framework RawDecoder.framework \
-archive archives/RawDecoder-iOS_Simulator.xcarchive \
-framework RawDecoder.framework \
-output xcframework/RawDecoder.xcframework
