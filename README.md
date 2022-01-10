# Specter-Mobile (WIP)

**POC Mobile wallet / co-signer app built with Flutter and Rust**

## Pre-requisites

- Check if Flutter is properly configured by running `flutter doctor`
- To check whether you have Rust installed correctly, run `rustc --version`
- Make sure that the Android NDK is installed
  - You might also need LLVM from the SDK manager
- Ensure that the env variable `$ANDROID_NDK_HOME` points to the NDK base folder
  - It may look like `/Users/username/Library/Android/sdk/ndk-bundle` on MacOS
  - And look like `/home/username/dev/android/ndk-bundle` on Linux

## Building and running

On the root directory:

- Run `make` to see the available actions
- Run `make init` to install the Flutter dependencies and Rust targets
- Run `make run` to build and run the mobile app on an attached device

- Use NDK 22 version
- Install llvm for the ffgen plugin (sudo apt-get install libclang-dev)

On Linux:
Add ANDROID_NDK_HOME="/home/{username}/Android/Sdk/ndk/22.x.xxxxxx" in the /etc/environment file