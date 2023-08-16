## RawDecoder: A Camera Raw Decoding Frontend for Apple Software Projects

RawDecoder is an Objective-C/Objective-C++ framework which abstracts over the [LibRaw](https://www.libraw.org/) and [RawSpeed](https://github.com/darktable-org/rawspeed) camera raw file decoders. RawDecoder simplifies the incorporation of these raw file decoders into the Apple development ecosystem, including Swift projects. One goal of RawDecoder is to provide multiplatform compatibility. To that end, a script, `create_xcframework.sh`, is included to create an XCFramework for macOS, iOS and iOS Simulator.

### Repo Layout

The RawDecoder repo is divided into two major parts: the RawDecoder framework itself and vendor support code. The RawDecoder framework follows typical Xcode project layout, with `RawDecoder.xcodeproj`, `RawDecoder` and `RawDecoderTests` at the root of the repo. The vendor support code is in the `vendor` directory, including the vendor source itself and build scripts.

Each raw decoder has its own vendor support subdirectory in the `vendor` directory, namely `vendor/LibRaw` and `vendor/RawSpeed`. Those directories contain build support files and Git submodules referencing the vendor source repositories. In addition to the main source repositories, there is another submodule for the `LibRaw-cmake` repo.

### Build Instructions

The vendor libraries must be built first, and each library must be built for each platform: macOS, iOS and iOS Simulator. Strictly speaking, you only have to build the platforms you need. If you only want to build for macOS, you can avoid building the other platforms. The `vendor` directory has two build scripts: `build_vendor_platform.sh` and `build_all.sh`. The former builds one combination of vendor/platform, e.g. RawSpeed for macOS. The latter builds all six vendor/platform combinations.

The vendor build scripts incorporate vendor-specific subscripts called `include.sh`. They specify some customizable settings for the builds, such as C compiler, whether to build a debug or release build or whether to build with OpenMP support. These settings can be customized/overridden by files following the naming pattern `vendor/{vendor}/env-(platform).sh`, where `{vendor}` is `LibRaw` or `RawSpeed`, and `{platform}` is `macOS`, `iOS` or `iOS_Simulator`. For example, to customize the build of RawSpeed for macOS, create a file `vendor/RawSpeed/env-macOS.sh` and include the settings you want to override, e.g.:

```sh
BUILD_CONFIG=Debug
WITH_OPENMP=ON
USE_BUNDLED_LLVMOPENMP=ON
ALLOW_DOWNLOADING_LLVMOPENMP=ON
```

_Be warned_, building both `LibRaw` and `RawSpeed` with OpenMP support is discouraged unless the exact same version of OpenMP is linked with both libraries. If the versions of OpenMP are different, you may encounter crashes related to use of the OpenMP API. Personally, I build RawSpeed with OpenMP and LibRaw without OpenMP. I have not tried building both with the same version, and the build scripts provided in this repo will not check that condition.

Once you have customized your build settings, you can build the platform support you desire with the `build_vendor_platform.sh` script. If you want to build an XCFramework supporting all deployment platforms, just run `build_all.sh`.

Once the vendor libraries have been built, the RawDecoder framework can be built. You will need to update the signing configuration of `RawDecoder.xcodeproj` in Xcode. You may also need to modify the framework target library dependencies. For example, the target dependencies are configured to include the OpenMP runtime libraries from RawSpeed. If you do not build RawSpeed with OpenMP support, remove those dependencies from the platform build targets.

Once the project settings have been updated appropriately, you can either build platform specific frameworks using the framework build targets. Or, run `create_xcframework.sh` to create a multi-platform XCFramework. The XCFramework can be used as a dependency of a multi-platform target, like a SwiftUI app.

### A Note on Licensing

The proprietary code of this repo itself is licensed under the terms of Apache 2.0 license. See `LICENSE.txt`. However, RawDecoder is a frontend to two library backends. Consumers of RawDecoder are incumbent on complying with the terms of the licenses of the backend software, namely LibRaw and RawSpeed.
