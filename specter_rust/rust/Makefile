.DEFAULT_GOAL := help
LIBNAME=libspecter_rust
PROJECTNAME=$(shell basename "$(PWD)")
SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))

OS_NAME=$(shell uname | tr '[:upper:]' '[:lower:]')
PATH := $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin:$(PATH)

ANDROID_AARCH64_LINKER=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/aarch64-linux-android29-clang
ANDROID_ARMV7_LINKER=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/armv7a-linux-androideabi29-clang
ANDROID_I686_LINKER=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/i686-linux-android29-clang
ANDROID_X86_64_LINKER=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/x86_64-linux-android29-clang

ANDROID_LIB_DIR=../android/src/main/jniLibs

SHELL := /bin/bash

# ##############################################################################
# # GENERAL
# ##############################################################################

.PHONY: help
help: Makefile
	@echo
	@echo " Available actions in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## init: Install missing dependencies.
.PHONY: init
init:
	rustup target add aarch64-apple-ios x86_64-apple-ios
# rustup target add armv7-apple-ios armv7s-apple-ios i386-apple-ios ## Deprecated!
	rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
	@if [ $$(uname) == "Darwin" ] ; then cargo install cargo-lipo ; fi
	cargo install cbindgen

## :

# ##############################################################################
# # RECIPES
# ##############################################################################

## all: Compile iOS, Android and bindings targets
all: ios android bindings

## ios: Compile the iOS universal library
ios: target/universal/release/$(LIBNAME).a

target/universal/release/$(LIBNAME).a: $(SOURCES) ndk-home
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release ; \
		rm -f ../ios/$(LIBNAME).a ; \
		mv -f $@ ../ios ; \
	else echo "Skipping iOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

## android: Compile the android targets (arm64, armv7 and i686)
android: target/aarch64-linux-android/release/$(LIBNAME).so target/armv7-linux-androideabi/release/$(LIBNAME).so target/i686-linux-android/release/$(LIBNAME).so target/x86_64-linux-android/release/$(LIBNAME).so

target/aarch64-linux-android/release/$(LIBNAME).so: $(SOURCES) ndk-home
	CC_aarch64_linux_android=$(ANDROID_AARCH64_LINKER) \
	CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$(ANDROID_AARCH64_LINKER) \
		cargo build --target aarch64-linux-android --release
	rm -f $(ANDROID_LIB_DIR)/arm64-v8a/$(LIBNAME).so
	mkdir -p $(ANDROID_LIB_DIR)/arm64-v8a
	mv -f $@ $(ANDROID_LIB_DIR)/arm64-v8a
	@echo "[DONE] $@"

target/armv7-linux-androideabi/release/$(LIBNAME).so: $(SOURCES) ndk-home
	CC_armv7_linux_androideabi=$(ANDROID_ARMV7_LINKER) \
	CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER=$(ANDROID_ARMV7_LINKER) \
		cargo build --target armv7-linux-androideabi --release
	rm -f $(ANDROID_LIB_DIR)/armeabi-v7a/$(LIBNAME).so
	mkdir -p $(ANDROID_LIB_DIR)/armeabi-v7a
	mv -f $@ $(ANDROID_LIB_DIR)/armeabi-v7a
	@echo "[DONE] $@"

target/i686-linux-android/release/$(LIBNAME).so: $(SOURCES) ndk-home
	CC_i686_linux_android=$(ANDROID_I686_LINKER) \
	CARGO_TARGET_I686_LINUX_ANDROID_LINKER=$(ANDROID_I686_LINKER) \
		cargo  build --target i686-linux-android --release
	rm -f $(ANDROID_LIB_DIR)/x86/$(LIBNAME).so
	mkdir -p $(ANDROID_LIB_DIR)/x86
	mv -f $@ $(ANDROID_LIB_DIR)/x86
	@echo "[DONE] $@"

target/x86_64-linux-android/release/$(LIBNAME).so: $(SOURCES) ndk-home
	CC_x86_64_linux_android=$(ANDROID_X86_64_LINKER) \
	CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER=$(ANDROID_X86_64_LINKER) \
		cargo build --target x86_64-linux-android --release
	rm -f $(ANDROID_LIB_DIR)/x86_64/$(LIBNAME).so
	mkdir -p $(ANDROID_LIB_DIR)/x86_64
	mv -f $@ $(ANDROID_LIB_DIR)/x86_64
	@echo "[DONE] $@"

.PHONY: ndk-home
ndk-home:
	@if [ ! -d "${ANDROID_NDK_HOME}" ] ; then \
		echo "Error: Please, set the ANDROID_NDK_HOME env variable to point to your NDK folder" ; \
		exit 1 ; \
	fi

## bindings: Generate the .h file for iOS
bindings: target/bindings.h cbindgen.toml

target/bindings.h: src/lib.rs cbindgen.toml
	cd ..; flutter pub get
	cbindgen $< -c cbindgen.toml | uniq > $@
	cp -f $@ ../ios/Classes/$(LIBNAME)_bindings.h
	@echo "[DONE] $@"

# Generate debug version of the library for the host OS
test_lib: $(SOURCES)
	cargo build

## :

# ##############################################################################
# # OTHER
# ##############################################################################

## clean:
.PHONY: clean
clean:
	cargo clean
	rm -f target/bindings.h target/bindings.src.h
	rm -f ../ios/Classes/$(LIBNAME)_bindings.h
	rm -f $(ANDROID_LIB_DIR)/arm64-v8a/$(LIBNAME).so
	rm -f $(ANDROID_LIB_DIR)/armeabi-v7a/$(LIBNAME).so
	rm -f $(ANDROID_LIB_DIR)/x86/$(LIBNAME).so
	rm -f $(ANDROID_LIB_DIR)/x86_64/$(LIBNAME).so
	rm -f ../ios/$(LIBNAME).a

## test:
.PHONY: test
test:
	cargo test
