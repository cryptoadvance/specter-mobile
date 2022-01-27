# specter_rust

Specter Rust bindings for wallet functionality.

## Building

First run:

```
flutter pub get
cd rust
make init
make bindings
```

Then for Android and iOS run `make all` or separately `make ios` and `make android`

On Linux run `cargo build` and install the resulting library or make it somehow available for the system:

```
sudo cp target/debug/libspecter_rust.so /usr/lib
```

## Running dart example

```
dart examples/hello.dart
```

## Creating bindings

```
dart pub get
dart run ffigen
```

Problems with llvm? For me this fixed the problem: `sudo ln /usr/lib/llvm-10/lib/libclang.so.1 /usr/lib/llvm-10/lib/libclang.so`