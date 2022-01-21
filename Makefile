.DEFAULT_GOAL := help
PROJECTNAME=$(shell basename "$(PWD)")
RUST_PACKAGE_DIR=./specter_rust
RUST_DIR=./$(RUST_PACKAGE_DIR)/rust

# List of all supported platforms
FLUTTER_CMDS = run build

# Check if Flutter command is passed
FIRST_ARG = $(firstword $(MAKECMDGOALS))
ifeq ($(findstring $(FIRST_ARG),$(FLUTTER_CMDS)),$(FIRST_ARG))
  FLUTTER_RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(FLUTTER_RUN_ARGS):;@:)
endif

.PHONY: help clean init test_rust $(FLUTTER_CMDS)

# Display help screen when make is executed with no arguments
help: Makefile
	@echo
	@echo " Available actions in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## clean: Clean project removing all build artifacts.
clean:
	flutter clean
	@$(MAKE) -C $(RUST_DIR) clean

## init: Install missing dependencies.
init:
	@flutter pub get
	@$(MAKE) -C $(RUST_DIR) init

## build_rust: Build the Rust part of the project.
build_rust:
	@$(MAKE) -C $(RUST_DIR) all
	@cd $(RUST_PACKAGE_DIR); flutter pub run ffigen

## build: Build the Flutter application.
build: build_rust
	@flutter build $(FLUTTER_RUN_ARGS)

## test_rust: Run tests in the Rust part of the project.
test_rust:
	@echo "Running tests for the Rust code"
	@cd $(RUST_DIR); cargo test

## test_rust_pkg: Test Rust package including Dart wrappers.
test_rust_pkg:
	@echo "Running tests for the Rust package"
	@$(MAKE) -C $(RUST_DIR) test_lib
	@cd $(RUST_PACKAGE_DIR); flutter test

## test: Run all tests.
test: test_rust test_rust_pkg
	@echo "Running tests for the Flutter application"
	@flutter test

## run: Run the Flutter application.
run: build_rust
	@flutter run $(FLUTTER_RUN_ARGS)

## install: Install the Flutter app on an attached device.
install:
	@flutter install $(FLUTTER_RUN_ARGS)
