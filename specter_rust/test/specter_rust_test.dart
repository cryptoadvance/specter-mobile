import 'package:flutter_test/flutter_test.dart';
// import 'package:specter_rust/specter_rust.dart';

void main() {
  // Testing native mobile architectures on desktop environments is not
  // supported at this point.

  // However, it is still possible to cross-compile to
  // Mac, Linux or Windows, load their respective library and
  // test from there.

  /*
  test('greet', () {
    expect(SpecterRust.greet('Alice'), 'Hello Alice');
  });
  */
  test('Trivial', () {
    expect(true, true);
  });
}
